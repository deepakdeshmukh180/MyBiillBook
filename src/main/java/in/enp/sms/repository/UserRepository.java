package in.enp.sms.repository;

import in.enp.sms.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsernameAndStatus(String username,String status);

    User findByUsername(String userName);

    boolean existsByUsername(String username);

    List<User> findByOwnerIdIsNull();
}
