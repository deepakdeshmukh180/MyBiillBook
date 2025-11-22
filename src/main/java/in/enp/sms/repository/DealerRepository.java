package in.enp.sms.repository;



import in.enp.sms.entities.DealerInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DealerRepository extends JpaRepository<DealerInfo, String> {


    List<DealerInfo>  findByOwnerIdAndStatusOrderByLastModifiedDateDesc(String ownerIdFromSession, String active);

    Optional<DealerInfo> findByOwnerIdAndId(String ownerId, String dealerId);

    List<DealerInfo> findByDealerNameContainingIgnoreCaseOrMobileNoContainingIgnoreCase(String query, String query1);
}
