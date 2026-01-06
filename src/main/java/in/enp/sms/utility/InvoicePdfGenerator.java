package in.enp.sms.utility;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import in.enp.sms.entities.CustProfile;
import in.enp.sms.entities.InvoiceDetails;
import in.enp.sms.entities.ItemDetails;
import in.enp.sms.pojo.OwnerSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayOutputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Professional PDF invoice generator using iText
 * Black & White theme, optimized for A5 Landscape printing
 * Features: clean layouts, consistent styling, safe null handling
 */
public class InvoicePdfGenerator {

    private static final Logger LOGGER = LoggerFactory.getLogger(InvoicePdfGenerator.class);

    private static final Rectangle PAGE_SIZE = new Rectangle(PageSize.A5.getHeight(), PageSize.A5.getWidth());
    private static final float[] MARGINS = {18, 18, 18, 18};
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy");

    // Color palette
    private static final BaseColor BLACK = new BaseColor(0, 0, 0);
    private static final BaseColor DARK_GRAY = new BaseColor(40, 40, 40);
    private static final BaseColor LIGHT_GRAY = new BaseColor(240, 240, 240);
    private static final BaseColor BORDER_GRAY = new BaseColor(100, 100, 100);

    // Font cache
    private Font fontCompanyName;
    private Font fontCompanyNameBold;
    private Font fontSectionTitle;
    private Font fontSectionTitleBold;
    private Font fontNormal;
    private Font fontSmall;
    private Font fontBold;
    private Font fontTableHeader;
    private Font fontTableData;

    public void generateInvoicePdf(
            InvoiceDetails invoiceDetails,
            CustProfile customer,
            List<ItemDetails> items,
            OwnerSession ownerInfo,
            List<String> invoiceColumns,
            OutputStream outputStream) throws Exception {
        generateInvoicePdf(invoiceDetails, customer, items, ownerInfo, invoiceColumns, null, outputStream);
    }

    public void generateInvoicePdf(
            InvoiceDetails invoiceDetails,
            CustProfile customer,
            List<ItemDetails> items,
            OwnerSession ownerInfo,
            List<String> invoiceColumns,
            String qrCodeBase64,
            OutputStream outputStream) throws Exception {

        initializeFonts();
        Document document = new Document(PAGE_SIZE, MARGINS[0], MARGINS[1], MARGINS[2], MARGINS[3]);
        PdfWriter writer = PdfWriter.getInstance(document, outputStream);

        document.open();
        drawPageBorder(writer.getDirectContent(), document);

        addHeader(document, invoiceDetails, ownerInfo, qrCodeBase64);
        addDivider(document);
        addCustomerInfo(document, customer);
        addDivider(document);
        addItemsTable(document, items, invoiceColumns);
        addDivider(document);
        addSummarySection(document, invoiceDetails, ownerInfo);
        addFooter(document);

        document.close();
        LOGGER.info("Invoice PDF generated: {}", invoiceDetails.getInvoiceId());
    }

    public byte[] generateInvoicePdfToByteArray(
            InvoiceDetails invoiceDetails,
            CustProfile customer,
            List<ItemDetails> items,
            OwnerSession ownerInfo,
            List<String> invoiceColumns) throws Exception {

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        generateInvoicePdf(invoiceDetails, customer, items, ownerInfo, invoiceColumns, out);
        return out.toByteArray();
    }

    private void initializeFonts() {
        try {
            BaseFont regular = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            BaseFont bold = BaseFont.createFont(BaseFont.HELVETICA_BOLD, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);

            fontCompanyName = new Font(regular, 13, Font.NORMAL, BLACK);
            fontCompanyNameBold = new Font(bold, 13, Font.BOLD, BLACK);
            fontSectionTitle = new Font(regular, 9, Font.NORMAL, BLACK);
            fontSectionTitleBold = new Font(bold, 9, Font.BOLD, BLACK);
            fontNormal = new Font(regular, 8, Font.NORMAL, DARK_GRAY);
            fontSmall = new Font(regular, 7, Font.NORMAL, DARK_GRAY);
            fontBold = new Font(bold, 7, Font.BOLD, BLACK);
            fontTableHeader = new Font(bold, 8, Font.BOLD, BaseColor.WHITE);
            fontTableData = new Font(regular, 8, Font.NORMAL, DARK_GRAY);
        } catch (Exception e) {
            LOGGER.error("Font initialization failed", e);
            throw new RuntimeException("Failed to initialize fonts", e);
        }
    }

