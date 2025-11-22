package in.enp.sms.repository;

import in.enp.sms.entities.DailyExpense;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface DailyExpenseRepository extends JpaRepository<DailyExpense, Long> {
    List<DailyExpense> findByDate(Date date);

    // Find expenses by date + ownerId, sorted by createdAt DESC
    List<DailyExpense> findByDateAndOwnerIdOrderByCreatedAtDesc(Date date, String ownerId);

    // Optional: find all for owner sorted by createdAt
    List<DailyExpense> findByOwnerIdOrderByCreatedAtDesc(String ownerId);

    @Query("SELECT SUM(e.amount) FROM DailyExpense e WHERE e.date = :date AND e.ownerId = :ownerId")
    Double getDailyTotal(@Param("date") Date date, @Param("ownerId") String ownerId);


    @Query("SELECT SUM(e.amount) FROM DailyExpense e " +
            "WHERE FUNCTION('MONTH', e.date) = FUNCTION('MONTH', CURRENT_DATE) " +
            "AND FUNCTION('YEAR', e.date) = FUNCTION('YEAR', CURRENT_DATE) " +
            "AND e.ownerId = :ownerId")
    Double getCurrentMonthTotal(@Param("ownerId") String ownerId);




    @Query(value = "SELECT owner_id, SUM(amount) FROM daily_expense " +
            "WHERE expense_date BETWEEN :startDate AND :endDate " +
            "GROUP BY owner_id", nativeQuery = true)
    List<Object[]> findMonthlyExpensesForYearRange(@Param("startDate") Date startDate,
                                                   @Param("endDate") Date endDate);

    List<DailyExpense> findByDateAndOwnerId(Date date, String ownerId);
}
