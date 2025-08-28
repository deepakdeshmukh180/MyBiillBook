package in.enp.sms.repository;

import in.enp.sms.entities.InvoiceNo;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InvoiceNoRepository extends JpaRepository<InvoiceNo, String> {

    boolean existsByOwnerId(String ownerId);

    InvoiceNo findByOwnerId(String ownerId);
}
