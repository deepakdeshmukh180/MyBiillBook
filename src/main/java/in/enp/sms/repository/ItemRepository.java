package in.enp.sms.repository;

import in.enp.sms.entities.ItemDetails;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ItemRepository extends JpaRepository<ItemDetails, String> {


    List<ItemDetails> findByInvoiceNoAndCustId(String invoiceNo, String custId);

    List<ItemDetails> findByCustId(String custId);

    List<ItemDetails> findByInvoiceNoAndStatus(String invoiceId, boolean b);

    List<ItemDetails> findByInvoiceNoAndCustIdAndStatusOrderByItemNoAsc(String invoiceId, String custId, boolean b);


        @Query("SELECT i FROM ItemDetails i " +
                "WHERE i.invoiceNo = :invoiceNo AND i.custId = :custId")
        List<ItemDetails> findItemsByInvoiceNoAndCustId(@Param("invoiceNo") String invoiceNo,
                                                   @Param("custId") String custId);
    }
