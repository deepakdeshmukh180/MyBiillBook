package in.enp.sms.pojo;

import java.math.BigDecimal;

public class PurchaseItemRequest {
    private String dealerId;
    private String purchaseNo;
    private int itemNo;
    private String productId;
    private String productName;
    private String batchNo;
    private int quantity;
    private BigDecimal rate;
    private BigDecimal gstPercent;

    // Getters and setters
    public String getDealerId() { return dealerId; }
    public void setDealerId(String dealerId) { this.dealerId = dealerId; }

    public String getPurchaseNo() { return purchaseNo; }
    public void setPurchaseNo(String purchaseNo) { this.purchaseNo = purchaseNo; }

    public int getItemNo() { return itemNo; }
    public void setItemNo(int itemNo) { this.itemNo = itemNo; }

    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getBatchNo() { return batchNo; }
    public void setBatchNo(String batchNo) { this.batchNo = batchNo; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getRate() { return rate; }
    public void setRate(BigDecimal rate) { this.rate = rate; }

    public BigDecimal getGstPercent() { return gstPercent; }
    public void setGstPercent(BigDecimal gstPercent) { this.gstPercent = gstPercent; }
}
