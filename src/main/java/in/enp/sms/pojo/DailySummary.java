package in.enp.sms.pojo;

public class DailySummary {

    private long totalAmount;
    private long totalBalanceAmount;
    private long totalAdvance;
    private long depositedAmount;
    private long collectedAmount;
    private long invoiceCount;
    private long transactionCount;


    public DailySummary() {
    }

    public long getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(long totalAmount) {
        this.totalAmount = totalAmount;
    }

    public long getTotalBalanceAmount() {
        return totalBalanceAmount;
    }

    public void setTotalBalanceAmount(long totalBalanceAmount) {
        this.totalBalanceAmount = totalBalanceAmount;
    }

    public long getTotalAdvance() {
        return totalAdvance;
    }

    public void setTotalAdvance(long totalAdvance) {
        this.totalAdvance = totalAdvance;
    }

    public long getDepositedAmount() {
        return depositedAmount;
    }

    public void setDepositedAmount(long depositedAmount) {
        this.depositedAmount = depositedAmount;
    }

    public long getCollectedAmount() {
        return collectedAmount;
    }

    public void setCollectedAmount(long collectedAmount) {
        this.collectedAmount = collectedAmount;
    }

    public long getTransactionCount() {
        return transactionCount;
    }

    public void setTransactionCount(long transactionCount) {
        this.transactionCount = transactionCount;
    }

    public long getInvoiceCount() {
        return invoiceCount;
    }

    public void setInvoiceCount(long invoiceCount) {
        this.invoiceCount = invoiceCount;
    }
}
