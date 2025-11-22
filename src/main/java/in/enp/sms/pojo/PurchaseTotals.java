package in.enp.sms.pojo;

public class PurchaseTotals {
    private int totalItems;
    private int totalQuantity;
    private java.math.BigDecimal totalAmount;
    private java.math.BigDecimal totalGst;

    public int getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public java.math.BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(java.math.BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public java.math.BigDecimal getTotalGst() {
        return totalGst;
    }

    public void setTotalGst(java.math.BigDecimal totalGst) {
        this.totalGst = totalGst;
    }
}
