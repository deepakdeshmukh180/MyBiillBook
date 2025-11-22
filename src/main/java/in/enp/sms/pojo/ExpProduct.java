package in.enp.sms.pojo;

public class ExpProduct {
    private String name;
    private int quantity;
    private int expiresIn; // number of days until expiration

    // Constructor
    public ExpProduct(String name, int quantity, int expiresIn) {
        this.name = name;
        this.quantity = quantity;
        this.expiresIn = expiresIn;
    }

    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getExpiresIn() {
        return expiresIn;
    }

    public void setExpiresIn(int expiresIn) {
        this.expiresIn = expiresIn;
    }
}