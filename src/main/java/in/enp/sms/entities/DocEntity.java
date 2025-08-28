package in.enp.sms.entities;

import javax.persistence.*;

@Entity
@Table(name = "doc_upload_tbl")
@SequenceGenerator(name = "docid-gen", sequenceName = "DOC_SQS", initialValue = 1000, allocationSize = 1)
public class DocEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "docid-gen")
    private long id;

    private String docType;

    private String docSize;

    private String path;

    private String stdId;

    private String status;

    public DocEntity(long id, String docType, String docSize, String path, String stdId, String status) {
        super();
        this.id = id;
        this.docType = docType;
        this.docSize = docSize;
        this.path = path;
        this.stdId = stdId;
        this.status = status;
    }

    public DocEntity() {
        super();
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getDocType() {
        return docType;
    }

    public void setDocType(String docType) {
        this.docType = docType;
    }

    public String getDocSize() {
        return docSize;
    }

    public void setDocSize(String docSize) {
        this.docSize = docSize;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
