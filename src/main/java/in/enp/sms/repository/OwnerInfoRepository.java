package in.enp.sms.repository;

import in.enp.sms.entities.OwnerInfo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OwnerInfoRepository extends JpaRepository<OwnerInfo, String> {

    List<OwnerInfo> findByStatus(String active);
}
