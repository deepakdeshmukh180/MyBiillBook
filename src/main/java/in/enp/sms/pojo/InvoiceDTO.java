package in.enp.sms.pojo;

import java.time.LocalDate;
import java.util.UUID;

public class InvoiceDTO {

    private String invoiceId;
    private String custId;
    private String custName;
    private String date;
    private double totQty;
    private double totInvoiceAmt;
    private double totAmt;
    private double balanceAmt;
    private double advanAmt;
    private String oldInvoicesFlag;

    public String getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(String invoiceId) {
        this.invoiceId = invoiceId;
    }

    public String getCustId() {
        return custId;
    }

    public void setCustId(String custId) {
        this.custId = custId;
    }

    public String getCustName() {
        return custName;
    }

    public void setCustName(String custName) {
        this.custName = custName;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public double getTotQty() {
        return totQty;
    }

    public void setTotQty(double totQty) {
        this.totQty = totQty;
    }

    public double getTotInvoiceAmt() {
        return totInvoiceAmt;
    }

    public void setTotInvoiceAmt(double totInvoiceAmt) {
        this.totInvoiceAmt = totInvoiceAmt;
    }

    public double getTotAmt() {
        return totAmt;
    }

    public void setTotAmt(double totAmt) {
        this.totAmt = totAmt;
    }

    public double getBalanceAmt() {
        return balanceAmt;
    }

    public void setBalanceAmt(double balanceAmt) {
        this.balanceAmt = balanceAmt;
    }

    public double getAdvanAmt() {
        return advanAmt;
    }

    public void setAdvanAmt(double advanAmt) {
        this.advanAmt = advanAmt;
    }

    public String getOldInvoicesFlag() {
        return oldInvoicesFlag;
    }

    public void setOldInvoicesFlag(String oldInvoicesFlag) {
        this.oldInvoicesFlag = oldInvoicesFlag;
    }

    // Getters and Setters

}
