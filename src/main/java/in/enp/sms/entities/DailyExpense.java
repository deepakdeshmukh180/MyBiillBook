package in.enp.sms.entities;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "daily_expense")
public class DailyExpense {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Temporal(TemporalType.DATE)
    @Column(name = "expense_date", nullable = false)
    private Date date;

    @Column(nullable = false, length = 100)
    private String expenseName;

    @Column(nullable = false)
    private Double amount;

    @Column(name = "owner_id", nullable = false, length = 50)
    private String ownerId;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at", nullable = false, updatable = false)
    private Date createdAt;

    public DailyExpense() {}

    public DailyExpense(Date date, String expenseName, Double amount, String ownerId) {
        this.date = date;
        this.expenseName = expenseName;
        this.amount = amount;
        this.ownerId = ownerId;
        this.createdAt = new Date(); // set automatically on creation
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getExpenseName() {
        return expenseName;
    }

    public void setExpenseName(String expenseName) {
        this.expenseName = expenseName;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public String getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = new Date();
    }
}
