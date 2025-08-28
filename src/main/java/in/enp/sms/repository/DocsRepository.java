package in.enp.sms.repository;

import in.enp.sms.entities.DocEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface DocsRepository extends JpaRepository<DocEntity, Long> {

    List<DocEntity> findByStdId(String stdId);

    List<DocEntity> findByStdIdAndStatus(String stdId, String string);

}
