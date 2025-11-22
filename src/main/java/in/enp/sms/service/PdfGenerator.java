package in.enp.sms.service;


import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import in.enp.sms.entities.CustProfile;
import in.enp.sms.entities.DailyExpense;
import in.enp.sms.entities.InvoiceDetails;
import in.enp.sms.entities.OwnerInfo;
import in.enp.sms.pojo.BalanceDeposite;
import in.enp.sms.pojo.OwnerSession;
import in.enp.sms.pojo.TransactionEntry;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import static in.enp.sms.controller.UserController.getCurretDateWithTime;

public class PdfGenerator {




    // ==================== COLOR SCHEME ====================
    private final BaseColor primaryColor = new BaseColor(41, 128, 185);        // Professional Blue
    private final BaseColor secondaryColor = new BaseColor(52, 73, 94);        // Dark Gray-Blue
    private final BaseColor accentColor = new BaseColor(46, 204, 113);         // Success Green
    private final BaseColor warningColor = new BaseColor(230, 126, 34);        // Warning Orange
    private final BaseColor dangerColor = new BaseColor(231, 76, 60);          // Red
    private final BaseColor lightGray = new BaseColor(236, 240, 241);          // Light Background
    private final BaseColor darkGray = new BaseColor(52, 73, 94);              // Dark Text
    private final BaseColor headerBgColor = new BaseColor(41, 128, 185);       // Table Header
    private final BaseColor rowAltColor = new BaseColor(250, 250, 250);        // Alternate Row
    private final BaseColor totalRowColor = new BaseColor(52, 73, 94);
    private final BaseColor expColor = new BaseColor(41, 128, 185); // A blue shade

    // Total Row

