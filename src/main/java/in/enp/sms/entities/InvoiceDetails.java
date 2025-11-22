package in.enp.sms.entities;

import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "invoice_info_tbl")
public class InvoiceDetails {

    @Id
    private String invoiceId;

    private String custName;

    private String custId;

    private Double totQty;

    private Double totInvoiceAmt;

    private Double totAmt;

    private Double balanceAmt;

    private Double discount;

    private Double preBalanceAmt;

    private Double advanAmt;

    private Double preTaxAmt;

    private Double tax;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;

    private String filePath;


    @Column(length = 1000)
    private String itemDetails;

    private String  oldInvoicesFlag;

    private String createdBy;

    private String  ownerId;

    private String  createdAt;


    private String  invoiceType;

    public String getInvoiceType() {
        return invoiceType;
    }

    public void setInvoiceType(String invoiceType) {
        this.invoiceType = invoiceType;
    }

    public String getOldInvoicesFlag() {
        return oldInvoicesFlag;
    }

    public void setOldInvoicesFlag(String oldInvoicesFlag) {
        this.oldInvoicesFlag = oldInvoicesFlag;
    }

    public InvoiceDetails() {
        super();
    }

    public String getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(String invoiceId) {
        this.invoiceId = invoiceId;
    }

    public String getCustName() {
        return custName;
    }

    public void setCustName(String custName) {
        this.custName = custName;
    }

    public String getCustId() {
        return custId;
    }

    public void setCustId(String custId) {
        this.custId = custId;
    }

    public Double getTotQty() {
        return totQty;
    }

    public void setTotQty(Double totQty) {
        this.totQty = totQty;
    }

    public Double getTotInvoiceAmt() {
        return totInvoiceAmt;
    }

    public void setTotInvoiceAmt(Double totInvoiceAmt) {
        this.totInvoiceAmt = totInvoiceAmt;
    }

    public Double getTotAmt() {
        return totAmt;
    }

    public void setTotAmt(Double totAmt) {
        this.totAmt = totAmt;
    }

    public Double getBalanceAmt() {
        return balanceAmt;
    }

    public void setBalanceAmt(Double balanceAmt) {
        this.balanceAmt = balanceAmt;
    }

    public Double getAdvanAmt() {
        return advanAmt;
    }

    public void setAdvanAmt(Double advanAmt) {
        this.advanAmt = advanAmt;
    }

    public LocalDate getDate() {
        return date;
    }

    public Double getPreTaxAmt() {
        return preTaxAmt;
    }

    public void setPreTaxAmt(Double preTaxAmt) {
        this.preTaxAmt = preTaxAmt;
    }

    public Double getTax() {
        return tax;
    }

    public void setTax(Double tax) {
        this.tax = tax;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public String getItemDetails() {
        return itemDetails;
    }

    public void setItemDetails(String itemDetails) {
        this.itemDetails = itemDetails;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public Double getPreBalanceAmt() {
        return preBalanceAmt;
    }

    public void setPreBalanceAmt(Double preBalanceAmt) {
        this.preBalanceAmt = preBalanceAmt;
    }

    public String getOwnerId() {
        return ownerId;
    }

    public Double getDiscount() {
        return discount;
    }

    public void setDiscount(Double discount) {
        this.discount = discount;
    }

    public void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }
}