    private void drawPageBorder(PdfContentByte canvas, Document document) {
        canvas.saveState();
        canvas.setColorStroke(BLACK);
        canvas.setLineWidth(1.5f);
        float x = document.leftMargin() - 4;
        float y = document.bottomMargin() - 4;
        float w = document.getPageSize().getWidth() - document.leftMargin() - document.rightMargin() + 8;
        float h = document.getPageSize().getHeight() - document.topMargin() - document.bottomMargin() + 8;
        canvas.rectangle(x, y, w, h);
        canvas.stroke();
        canvas.restoreState();
    }

    private void addDivider(Document document) throws Exception {
        Paragraph p = new Paragraph();
        p.setSpacingBefore(2);
        p.setSpacingAfter(2);
        p.add(new LineSeparator(1f, 100f, BORDER_GRAY, Element.ALIGN_CENTER, -2));
        document.add(p);
    }

    private void addHeader(Document document, InvoiceDetails invoiceDetails, OwnerSession ownerInfo, String qrCodeBase64) throws Exception {
        PdfPTable headerTable = new PdfPTable(new float[]{55, 20, 25});
        headerTable.setWidthPercentage(100);
        headerTable.setSpacingAfter(3f);

        headerTable.addCell(createCompanyCell(ownerInfo));
        headerTable.addCell(createQRCell(qrCodeBase64));
        headerTable.addCell(createInvoiceDetailsCell(invoiceDetails));

        document.add(headerTable);
    }

    private PdfPCell createCompanyCell(OwnerSession owner) throws DocumentException {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(BLACK);
        cell.setBorderWidth(1f);
        cell.setPadding(6);
        cell.setBackgroundColor(BaseColor.WHITE);

        Paragraph shopName = new Paragraph(nvl(owner.getShopName()), fontCompanyNameBold);
        shopName.setSpacingAfter(5);
        cell.addElement(shopName);

        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(100);
        infoTable.setWidths(new float[]{30f, 70f});
        infoTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);

        addInfoRow(infoTable, "Address:", nvl(owner.getAddress()));
        addInfoRow(infoTable, "Owner:", nvl(owner.getOwnerName()+" ( Mob:"+owner.getMobNumber()+" )"));
        addInfoRow(infoTable, "LC No:", nvl(owner.getLcNo()));
        addInfoRow(infoTable, "GST:", nvl(owner.getGstNumber()));

