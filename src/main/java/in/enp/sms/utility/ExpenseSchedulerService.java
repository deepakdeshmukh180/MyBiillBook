package in.enp.sms.utility;


import in.enp.sms.entities.OwnerInfo;
import in.enp.sms.pojo.MonthlyExpenseSummary;
import in.enp.sms.repository.DailyExpenseRepository;
import in.enp.sms.repository.MonthlyExpenseSummaryRepository;
import in.enp.sms.repository.OwnerInfoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
@EnableScheduling
public class ExpenseSchedulerService {

    @Autowired
    private DailyExpenseRepository expenseRepository;


    @Autowired
    OwnerInfoRepository ownerInfoRepository;

    @Autowired
    private MonthlyExpenseSummaryRepository summaryRepository;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM");

    // Run every day at 2 AM
    @Scheduled(cron = "0 3 0 * * *")
    public void recalcFinancialYearExpenses() {
        LocalDate now = LocalDate.now();
        LocalDate startDate;
        LocalDate endDate;

        // Determine current financial year
        if (now.getMonthValue() >= 4) {
            startDate = LocalDate.of(now.getYear(), 4, 1);
            endDate = LocalDate.of(now.getYear() + 1, 3, 31);
        } else {
            startDate = LocalDate.of(now.getYear() - 1, 4, 1);
            endDate = LocalDate.of(now.getYear(), 3, 31);
        }

        // Get all owners
        List<OwnerInfo> owners = ownerInfoRepository.findByStatus("ACTIVE");
        List<String> ownerIds = owners.stream()
                .map(OwnerInfo::getOwnerId)
                .collect(Collectors.toList());

        for (String ownerId : ownerIds) {
            // delete old summaries for this owner for this FY
            summaryRepository.findByOwnerIdOrderByMonth(ownerId)
                    .forEach(summaryRepository::delete);

            // Recalculate month by month
            LocalDate current = startDate;
            while (!current.isAfter(endDate)) {
                LocalDate monthStart = current.withDayOfMonth(1);
                LocalDate monthEnd = current.withDayOfMonth(current.lengthOfMonth());

                String monthStr = current.format(FORMATTER);

                List<Object[]> results = expenseRepository.findMonthlyExpensesForYearRange(
                        java.sql.Date.valueOf(monthStart),
                        java.sql.Date.valueOf(monthEnd));

                boolean found = false;
                for (Object[] row : results) {
                    String rowOwnerId = (String) row[0];
                    Double total = (Double) row[1];

                    if (rowOwnerId.equals(ownerId)) {
                        MonthlyExpenseSummary summary = new MonthlyExpenseSummary();
                        summary.setOwnerId(ownerId);
                        summary.setMonth(monthStr);
                        summary.setTotalAmount(total);
                        summary.setCalculatedAt(new Date());
                        summaryRepository.save(summary);
                        found = true;
                    }
                }

                if (!found) {
                    // insert zero if no data for this owner/month
                    MonthlyExpenseSummary summary = new MonthlyExpenseSummary();
                    summary.setOwnerId(ownerId);
                    summary.setMonth(monthStr);
                    summary.setTotalAmount(0.0);
                    summary.setCalculatedAt(new Date());
                    summaryRepository.save(summary);
                }

                current = current.plusMonths(1);
            }
        }
    }
}

