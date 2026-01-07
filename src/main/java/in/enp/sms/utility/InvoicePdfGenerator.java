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
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

/**
 * Enhanced Professional PDF Invoice Generator
 * Modern design with elegant styling, emojis, and improved layout
 * Optimized for A5 Landscape printing
 */
public class InvoicePdfGenerator {

    private static final Logger LOGGER = LoggerFactory.getLogger(InvoicePdfGenerator.class);

    // Page Configuration
    private static final Rectangle PAGE_SIZE = new Rectangle(PageSize.A5.getHeight(), PageSize.A5.getWidth());
    private static final float[] MARGINS = {20, 20, 20, 20};
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy");

    // Enhanced Color Palette
    private static final BaseColor PRIMARY_DARK = new BaseColor(25, 35, 45);
    private static final BaseColor PRIMARY_ACCENT = new BaseColor(41, 128, 185);
    private static final BaseColor SECONDARY_ACCENT = new BaseColor(52, 152, 219);
    private static final BaseColor SUCCESS_GREEN = new BaseColor(39, 174, 96);
    private static final BaseColor TEXT_DARK = new BaseColor(44, 62, 80);
    private static final BaseColor TEXT_LIGHT = new BaseColor(127, 140, 141);
    private static final BaseColor BG_LIGHT = new BaseColor(249, 250, 251);
    private static final BaseColor BG_ACCENT = new BaseColor(236, 240, 241);
    private static final BaseColor BORDER_COLOR = new BaseColor(189, 195, 199);
    private static final BaseColor WHITE = BaseColor.WHITE;

    // Font Configuration
    private Font fontCompanyName;
    private Font fontCompanyNameLarge;
    private Font fontSectionTitle;
    private Font fontSectionTitleBold;
    private Font fontNormal;
    private Font fontSmall;
    private Font fontBold;
    private Font fontTableHeader;
    private Font fontTableData;
    private Font fontEmoji;
    private Font fontInvoiceNumber;
    private Font fontTotalAmount;

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

        // Enhanced page border
        drawEnhancedPageBorder(writer.getDirectContent(), document);

        // Add sections with improved styling
        addEnhancedHeader(document, invoiceDetails, ownerInfo, qrCodeBase64);
        addStyledDivider(document, PRIMARY_ACCENT);
        addEnhancedCustomerInfo(document, customer);
        addStyledDivider(document, BORDER_COLOR);
        addEnhancedItemsTable(document, items, invoiceColumns);
        addStyledDivider(document, BORDER_COLOR);
        addEnhancedSummarySection(document, invoiceDetails, ownerInfo);


        document.close();
        LOGGER.info("Enhanced invoice PDF generated: {}", invoiceDetails.getInvoiceId());
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

