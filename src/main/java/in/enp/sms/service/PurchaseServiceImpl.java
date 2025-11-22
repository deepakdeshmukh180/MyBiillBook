package in.enp.sms.service;

import in.enp.sms.entities.Purchase;
import in.enp.sms.repository.PurchaseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@Transactional
public class PurchaseServiceImpl implements  PurchaseService{

    @Autowired
    private PurchaseRepository purchaseRepository;

    /**
     * Generate unique purchase number
     */
    public String generatePurchaseNumber() {
        String prefix = "PUR";
        String datePart = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        long todayCount = purchaseRepository.countTodayPurchases();
        String sequence = String.format("%04d", todayCount + 1);
        return prefix + datePart + sequence;
    }

    /**
     * Save purchase
     *
     * @return
     */
    public Purchase save(Purchase purchase) {
        return purchaseRepository.save(purchase);
    }

    /**
     * Update purchase
     */
    public Purchase update(Purchase purchase) {
        return purchaseRepository.save(purchase);
    }

    /**
     * Find purchase by ID
     */
    public Purchase findById(String id) {
        return purchaseRepository.findById(id).orElse(null);
    }

    /**
     * Find purchase by purchase number
     */
    public Purchase findByPurchaseNo(String purchaseNo) {
        return purchaseRepository.findByPurchaseNo(purchaseNo).orElse(null);
    }

    /**
     * Find all purchases by dealer
     */
    public List<Purchase> findByDealerId(String dealerId) {
        return purchaseRepository.findByDealerId(dealerId);
    }

    /**
     * Find purchases by date range
     */
    public List<Purchase> findByDateRange(LocalDate fromDate, LocalDate toDate) {
        return purchaseRepository.findByInvoiceDateBetween(fromDate, toDate);
    }

    /**
     * Find all purchases
     */
    public List<Purchase> findAll() {
        return purchaseRepository.findAll();
    }

    /**
     * Find purchases by status
     */
    public List<Purchase> findByStatus(String status) {
        return purchaseRepository.findByStatus(status);
    }

    /**
     * Delete purchase
     */
    public void deleteById(String id) {
        purchaseRepository.deleteById(id);
    }

    /**
     * Get total purchase amount for dealer
     */
    public java.math.BigDecimal getTotalPurchaseAmount(String dealerId) {
        List<Purchase> purchases = findByDealerId(dealerId);
        return purchases.stream()
                .map(Purchase::getTotalAmount)
                .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add);
    }
}


