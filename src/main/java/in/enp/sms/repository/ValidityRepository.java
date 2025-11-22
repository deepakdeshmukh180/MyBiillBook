package in.enp.sms.repository;

import in.enp.sms.entities.ValidityDetails;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ValidityRepository extends JpaRepository<ValidityDetails, String> {
}
