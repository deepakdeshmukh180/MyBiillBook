package in.enp.sms.repository;

import in.enp.sms.entities.ItemDetails;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ItemRepository extends JpaRepository<ItemDetails, String> {


    List<ItemDetails> findByInvoiceNoAndCustId(String invoiceNo, String custId);

    List<ItemDetails> findByInvoiceNoAndCustIdAndStatus(String invoiceId, String custId, boolean b);

    List<ItemDetails> findByCustId(String custId);

    List<ItemDetails> findByInvoiceNoAndStatus(String invoiceId, boolean b);
}
