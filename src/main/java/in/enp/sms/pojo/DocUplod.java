package in.enp.sms.pojo;

import org.springframework.web.multipart.MultipartFile;

public class DocUplod {


    private String invoiceNo;

    private MultipartFile file;


    public DocUplod() {
        super();
    }

    public DocUplod(String invoiceNo, MultipartFile file) {
        super();
        this.invoiceNo = invoiceNo;
        this.file = file;
    }

    public MultipartFile getFile() {
        return file;
    }

    public void setFile(MultipartFile file) {
        this.file = file;
    }

    public String getInvoiceNo() {
        return invoiceNo;
    }

    public void setInvoiceNo(String invoiceNo) {
        this.invoiceNo = invoiceNo;
    }


//	


}
