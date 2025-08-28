package in.enp.sms.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "tbl_validity_details")
public class ValidityDetails {


    @Id
    private String userId;

    private String ownerId;

    private String role;

    private String validUptoDate;

    private String subscriptionDate;

    private String Status;


    public ValidityDetails(String userId, String ownerId, String role, String validUptoDate, String subscriptionDate, String status) {
        this.userId = userId;
        this.ownerId = ownerId;
        this.role = role;
        this.validUptoDate = validUptoDate;
        this.subscriptionDate = subscriptionDate;
        Status = status;
    }

    public ValidityDetails() {
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getValidUptoDate() {
        return validUptoDate;
    }

    public void setValidUptoDate(String validUptoDate) {
        this.validUptoDate = validUptoDate;
    }

    public String getSubscriptionDate() {
        return subscriptionDate;
    }

    public void setSubscriptionDate(String subscriptionDate) {
        this.subscriptionDate = subscriptionDate;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String status) {
        Status = status;
    }
}
