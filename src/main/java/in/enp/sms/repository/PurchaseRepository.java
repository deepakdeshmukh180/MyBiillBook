package in.enp.sms.repository;

import in.enp.sms.entities.Purchase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface PurchaseRepository extends JpaRepository<Purchase, String> {

    List<Purchase> findByDealerId(String dealerId);

    Optional<Purchase> findByPurchaseNo(String purchaseNo);

    List<Purchase> findByInvoiceDateBetween(LocalDate fromDate, LocalDate toDate);

    List<Purchase> findByStatus(String status);

    @Query("SELECT p FROM Purchase p WHERE p.dealerId = :dealerId AND p.status = :status")
    List<Purchase> findByDealerIdAndStatus(@Param("dealerId") String dealerId, @Param("status") String status);

    @Query("SELECT COUNT(p) FROM Purchase p WHERE DATE(p.createdAt) = CURRENT_DATE")
    long countTodayPurchases();
}
