package in.enp.sms.pojo;

import java.time.LocalDateTime;

public class TransactionEntry {

    private LocalDateTime date;
    private String description;
    private Double debit;   // Invoice
    private Double credit;  // Deposit
    private Double balance;

    public TransactionEntry(LocalDateTime date, String description, double debit, double credit ,double balance) {
        this.date = date;
        this.description = description;
        this.debit = debit;
        this.credit = credit;
        this.balance = balance;
    }
    public LocalDateTime getDate() {
        return date;
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getDebit() {
        return debit;
    }

    public void setDebit(Double debit) {
        this.debit = debit;
    }

    public Double getCredit() {
        return credit;
    }

    public void setCredit(Double credit) {
        this.credit = credit;
    }

    public Double getBalance() {
        return balance;
    }

    public void setBalance(Double balance) {
        this.balance = balance;
    }
}
