package in.enp.sms.repository;

import in.enp.sms.entities.CustProfile;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CustProfileRepository extends JpaRepository<CustProfile, String> {

    List<CustProfile> findByPhoneNo(String phoneNo);

    List<CustProfile> findTop5ByOwnerIdOrderByLastModifiedDateDesc(String name);
    

    List<CustProfile> findByPhoneNoAndOwnerId(String phoneNo, String ownerIdFromSession);

    List<CustProfile> findByOwnerId(String ownerIdFromSession);
    Page<CustProfile> findByOwnerId(String ownerIdFromSession , Pageable pageable);

    @Query("SELECT SUM(c.totalAmount), SUM(c.currentOusting), SUM(c.paidAmout) " +
            "FROM CustProfile c WHERE c.ownerId = :ownerId")
    Object[] findSumsByOwnerId(@Param("ownerId") String ownerId);

    List<CustProfile> findBycustNameContainingIgnoreCaseOrAddressContainingIgnoreCaseOrPhoneNoContaining(String query, String query1, String query2);

    Page<CustProfile> findByOwnerIdAndCustNameContainingIgnoreCase(String ownerId, String search, Pageable pageable);

    List<CustProfile> findByCustNameContainingIgnoreCaseOrAddressContainingIgnoreCaseOrPhoneNoContainingAndOwnerId(String query, String query1, String query2, String ownerId);

    List<CustProfile> findByOwnerIdOrderByCustNameAsc(String ownerId);

    long countByOwnerId(String ownerId);
}
