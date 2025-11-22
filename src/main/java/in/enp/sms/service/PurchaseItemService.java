package in.enp.sms.service;

import in.enp.sms.entities.PurchaseItem;

import java.util.List;

public interface PurchaseItemService {
    List<PurchaseItem> findByPurchaseNo(String purchaseNo);

    PurchaseItem save(PurchaseItem item);

    void deleteById(String itemId);

    List<PurchaseItem> findByPurchaseNoAndDealerIdAndStatus(String purchaseNo, String dealerId, boolean b);

    void saveAll(List<PurchaseItem> items);
}
