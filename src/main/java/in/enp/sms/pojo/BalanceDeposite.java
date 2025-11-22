package in.enp.sms.pojo;


import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "tbl_balance_deposit")
public class BalanceDeposite {

    @Id
    private String id;

    private String custId;

    private String custName;

    private double advAmt;

    private String modeOfPayment;

    private String description;

    private double totalAmount;

    private double currentOusting;

    private double paidAmout;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;

    private String createdBy;

    private String  createdAt;

    private String  ownerId;

    public BalanceDeposite() {
    }


    public String getCustName() {
        return custName;
    }

    public void setCustName(String custName) {
        this.custName = custName;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public double getCurrentOusting() {
        return currentOusting;
    }

    public void setCurrentOusting(double currentOusting) {
        this.currentOusting = currentOusting;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getPaidAmout() {
        return paidAmout;
    }

    public void setPaidAmout(double paidAmout) {
        this.paidAmout = paidAmout;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getAdvAmt() {
        return advAmt;
    }

    public void setAdvAmt(double advAmt) {
        this.advAmt = advAmt;
    }

    public String getCustId() {
        return custId;
    }

    public void setCustId(String custId) {
        this.custId = custId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getModeOfPayment() {
        return modeOfPayment;
    }

    public void setModeOfPayment(String modeOfPayment) {
        this.modeOfPayment = modeOfPayment;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }
}