            fontCompanyName = new Font(bold, 16, Font.BOLD, PRIMARY_DARK);
            fontCompanyNameLarge = new Font(bold, 18, Font.BOLD, PRIMARY_DARK);
            fontSectionTitle = new Font(bold, 10, Font.BOLD, TEXT_DARK);
            fontSectionTitleBold = new Font(bold, 11, Font.BOLD, PRIMARY_ACCENT);
            fontNormal = new Font(regular, 8, Font.NORMAL, TEXT_DARK);
            fontSmall = new Font(regular, 7, Font.NORMAL, TEXT_DARK);
            fontBold = new Font(bold, 8, Font.BOLD, TEXT_DARK);
            fontTableHeader = new Font(bold, 8, Font.BOLD, WHITE);
            fontTableData = new Font(regular, 8, Font.NORMAL, TEXT_DARK);
            fontEmoji = new Font(regular, 10, Font.NORMAL, TEXT_DARK);
            fontInvoiceNumber = new Font(bold, 20, Font.BOLD, PRIMARY_ACCENT);
            fontTotalAmount = new Font(bold, 9, Font.BOLD, SUCCESS_GREEN);

        } catch (Exception e) {
            LOGGER.error("Font initialization failed", e);
            throw new RuntimeException("Failed to initialize fonts", e);
        }
    }

    private void drawEnhancedPageBorder(PdfContentByte canvas, Document document) {
        canvas.saveState();

        // Outer border
        canvas.setColorStroke(PRIMARY_ACCENT);
        canvas.setLineWidth(2f);
        float x = document.leftMargin() - 5;
        float y = document.bottomMargin() - 5;
        float w = document.getPageSize().getWidth() - document.leftMargin() - document.rightMargin() + 10;
        float h = document.getPageSize().getHeight() - document.topMargin() - document.bottomMargin() + 10;
        canvas.rectangle(x, y, w, h);
        canvas.stroke();

        // Inner accent border
        canvas.setColorStroke(SECONDARY_ACCENT);
        canvas.setLineWidth(0.5f);
        canvas.rectangle(x + 2, y + 2, w - 4, h - 4);
        canvas.stroke();

        canvas.restoreState();
    }

    private void addStyledDivider(Document document, BaseColor color) throws Exception {
        Paragraph p = new Paragraph();
        p.setSpacingBefore(2);
        p.setSpacingAfter(2);
        LineSeparator separator = new LineSeparator(1.5f, 100f, color, Element.ALIGN_CENTER, -2);
        p.add(separator);
        document.add(p);
    }

    private void addEnhancedHeader(Document document, InvoiceDetails invoiceDetails,
                                   OwnerSession ownerInfo, String qrCodeBase64) throws Exception {
        PdfPTable headerTable = new PdfPTable(new float[]{60, 18, 22});
        headerTable.setWidthPercentage(100);
        headerTable.setSpacingAfter(4f);

        headerTable.addCell(createEnhancedCompanyCell(ownerInfo));
        headerTable.addCell(createEnhancedQRCell(qrCodeBase64));
        headerTable.addCell(createEnhancedInvoiceDetailsCell(invoiceDetails));

        document.add(headerTable);
    }

    private PdfPCell createEnhancedCompanyCell(OwnerSession owner) throws Exception {

        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setPadding(6);                 // compact
        cell.setBackgroundColor(BG_LIGHT);



        // ---- Shop name ----
        String shop = nvl(owner.getShopName());
        if (!shop.isEmpty()) {
            Paragraph s = new Paragraph("🏪 " + shop, fontCompanyName);
            s.setSpacingAfter(3);
            cell.addElement(s);
        }

        // ---- Dense info only if present ----
        addIconRowIf(cell, "📍 Address", owner.getAddress());
        addIconRowIf(cell, "👤 Owner", owner.getOwnerName() +" Mob No.:"+owner.getMobNumber());
        addIconRowIf(cell, "🆔 LC No", owner.getLcNo());
        addIconRowIf(cell, "🏦 GST", owner.getGstNumber());

        return cell;
    }

    // helper
    private void addIconRowIf(PdfPCell cell, String label, String value) {
        String v = nvl(value);
        if (v.isEmpty()) return;            // skip if null
        Paragraph p = new Paragraph(label + ": " + v, fontSmall);
        p.setSpacingAfter(2);
        cell.addElement(p);
    }


    private void addIconRow(PdfPCell parentCell, String icon, String label, String value) {
        PdfPTable table = new PdfPTable(new float[]{8, 92});
        table.setWidthPercentage(100);

        PdfPCell iconCell = new PdfPCell(new Phrase(icon, fontEmoji));
        iconCell.setBorder(Rectangle.NO_BORDER);
        iconCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(iconCell);

        PdfPCell textCell = new PdfPCell();
        textCell.setBorder(Rectangle.NO_BORDER);
        Phrase phrase = new Phrase();
        phrase.add(new Chunk(label + ": ", new Font(fontBold.getBaseFont(), 8, Font.BOLD, PRIMARY_ACCENT)));
        phrase.add(new Chunk(value, fontSmall));
        textCell.addElement(phrase);
        table.addCell(textCell);

        parentCell.addElement(table);
    }

    private void addCompactIconRow(PdfPCell parentCell, String icon, String label, String value) {
        PdfPTable table = new PdfPTable(new float[]{6, 94});
        table.setWidthPercentage(100);
        table.setSpacingAfter(1);

        PdfPCell iconCell = new PdfPCell(new Phrase(icon, new Font(fontEmoji.getBaseFont(), 7, Font.NORMAL, TEXT_DARK)));
        iconCell.setBorder(Rectangle.NO_BORDER);
        iconCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        iconCell.setPaddingTop(1);
        table.addCell(iconCell);

        PdfPCell textCell = new PdfPCell();
        textCell.setBorder(Rectangle.NO_BORDER);
        textCell.setPaddingTop(1);
        Phrase phrase = new Phrase();
        phrase.add(new Chunk(label + ": ", new Font(fontBold.getBaseFont(), 7, Font.BOLD, PRIMARY_ACCENT)));
        phrase.add(new Chunk(value, new Font(fontSmall.getBaseFont(), 6.5f, Font.NORMAL, TEXT_LIGHT)));
        textCell.addElement(phrase);
        table.addCell(textCell);

        parentCell.addElement(table);
    }

    private Image loadEnhancedLogo() {
        try {
            InputStream is = getClass().getResourceAsStream("/img.png");
            if (is == null) {
                LOGGER.warn("Logo not found at /img.png");
                return null;
            }
            byte[] bytes = org.apache.commons.io.IOUtils.toByteArray(is);
            Image img = Image.getInstance(bytes);
            img.scaleToFit(100, 40);
            img.setAlignment(Image.ALIGN_LEFT);
            return img;
        } catch (Exception e) {
            LOGGER.warn("Error loading logo: {}", e.getMessage());
            return null;
        }
    }

    private PdfPCell createEnhancedQRCell(String qrCodeBase64) {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(PRIMARY_ACCENT);
        cell.setBorderWidth(1.5f);
        cell.setPadding(2);
        cell.setBackgroundColor(WHITE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);

        // Compact title with emoji
        Paragraph label = new Paragraph();
        label.add(new Chunk("📱 ", new Font(fontEmoji.getBaseFont(), 8, Font.NORMAL, TEXT_DARK)));
        label.add(new Chunk("SCAN TO PAY", new Font(fontSectionTitleBold.getBaseFont(), 9, Font.BOLD, PRIMARY_ACCENT)));
        label.setAlignment(Element.ALIGN_CENTER);
        label.setSpacingAfter(2);
        cell.addElement(label);

        if (qrCodeBase64 != null && !qrCodeBase64.isEmpty()) {
            addQRImage(cell, qrCodeBase64);
        } else {
            addStyledQRPlaceholder(cell);
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
            LOGGER.warn("Failed to decode QR code: {}", e.getMessage());
            addStyledQRPlaceholder(cell);
        }
    }

    private void addStyledQRPlaceholder(PdfPCell cell) {
        Paragraph qr = new Paragraph("▓▓▓▓▓▓▓\n▓ QR ▓\n▓▓▓▓▓▓▓",
                new Font(fontSmall.getBaseFont(), 9, Font.BOLD, TEXT_LIGHT));
        qr.setAlignment(Element.ALIGN_CENTER);
        cell.addElement(qr);
    }

    private PdfPCell createEnhancedInvoiceDetailsCell(InvoiceDetails invoice) throws Exception {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(PRIMARY_ACCENT);
        cell.setBorderWidth(1.5f);
        cell.setPadding(5);
        cell.setBackgroundColor(BG_LIGHT);
        cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
// ---- Logo compact ----
        Image logo = loadEnhancedLogo();
        if (logo != null) {

            logo.scaleToFit(80, 28);
            logo.setAlignment(Image.ALIGN_RIGHT);     // move to opposite side

            Paragraph logoPara = new Paragraph();
            logoPara.setAlignment(Element.ALIGN_RIGHT);

            // x = 0 keeps horizontal, y = -4 slight up
            logoPara.add(new Chunk(logo, 0, -4, true));

            cell.addElement(logoPara);
        }

        // Compact Tax Invoice title
        Paragraph title = new Paragraph();
        title.add(new Chunk("📄 ", new Font(fontEmoji.getBaseFont(), 8, Font.NORMAL, TEXT_DARK)));
        title.add(new Chunk("TAX INVOICE",
                new Font(fontBold.getBaseFont(), 9, Font.BOLD, PRIMARY_DARK)));
        title.setAlignment(Element.ALIGN_RIGHT);
        title.setSpacingAfter(1);
        cell.addElement(title);

        // Invoice number - prominent
        Paragraph invoiceNo = new Paragraph("#" + nvl(invoice.getInvoiceId()),
                new Font(fontInvoiceNumber.getBaseFont(), 12, Font.BOLD, PRIMARY_ACCENT));
        invoiceNo.setAlignment(Element.ALIGN_RIGHT);
        invoiceNo.setSpacingAfter(2);
        cell.addElement(invoiceNo);

        // Date with icon - compact
        Paragraph date = new Paragraph();
        date.add(new Chunk("📅 ", new Font(fontEmoji.getBaseFont(), 7, Font.NORMAL, TEXT_DARK)));
        date.add(new Chunk("Date: " + formatDate(invoice.getDate()),
                new Font(fontNormal.getBaseFont(), 8, Font.BOLD, TEXT_DARK)));
        date.setAlignment(Element.ALIGN_RIGHT);
        date.setSpacingAfter(1);
        cell.addElement(date);



        return cell;
    }

    private void addEnhancedCustomerInfo(Document document, CustProfile customer) throws Exception {
        PdfPTable table = new PdfPTable(3);
        table.setWidthPercentage(100);
        table.setSpacingAfter(4f);
        table.setWidths(new float[]{45, 25, 30});

        table.addCell(createStyledCustomerCell("👤 Customer: " + nvl(customer.getCustName())));
        table.addCell(createStyledCustomerCell("📞 Mobile: " + nvl(customer.getPhoneNo())));
        table.addCell(createStyledCustomerCell("📍 Address: " + nvl(customer.getAddress())));

        document.add(table);
    }

    private PdfPCell createStyledCustomerCell(String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text, fontSectionTitle));
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(PRIMARY_ACCENT);
        cell.setBorderWidth(1f);
        cell.setPadding(6);
        cell.setBackgroundColor(BG_ACCENT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        return cell;
    }

    private void addEnhancedItemsTable(Document document, List<ItemDetails> items,
                                       List<String> columns) throws Exception {
        PdfPTable table = new PdfPTable(calculateColumnWidths(columns));
        table.setWidthPercentage(100);
        table.setSpacingAfter(4f);

        addEnhancedTableHeader(table, columns);

        int sr = 1;
        for (ItemDetails item : items) {
            addEnhancedTableRow(table, item, sr++, columns);
        }

        document.add(table);
    }

    private float[] calculateColumnWidths(List<String> columns) {
        float sr = 4;
        float desc = 30;
        float brand = 10;
        float batch = 9;
        float expiry = 7;
        float mrp = 9;
        float qty = 6;
        float rate = 10;
        float amount = 12;

        List<Float> widths = new ArrayList<>();
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

    private void addEnhancedTableHeader(PdfPTable table, List<String> columns) {
        addStyledHeader(table, "#");
        addStyledHeader(table, "DESCRIPTION");
        if (columns.contains("BRAND")) addStyledHeader(table, "BRAND");
        if (columns.contains("BATCHNO")) addStyledHeader(table, "BATCH");
        if (columns.contains("EXPD")) addStyledHeader(table, "EXPIRY");
        if (columns.contains("MRP")) addStyledHeader(table, "MRP");
        addStyledHeader(table, "QTY");
        addStyledHeader(table, "RATE");
        addStyledHeader(table, "AMOUNT");
    }

    private void addStyledHeader(PdfPTable table, String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text, fontTableHeader));
        cell.setBackgroundColor(PRIMARY_DARK);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(5);
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(PRIMARY_ACCENT);
        table.addCell(cell);
    }

    private void addEnhancedTableRow(PdfPTable table, ItemDetails item, int sr, List<String> columns) {
        boolean alternate = sr % 2 == 0;
        BaseColor bgColor = alternate ? BG_LIGHT : WHITE;

        addStyledDataCell(table, String.valueOf(sr), Element.ALIGN_CENTER, bgColor);
        addStyledDataCell(table, nvl(item.getDescription()), Element.ALIGN_LEFT, bgColor);
        if (columns.contains("BRAND"))
            addStyledDataCell(table, nvl(item.getBrand()), Element.ALIGN_CENTER, bgColor);
        if (columns.contains("BATCHNO"))
            addStyledDataCell(table, nvl(item.getBatchNo()), Element.ALIGN_CENTER, bgColor);
        if (columns.contains("EXPD"))
            addStyledDataCell(table, nvl(item.getExpDate()), Element.ALIGN_CENTER, bgColor);
        if (columns.contains("MRP"))
            addStyledDataCell(table, "₹" + nvl(item.getMrp()), Element.ALIGN_RIGHT, bgColor);
        addStyledDataCell(table, String.valueOf(item.getQty()), Element.ALIGN_CENTER, bgColor);
        addStyledDataCell(table, "₹" + nvl(item.getRate()), Element.ALIGN_RIGHT, bgColor);
        addStyledDataCell(table, "₹" + nvl(item.getAmount()), Element.ALIGN_RIGHT, bgColor);
    }

    private void addStyledDataCell(PdfPTable table, String text, int alignment, BaseColor bgColor) {
        PdfPCell cell = new PdfPCell(new Phrase(text, fontTableData));
        cell.setHorizontalAlignment(alignment);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(4);
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(BORDER_COLOR);
        cell.setBackgroundColor(bgColor);
        table.addCell(cell);
    }

    private void addEnhancedSummarySection(Document document, InvoiceDetails invoice,
                                           OwnerSession owner) throws Exception {
        PdfPTable mainTable = new PdfPTable(new float[]{1, 1.2f, 1f});
        mainTable.setWidthPercentage(100);

        mainTable.addCell(createEnhancedTermsCell(owner));
        mainTable.addCell(createEnhancedPaymentCell(owner));
        mainTable.addCell(createEnhancedSummaryCell(invoice));

        document.add(mainTable);
      //  addEnhancedFooter(document);
    }

    private PdfPCell createEnhancedTermsCell(OwnerSession owner) {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(PRIMARY_ACCENT);
        cell.setBorderWidth(1f);
        cell.setPadding(6);
        cell.setBackgroundColor(BG_LIGHT);

        Paragraph title = new Paragraph();
        title.add(new Chunk("📋 ", fontEmoji));
        title.add(new Chunk("Terms & Conditions", fontSectionTitleBold));
        title.setSpacingAfter(3);
        cell.addElement(title);

        Paragraph terms = new Paragraph(nvl(owner.getTerms(), "Standard terms apply."), fontSmall);
        cell.addElement(terms);

        return cell;
    }

    private PdfPCell createEnhancedPaymentCell(OwnerSession owner) throws Exception {

        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderWidth(1f);
        cell.setPadding(6);
        cell.setBackgroundColor(BG_LIGHT);

        // ---- Title ----
        Paragraph title = new Paragraph();
        title.add(new Chunk("💳 ", fontEmoji));
        title.add(new Chunk("Payment Details", fontSectionTitleBold));
        title.setSpacingAfter(3);
        cell.addElement(title);

        // ===== INNER TABLE FOR COMBINED ROWS =====
        PdfPTable t = new PdfPTable(2);
        t.setWidthPercentage(100);
        t.setWidths(new float[]{50, 50});

        // ---- ROW 1 : BANK + ACCOUNT ----
        PdfPCell c1 = new PdfPCell();
        c1.setBorder(Rectangle.NO_BORDER);

        Paragraph p1 = new Paragraph();
        p1.add(new Chunk("🏦 Bank: ", fontNormal));
        p1.add(new Chunk(nvl(owner.getBankName()), fontSmall));

        c1.addElement(p1);


        PdfPCell c2 = new PdfPCell();
        c2.setBorder(Rectangle.NO_BORDER);

        Paragraph p2 = new Paragraph();
        p2.add(new Chunk("🔢 A/c: ", fontNormal));
        p2.add(new Chunk(nvl(owner.getAccountNo()), fontSmall));

        c2.addElement(p2);

        t.addCell(c1);
        t.addCell(c2);

        // ---- ROW 2 : IFSC + UPI ----
        PdfPCell c3 = new PdfPCell();
        c3.setBorder(Rectangle.NO_BORDER);

        Paragraph p3 = new Paragraph();
        p3.add(new Chunk("🏧 IFSC: ", fontNormal));
        p3.add(new Chunk(nvl(owner.getIfscCode()), fontSmall));

        c3.addElement(p3);


        PdfPCell c4 = new PdfPCell();
        c4.setBorder(Rectangle.NO_BORDER);

        Paragraph p4 = new Paragraph();
        p4.add(new Chunk("📲 UPI: ", fontNormal));
        p4.add(new Chunk(nvl(owner.getUpiId()), fontSmall));

        c4.addElement(p4);

        t.addCell(c3);
        t.addCell(c4);

        cell.addElement(t);

        return cell;
    }


    private void addPaymentInfoRow(PdfPCell parentCell, String icon, String label, String value) {
        PdfPTable table = new PdfPTable(new float[]{10, 90});
        table.setWidthPercentage(100);
        table.setSpacingAfter(2);

        PdfPCell iconCell = new PdfPCell(new Phrase(icon, fontEmoji));
        iconCell.setBorder(Rectangle.NO_BORDER);
        table.addCell(iconCell);

        PdfPCell textCell = new PdfPCell();
        textCell.setBorder(Rectangle.NO_BORDER);
        Phrase phrase = new Phrase();
        phrase.add(new Chunk(label + ": ", fontBold));
        phrase.add(new Chunk(value, fontSmall));
        textCell.addElement(phrase);
        table.addCell(textCell);

        parentCell.addElement(table);
    }

    private PdfPCell createEnhancedSummaryCell(InvoiceDetails invoice) {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(PRIMARY_ACCENT);
        cell.setBorderWidth(1.5f);
        cell.setPadding(6);
        cell.setBackgroundColor(WHITE);

        addFinancialRow(cell, "Sub Total:", "₹" + nvl(invoice.getTotInvoiceAmt()), false);
        addFinancialRow(cell, "GST:", "₹" + nvl(invoice.getTax()), false);
        addFinancialRow(cell, "Paid:", "₹" + nvl(invoice.getAdvanAmt()), false);
        addFinancialRow(cell, "Prev Balance:", "₹" + nvl(invoice.getPreBalanceAmt()), false);

        // Balance Due highlighted
        PdfPTable totalTable = new PdfPTable(2);
        totalTable.setWidthPercentage(100);

        PdfPCell labelCell = new PdfPCell(new Phrase("💰 BAL DUE:", fontTotalAmount));
        labelCell.setBorder(Rectangle.BOX);
        labelCell.setBorderColor(SUCCESS_GREEN);
        labelCell.setBorderWidth(1f);
        labelCell.setBackgroundColor(BG_ACCENT);
        labelCell.setPadding(4);
        totalTable.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase("₹" + nvl(invoice.getBalanceAmt()), fontTotalAmount));
        valueCell.setBorder(Rectangle.BOX);
        valueCell.setBorderColor(SUCCESS_GREEN);
        valueCell.setBorderWidth(1.5f);
        valueCell.setBackgroundColor(BG_ACCENT);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        valueCell.setPadding(4);
        totalTable.addCell(valueCell);

        cell.addElement(totalTable);
        return cell;
    }

    private void addFinancialRow(PdfPCell parent, String label, String value, boolean highlight) {
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingAfter(2);

        BaseColor bgColor = highlight ? PRIMARY_ACCENT : PRIMARY_DARK;

        PdfPCell labelCell = new PdfPCell(new Phrase(label,
                new Font(fontNormal.getBaseFont(), 8, Font.NORMAL, WHITE)));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setBackgroundColor(bgColor);
        labelCell.setPadding(2);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(value,
                new Font(fontBold.getBaseFont(), 8, Font.BOLD, WHITE)));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setBackgroundColor(bgColor);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        valueCell.setPadding(2);
        table.addCell(valueCell);

        parent.addElement(table);
    }

    private void addEnhancedFooter(Document document) throws Exception {
        Paragraph footer = new Paragraph();
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(4);

        Phrase footerText = new Phrase();
        footerText.add(new Chunk("✨ ", fontEmoji));
        footerText.add(new Chunk("Generated by ", fontSmall));
        footerText.add(new Chunk("BillMatePro",
                new Font(fontBold.getBaseFont(), 8, Font.BOLD, PRIMARY_ACCENT)));
        footerText.add(new Chunk(" | 📞 8180080378 | 📧 support@billmatepro.com", fontSmall));

        footer.add(footerText);
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