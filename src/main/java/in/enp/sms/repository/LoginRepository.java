package in.enp.sms.repository;

import in.enp.sms.entities.Login;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;


@Repository
@Transactional
public interface LoginRepository extends JpaRepository<Login, Long> {

    List<Login> findByUserNameAndPassword(String username, String password);

}
