package in.enp.sms.entities;

import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import java.time.LocalDateTime;

@Entity
@EntityListeners(AuditingEntityListener.class)
public class DealerInfo {

    @Id
    @Column(length = 36)
    private String id;

    @NotBlank(message = "Dealer name is required")
    @Column(nullable = false)
    private String dealerName;

    @NotBlank(message = "Address is required")
    @Column(nullable = false)
    private String dealerAddress;

    @Pattern(regexp = "^\\d{10}$", message = "Mobile number must be 10 digits")
    @Column(length = 10)
    private String mobileNo;

    @Column(length = 15)
    private String gstNo;

    @Min(value = 0, message = "Balance must be >= 0")
    @Column(nullable = false)
    private Double balanceAmount = 0.0;

    @Min(value = 0, message = "Paid amount must be >= 0")
    @Column(nullable = false)
    private Double paidAmount = 0.0;

    @Min(value = 0, message = "Total amount must be >= 0")
    @Column(nullable = false)
    private Double totalAmount = 0.0;

    @NotBlank(message = "Bank name is required")
    @Column(nullable = false)
    private String bankName;

    @NotBlank(message = "Account number is required")
    @Column(nullable = false)
    private String accountNo;

    @NotBlank(message = "IFSC code is required")
    @Column(nullable = false, length = 11)
    private String ifscCode;

    @NotBlank(message = "Branch name is required")
    @Column(nullable = false)
    private String branchName;

    @LastModifiedDate
    private LocalDateTime lastModifiedDate;

    @Column(nullable = false)
    private String ownerId;

    @Column(length = 20)
    private String status = "ACTIVE";

    // Default constructor
    public DealerInfo() {
        this.balanceAmount = 0.0;
        this.paidAmount = 0.0;
        this.totalAmount = 0.0;
        this.status = "ACTIVE";
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDealerName() {
        return dealerName;
    }

    public void setDealerName(String dealerName) {
        this.dealerName = dealerName;
    }

    public String getDealerAddress() {
        return dealerAddress;
    }

    public void setDealerAddress(String dealerAddress) {
        this.dealerAddress = dealerAddress;
    }

    public String getMobileNo() {
        return mobileNo;
    }

    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }

    public String getGstNo() {
        return gstNo;
    }

    public void setGstNo(String gstNo) {
        this.gstNo = gstNo;
    }

    public Double getBalanceAmount() {
        return balanceAmount;
    }

    public void setBalanceAmount(Double balanceAmount) {
        this.balanceAmount = balanceAmount;
    }

    public Double getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(Double paidAmount) {
        this.paidAmount = paidAmount;
    }

    public Double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getAccountNo() {
        return accountNo;
    }

    public void setAccountNo(String accountNo) {
        this.accountNo = accountNo;
    }

    public String getIfscCode() {
        return ifscCode;
    }

    public void setIfscCode(String ifscCode) {
        this.ifscCode = ifscCode;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public LocalDateTime getLastModifiedDate() {
        return lastModifiedDate;
    }

    public void setLastModifiedDate(LocalDateTime lastModifiedDate) {
        this.lastModifiedDate = lastModifiedDate;
    }

    public String getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Helper method to calculate and update balance
    @PrePersist
    @PreUpdate
    public void calculateBalance() {
        if (this.totalAmount != null && this.paidAmount != null) {
            this.balanceAmount = this.totalAmount - this.paidAmount;
        }
    }

    @Override
    public String toString() {
        return "DealerInfo{" +
                "id='" + id + '\'' +
                ", dealerName='" + dealerName + '\'' +
                ", mobileNo='" + mobileNo + '\'' +
                ", balanceAmount=" + balanceAmount +
                ", status='" + status + '\'' +
                '}';
    }
}