        cell.addElement(infoTable);
        return cell;
    }

    private void addInfoRow(PdfPTable table, String label, String value) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, fontBold));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setPaddingBottom(2);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(value, fontSmall));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setPaddingBottom(2);
        table.addCell(valueCell);
    }

    private PdfPCell createQRCell(String qrCodeBase64) {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(BLACK);
        cell.setBorderWidth(1f);
        cell.setPadding(5);
        cell.setBackgroundColor(LIGHT_GRAY);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);

        Paragraph label = new Paragraph("SCAN TO PAY", fontSectionTitleBold);
        label.setAlignment(Element.ALIGN_CENTER);
        label.setSpacingAfter(4);
        cell.addElement(label);

        if (qrCodeBase64 != null && !qrCodeBase64.isEmpty()) {
            addQRImage(cell, qrCodeBase64);
        } else {
            addQRPlaceholder(cell);
        }

        return cell;
    }

    private void addQRImage(PdfPCell cell, String qrCodeBase64) {
        try {
            byte[] qrBytes = java.util.Base64.getDecoder().decode(qrCodeBase64);
            Image qrImage = Image.getInstance(qrBytes);
            qrImage.scaleToFit(55, 55);
            qrImage.setAlignment(Element.ALIGN_CENTER);
            cell.addElement(qrImage);
        } catch (Exception e) {
            LOGGER.warn("Failed to decode QR code, using placeholder", e);
            addQRPlaceholder(cell);
        }
    }

    private void addQRPlaceholder(PdfPCell cell) {
        Paragraph qr = new Paragraph("█████████\n█ QR CODE █\n█████████", fontSmall);
        qr.setAlignment(Element.ALIGN_CENTER);
        cell.addElement(qr);
    }

    private PdfPCell createInvoiceDetailsCell(InvoiceDetails invoice) {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(BLACK);
        cell.setBorderWidth(1f);
        cell.setPadding(5);
        cell.setBackgroundColor(BaseColor.WHITE);
        cell.setHorizontalAlignment(Element.ALIGN_RIGHT);

        Paragraph title = new Paragraph("TAX INVOICE", new Font(fontTableHeader.getBaseFont(), 11, Font.BOLD, BLACK));
        title.setAlignment(Element.ALIGN_RIGHT);
        title.setSpacingAfter(3);
        cell.addElement(title);

        Paragraph invoiceNo = new Paragraph("#" + nvl(invoice.getInvoiceId()), new Font(fontTableHeader.getBaseFont(), 16, Font.BOLD, BLACK));
        invoiceNo.setAlignment(Element.ALIGN_RIGHT);
        invoiceNo.setSpacingAfter(4);
        cell.addElement(invoiceNo);

        Paragraph date = new Paragraph("Date: " + formatDate(invoice.getDate()), fontNormal);
        date.setAlignment(Element.ALIGN_RIGHT);
        date.setSpacingAfter(3);
        cell.addElement(date);

        Paragraph original = new Paragraph("■ ORIGINAL", new Font(fontSmall.getBaseFont(), 7, Font.BOLD, BLACK));
        original.setAlignment(Element.ALIGN_RIGHT);
        cell.addElement(original);

        return cell;
    }

    // ==================== CUSTOMER INFO SECTION ====================

    private void addCustomerInfo(Document document, CustProfile customer) throws Exception {
        PdfPTable table = new PdfPTable(3);
        table.setWidthPercentage(100);
        table.setSpacingAfter(4f);
        table.setWidths(new float[]{50, 20, 30});

        table.addCell(createCustomerCell("Customer: " + nvl(customer.getCustName()), true));
        table.addCell(createCustomerCell("Mob: " + nvl(customer.getPhoneNo()), true));
        table.addCell(createCustomerCell("Address: " + nvl(customer.getAddress()), true));

        document.add(table);
    }

    private PdfPCell createCustomerCell(String text, boolean highlight) {
        PdfPCell cell = new PdfPCell(new Phrase(text, highlight ? fontSectionTitleBold : fontSectionTitle));
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(BORDER_GRAY);
        cell.setPadding(5);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        if (highlight) {
            cell.setBackgroundColor(LIGHT_GRAY);
        }
        return cell;
    }

    // ==================== ITEMS TABLE SECTION ====================

    private void addItemsTable(Document document, List<ItemDetails> items, List<String> columns) throws Exception {
        PdfPTable table = new PdfPTable(calculateColumnWidths(columns));
        table.setWidthPercentage(100);
        table.setSpacingAfter(3f);

        addTableHeader(table, columns);

        int sr = 1;
        for (ItemDetails item : items) {
            addTableRow(table, item, sr++, columns);
        }

        document.add(table);
    }

    private float[] calculateColumnWidths(List<String> columns) {
        float sr = 3;
        float desc = 28;
        float brand = 9;
        float batch = 8;
        float expiry = 6;
        float mrp = 8;
        float qty = 5;
        float rate = 9;
        float amount = 11;

        float total = sr + desc + qty + rate + amount;
        if (columns.contains("BRAND")) total += brand;
        if (columns.contains("BATCHNO")) total += batch;
        if (columns.contains("EXPD")) total += expiry;
        if (columns.contains("MRP")) total += mrp;

        java.util.List<Float> widths = new java.util.ArrayList<>();
        widths.add(sr);
        widths.add(desc);
        if (columns.contains("BRAND")) widths.add(brand);
        if (columns.contains("BATCHNO")) widths.add(batch);
        if (columns.contains("EXPD")) widths.add(expiry);
        if (columns.contains("MRP")) widths.add(mrp);
        widths.add(qty);
        widths.add(rate);
        widths.add(amount);

        float[] result = new float[widths.size()];
        for (int i = 0; i < widths.size(); i++) {
            result[i] = widths.get(i);
        }
        return result;
    }

    private void addTableHeader(PdfPTable table, List<String> columns) {
        addHeader(table, "SR");
        addHeader(table, "DESCRIPTION");
        if (columns.contains("BRAND")) addHeader(table, "BRAND");
        if (columns.contains("BATCHNO")) addHeader(table, "BATCH");
        if (columns.contains("EXPD")) addHeader(table, "EXP");
        if (columns.contains("MRP")) addHeader(table, "MRP");
        addHeader(table, "QTY");
        addHeader(table, "RATE");
        addHeader(table, "AMOUNT");
    }

    private void addHeader(PdfPTable table, String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text, fontTableHeader));
        cell.setBackgroundColor(BLACK);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(4);
        cell.setBorder(Rectangle.BOX);
        table.addCell(cell);
    }

    private void addTableRow(PdfPTable table, ItemDetails item, int sr, List<String> columns) {
        boolean alternate = sr % 2 == 0;

        addDataCell(table, String.valueOf(sr), Element.ALIGN_CENTER, alternate);
        addDataCell(table, nvl(item.getDescription()), Element.ALIGN_LEFT, alternate);
        if (columns.contains("BRAND")) addDataCell(table, nvl(item.getBrand()), Element.ALIGN_CENTER, alternate);
        if (columns.contains("BATCHNO")) addDataCell(table, nvl(item.getBatchNo()), Element.ALIGN_CENTER, alternate);
        if (columns.contains("EXPD")) addDataCell(table, nvl(item.getExpDate()), Element.ALIGN_CENTER, alternate);
        if (columns.contains("MRP")) addDataCell(table, "Rs." + nvl(item.getMrp()), Element.ALIGN_RIGHT, alternate);
        addDataCell(table, String.valueOf(item.getQty()), Element.ALIGN_CENTER, alternate);
        addDataCell(table, "Rs." + nvl(item.getRate()), Element.ALIGN_RIGHT, alternate);
        addDataCell(table, "Rs." + nvl(item.getAmount()), Element.ALIGN_RIGHT, alternate);
    }

    private void addDataCell(PdfPTable table, String text, int alignment, boolean alternate) {
        PdfPCell cell = new PdfPCell(new Phrase(text, fontTableData));
        cell.setHorizontalAlignment(alignment);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(3);
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(BORDER_GRAY);
        cell.setBackgroundColor(alternate ? LIGHT_GRAY : BaseColor.WHITE);
        table.addCell(cell);
    }

    // ==================== SUMMARY SECTION ====================

    private void addSummarySection(Document document, InvoiceDetails invoice, OwnerSession owner) throws Exception {
        PdfPTable mainTable = new PdfPTable(new float[]{1, 1.3f, 0.9f});
        mainTable.setWidthPercentage(100);

        mainTable.addCell(createTermsCell(owner));
        mainTable.addCell(createPaymentCell(owner));
        mainTable.addCell(createSummaryCell(invoice));

        document.add(mainTable);
    }

    private PdfPCell createTermsCell(OwnerSession owner) {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(BORDER_GRAY);
        cell.setBorderWidth(1f);
        cell.setPadding(4);
        cell.setBackgroundColor(LIGHT_GRAY);

        Paragraph title = new Paragraph("Terms & Conditions", fontSectionTitle);
        title.setSpacingAfter(2);
        cell.addElement(title);

        Paragraph terms = new Paragraph(nvl(owner.getTerms(), "Standard terms apply."), fontSmall);
        cell.addElement(terms);

        return cell;
    }

    private PdfPCell createPaymentCell(OwnerSession owner) {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(BORDER_GRAY);
        cell.setBorderWidth(1f);
        cell.setPadding(4);
        cell.setBackgroundColor(LIGHT_GRAY);

        Paragraph title = new Paragraph("Payment Details", fontSectionTitle);
        title.setSpacingAfter(2);
        cell.addElement(title);

        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);

        addPaymentRow(table, "Bank:", nvl(owner.getBankName()));
        addPaymentRow(table, "A/c:", nvl(owner.getAccountNo()));
        addPaymentRow(table, "IFSC:", nvl(owner.getIfscCode()));
        addPaymentRow(table, "UPI:", nvl(owner.getUpiId()));

        cell.addElement(table);
        return cell;
    }

    private void addPaymentRow(PdfPTable table, String label, String value) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, fontBold));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setPaddingBottom(1);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(value, fontSmall));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setPaddingBottom(1);
        table.addCell(valueCell);
    }

    private PdfPCell createSummaryCell(InvoiceDetails invoice) {

        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(BaseColor.BLACK);
        cell.setBorderWidth(1f);                 // outer border
        cell.setPadding(4);
        cell.setBackgroundColor(BaseColor.WHITE);

        addSummaryRow(cell, "Sub Total:", "Rs." + nvl(invoice.getTotInvoiceAmt()), true);
        addSummaryRow(cell, "GST:", "Rs." + nvl(invoice.getTax()), true);
        addSummaryRow(cell, "Paid:", "Rs." + nvl(invoice.getAdvanAmt()), true);
        addSummaryRow(cell, "Prev Bal:", "Rs." + nvl(invoice.getPreBalanceAmt()), true);

        PdfPTable totalTable = new PdfPTable(2);
        totalTable.setWidthPercentage(100);
        totalTable.setSpacingBefore(1);

        // ----- LABEL CELL WITH BORDER -----
        PdfPCell labelCell = new PdfPCell(
                new Phrase("BAL DUE:", new Font(fontBold.getBaseFont(), 8, Font.BOLD, BaseColor.BLACK))
        );
        labelCell.setBorder(Rectangle.BOX);
        labelCell.setBorderColor(BaseColor.BLACK);
        labelCell.setBorderWidth(1f);
        labelCell.setBackgroundColor(BaseColor.WHITE);
        labelCell.setPadding(2);
        totalTable.addCell(labelCell);

        // ----- VALUE CELL WITH BORDER -----
        PdfPCell valueCell = new PdfPCell(
                new Phrase("Rs." + nvl(invoice.getBalanceAmt()),
                        new Font(fontBold.getBaseFont(), 8, Font.BOLD, BaseColor.BLACK))
        );
        valueCell.setBorder(Rectangle.BOX);
        valueCell.setBorderColor(BaseColor.BLACK);
        valueCell.setBorderWidth(1f);
        valueCell.setBackgroundColor(BaseColor.WHITE);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        valueCell.setPadding(2);
        totalTable.addCell(valueCell);

        cell.addElement(totalTable);
        return cell;
    }

    private void addSummaryRow(PdfPCell parent, String label, String value, boolean highlight) {
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingAfter(1);

        PdfPCell labelCell = new PdfPCell(new Phrase(label, new Font(fontSmall.getBaseFont(), 8, Font.NORMAL, BaseColor.WHITE)));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setBackgroundColor(BLACK);
        labelCell.setPadding(1);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(value, new Font(fontBold.getBaseFont(), 8, Font.BOLD, BaseColor.WHITE)));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setBackgroundColor(BLACK);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        valueCell.setPadding(1);
        table.addCell(valueCell);

        parent.addElement(table);
    }

    // ==================== FOOTER ====================

    private void addFooter(Document document) throws Exception {
        Paragraph footer = new Paragraph();
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(3);
        footer.add(new Chunk("Generated by BillMatePro | 8180080378 | support@billmatepro.com", fontSmall));
        document.add(footer);
    }

    // ==================== UTILITY METHODS ====================

    private String nvl(Object value) {
        return nvl(value, "-");
    }

    private String nvl(Object value, String defaultValue) {
        return value == null || value.toString().trim().isEmpty() ? defaultValue : value.toString();
    }

    private String formatDate(Object date) {
        if (date == null) return "-";
        try {
            return date instanceof Date ? DATE_FORMAT.format((Date) date) : date.toString();
        } catch (Exception e) {
            return "-";
        }
    }
}