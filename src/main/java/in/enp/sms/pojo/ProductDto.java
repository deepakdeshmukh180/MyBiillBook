package in.enp.sms.pojo;

public class ProductDto {
    private Long productId;
    private String productName;
    private Double price;

    public ProductDto(Long productId, String productName, Double price) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
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

