package in.enp.sms.entities;

import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Entity
@Table(name = "cust_profile_tbl")
@EntityListeners(AuditingEntityListener.class)
public class CustProfile {

    @Id
    private String id;

    @NotNull
    private String custName;

    @NotNull
    private String address;


    private String email;

    private String phoneNo;

    private String addharNo;

    private String status;

    private double totalAmount;

    private double currentOusting;

    private double paidAmout;

    private String ownerId;

    @LastModifiedDate
    private LocalDateTime lastModifiedDate;

    public CustProfile() {
        super();
    }

    public CustProfile(String addharNo, double paidAmout, String address, double currentOusting, String id, LocalDateTime lastModifiedDate, String email, String custName, String ownerId, String phoneNo, String status, double totalAmount) {
        this.addharNo = addharNo;
        this.paidAmout = paidAmout;
        this.address = address;
        this.currentOusting = currentOusting;
        this.id = id;
        this.lastModifiedDate = lastModifiedDate;
        this.email = email;
        this.custName = custName;
        this.ownerId = ownerId;
        this.phoneNo = phoneNo;
        this.status = status;
        this.totalAmount = totalAmount;
    }

    public String getAddress() {
        return address;
    }

    public String getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    public double getCurrentOusting() {
        return currentOusting;
    }

    public void setCurrentOusting(double currentOusting) {
        this.currentOusting = currentOusting;
    }

    public String getAddharNo() {
        return addharNo;
    }

    public void setAddharNo(String addharNo) {
        this.addharNo = addharNo;
    }

    public String getId() {
        return id;
    }


    public String getCustName() {
        return custName;
    }

    public void setCustName(String custName) {
        this.custName = custName;
    }

    public String getPhoneNo() {
        return phoneNo;
    }

    public void setPhoneNo(String phoneNo) {
        this.phoneNo = phoneNo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setId(String id) {
        this.id = id;
    }

    public LocalDateTime getLastModifiedDate() {
        return lastModifiedDate;
    }

    public void setLastModifiedDate(LocalDateTime lastModifiedDate) {
        this.lastModifiedDate = lastModifiedDate;
    }
}
