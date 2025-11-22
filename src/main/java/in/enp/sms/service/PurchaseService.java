package in.enp.sms.service;

import in.enp.sms.entities.Purchase;

import java.time.LocalDate;
import java.util.List;

public interface PurchaseService {
    String generatePurchaseNumber();

    List<Purchase> findByDealerId(String dealerId);

    List<Purchase> findByDateRange(LocalDate from, LocalDate to);

    Purchase findById(String purchaseId);

    List<Purchase> findAll();

    Purchase save(Purchase purchase);
}
