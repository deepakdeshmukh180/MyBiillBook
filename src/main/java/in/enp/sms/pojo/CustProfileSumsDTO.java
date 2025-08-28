package in.enp.sms.pojo;

public class CustProfileSumsDTO {
    private Double totalAmount;
    private Double currentOusting;
    private Double paidAmout;


    public Double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Double getCurrentOusting() {
        return currentOusting;
    }

    public void setCurrentOusting(Double currentOusting) {
        this.currentOusting = currentOusting;
    }

    public Double getPaidAmout() {
        return paidAmout;
    }

    public void setPaidAmout(Double paidAmout) {
        this.paidAmout = paidAmout;
    }

    public CustProfileSumsDTO(Double totalAmount, Double currentOusting, Double paidAmout) {
        this.totalAmount = totalAmount;
        this.currentOusting = currentOusting;
        this.paidAmout = paidAmout;
    }

    public CustProfileSumsDTO() {
    }
}
