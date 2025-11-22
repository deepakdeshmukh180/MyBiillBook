package in.enp.sms.repository;

import in.enp.sms.entities.PurchaseItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PurchaseItemRepository extends JpaRepository<PurchaseItem, String> {

    List<PurchaseItem> findByPurchaseNo(String purchaseNo);

    List<PurchaseItem> findByDealerId(String dealerId);

    List<PurchaseItem> findByProductId(String productId);

    @Query("SELECT SUM(pi.quantity) FROM PurchaseItem pi WHERE pi.purchaseNo = :purchaseNo")
    Integer getTotalQuantityByPurchaseNo(@Param("purchaseNo") String purchaseNo);

    void deleteByPurchaseNo(String purchaseNo);

    List<PurchaseItem> findByPurchaseNoAndDealerIdAndStatus(String purchaseNo, String dealerId, boolean b);
}
