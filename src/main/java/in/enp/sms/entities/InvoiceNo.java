package in.enp.sms.entities;

import javax.persistence.*;

@Entity
@Table(name = "invoice_count")
public class InvoiceNo {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "bill_no_gen")
    @SequenceGenerator(name = "bill_no_gen", sequenceName = "bill_no_seq", allocationSize = 1)
    private Long billNo;


    private String ownerId ;

    private long invoiceNumber;



    public InvoiceNo() {
        super();
    }

    public String getInvoiceId() {
        return ownerId;
    }

    public void setInvoiceId(String ownerId) {
        this.ownerId = ownerId;
    }

    public long getInvoiceNumber() {
        return invoiceNumber;
    }

    public void setInvoiceNumber(long invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }


    public Long getBillNo() {
        return billNo;
    }

    public void setBillNo(Long billNo) {
        this.billNo = billNo;
    }

    public String getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }
}
