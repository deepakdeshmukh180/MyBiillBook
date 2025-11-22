package in.enp.sms.entities;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Date;

@Entity
@Table(name = "purchases")
public class Purchase {

    @Id
    @Column(length = 100)
    private String id;

    @Column(name = "purchase_no", length = 50, unique = true, nullable = false)
    private String purchaseNo;

    @Column(name = "dealer_id", length = 100, nullable = false)
    private String dealerId;

    @Column(name = "dealer_invoice_no", length = 100)
    private String dealerInvoiceNo;

    @Column(name = "invoice_date")
    private LocalDate invoiceDate;

    @Column(name = "total_items")
    private int totalItems;

    @Column(name = "total_amount", precision = 10, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "total_gst", precision = 10, scale = 2)
    private BigDecimal totalGst;

    @Column(name = "notes", length = 500)
    private String notes;

    @Column(name = "status", length = 20)
    private String status; // DRAFT, COMPLETED, CANCELLED

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @Column(name = "updated_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;

    // Constructors
    public Purchase() {
        this.createdAt = new Date();
        this.updatedAt = new Date();
        this.status = "DRAFT";
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPurchaseNo() {
        return purchaseNo;
    }

    public void setPurchaseNo(String purchaseNo) {
        this.purchaseNo = purchaseNo;
    }

    public String getDealerId() {
        return dealerId;
    }

    public void setDealerId(String dealerId) {
        this.dealerId = dealerId;
    }

    public String getDealerInvoiceNo() {
        return dealerInvoiceNo;
    }

    public void setDealerInvoiceNo(String dealerInvoiceNo) {
        this.dealerInvoiceNo = dealerInvoiceNo;
    }

    public LocalDate getInvoiceDate() {
        return invoiceDate;
    }

    public void setInvoiceDate(LocalDate invoiceDate) {
        this.invoiceDate = invoiceDate;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getTotalGst() {
        return totalGst;
    }

    public void setTotalGst(BigDecimal totalGst) {
        this.totalGst = totalGst;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    @PreUpdate
    public void preUpdate() {
        this.updatedAt = new Date();
    }
}