    // ==================== FONT DEFINITIONS ====================
    private final Font companyNameFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, primaryColor);
    private final Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16, secondaryColor);
    private final Font subtitleFont = FontFactory.getFont(FontFactory.HELVETICA, 10, darkGray);
    private final Font sectionHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.WHITE);
    private final Font tableHeaderFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8, BaseColor.WHITE);
    private final Font cellFont = FontFactory.getFont(FontFactory.HELVETICA, 8, BaseColor.BLACK);
    private final Font cellFontBold = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8, BaseColor.BLACK);
    private final Font summaryFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, BaseColor.WHITE);
    private final Font infoFont = FontFactory.getFont(FontFactory.HELVETICA, 9, darkGray);
    private final Font infoBoldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, darkGray);
    private final Font smallFont = FontFactory.getFont(FontFactory.HELVETICA, 7, BaseColor.GRAY);

    // ==================== HELPER METHODS ====================

    /**
     * Add a centered paragraph to the document
     */
    private void addCenteredParagraph(Document doc, String text, Font font, float spacingBefore, float spacingAfter)
            throws DocumentException {
        Paragraph p = new Paragraph(text, font);
        p.setAlignment(Element.ALIGN_CENTER);
        p.setSpacingBefore(spacingBefore);
        p.setSpacingAfter(spacingAfter);
        doc.add(p);
    }

    /**
     * Add a left-aligned paragraph to the document
     */
    private void addParagraph(Document doc, String text, Font font, float spacingBefore, float spacingAfter)
            throws DocumentException {
        Paragraph p = new Paragraph(text, font);
        p.setSpacingBefore(spacingBefore);
        p.setSpacingAfter(spacingAfter);
        doc.add(p);
    }

    /**
     * Add a decorative separator line
     */
    private void addSeparatorLine(Document doc, BaseColor color, float thickness) throws DocumentException {
        LineSeparator line = new LineSeparator();
        line.setLineColor(color);
        line.setLineWidth(thickness);
        line.setPercentage(100f);
        doc.add(new Chunk(line));
    }

    /**
     * Add company header with branding
     */
    private void addCompanyHeader(Document doc, OwnerSession ownerInfo) throws DocumentException {
        addSeparatorLine(doc, primaryColor, 3f);

        addCenteredParagraph(doc, ownerInfo.getShopName(), companyNameFont, 15f, 5f);
        addCenteredParagraph(doc, ownerInfo.getAddress(), subtitleFont, 0f, 2f);

        if (ownerInfo.getOwnerName() != null && ownerInfo.getMobNumber() != null) {
            addCenteredParagraph(doc,
                    "Contact: " + ownerInfo.getMobNumber() + " | Owner: " + ownerInfo.getOwnerName(),
                    infoFont, 0f, 10f);
        }

        addSeparatorLine(doc, primaryColor, 3f);
    }

    /**
     * Add section header with background color
     */
    private void addSectionHeader(Document doc, String title) throws DocumentException {
        PdfPTable headerTable = new PdfPTable(1);
        headerTable.setWidthPercentage(100);
        headerTable.setSpacingBefore(15f);
        headerTable.setSpacingAfter(10f);

        PdfPCell cell = new PdfPCell(new Phrase(title, sectionHeaderFont));
        cell.setBackgroundColor(secondaryColor);
        cell.setPadding(10f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);

        headerTable.addCell(cell);
        doc.add(headerTable);
    }

    /**
     * Create a styled table with headers
     */
    private PdfPTable createTable(String[] headers, int[] widths) throws DocumentException {
        PdfPTable table = new PdfPTable(headers.length);
        table.setWidthPercentage(100);
        table.setWidths(widths);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);

        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, tableHeaderFont));
            cell.setBackgroundColor(headerBgColor);
            cell.setPadding(8f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cell.setBorderWidth(0.5f);
            cell.setBorderColor(BaseColor.WHITE);
            table.addCell(cell);
        }
        return table;
    }

    /**
     * Create a standard table cell
     */
    private PdfPCell createCell(String content, int alignment, boolean shaded) {
        return createCell(content, alignment, shaded, cellFont);
    }

    /**
     * Create a table cell with custom font
     */
    private PdfPCell createCell(String content, int alignment, boolean shaded, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(content != null ? content : "", font));
        cell.setHorizontalAlignment(alignment);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(6f);
        cell.setBorderWidth(0.5f);
        cell.setBorderColor(lightGray);
        if (shaded) {
            cell.setBackgroundColor(rowAltColor);
        }
        return cell;
    }

    /**
     * Create a cell for totals row
     */
    private PdfPCell createTotalCell(String content, int alignment) {
        PdfPCell cell = new PdfPCell(new Phrase(content, summaryFont));
        cell.setHorizontalAlignment(alignment);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(8f);
        cell.setBackgroundColor(totalRowColor);
        cell.setBorderWidth(1f);
        cell.setBorderColor(primaryColor);
        return cell;
    }

    /**
     * Create an empty cell for spacing
     */
    private PdfPCell createEmptyCell() {
        PdfPCell cell = new PdfPCell(new Phrase(""));
        cell.setBorder(Rectangle.NO_BORDER);
        return cell;
    }

    /**
     * Add info row for customer details
     */
    private void addInfoRow(PdfPTable table, String label, String value) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, cellFontBold));
        labelCell.setPadding(8f);
        labelCell.setBackgroundColor(lightGray);
        labelCell.setBorder(Rectangle.BOX);
        labelCell.setBorderColor(BaseColor.LIGHT_GRAY);
        labelCell.setBorderWidth(0.5f);

        PdfPCell valueCell = new PdfPCell(new Phrase(value, cellFont));
        valueCell.setPadding(8f);
        valueCell.setBorder(Rectangle.BOX);
        valueCell.setBorderColor(BaseColor.LIGHT_GRAY);
        valueCell.setBorderWidth(0.5f);

        table.addCell(labelCell);
        table.addCell(valueCell);
    }

    /**
     * Create a summary card cell
     */
    private PdfPCell createSummaryCell(String label, String value, BaseColor bgColor) {
        PdfPCell cell = new PdfPCell();
        cell.setPadding(15f);
        cell.setBackgroundColor(bgColor);
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);

        Paragraph labelPara = new Paragraph(label,
                FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.WHITE));
        labelPara.setAlignment(Element.ALIGN_CENTER);

        Paragraph valuePara = new Paragraph(value,
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, BaseColor.WHITE));
        valuePara.setAlignment(Element.ALIGN_CENTER);
        valuePara.setSpacingBefore(8f);

        cell.addElement(labelPara);
        cell.addElement(valuePara);
        return cell;
    }

    /**
     * Add summary information box
     */
    private void addSummaryBox(Document doc, int customerCount, double total, double paid, double balance, double expences)
            throws DocumentException {
        PdfPTable summaryTable = new PdfPTable(5);
        summaryTable.setWidthPercentage(100);
        summaryTable.setSpacingBefore(20f);
        summaryTable.setWidths(new int[]{1, 1, 1, 1,1});

        String[] labels = {"No Customers", "Total Amt", "Paid Amt", "Outstanding","Expenses"};
        String[] values = {
                String.valueOf(customerCount),
                "₹ " + String.format("%.2f", total),
                "₹ " + String.format("%.2f", paid),
                "₹ " + String.format("%.2f", balance),
                "₹ " + String.format("%.2f", expences),
        };

        BaseColor[] colors = {
                primaryColor,
                secondaryColor,
                accentColor,
                balance > 0 ? warningColor : accentColor,
                expColor

        };

        for (int i = 0; i < 4; i++) {
            summaryTable.addCell(createSummaryCell(labels[i], values[i], colors[i]));
        }

        doc.add(summaryTable);
    }

    private void addSummaryBox(Document doc, int customerCount, double total, double paid, double balance)
            throws DocumentException {
        PdfPTable summaryTable = new PdfPTable(5);
        summaryTable.setWidthPercentage(100);
        summaryTable.setSpacingBefore(20f);
        summaryTable.setWidths(new int[]{1, 1, 1, 1,1});

        String[] labels = {"No Customers", "Total Amt", "Paid Amt", "Outstanding","Expenses"};
        String[] values = {
                String.valueOf(customerCount),
                "₹ " + String.format("%.2f", total),
                "₹ " + String.format("%.2f", paid),
                "₹ " + String.format("%.2f", balance),

        };

        BaseColor[] colors = {
                primaryColor,
                secondaryColor,
                accentColor,
                balance > 0 ? warningColor : accentColor


        };

        for (int i = 0; i < 4; i++) {
            summaryTable.addCell(createSummaryCell(labels[i], values[i], colors[i]));
        }

        doc.add(summaryTable);
    }

    /**
     * Add account summary for customer statement
     */
    private void addAccountSummary(Document doc, CustProfile profile) throws DocumentException {
        PdfPTable summaryTable = new PdfPTable(3);
        summaryTable.setWidthPercentage(100);
        summaryTable.setSpacingBefore(20f);
        summaryTable.setWidths(new int[]{1, 1, 1});

        PdfPCell cell1 = createSummaryCell("Total Amount",
                "₹ " + String.format("%.2f", profile.getTotalAmount()),
                primaryColor);
        PdfPCell cell2 = createSummaryCell("Paid Amount",
                "₹ " + String.format("%.2f", profile.getPaidAmout()),
                accentColor);
        PdfPCell cell3 = createSummaryCell("Outstanding Balance",
                "₹ " + String.format("%.2f", profile.getCurrentOusting()),
                profile.getCurrentOusting() > 0 ? warningColor : accentColor);

        summaryTable.addCell(cell1);
        summaryTable.addCell(cell2);
        summaryTable.addCell(cell3);

        doc.add(summaryTable);
    }

    // ==================== MAIN PDF GENERATION METHODS ====================

    /**
     * Generate customer list PDF
     */
    public void generate(List<CustProfile> customerList, HttpServletResponse response, OwnerSession ownerInfo)
            throws Exception {
        Document document = new Document(PageSize.A4, 36, 36, 54, 54);
        PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
        writer.setPageEvent(new HeaderFooterPageEvent());

        document.open();

        // Header
        addCompanyHeader(document, ownerInfo);
        addSectionHeader(document, "CUSTOMER LIST");
        addCenteredParagraph(document, "Generated on: " + getCurretDateWithTime(), infoFont, 0f, 15f);

        // Customer Table
        String[] headers = {"S.No", "Customer Name", "Address", "Contact", "Total Amount", "Paid Amount", "Balance"};
        int[] columnWidths = {1, 3, 4, 2, 2, 2, 2};
        PdfPTable table = createTable(headers, columnWidths);

        int count = 1;
        boolean shade = false;

        for (CustProfile cust : customerList) {
            table.addCell(createCell(String.valueOf(count++), Element.ALIGN_CENTER, shade));
            table.addCell(createCell(cust.getCustName(), Element.ALIGN_LEFT, shade, cellFontBold));
            table.addCell(createCell(cust.getAddress(), Element.ALIGN_LEFT, shade));
            table.addCell(createCell(cust.getPhoneNo().substring(3), Element.ALIGN_CENTER, shade));
            table.addCell(createCell("₹ " + String.format("%.2f", cust.getTotalAmount()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell("₹ " + String.format("%.2f", cust.getPaidAmout()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell("₹ " + String.format("%.2f", cust.getCurrentOusting()), Element.ALIGN_RIGHT, shade));
            shade = !shade;
        }

        // Totals
        double totalAmt = customerList.stream().mapToDouble(CustProfile::getTotalAmount).sum();
        double paidAmt = customerList.stream().mapToDouble(CustProfile::getPaidAmout).sum();
        double balanceAmt = customerList.stream().mapToDouble(CustProfile::getCurrentOusting).sum();

        for (int i = 0; i < 4; i++) table.addCell(createTotalCell("", Element.ALIGN_CENTER));
        table.addCell(createTotalCell("₹ " + String.format("%.2f", totalAmt), Element.ALIGN_RIGHT));
        table.addCell(createTotalCell("₹ " + String.format("%.2f", paidAmt), Element.ALIGN_RIGHT));
        table.addCell(createTotalCell("₹ " + String.format("%.2f", balanceAmt), Element.ALIGN_RIGHT));

        document.add(table);

        // Summary Cards
        addSummaryBox(document, customerList.size(), totalAmt, paidAmt, balanceAmt);

        document.close();
    }

    /**
     * Generate statement with invoices and transactions
     */
    public void generateStatement(List<InvoiceDetails> invoiceDetails,
                                  List<BalanceDeposite> balanceDeposites,
                                  HttpServletResponse response,
                                  OwnerSession ownerInfo,
                                  String date) throws Exception {

        Document document = new Document(PageSize.A4, 36, 36, 54, 54);
        PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
        writer.setPageEvent(new PdfPageFooter(ownerInfo.getShopName()));
        writer.setPageEvent(new HeaderFooterPageEvent());

        document.open();

        // Header
        addCompanyHeader(document, ownerInfo);
        addSectionHeader(document, "FINANCIAL STATEMENT");
        addCenteredParagraph(document, "Period: " + date, infoFont, 0f, 15f);

        // Invoice Section
        addSectionHeader(document, "Invoice History");
        generateInvoiceTable(document, invoiceDetails);

        // Transaction Section
        addSectionHeader(document, "Payment History");
        generateTransactionTable(document, balanceDeposites);

        document.close();
    }

    /**
     * Generate invoice history for specific customer
     */
    public void generateInvoiceHistory(CustProfile profile,
                                       HttpServletResponse response,
                                       OwnerSession ownerInfo,
                                       List<InvoiceDetails> oldInvoices,
                                       List<BalanceDeposite> deposits) throws Exception {

        Document document = new Document(PageSize.A4, 36, 36, 54, 54);
        PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
        writer.setPageEvent(new PdfPageFooter(ownerInfo.getShopName()));
        writer.setPageEvent(new HeaderFooterPageEvent());

        document.open();

        // Header
        addCompanyHeader(document, ownerInfo);
        addSectionHeader(document, "CUSTOMER STATEMENT");

        // Customer Info Box
        PdfPTable custInfoTable = new PdfPTable(2);
        custInfoTable.setWidthPercentage(100);
        custInfoTable.setSpacingBefore(10f);
        custInfoTable.setSpacingAfter(15f);
        custInfoTable.setWidths(new int[]{1, 1});

        addInfoRow(custInfoTable, "Customer Name:", profile.getCustName());
        addInfoRow(custInfoTable, "Address:", profile.getAddress());
        addInfoRow(custInfoTable, "Phone:", profile.getPhoneNo());
        addInfoRow(custInfoTable, "Statement Date:", getCurretDateWithTime());

        document.add(custInfoTable);

        // Transaction Ledger
        addSectionHeader(document, "Transaction Ledger");
        generateCombinedTransactionLedger(document, oldInvoices, deposits, profile);

        // Account Summary
        addAccountSummary(document, profile);

        document.close();
    }

    /**
     * Generate comprehensive statement PDF to ByteArrayOutputStream
     */
    public ByteArrayOutputStream generateStatementPdf(List<InvoiceDetails> invoiceDetails,
                                                      List<BalanceDeposite> balanceDeposites,
                                                      List<CustProfile> customerList,
                                                      List<DailyExpense>  expenses,
                                                      OwnerInfo ownerInfo,
                                                      String date) throws Exception {

        Document document = new Document(PageSize.A4, 36, 36, 54, 54);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        PdfWriter writer = PdfWriter.getInstance(document, out);
        writer.setPageEvent(new PdfPageFooter(ownerInfo.getShopName()));
        writer.setPageEvent(new HeaderFooterPageEvent());

        document.open();

        // Convert OwnerInfo to OwnerSession
        OwnerSession ownerSession = new OwnerSession();
        ownerSession.setShopName(ownerInfo.getShopName());
        ownerSession.setAddress(ownerInfo.getAddress());
        ownerSession.setOwnerName(ownerInfo.getOwnerName());
        ownerSession.setMobNumber(ownerInfo.getMobNumber());

        // Header
        addCompanyHeader(document, ownerSession);
        addSectionHeader(document, "COMPREHENSIVE BUSINESS REPORT");
        addCenteredParagraph(document, "Report Period: " + date, infoFont, 0f, 15f);

        // Invoice Section
        addSectionHeader(document, "Sales & Invoices");
        generateInvoiceTable(document, invoiceDetails);

        // Transaction Section
        addSectionHeader(document, "Payment Transactions");
        generateTransactionTable(document, balanceDeposites);


        addSectionHeader(document, "Daily Expenses");
        generateExpensesTable(document, expenses);

        // New page for customer list
        document.newPage();
        addSectionHeader(document, "Customer Directory");
        addCenteredParagraph(document, "Date: " + getCurretDateWithTime(), infoFont, 0f, 10f);

        double totalAmt = expenses.stream().mapToDouble(DailyExpense::getAmount).sum();

        generateCustomerTable(document, customerList,totalAmt);

        document.close();
        return out;
    }


    private void generateExpensesTable(Document document, List<DailyExpense> expenses) throws DocumentException {
        PdfPTable table = createTable(
                new String[]{"Sr No", "Date", "Expense Name", "Amount"},
                new int[]{1, 3, 6, 2}
        );

        boolean shade = false;
        int srNo = 1;
        double totalAmount = 0.0;

        for (DailyExpense expense : expenses) {
            table.addCell(createCell(String.valueOf(srNo++), Element.ALIGN_CENTER, shade));
            table.addCell(createCell(expense.getDate().toString(), Element.ALIGN_CENTER, shade));
            table.addCell(createCell(expense.getExpenseName(), Element.ALIGN_LEFT, shade));
            table.addCell(createCell("₹ " + String.format("%.2f", expense.getAmount()), Element.ALIGN_RIGHT, shade));
            totalAmount += expense.getAmount();
            shade = !shade;
        }

        // Add total row
        table.addCell(createTotalCell("", Element.ALIGN_CENTER));
        table.addCell(createTotalCell("", Element.ALIGN_CENTER));
        table.addCell(createTotalCell("TOTAL", Element.ALIGN_RIGHT));
        table.addCell(createTotalCell("₹ " + String.format("%.2f", totalAmount), Element.ALIGN_RIGHT));

        document.add(table);
    }

    // ==================== HELPER GENERATION METHODS ====================

    /**
     * Generate invoice table
     */
    private void generateInvoiceTable(Document doc, List<InvoiceDetails> invoiceDetails) throws DocumentException {
        PdfPTable table = createTable(
                new String[]{"Bill No", "Customer", "Products", "Pre-Tax", "GST", "Total", "Date"},
                new int[]{2, 2, 5, 2, 2, 2, 2});

        boolean shade = false;
        for (InvoiceDetails invoice : invoiceDetails) {
            table.addCell(createCell(invoice.getInvoiceId(), Element.ALIGN_CENTER, shade, cellFontBold));
            table.addCell(createCell(invoice.getCustName(), Element.ALIGN_LEFT, shade));
            table.addCell(createCell(invoice.getItemDetails().replace(",", "\n"), Element.ALIGN_LEFT, shade));
            table.addCell(createCell("₹ " + String.format("%.2f", invoice.getPreTaxAmt()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell("₹ " + String.format("%.2f", invoice.getTax()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell("₹ " + String.format("%.2f", invoice.getTotInvoiceAmt()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell(invoice.getDate().toString(), Element.ALIGN_CENTER, shade));
            shade = !shade;
        }

        // Totals
        double totalPreTax = invoiceDetails.stream().mapToDouble(InvoiceDetails::getPreTaxAmt).sum();
        double totalTax = invoiceDetails.stream().mapToDouble(InvoiceDetails::getTax).sum();
        double totalAmt = invoiceDetails.stream().mapToDouble(InvoiceDetails::getTotInvoiceAmt).sum();

        table.addCell(createTotalCell("", Element.ALIGN_CENTER));
        table.addCell(createTotalCell("", Element.ALIGN_CENTER));
        table.addCell(createTotalCell("TOTAL", Element.ALIGN_RIGHT));
        table.addCell(createTotalCell("₹ " + String.format("%.2f", totalPreTax), Element.ALIGN_RIGHT));
        table.addCell(createTotalCell("₹ " + String.format("%.2f", totalTax), Element.ALIGN_RIGHT));
        table.addCell(createTotalCell("₹ " + String.format("%.2f", totalAmt), Element.ALIGN_RIGHT));
        table.addCell(createTotalCell("", Element.ALIGN_CENTER));

        doc.add(table);
    }

    /**
     * Generate transaction table
     */
    private void generateTransactionTable(Document doc, List<BalanceDeposite> balanceDeposites) throws DocumentException {
        PdfPTable table = createTable(
                new String[]{"Trans. ID", "Customer", "Description", "Balance", "Mode", "Amount", "Date"},
                new int[]{2, 3, 3, 2, 2, 2, 2});

        boolean shade = false;
        for (BalanceDeposite transaction : balanceDeposites) {
            table.addCell(createCell(transaction.getId(), Element.ALIGN_CENTER, shade, cellFontBold));
            table.addCell(createCell(transaction.getCustName(), Element.ALIGN_LEFT, shade));
            table.addCell(createCell(transaction.getDescription(), Element.ALIGN_LEFT, shade));
            table.addCell(createCell("₹ " + String.format("%.2f", transaction.getCurrentOusting()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell(transaction.getModeOfPayment(), Element.ALIGN_CENTER, shade));
            table.addCell(createCell("₹ " + String.format("%.2f", transaction.getAdvAmt()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell(transaction.getDate().toString(), Element.ALIGN_CENTER, shade));
            shade = !shade;
        }

        // Totals
        double totalDeposits = balanceDeposites.stream().mapToDouble(BalanceDeposite::getAdvAmt).sum();

        for (int i = 0; i < 4; i++) table.addCell(createTotalCell("", Element.ALIGN_CENTER));
        table.addCell(createTotalCell("TOTAL", Element.ALIGN_RIGHT));
        table.addCell(createTotalCell("₹ " + String.format("%.2f", totalDeposits), Element.ALIGN_RIGHT));
        table.addCell(createTotalCell("", Element.ALIGN_CENTER));

        doc.add(table);
    }

    /**
     * Generate customer table
     */
    private void generateCustomerTable(Document doc, List<CustProfile> customerList, double expenses) throws DocumentException {
        PdfPTable table = createTable(
                new String[]{"S.No", "Customer Name", "Address", "Contact", "Total", "Paid", "Balance"},
                new int[]{1, 3, 4, 2, 2, 2, 2});

        int count = 1;
        boolean shade = false;

        for (CustProfile cust : customerList) {
            table.addCell(createCell(String.valueOf(count++), Element.ALIGN_CENTER, shade));
            table.addCell(createCell(cust.getCustName(), Element.ALIGN_LEFT, shade, cellFontBold));
            table.addCell(createCell(cust.getAddress(), Element.ALIGN_LEFT, shade));
            table.addCell(createCell(cust.getPhoneNo().substring(3), Element.ALIGN_CENTER, shade));
            table.addCell(createCell("₹ " + String.format("%.2f", cust.getTotalAmount()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell("₹ " + String.format("%.2f", cust.getPaidAmout()), Element.ALIGN_RIGHT, shade));
            table.addCell(createCell("₹ " + String.format("%.2f", cust.getCurrentOusting()), Element.ALIGN_RIGHT, shade));
            shade = !shade;
        }

        // Totals
        double totalAmt = customerList.stream().mapToDouble(CustProfile::getTotalAmount).sum();
        double paidAmt = customerList.stream().mapToDouble(CustProfile::getPaidAmout).sum();
        double balanceAmt = customerList.stream().mapToDouble(CustProfile::getCurrentOusting).sum();

        for (int i = 0; i < 4; i++) table.addCell(createTotalCell("", Element.ALIGN_CENTER));
        table.addCell(createTotalCell("₹ " + String.format("%.2f", totalAmt), Element.ALIGN_RIGHT));
        table.addCell(createTotalCell("₹ " + String.format("%.2f", paidAmt), Element.ALIGN_RIGHT));
        table.addCell(createTotalCell("₹ " + String.format("%.2f", balanceAmt), Element.ALIGN_RIGHT));

        doc.add(table);

        // Summary Cards
        addSummaryBox(doc, customerList.size(), totalAmt, paidAmt, balanceAmt, expenses);
    }

    /**
     * Generate combined transaction ledger
     */
    private void generateCombinedTransactionLedger(Document doc,
                                                   List<InvoiceDetails> oldInvoices,
                                                   List<BalanceDeposite> deposits,
                                                   CustProfile profile) throws DocumentException {
        List<TransactionEntry> transactions = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

        // Add Invoices (Debits)
        for (InvoiceDetails inv : oldInvoices) {
            transactions.add(new TransactionEntry(
                    LocalDateTime.parse(inv.getCreatedAt(), formatter),
                    "Invoice: " + inv.getInvoiceId() + " - " + inv.getInvoiceType(),
                    inv.getTotInvoiceAmt(),
                    inv.getAdvanAmt(),
                    inv.getBalanceAmt()
            ));
        }

        // Add Deposits (Credits)
        for (BalanceDeposite dep : deposits) {
            transactions.add(new TransactionEntry(
                    LocalDateTime.parse(dep.getCreatedAt(), formatter),
                    "Payment: " + dep.getId() + " - " + dep.getDescription() + " - " + dep.getModeOfPayment(),
                    0.0,
                    dep.getAdvAmt(),
                    dep.getCurrentOusting()
            ));
        }

        // Sort by date
        transactions.sort(Comparator.comparing(TransactionEntry::getDate));

        // Create transaction table
        PdfPTable transTable = createTable(
                new String[]{"Date & Time", "Description", "Debit", "Credit", "Balance"},
                new int[]{3, 6, 2, 2, 2});

        boolean shade = false;
        for (TransactionEntry t : transactions) {
            transTable.addCell(createCell(t.getDate().format(formatter), Element.ALIGN_LEFT, shade));
            transTable.addCell(createCell(t.getDescription(), Element.ALIGN_LEFT, shade));
            transTable.addCell(createCell(
                    t.getDebit() > 0 ? "₹ " + String.format("%.2f", t.getDebit()) : "-",
                    Element.ALIGN_RIGHT, shade));
            transTable.addCell(createCell(
                    t.getCredit() > 0 ? "₹ " + String.format("%.2f", t.getCredit()) : "-",
                    Element.ALIGN_RIGHT, shade));
            transTable.addCell(createCell("₹ " + String.format("%.2f", t.getBalance()), Element.ALIGN_RIGHT, shade));
            shade = !shade;
        }

        doc.add(transTable);
    }

    /**
     * Utility method to get current date and time
     */
    public static String getCurrentDateWithTime() {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm:ss a");
        return now.format(formatter);
    }
}