package in.enp.sms.controller;

import in.enp.sms.entities.DailyExpense;
import in.enp.sms.pojo.MonthlyExpenseSummary;
import in.enp.sms.repository.DailyExpenseRepository;
import in.enp.sms.repository.MonthlyExpenseSummaryRepository;
import in.enp.sms.utility.Utility;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/expenses")
public class DailyExpenseController {

    @Autowired
    private DailyExpenseRepository expenseRepository;


    @Autowired
    private MonthlyExpenseSummaryRepository summaryRepository;

    @GetMapping
    public String listExpenses(@RequestParam(value = "date", required = false)
                               @DateTimeFormat(pattern = "yyyy-MM-dd") Date date,
                               Model model,
                               HttpServletRequest request) {
        String ownerId = Utility.getOwnerIdFromSession(request);

        List<DailyExpense> expenses;
        if (date != null) {
            expenses = expenseRepository.findByDateAndOwnerIdOrderByCreatedAtDesc(date,ownerId);
            model.addAttribute("selectedDate", date);
        } else {

            expenses = expenseRepository.findByDateAndOwnerIdOrderByCreatedAtDesc(new Date(),ownerId);
        }
        model.addAttribute("expenses", expenses);
        model.addAttribute("today", new Date());

        model.addAttribute("daily_expenses", expenseRepository.getDailyTotal(new Date(),ownerId));
        Double currentMonthly = expenseRepository.getCurrentMonthTotal(ownerId);
        model.addAttribute("monthly_expenses",currentMonthly);// default form value
        List<MonthlyExpenseSummary> summaryList = summaryRepository.findByOwnerIdOrderByMonth(ownerId);
        double totalExpense = summaryList.stream() .mapToDouble(s -> s.getTotalAmount() != null ? s.getTotalAmount() : 0) .sum();
        model.addAttribute("yearly_expenses",totalExpense);//
        model.addAttribute("monthlyExpenses",summaryList);
        return "daily-expenses"; // JSP under /WEB-INF/views/dashboard/expenses.jsp
    }

    @PostMapping("/add")
    public String addExpense(HttpServletRequest request, @RequestParam("date")
                             @DateTimeFormat(pattern = "yyyy-MM-dd") Date date,
                             @RequestParam("expenseName") String expenseName,
                             @RequestParam("amount") Double amount,
                             Model model) {

        String ownerId = Utility.getOwnerIdFromSession(request);
        try {
            DailyExpense exp = new DailyExpense(date, expenseName, amount,ownerId);
            expenseRepository.save(exp);
            String currentMonth = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
            MonthlyExpenseSummary summary = summaryRepository.findByOwnerIdAndMonth(ownerId, currentMonth);
            summary.setTotalAmount(summary.getTotalAmount()+amount);
            summaryRepository.save(summary);
            model.addAttribute("message", "Expense added successfully!");
        } catch (Exception e) {
            model.addAttribute("error", "Failed to save expense: " + e.getMessage());
        }
        return "redirect:/expenses";
    }
}
