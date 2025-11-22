package in.enp.sms.repository;

import in.enp.sms.pojo.BalanceDeposite;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface BalanceDepositeRepository extends JpaRepository<BalanceDeposite, String> {
    List<BalanceDeposite> findByCustId(String custId);


    List<BalanceDeposite> findByDateBetweenAndOwnerId(LocalDate startDate, LocalDate endDate, String ownerId);

    List<BalanceDeposite> findByOwnerIdAndDate(String ownerId, LocalDate startDate);

    long countByOwnerIdAndDate(String ownerIdFromSession, LocalDate now);
}
