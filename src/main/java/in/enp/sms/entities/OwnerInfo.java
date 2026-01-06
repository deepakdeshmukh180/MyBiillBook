package in.enp.sms.entities;


import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "tbl_owner_info")
public class OwnerInfo {

    @Id
    private String ownerId;
    private String status;
    private String shopName;
    private String address;
    private String userName;
    private String email;
    private String mobNumber;
    private String ownerName;
    private String lcNo;
    private String gstNumber;
    private String invoiceType;
    private String upiId;
    private String terms;
    private String date;
    private int planDuration;
    private String invoiceColms;

    private String accountNo;
    private String bankName;
    private String ifscCode;

    private Date expDate;

    public OwnerInfo() {
    }

    @Override
    public String toString() {
        return "OwnerInfo{" +
                "ownerId=" + ownerId +
                ", status='" + status + '\'' +
                ", shopName='" + shopName + '\'' +
                ", address='" + address + '\'' +
                ", userName='" + userName + '\'' +
                ", email='" + email + '\'' +
                ", mobNumber='" + mobNumber + '\'' +
                ", ownerName='" + ownerName + '\'' +
                ", lcNo='" + lcNo + '\'' +
                ", gstNumber='" + gstNumber + '\'' +
                ", date=" + date +
                '}';
    }


    public OwnerInfo(String shopName, String ownerId, String status, String address, String userName, String email, String mobNumber, String ownerName, String lcNo, String gstNumber, String invoiceType, String upiId, String terms, String date, int planDuration, String invoiceColms, String accountNo, String bankName, String ifscCode, Date expDate) {
        this.shopName = shopName;
        this.ownerId = ownerId;
        this.status = status;
        this.address = address;
        this.userName = userName;
        this.email = email;
        this.mobNumber = mobNumber;
        this.ownerName = ownerName;
        this.lcNo = lcNo;
        this.gstNumber = gstNumber;
        this.invoiceType = invoiceType;
        this.upiId = upiId;
        this.terms = terms;
        this.date = date;
        this.planDuration = planDuration;
        this.invoiceColms = invoiceColms;
        this.accountNo = accountNo;
        this.bankName = bankName;
        this.ifscCode = ifscCode;
        this.expDate = expDate;
    }

    public String getInvoiceColms() {
        return invoiceColms;
    }

    public void setInvoiceColms(String invoiceColms) {
        this.invoiceColms = invoiceColms;
    }

    public String getTerms() {
        return terms;
    }

    public void setTerms(String terms) {
        this.terms = terms;
    }

    public String getInvoiceType() {
        return invoiceType;
    }

    public String getUpiId() {
        return upiId;
    }

    public void setUpiId(String upiId) {
        this.upiId = upiId;
    }

    public void setInvoiceType(String invoiceType) {
        this.invoiceType = invoiceType;
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

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMobNumber() {
        return mobNumber;
    }

    public void setMobNumber(String mobNumber) {
        this.mobNumber = mobNumber;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public String getLcNo() {
        return lcNo;
    }

    public void setLcNo(String lcNo) {
        this.lcNo = lcNo;
    }

    public String getGstNumber() {
        return gstNumber;
    }

    public void setGstNumber(String gstNumber) {
        this.gstNumber = gstNumber;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public Date getExpDate() {
        return expDate;
    }

    public int getPlanDuration() {
        return planDuration;
    }

    public void setPlanDuration(int planDuration) {
        this.planDuration = planDuration;
    }

    public void setExpDate(Date expDate) {
        this.expDate = expDate;
    }

    public String getIfscCode() {
        return ifscCode;
    }

    public void setIfscCode(String ifscCode) {
        this.ifscCode = ifscCode;
    }

    public String getAccountNo() {
        return accountNo;
    }

    public void setAccountNo(String accountNo) {
        this.accountNo = accountNo;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }
}
