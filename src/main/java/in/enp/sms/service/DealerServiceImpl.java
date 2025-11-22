package in.enp.sms.service;

import in.enp.sms.entities.DealerInfo;
import in.enp.sms.pojo.DealerPayment;
import in.enp.sms.repository.DealerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class DealerServiceImpl implements DealerService{

    @Autowired
    DealerRepository dealerRepository;

    @Autowired
    private PurchaseService purchaseService;

    /**
     * Find dealer by ID
     */
    public DealerInfo findById(String id) {
        return dealerRepository.findById(id).orElse(null);
    }

    /**
     * Find all dealers
     */
    public List<DealerInfo> findAll() {
        return dealerRepository.findAll();
    }

    /**
     * Save dealer
     */
    public DealerInfo save(DealerInfo dealer) {
        return dealerRepository.save(dealer);
    }

    /**
     * Update dealer
     *
     * @return
     */
    public DealerInfo update(DealerInfo dealer) {
        return dealerRepository.save(dealer);
    }

    @Override
    public List<DealerInfo> findByOwnerIdAndStatusOrderByLastModifiedDateDesc(String ownerIdFromSession, String active) {
        return dealerRepository.findByOwnerIdAndStatusOrderByLastModifiedDateDesc(ownerIdFromSession,active);
    }

    @Override
    public Optional<DealerInfo> findByOwnerIdAndId(String ownerId, String dealerId) {
        return dealerRepository.findByOwnerIdAndId(ownerId,dealerId);
    }

    /**
     * Delete dealer
     */
    public void deleteById(String id) {
        dealerRepository.deleteById(id);
    }

    /**
     * Get payment history for dealer
     */
    public List<DealerPayment> getPaymentHistory(String dealerId) {
        // Implementation depends on your DealerPayment entity
        // This is a placeholder
        return java.util.Collections.emptyList();
    }

    /**
     * Search dealers by name or phone
     */
    public List<DealerInfo> searchDealers(String query) {
        return dealerRepository.findByDealerNameContainingIgnoreCaseOrMobileNoContainingIgnoreCase(query, query);
    }
}


