package in.enp.sms.pojo;

public class ProductDto {
    private Long productId;
    private String productName;
    private String batchNo;
    private long stock;
    private String expDate;
    private int taxPercentage;
    private String pname;

    private Double price;
    private Double mrp;
    private Double dealerPrice;

    // ✅ Constructor including all fields
    public ProductDto(Long productId, String productName, String batchNo, long stock,
                      String expDate, int taxPercentage, String pname,
                      Double price, Double mrp, Double dealerPrice) {
        this.productId = productId;
        this.productName = productName;
        this.batchNo = batchNo;
        this.stock = stock;
        this.expDate = expDate;
        this.taxPercentage = taxPercentage;
        this.pname = pname;
        this.price = price;
        this.mrp = mrp;
        this.dealerPrice = dealerPrice;
    }

    // ✅ Getters and Setters
    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
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

    public long getStock() {
        return stock;
    }

    public void setStock(long stock) {
        this.stock = stock;
    }

    public String getExpDate() {
        return expDate;
    }

    public void setExpDate(String expDate) {
        this.expDate = expDate;
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

    public void setPname(String pname) {
        this.pname = pname;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Double getMrp() {
        return mrp;
    }

    public void setMrp(Double mrp) {
        this.mrp = mrp;
    }

    public Double getDealerPrice() {
        return dealerPrice;
    }

    public void setDealerPrice(Double dealerPrice) {
        this.dealerPrice = dealerPrice;
    }
}
