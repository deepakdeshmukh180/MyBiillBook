package in.enp.sms.service;

import in.enp.sms.entities.DocEntity;
import in.enp.sms.repository.DocsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DocsServiceImpl implements DocsService {


    @Autowired
    DocsRepository docsRepository;

    @Override
    public List<DocEntity> saveDocumentInformation(DocEntity docEntity) {
        docsRepository.save(docEntity);
        List<DocEntity> list = docsRepository.findByStdIdAndStatus(docEntity.getStdId(), "ACTIVE");
        return list;
    }

    @Override
    public List<DocEntity> getDocListByStdId(String stdId) {
        return docsRepository.findByStdIdAndStatus(stdId, "ACTIVE");
    }

    @Override
    public DocEntity getDocEntityBy(String docId) {
        long id = Long.parseLong(docId);
        return docsRepository.getOne(id);
    }

}
