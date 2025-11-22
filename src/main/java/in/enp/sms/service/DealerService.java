package in.enp.sms.service;

import in.enp.sms.entities.DealerInfo;
import in.enp.sms.pojo.DealerPayment;

import java.util.List;
import java.util.Optional;

public interface DealerService {
    List<DealerInfo> findAll();

    DealerInfo findById(String dealerId);

    Optional<DealerInfo> findByOwnerIdAndId(String ownerId, String dealerId);

    List<DealerPayment> getPaymentHistory(String dealerId);

    DealerInfo update(DealerInfo dealer);

    List<DealerInfo> findByOwnerIdAndStatusOrderByLastModifiedDateDesc(String ownerIdFromSession, String active);
}
