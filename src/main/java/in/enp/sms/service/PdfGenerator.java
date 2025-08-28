package in.enp.sms.service;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.CMYKColor;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import in.enp.sms.controller.CompanyController;
import in.enp.sms.entities.CustProfile;
import in.enp.sms.entities.InvoiceDetails;
import in.enp.sms.entities.OwnerInfo;
import in.enp.sms.pojo.BalanceDeposite;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

public class PdfGenerator {

    private final Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16, BaseColor.BLACK);
    private final Font subtitleFont = FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.DARK_GRAY);
    private final Font tableHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, BaseColor.WHITE);
    private final Font cellFont = FontFactory.getFont(FontFactory.HELVETICA, 9);
    private final BaseColor headerBgColor = new BaseColor(63, 81, 181); // Indigo
    private final BaseColor rowAltColor = new BaseColor(245, 245, 245);
    private final Font subHeaderFont = FontFactory.getFont(FontFactory.TIMES_BOLD, 10, CMYKColor.DARK_GRAY);

    private void addCenteredParagraph(Document doc, String text, Font font, float spacingBefore, float spacingAfter) throws DocumentException {
        Paragraph p = new Paragraph(text, font);
        p.setAlignment(Element.ALIGN_CENTER);
        p.setSpacingBefore(spacingBefore);
        p.setSpacingAfter(spacingAfter);
        doc.add(p);
    }

    private PdfPTable createTable(String[] headers, int[] widths) throws DocumentException {
        PdfPTable table = new PdfPTable(headers.length);
        table.setWidthPercentage(100);
        table.setWidths(widths);
        table.setSpacingBefore(5f);
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, tableHeaderFont));
            cell.setBackgroundColor(headerBgColor);
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }
        return table;
    }

    private PdfPCell createCell(String content, int alignment, boolean shaded) {
        PdfPCell cell = new PdfPCell(new Phrase(content != null ? content : "", cellFont));
        cell.setHorizontalAlignment(alignment);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(5f);
        if (shaded) cell.setBackgroundColor(rowAltColor);
        return cell;
    }

    private void addLogo(Document document) throws DocumentException, IOException {
        Image logo = Image.getInstance("src/main/resources/img.png"); // Adjust this path to your setup
        logo.scaleToFit(150, 150);
        logo.setAlignment(Image.ALIGN_CENTER);
        logo.setSpacingAfter(10f);
        document.add(logo);
    }

    public void generate(List<CustProfile> customerList, HttpServletResponse response, OwnerInfo ownerInfo)
            throws IOException, DocumentException {

        Document document = new Document(PageSize.A4);
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        addLogo(document);

        addCenteredParagraph(document, ownerInfo.getShopName(), titleFont, 10f, 0f);
        addCenteredParagraph(document, ownerInfo.getAddress(), subtitleFont, 0f, 0f);
        addCenteredParagraph(document, "List of the Customers", subtitleFont, 5f, 0f);
        addCenteredParagraph(document, "Date: " + CompanyController.getCurretDateWithTime(), subtitleFont, 0f, 10f);

        String[] headers = {"SN", "Customer Name", "Address", "Contact No", "Total AMT", "Paid AMT", "Bal. AMT"};
        int[] columnWidths = {1, 4, 4, 3, 2, 2, 2};
        PdfPTable table = createTable(headers, columnWidths);

        int count = 1;
        boolean shade = false;

        for (CustProfile cust : customerList) {
            table.addCell(createCell(String.valueOf(count++), Element.ALIGN_CENTER, shade));
            table.addCell(createCell(cust.getCustName(), Element.ALIGN_LEFT, shade));
            table.addCell(createCell(cust.getAddress(), Element.ALIGN_LEFT, shade));
            table.addCell(createCell(cust.getPhoneNo(), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell(String.format("%.2f", cust.getTotalAmount()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell(String.format("%.2f", cust.getPaidAmout()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell(String.format("%.2f", cust.getCurrentOusting()), Element.ALIGN_RIGHT, shade));
            shade = !shade;
        }

        double totalAmt = customerList.stream().mapToDouble(CustProfile::getTotalAmount).sum();
        double paidAmt = customerList.stream().mapToDouble(CustProfile::getPaidAmout).sum();
        double balanceAmt = customerList.stream().mapToDouble(CustProfile::getCurrentOusting).sum();

        for (int i = 0; i < 3; i++) table.addCell(createCell("", Element.ALIGN_CENTER, false));
        table.addCell(createCell("Total", Element.ALIGN_CENTER, true));
        table.addCell(createCell(String.format("%.2f", totalAmt), Element.ALIGN_RIGHT, true));
        table.addCell(createCell(String.format("%.2f", paidAmt), Element.ALIGN_RIGHT, true));
        table.addCell(createCell(String.format("%.2f", balanceAmt), Element.ALIGN_RIGHT, true));

        document.add(table);
        document.close();
    }

    public void generateStatement(List<InvoiceDetails> invoiceDetails,
                                  List<BalanceDeposite> balanceDeposites,
                                  HttpServletResponse response,
                                  OwnerInfo ownerInfo,
                                  String date) throws IOException, DocumentException {

        Document document = new Document(PageSize.A4, 36, 36, 54, 54);
        PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
        writer.setPageEvent(new PdfPageFooter(ownerInfo.getShopName()));
        document.open();

        addLogo(document);

        addCenteredParagraph(document, ownerInfo.getShopName(), titleFont, 10f, 0f);
        addCenteredParagraph(document, ownerInfo.getAddress(), subtitleFont, 0f, 5f);
        addCenteredParagraph(document, "Invoice & Transaction Summary", subtitleFont, 0f, 10f);
        addCenteredParagraph(document, "Date: " + date, subtitleFont, 0f, 10f);

        addCenteredParagraph(document, "Invoice History", subHeaderFont, 10f, 5f);

        PdfPTable invoiceTable = createTable(
                new String[]{"Bill No", "Customer", "Products", "PreTax", "GST", "Total", "Date"},
                new int[]{2, 2, 6, 2, 2, 2, 2});

        boolean shade = false;
        for (InvoiceDetails invoice : invoiceDetails) {
            invoiceTable.addCell(createCell(invoice.getInvoiceId(), Element.ALIGN_LEFT, shade));
            invoiceTable.addCell(createCell(invoice.getCustName(), Element.ALIGN_LEFT, shade));
            invoiceTable.addCell(createCell(invoice.getItemDetails().replace(",", "\n"), Element.ALIGN_LEFT, shade));
            invoiceTable.addCell(createCell(String.format("%.2f", invoice.getPreTaxAmt()), Element.ALIGN_RIGHT, shade));
            invoiceTable.addCell(createCell(String.format("%.2f", invoice.getTax()), Element.ALIGN_RIGHT, shade));
            invoiceTable.addCell(createCell(String.format("%.2f", invoice.getTotInvoiceAmt()), Element.ALIGN_RIGHT, shade));
            invoiceTable.addCell(createCell(invoice.getDate().toString(), Element.ALIGN_RIGHT, shade));
            shade = !shade;
        }

        double totalPreTax = invoiceDetails.stream().mapToDouble(InvoiceDetails::getPreTaxAmt).sum();
        double totalTax = invoiceDetails.stream().mapToDouble(InvoiceDetails::getTax).sum();
        double totalAmt = invoiceDetails.stream().mapToDouble(InvoiceDetails::getTotInvoiceAmt).sum();

        invoiceTable.addCell(createCell("", Element.ALIGN_CENTER, false));
        invoiceTable.addCell(createCell("", Element.ALIGN_CENTER, false));
        invoiceTable.addCell(createCell("Total", Element.ALIGN_RIGHT, true));
        invoiceTable.addCell(createCell(String.format("%.2f", totalPreTax), Element.ALIGN_RIGHT, true));
        invoiceTable.addCell(createCell(String.format("%.2f", totalTax), Element.ALIGN_RIGHT, true));
        invoiceTable.addCell(createCell(String.format("%.2f", totalAmt), Element.ALIGN_RIGHT, true));
        invoiceTable.addCell(createCell("", Element.ALIGN_CENTER, false));

        document.add(invoiceTable);

        addCenteredParagraph(document, "Transaction History", subHeaderFont, 15f, 5f);

        PdfPTable transTable = createTable(
                new String[]{"Transaction Id", "Customer", "Description", "Balance", "Payment Mode", "Deposited", "Date"},
                new int[]{3, 3, 3, 2, 2, 2, 2});

        shade = false;
        for (BalanceDeposite transaction : balanceDeposites) {
            transTable.addCell(createCell(transaction.getId(), Element.ALIGN_LEFT, shade));
            transTable.addCell(createCell(transaction.getCustName(), Element.ALIGN_LEFT, shade));
            transTable.addCell(createCell(transaction.getDescription(), Element.ALIGN_LEFT, shade));
            transTable.addCell(createCell(String.format("%.2f", transaction.getCurrentOusting()), Element.ALIGN_RIGHT, shade));
            transTable.addCell(createCell(transaction.getModeOfPayment(), Element.ALIGN_CENTER, shade));
            transTable.addCell(createCell(String.format("%.2f", transaction.getAdvAmt()), Element.ALIGN_RIGHT, shade));
            transTable.addCell(createCell(transaction.getDate().toString(), Element.ALIGN_RIGHT, shade));
            shade = !shade;
        }

        double totalDeposits = balanceDeposites.stream().mapToDouble(BalanceDeposite::getAdvAmt).sum();

        for (int i = 0; i < 4; i++) transTable.addCell(createCell("", Element.ALIGN_CENTER, false));
        transTable.addCell(createCell("Total:", Element.ALIGN_RIGHT, true));
        transTable.addCell(createCell(String.format("%.2f", totalDeposits), Element.ALIGN_RIGHT, true));
        transTable.addCell(createCell("", Element.ALIGN_CENTER, false));

        document.add(transTable);
        document.close();
    }

    public void generateInvoiceHistory(CustProfile profile,
                                       HttpServletResponse response,
                                       OwnerInfo ownerInfo,
                                       List<InvoiceDetails> oldInvoices,
                                       List<BalanceDeposite> deposits) throws Exception {

        Document document = new Document(PageSize.A4, 36, 36, 54, 54);
        PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
        writer.setPageEvent(new PdfPageFooter(ownerInfo.getShopName()));
        document.open();

        addLogo(document);

        addCenteredParagraph(document, ownerInfo.getShopName(), titleFont, 10f, 0f);
        addCenteredParagraph(document, ownerInfo.getAddress(), subtitleFont, 0f, 0f);
        addCenteredParagraph(document, "Owner : " + ownerInfo.getOwnerName() + " | Contact: " + ownerInfo.getMobNumber(), subtitleFont, 0f, 10f);

        PdfPTable custTable = createTable(new String[]{"Customer", "Address", "Phone", "Date"}, new int[]{3, 4, 2, 2});
        custTable.addCell(createCell(profile.getCustName(), Element.ALIGN_LEFT, false));
        custTable.addCell(createCell(profile.getAddress(), Element.ALIGN_LEFT, false));
        custTable.addCell(createCell(profile.getPhoneNo(), Element.ALIGN_RIGHT, false));
        custTable.addCell(createCell(CompanyController.getCurretDateWithTime(), Element.ALIGN_RIGHT, false));
        document.add(custTable);

        addCenteredParagraph(document, "Billing Statement History", subHeaderFont, 10f, 5f);

        if (!oldInvoices.isEmpty()) {
            PdfPTable invoiceTable = createTable(
                    new String[]{"Bill No / Date", "Items", "PreTax + GST", "Total", "Paid", "Balance"},
                    new int[]{2, 5, 2, 2, 2, 2});

            boolean shade = false;
            for (InvoiceDetails inv : oldInvoices) {
                invoiceTable.addCell(createCell(inv.getInvoiceId() + "\n[" + inv.getDate() + "]", Element.ALIGN_LEFT, shade));
                invoiceTable.addCell(createCell(inv.getItemDetails().replaceAll(" ", "").replaceAll(",", "\n"), Element.ALIGN_LEFT, shade));
                invoiceTable.addCell(createCell(String.format("%.2f\n+%.2f", inv.getPreTaxAmt(), inv.getTax()), Element.ALIGN_RIGHT, shade));
                invoiceTable.addCell(createCell(String.format("%.2f", inv.getTotInvoiceAmt()), Element.ALIGN_RIGHT, shade));
                invoiceTable.addCell(createCell(String.format("%.2f", inv.getAdvanAmt()), Element.ALIGN_RIGHT, shade));
                invoiceTable.addCell(createCell(String.format("%.2f", inv.getBalanceAmt()), Element.ALIGN_RIGHT, shade));
                shade = !shade;
            }

            document.add(invoiceTable);
        }

        if (!deposits.isEmpty()) {
            addCenteredParagraph(document, "Payment History", subHeaderFont, 10f, 5f);

            PdfPTable transTable = createTable(
                    new String[]{"Transaction Id", "Description", "Balance", "Mode", "Deposited", "Date"},
                    new int[]{3, 4, 2, 2, 2, 2});

            boolean shade = false;
            for (BalanceDeposite dep : deposits) {
                transTable.addCell(createCell(dep.getId(), Element.ALIGN_LEFT, shade));
                transTable.addCell(createCell(dep.getDescription(), Element.ALIGN_LEFT, shade));
                transTable.addCell(createCell(String.format("%.2f", dep.getCurrentOusting()), Element.ALIGN_RIGHT, shade));
                transTable.addCell(createCell(dep.getModeOfPayment(), Element.ALIGN_CENTER, shade));
                transTable.addCell(createCell(String.format("%.2f", dep.getAdvAmt()), Element.ALIGN_RIGHT, shade));
                transTable.addCell(createCell(dep.getDate().toString(), Element.ALIGN_RIGHT, shade));
                shade = !shade;
            }

            document.add(transTable);
        }

        PdfPTable summary = createTable(
                new String[]{
                        "Total Amount: Rs. " + profile.getTotalAmount(),
                        "Paid: Rs. " + profile.getPaidAmout(),
                        "Balance: Rs. " + profile.getCurrentOusting()},
                new int[]{2, 2, 2});
        document.add(summary);

        document.close();
    }


    public ByteArrayOutputStream generateStatementPdf(List<InvoiceDetails> invoiceDetails,
                                                      List<BalanceDeposite> balanceDeposites,
                                                      List<CustProfile> customerList,
                                                      OwnerInfo ownerInfo,
                                                      String date) throws IOException, DocumentException {

        Document document = new Document(PageSize.A4, 36, 36, 54, 54);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        PdfWriter writer = PdfWriter.getInstance(document, out);
        writer.setPageEvent(new PdfPageFooter(ownerInfo.getShopName()));
        document.open();

        addLogo(document);
        addCenteredParagraph(document, ownerInfo.getShopName(), titleFont, 10f, 0f);
        addCenteredParagraph(document, ownerInfo.getAddress(), subtitleFont, 0f, 5f);
        addCenteredParagraph(document, "Invoice & Transaction Summary", subtitleFont, 0f, 10f);
        addCenteredParagraph(document, "Date: " + date, subtitleFont, 0f, 10f);
        addCenteredParagraph(document, "Invoice History", subHeaderFont, 10f, 5f);

        PdfPTable invoiceTable = createTable(
                new String[]{"Bill No", "Customer", "Products", "PreTax", "GST", "Total", "Date"},
                new int[]{2, 2, 6, 2, 2, 2, 2});

        boolean shade = false;
        for (InvoiceDetails invoice : invoiceDetails) {
            invoiceTable.addCell(createCell(invoice.getInvoiceId(), Element.ALIGN_LEFT, shade));
            invoiceTable.addCell(createCell(invoice.getCustName(), Element.ALIGN_LEFT, shade));
            invoiceTable.addCell(createCell(invoice.getItemDetails().replace(",", "\n"), Element.ALIGN_LEFT, shade));
            invoiceTable.addCell(createCell(String.format("%.2f", invoice.getPreTaxAmt()), Element.ALIGN_RIGHT, shade));
            invoiceTable.addCell(createCell(String.format("%.2f", invoice.getTax()), Element.ALIGN_RIGHT, shade));
            invoiceTable.addCell(createCell(String.format("%.2f", invoice.getTotInvoiceAmt()), Element.ALIGN_RIGHT, shade));
            invoiceTable.addCell(createCell(invoice.getDate().toString(), Element.ALIGN_RIGHT, shade));
            shade = !shade;
        }

        double totalPreTax = invoiceDetails.stream().mapToDouble(InvoiceDetails::getPreTaxAmt).sum();
        double totalTax = invoiceDetails.stream().mapToDouble(InvoiceDetails::getTax).sum();
        double totalAmt = invoiceDetails.stream().mapToDouble(InvoiceDetails::getTotInvoiceAmt).sum();

        invoiceTable.addCell(createCell("", Element.ALIGN_CENTER, false));
        invoiceTable.addCell(createCell("", Element.ALIGN_CENTER, false));
        invoiceTable.addCell(createCell("Total", Element.ALIGN_RIGHT, true));
        invoiceTable.addCell(createCell(String.format("%.2f", totalPreTax), Element.ALIGN_RIGHT, true));
        invoiceTable.addCell(createCell(String.format("%.2f", totalTax), Element.ALIGN_RIGHT, true));
        invoiceTable.addCell(createCell(String.format("%.2f", totalAmt), Element.ALIGN_RIGHT, true));
        invoiceTable.addCell(createCell("", Element.ALIGN_CENTER, false));

        document.add(invoiceTable);

        addCenteredParagraph(document, "Transaction History", subHeaderFont, 15f, 5f);

        PdfPTable transTable = createTable(
                new String[]{"Transaction Id", "Customer", "Description", "Balance", "Payment Mode", "Deposited", "Date"},
                new int[]{3, 3, 3, 2, 2, 2, 2});

        shade = false;
        for (BalanceDeposite transaction : balanceDeposites) {
            transTable.addCell(createCell(transaction.getId(), Element.ALIGN_LEFT, shade));
            transTable.addCell(createCell(transaction.getCustName(), Element.ALIGN_LEFT, shade));
            transTable.addCell(createCell(transaction.getDescription(), Element.ALIGN_LEFT, shade));
            transTable.addCell(createCell(String.format("%.2f", transaction.getCurrentOusting()), Element.ALIGN_RIGHT, shade));
            transTable.addCell(createCell(transaction.getModeOfPayment(), Element.ALIGN_CENTER, shade));
            transTable.addCell(createCell(String.format("%.2f", transaction.getAdvAmt()), Element.ALIGN_RIGHT, shade));
            transTable.addCell(createCell(transaction.getDate().toString(), Element.ALIGN_RIGHT, shade));
            shade = !shade;
        }

        double totalDeposits = balanceDeposites.stream().mapToDouble(BalanceDeposite::getAdvAmt).sum();

        for (int i = 0; i < 4; i++) transTable.addCell(createCell("", Element.ALIGN_CENTER, false));
        transTable.addCell(createCell("Total:", Element.ALIGN_RIGHT, true));
        transTable.addCell(createCell(String.format("%.2f", totalDeposits), Element.ALIGN_RIGHT, true));
        transTable.addCell(createCell("", Element.ALIGN_CENTER, false));

        document.add(transTable);
        document.newPage();
        addCenteredParagraph(document, "List of the Customers", subtitleFont, 5f, 0f);
        addCenteredParagraph(document, "Date: " + CompanyController.getCurretDateWithTime(), subtitleFont, 0f, 10f);

        String[] headers = {"SN", "Customer Name", "Address", "Contact No", "Total AMT", "Paid AMT", "Bal. AMT"};
        int[] columnWidths = {1, 4, 4, 3, 2, 2, 2};
        PdfPTable table = createTable(headers, columnWidths);

        int count = 1;


        for (CustProfile cust : customerList) {
            table.addCell(createCell(String.valueOf(count++), Element.ALIGN_CENTER, shade));
            table.addCell(createCell(cust.getCustName(), Element.ALIGN_LEFT, shade));
            table.addCell(createCell(cust.getAddress(), Element.ALIGN_LEFT, shade));
            table.addCell(createCell(cust.getPhoneNo(), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell(String.format("%.2f", cust.getTotalAmount()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell(String.format("%.2f", cust.getPaidAmout()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell(String.format("%.2f", cust.getCurrentOusting()), Element.ALIGN_RIGHT, shade));
            shade = !shade;
        }

        double totalAmt1 = customerList.stream().mapToDouble(CustProfile::getTotalAmount).sum();
        double paidAmt = customerList.stream().mapToDouble(CustProfile::getPaidAmout).sum();
        double balanceAmt = customerList.stream().mapToDouble(CustProfile::getCurrentOusting).sum();

        for (int i = 0; i < 3; i++) table.addCell(createCell("", Element.ALIGN_CENTER, false));
        table.addCell(createCell("Total", Element.ALIGN_CENTER, true));
        table.addCell(createCell(String.format("%.2f", totalAmt1), Element.ALIGN_RIGHT, true));
        table.addCell(createCell(String.format("%.2f", paidAmt), Element.ALIGN_RIGHT, true));
        table.addCell(createCell(String.format("%.2f", balanceAmt), Element.ALIGN_RIGHT, true));

        document.add(table);
        document.close();

        return out;
    }

}
