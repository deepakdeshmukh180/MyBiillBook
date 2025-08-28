package in.enp.sms.entities;


import javax.persistence.*;

@Entity
@Table(name = "tbl_product")
@SequenceGenerator(name = "productid-gen", sequenceName = "CUST_SQS", initialValue = 1000, allocationSize = 1)
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "productid-gen")
    private long productId;

    private String productName;


    private  String batchNo;

    private  String ownerId;

    private  String quantity;

    private  Double price;

    private  String company;

    private  long  stock;

    private  String expdate;

    private  String pname;


    private  int taxPercentage;

    private  Double mrp;

    private  Double delarPrice;

    private  Boolean status ;

    @Transient
    private  String custId ;



    public Product() {

    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public long getProductId() {
        return productId;
    }


    public String getCustId() {
        return custId;
    }

    public void setCustId(String custId) {
        this.custId = custId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public String getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }

    public String getBatchNo() {
        return batchNo;
    }

    public void setBatchNo(String batchNo) {
        this.batchNo = batchNo;
    }

    public String getQuantity() {
        return quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public Double getMrp() {
        return mrp;
    }

    public void setMrp(Double mrp) {
        this.mrp = mrp;
    }

    public long getStock() {
        return stock;
    }

    public void setStock(long stock) {
        this.stock = stock;
    }

    public String getExpdate() {
        return expdate;
    }

    public void setExpdate(String expdate) {
        this.expdate = expdate;
    }

    public int getTaxPercentage() {
        return taxPercentage;
    }

    public void setTaxPercentage(int taxPercentage) {
        this.taxPercentage = taxPercentage;
    }

    public String getPname() {
        return pname;
    }


    public Double getDelarPrice() {
        return delarPrice;
    }

    public void setDelarPrice(Double delarPrice) {
        this.delarPrice = delarPrice;
    }

    public void setPname(String pname) {
        this.pname = pname;
    }
}
