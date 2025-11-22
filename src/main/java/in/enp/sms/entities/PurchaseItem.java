package in.enp.sms.entities;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;
@Entity
@Table(name = "purchase_items")
public class PurchaseItem {

    @Id
    @Column(length = 100)
    private String id;

    @Column(name = "purchase_no", length = 50, nullable = false)
    private String purchaseNo;

    @Column(name = "dealer_id", length = 100, nullable = false)
    private String dealerId;

    @Column(name = "item_no")
    private int itemNo;

    @Column(name = "product_id", length = 100, nullable = false)
    private String productId;

    @Column(name = "product_name", length = 200)
    private String productName;

    @Column(name = "batch_no", length = 50)
    private String batchNo;

    @Column(name = "quantity")
    private int quantity;

    @Column(name = "rate", precision = 10, scale = 2)
    private BigDecimal rate;

    @Column(name = "gst_percent", precision = 5, scale = 2)
    private BigDecimal gstPercent;

    @Column(name = "gst_amount", precision = 10, scale = 2)
    private BigDecimal gstAmount;

    @Column(name = "total_amount", precision = 10, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;


    @Column(name = "status")
    private Boolean status;


    // Constructors
    public PurchaseItem() {
        this.createdAt = new Date();
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
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

    public int getItemNo() {
        return itemNo;
    }

    public void setItemNo(int itemNo) {
        this.itemNo = itemNo;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getBatchNo() {
        return batchNo;
    }

    public void setBatchNo(String batchNo) {
        this.batchNo = batchNo;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }


    public void setRate(BigDecimal rate) {
        this.rate = rate;
    }

    public BigDecimal getGstPercent() {
        return gstPercent;
    }

    public void setGstPercent(BigDecimal gstPercent) {
        this.gstPercent = gstPercent;
    }

    public BigDecimal getGstAmount() {
        return gstAmount;
    }

    public void setGstAmount(BigDecimal gstAmount) {
        this.gstAmount = gstAmount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public BigDecimal getRate() {
        return rate;
    }
}
