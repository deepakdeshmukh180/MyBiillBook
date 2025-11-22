package in.enp.sms.service;

import in.enp.sms.entities.PurchaseItem;
import in.enp.sms.pojo.PurchaseTotals;
import in.enp.sms.repository.PurchaseItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Collections;
import java.util.List;

@Service
@Transactional
public class PurchaseItemServiceImpl implements PurchaseItemService{


        @Autowired
        private PurchaseItemRepository purchaseItemRepository;

        /**
         * Save purchase item
         *
         * @return
         */
        public PurchaseItem save(PurchaseItem item) {
            return purchaseItemRepository.save(item);
        }

        /**
         * Find purchase item by ID
         */
        public PurchaseItem findById(String id) {
            return purchaseItemRepository.findById(id).orElse(null);
        }

        /**
         * Find all items by purchase number
         */
        public List<PurchaseItem> findByPurchaseNo(String purchaseNo) {
            return purchaseItemRepository.findByPurchaseNo(purchaseNo);
        }

        /**
         * Find all items by dealer
         */
        public List<PurchaseItem> findByDealerId(String dealerId) {
            return purchaseItemRepository.findByDealerId(dealerId);
        }

        /**
         * Find all items by product
         */
        public List<PurchaseItem> findByProductId(String productId) {
            return purchaseItemRepository.findByProductId(productId);
        }

        /**
         * Delete purchase item
         */
        public void deleteById(String id) {
            purchaseItemRepository.deleteById(id);
        }

    @Override
    public List<PurchaseItem> findByPurchaseNoAndDealerIdAndStatus(String purchaseNo, String dealerId, boolean b) {
        return purchaseItemRepository.findByPurchaseNoAndDealerIdAndStatus( purchaseNo,  dealerId,  b);
    }

    @Override
    public void saveAll(List<PurchaseItem> items) {
        purchaseItemRepository.saveAll(items);
    }

    /**
         * Delete all items by purchase number
         */
        public void deleteByPurchaseNo(String purchaseNo) {
            purchaseItemRepository.deleteByPurchaseNo(purchaseNo);
        }

        /**
         * Get total quantity for purchase
         */
        public Integer getTotalQuantity(String purchaseNo) {
            Integer total = purchaseItemRepository.getTotalQuantityByPurchaseNo(purchaseNo);
            return total != null ? total : 0;
        }

        /**
         * Calculate totals for purchase
         */
        public PurchaseTotals calculateTotals(String purchaseNo) {
            List<PurchaseItem> items = findByPurchaseNo(purchaseNo);

            PurchaseTotals totals = new PurchaseTotals();
            totals.setTotalItems(items.size());

            java.math.BigDecimal totalAmount = java.math.BigDecimal.ZERO;
            java.math.BigDecimal totalGst = java.math.BigDecimal.ZERO;
            int totalQty = 0;

            for (PurchaseItem item : items) {
                totalAmount = totalAmount.add(item.getTotalAmount());
                totalGst = totalGst.add(item.getGstAmount());
                totalQty += item.getQuantity();
            }

            totals.setTotalAmount(totalAmount);
            totals.setTotalGst(totalGst);
            totals.setTotalQuantity(totalQty);

            return totals;
        }

}
