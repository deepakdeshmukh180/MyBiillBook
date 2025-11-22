package in.enp.sms.repository;

import in.enp.sms.entities.Product;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;
import java.util.Optional;

public interface ProductRepository extends PagingAndSortingRepository<Product, Long> {

    List<Product> findByOwnerId(String ownerIdFromSession);

    List<Product> findByOwnerIdOrderByExpdateAsc(String ownerId);

    List<Product> findByProductIdAndOwnerId(long productId, String ownerId);

    boolean existsByProductNameAndOwnerId(String productName, String ownerId);

    List<Product> findByProductNameContainingIgnoreCaseAndOwnerId(String query, String ownerIdFromSession);

    Optional<Product> findByProductIdAndBatchNo(Long aLong, String batchNo);
}
