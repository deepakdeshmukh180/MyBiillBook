package in.enp.sms.pojo;

public class ProductDto {
    private Long productId;
    private String productName;
    private Double price;
    private String batchNo;
    private long stock;
    private String expDate ;

    public ProductDto(Long productId, String productName, Double price, String batchNo, String expDate, long stock) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.batchNo = batchNo;
        this.expDate = expDate;
        this.stock = stock;

    }

    public long getStock() {
        return stock;
    }

    public void setStock(long stock) {
        this.stock = stock;
    }

    public String getBatchNo() {
        return batchNo;
    }

    public void setBatchNo(String batchNo) {
        this.batchNo = batchNo;
    }

    public String getExpDate() {
        return expDate;
    }

    public void setExpDate(String expDate) {
        this.expDate = expDate;
    }

    // getters & setters

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }
}

