package in.enp.sms.pojo;

import in.enp.sms.entities.OwnerInfo;
import in.enp.sms.entities.User;

import java.io.Serializable;
import java.util.Date;

public class OwnerSession implements Serializable {

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
    private String date;
    private String terms;

    private String invoiceColms;


    private int planDuration;
    private Date expDate;
    private boolean superAdmin;

    // Constructor from User + OwnerInfo
    public OwnerSession(User user, OwnerInfo ownerInfo) {
        this.ownerId = user.getOwnerId();
        this.userName = user.getUsername();
        this.email = user.getUsername();
        this.superAdmin = user.isSuperAdmin();

        if (ownerInfo != null) {
            this.status = ownerInfo.getStatus();
            this.shopName = ownerInfo.getShopName();
            this.address = ownerInfo.getAddress();
            this.mobNumber = ownerInfo.getMobNumber();
            this.ownerName = ownerInfo.getOwnerName();
            this.lcNo = ownerInfo.getLcNo();
            this.gstNumber = ownerInfo.getGstNumber();
            this.invoiceType = ownerInfo.getInvoiceType();
            this.upiId = ownerInfo.getUpiId();
            this.date = ownerInfo.getDate();
            this.planDuration = ownerInfo.getPlanDuration();
            this.expDate = ownerInfo.getExpDate();
            this.terms = ownerInfo.getTerms();

            this.invoiceColms = ownerInfo.getInvoiceColms();


        }
    }

    public OwnerSession() {
    }

    public String getTerms() {
        return terms;
    }

    public void setTerms(String terms) {
        this.terms = terms;
    }

    public String getInvoiceColms() {
        return invoiceColms;
    }

    public void setInvoiceColms(String invoiceColms) {
        this.invoiceColms = invoiceColms;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
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

    public String getInvoiceType() {
        return invoiceType;
    }

    public void setInvoiceType(String invoiceType) {
        this.invoiceType = invoiceType;
    }

    public String getUpiId() {
        return upiId;
    }

    public void setUpiId(String upiId) {
        this.upiId = upiId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getPlanDuration() {
        return planDuration;
    }

    public void setPlanDuration(int planDuration) {
        this.planDuration = planDuration;
    }

    public Date getExpDate() {
        return expDate;
    }

    public void setExpDate(Date expDate) {
        this.expDate = expDate;
    }

    public boolean isSuperAdmin() {
        return superAdmin;
    }

    public void setSuperAdmin(boolean superAdmin) {
        this.superAdmin = superAdmin;
    }

    @Override
    public String toString() {
        final StringBuffer sb = new StringBuffer("OwnerSession{");
        sb.append("ownerId='").append(ownerId).append('\'');
        sb.append(", status='").append(status).append('\'');
        sb.append(", shopName='").append(shopName).append('\'');
        sb.append(", address='").append(address).append('\'');
        sb.append(", userName='").append(userName).append('\'');
        sb.append(", email='").append(email).append('\'');
        sb.append(", mobNumber='").append(mobNumber).append('\'');
        sb.append(", ownerName='").append(ownerName).append('\'');
        sb.append(", lcNo='").append(lcNo).append('\'');
        sb.append(", gstNumber='").append(gstNumber).append('\'');
        sb.append(", invoiceType='").append(invoiceType).append('\'');
        sb.append(", upiId='").append(upiId).append('\'');
        sb.append(", date='").append(date).append('\'');
        sb.append(", planDuration=").append(planDuration);
        sb.append(", expDate=").append(expDate);
        sb.append(", superAdmin=").append(superAdmin);
        sb.append('}');
        return sb.toString();
    }
}
