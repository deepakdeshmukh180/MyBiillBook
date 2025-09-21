package in.enp.sms.repository;

import in.enp.sms.pojo.MonthlyExpenseSummary;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MonthlyExpenseSummaryRepository extends JpaRepository<MonthlyExpenseSummary, Long> {
    List<MonthlyExpenseSummary> findByOwnerIdOrderByMonth(String ownerId);
}
