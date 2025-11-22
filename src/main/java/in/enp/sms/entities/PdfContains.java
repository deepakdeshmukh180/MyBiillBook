package in.enp.sms.entities;

public class PdfContains {

    private String htmlString;

    private String invoiceNo;

    public PdfContains(String htmlString, String invoiceNo) {
        super();
        this.htmlString = htmlString;
        this.invoiceNo = invoiceNo;
    }

    public PdfContains() {
        super();
    }

    public String getHtmlString() {
        return htmlString;
    }

    public void setHtmlString(String htmlString) {
        this.htmlString = htmlString;
    }

    public String getInvoiceNo() {
        return invoiceNo;
    }

    public void setInvoiceNo(String invoiceNo) {
        this.invoiceNo = invoiceNo;
    }

    ;

}
