package in.enp.sms.entities;

import javax.persistence.*;

@Entity
@Table(name = "item_info_tbl")

public class ItemDetails {

    @Id
    private String id;
    private String invoiceNo;
    private int itemNo;
    private String description;
    private double qty;
    private double rate;
    private double amount;
    private String batchNo;
    private double mrp;
    private boolean status;
    private long productId;

    private double taxAmount;

    private String brand;

    private String expDate;
    private String custId;
    private int taxPercetage;
    private double priTaxAmt;


    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public int getTaxPercetage() {
        return taxPercetage;
    }

    public void setTaxPercetage(int taxPercetage) {
        this.taxPercetage = taxPercetage;
    }

    public double getTaxAmount() {
        return taxAmount;
    }

    public String getExpDate() {
        return expDate;
    }

    public void setExpDate(String expDate) {
        this.expDate = expDate;
    }

    public void setTaxAmount(double taxAmount) {
        this.taxAmount = taxAmount;
    }

    public double getPriTaxAmt() {
        return priTaxAmt;
    }

    public void setPriTaxAmt(double priTaxAmt) {
        this.priTaxAmt = priTaxAmt;
    }

    public String getBatchNo() {
        return batchNo;
    }

    public void setBatchNo(String batchNo) {
        this.batchNo = batchNo;
    }

    public double getMrp() {
        return mrp;
    }

    public void setMrp(double mrp) {
        this.mrp = mrp;
    }

    public ItemDetails() {
        super();
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getInvoiceNo() {
        return invoiceNo;
    }

    public void setInvoiceNo(String invoiceNo) {
        this.invoiceNo = invoiceNo;
    }

    public int getItemNo() {
        return itemNo;
    }

    public void setItemNo(int itemNo) {
        this.itemNo = itemNo;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getCustId() {
        return custId;
    }

    public void setCustId(String custId) {
        this.custId = custId;
    }


}
