package in.enp.sms.repository;

import in.enp.sms.entities.InvoiceDetails;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface InvoiceDetailsRepository extends JpaRepository<InvoiceDetails, String> {

    List<InvoiceDetails> findByCustId(String id);


    InvoiceDetails findByCustIdAndInvoiceId(String custId, String invoiceId);


    List<InvoiceDetails> findByDateBetweenAndOwnerId(LocalDate startDate, LocalDate endDate, String ownerId);

    List<InvoiceDetails> getByInvoiceIdContainingIgnoreCaseAndOwnerIdOrderByDateDesc(String currentFY, String ownerIdFromSession);

    @Query("SELECT i FROM InvoiceDetails i WHERE i.invoiceId LIKE %:fy AND i.ownerId = :ownerId ORDER BY i.date DESC")
    Page<InvoiceDetails> findByInvoiceIdEndingWithFyAndOwnerId(
            @Param("fy") String fy,
            @Param("ownerId") String ownerId,
            Pageable pageable
    );

    Page<InvoiceDetails> findByOwnerIdAndCustNameContainingIgnoreCaseOrInvoiceIdContainingIgnoreCase(String ownerId, String custName, String invoiceId, Pageable pageable);

    List<InvoiceDetails> findByOwnerIdAndDate(String ownerIdFromSession, LocalDate now);

    long countByOwnerIdAndDate(String ownerIdFromSession, LocalDate now);

    Page<InvoiceDetails> findByOwnerIdAndInvoiceIdContainingIgnoreCase(String ownerId, String query, Pageable pageable);

    Page<InvoiceDetails> findByOwnerIdAndCustNameContainingIgnoreCase(String ownerId, String query, Pageable pageable);

    @Query("SELECT i FROM InvoiceDetails i " +
            "WHERE i.ownerId = :ownerId " +
            "AND i.invoiceId LIKE CONCAT('%', :fy, '%') " +
            "AND (LOWER(i.custName) LIKE LOWER(CONCAT('%', :query, '%')) " +
            "     OR CAST(i.invoiceId AS string) LIKE CONCAT('%', :query, '%')) " +
            "ORDER BY i.invoiceId DESC")
    List<InvoiceDetails> findByOwnerIdAndInvoiceIdOrCustNameContainingIgnoreCase(
            @Param("ownerId") String ownerId,
            @Param("fy") String fy,
            @Param("query") String query);


}
    
