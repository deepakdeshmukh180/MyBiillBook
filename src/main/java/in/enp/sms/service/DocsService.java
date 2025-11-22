package in.enp.sms.service;

import in.enp.sms.entities.DocEntity;

import java.util.List;

public interface DocsService {

    List<DocEntity> saveDocumentInformation(DocEntity docEntity);

    List<DocEntity> getDocListByStdId(String stdId);

    DocEntity getDocEntityBy(String docId);

}
