package in.enp.sms.repository;

import in.enp.sms.entities.Product;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ProductRepository extends PagingAndSortingRepository<Product, Long> {

    List<Product> findByOwnerId(String ownerIdFromSession);

    List<Product> findByOwnerIdOrderByExpdateAsc(String ownerId);

    List<Product> findByProductIdAndOwnerId(long productId, String ownerId);

    boolean existsByProductNameAndOwnerId(String productName, String ownerId);

    List<Product> findByProductNameContainingIgnoreCaseAndOwnerId(String query, String ownerIdFromSession);

    Optional<Product> findByProductIdAndBatchNo(Long aLong, String batchNo);

    // Add this to ProductRepository interface
    @Query("SELECT p FROM Product p WHERE p.ownerId = :ownerId AND " +
            "(UPPER(p.productName) LIKE %:query% OR " +
            "UPPER(p.company) LIKE %:query% OR " +
            "UPPER(p.batchNo) LIKE %:query%)")
    List<Product> searchProducts(@Param("query") String query, @Param("ownerId") String ownerId);
}
