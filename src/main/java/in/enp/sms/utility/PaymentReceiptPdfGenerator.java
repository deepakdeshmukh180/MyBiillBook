package in.enp.sms.utility;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import in.enp.sms.entities.CustProfile;
import in.enp.sms.pojo.BalanceDeposite;
import in.enp.sms.pojo.OwnerSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.Date;

/**
 * Professional Payment Receipt PDF Generator
 * Modern design matching invoice format
 * Optimized for A5 Landscape printing
 */
public class PaymentReceiptPdfGenerator {

    private static final Logger LOGGER = LoggerFactory.getLogger(PaymentReceiptPdfGenerator.class);

    // Page Configuration
    private static final Rectangle PAGE_SIZE = new Rectangle(PageSize.A5.getHeight(), PageSize.A5.getWidth());
    private static final float[] MARGINS = {20, 20, 20, 20};
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy");
    private static final DateTimeFormatter LOCAL_DATE_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

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
    private Font fontSectionTitleBold;
    private Font fontNormal;
    private Font fontSmall;
    private Font fontBold;
    private Font fontTableHeader;
    private Font fontEmoji;
    private Font fontReceiptNumber;
    private Font fontAmount;
    private Font fontAmountWords;

    public void generatePaymentReceiptPdf(
            BalanceDeposite balanceDeposite,
            CustProfile customer,
            OwnerSession ownerInfo,
            String qrCodeBase64,
            String amountInWords,
            OutputStream outputStream) throws Exception {

        initializeFonts();

        Document document = new Document(PAGE_SIZE, MARGINS[0], MARGINS[1], MARGINS[2], MARGINS[3]);
        PdfWriter writer = PdfWriter.getInstance(document, outputStream);
        document.open();

        // Enhanced page border
        drawEnhancedPageBorder(writer.getDirectContent(), document);

        // Add sections
        addEnhancedHeader(document, balanceDeposite, ownerInfo, qrCodeBase64);
        addStyledDivider(document, PRIMARY_ACCENT);
        addCustomerInfo(document, customer);
        addStyledDivider(document, BORDER_COLOR);
        addPaymentDetailsSection(document, balanceDeposite, amountInWords);
        addStyledDivider(document, BORDER_COLOR);
        addBalanceSummarySection(document, balanceDeposite);


        document.close();
        LOGGER.info("Payment receipt PDF generated: {}", balanceDeposite.getId());
    }

    public byte[] generatePaymentReceiptPdfToByteArray(
            BalanceDeposite balanceDeposite,
            CustProfile customer,
            OwnerSession ownerInfo,
            String qrCodeBase64,
            String amountInWords) throws Exception {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        generatePaymentReceiptPdf(balanceDeposite, customer, ownerInfo, qrCodeBase64, amountInWords, out);
        return out.toByteArray();
    }

    private void initializeFonts() {
        try {
            BaseFont regular = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            BaseFont bold = BaseFont.createFont(BaseFont.HELVETICA_BOLD, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);

            fontCompanyName = new Font(bold, 16, Font.BOLD, PRIMARY_DARK);
            fontSectionTitleBold = new Font(bold, 11, Font.BOLD, PRIMARY_ACCENT);
            fontNormal = new Font(regular, 9, Font.NORMAL, TEXT_DARK);
            fontSmall = new Font(regular, 7, Font.NORMAL, TEXT_DARK);
            fontBold = new Font(bold, 8, Font.BOLD, TEXT_DARK);
            fontTableHeader = new Font(bold, 8, Font.BOLD, WHITE);
            fontEmoji = new Font(regular, 10, Font.NORMAL, TEXT_DARK);
            fontReceiptNumber = new Font(bold, 18, Font.BOLD, PRIMARY_ACCENT);
            fontAmount = new Font(bold, 16, Font.BOLD, SUCCESS_GREEN);
            fontAmountWords = new Font(regular, 9, Font.NORMAL, TEXT_DARK);

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

    private void addEnhancedHeader(Document document, BalanceDeposite balanceDeposite,
                                   OwnerSession ownerInfo, String qrCodeBase64) throws Exception {
        PdfPTable headerTable = new PdfPTable(new float[]{55, 18, 27});
        headerTable.setWidthPercentage(100);
        headerTable.setSpacingAfter(4f);

        headerTable.addCell(createCompanyCell(ownerInfo));
        headerTable.addCell(createQRCell(qrCodeBase64));
        headerTable.addCell(createReceiptDetailsCell(balanceDeposite));

        document.add(headerTable);
    }

    private PdfPCell createCompanyCell(OwnerSession owner) {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.NO_BORDER);
        cell.setPadding(6);
        cell.setBackgroundColor(BG_LIGHT);

        // Shop name
        String shop = nvl(owner.getShopName());
        if (!shop.isEmpty()) {
            Paragraph s = new Paragraph("🏪 " + shop, fontCompanyName);
            s.setSpacingAfter(3);
            cell.addElement(s);
        }

        // Company info
        addInfoRowIf(cell, "📍 Address", owner.getAddress());
        addInfoRowIf(cell, "👤 Owner", owner.getOwnerName() + " Mob No.: " + owner.getMobNumber());
        addInfoRowIf(cell, "🆔 LC No", owner.getLcNo());
        addInfoRowIf(cell, "🏦 GST", owner.getGstNumber());

        return cell;
    }

    private void addInfoRowIf(PdfPCell cell, String label, String value) {
        String v = nvl(value);
        if (v.isEmpty()) return;
        Paragraph p = new Paragraph(label + ": " + v, fontSmall);
        p.setSpacingAfter(2);
        cell.addElement(p);
    }

    private Image loadLogo() {
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

    private PdfPCell createQRCell(String qrCodeBase64) {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(PRIMARY_ACCENT);
        cell.setBorderWidth(1.5f);
        cell.setPadding(2);
        cell.setBackgroundColor(WHITE);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);

        Paragraph label = new Paragraph();
        label.add(new Chunk("📱 ", new Font(fontEmoji.getBaseFont(), 8, Font.NORMAL, TEXT_DARK)));
        label.add(new Chunk("SCAN TO PAY", new Font(fontSectionTitleBold.getBaseFont(), 9, Font.BOLD, PRIMARY_ACCENT)));
        label.setAlignment(Element.ALIGN_CENTER);
        label.setSpacingAfter(2);
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
            LOGGER.warn("Failed to decode QR code: {}", e.getMessage());
            addQRPlaceholder(cell);
        }
    }

    private void addQRPlaceholder(PdfPCell cell) {
        Paragraph qr = new Paragraph("▓▓▓▓▓▓▓\n▓ QR ▓\n▓▓▓▓▓▓▓",
                new Font(fontSmall.getBaseFont(), 9, Font.BOLD, TEXT_LIGHT));
        qr.setAlignment(Element.ALIGN_CENTER);
        cell.addElement(qr);
    }

    private PdfPCell createReceiptDetailsCell(BalanceDeposite balanceDeposite) throws Exception {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(PRIMARY_ACCENT);
        cell.setBorderWidth(1.5f);
        cell.setPadding(5);
        cell.setBackgroundColor(BG_LIGHT);
        cell.setHorizontalAlignment(Element.ALIGN_RIGHT);

        // Logo
        Image logo = loadLogo();
        if (logo != null) {
            logo.scaleToFit(80, 28);
            logo.setAlignment(Image.ALIGN_RIGHT);
            Paragraph logoPara = new Paragraph();
            logoPara.setAlignment(Element.ALIGN_RIGHT);
            logoPara.add(new Chunk(logo, 0, -4, true));
            cell.addElement(logoPara);
        }

        // Title
        Paragraph title = new Paragraph();
        title.add(new Chunk("💰 ", new Font(fontEmoji.getBaseFont(), 8, Font.NORMAL, TEXT_DARK)));
        title.add(new Chunk("PAYMENT RECEIPT",
                new Font(fontBold.getBaseFont(), 9, Font.BOLD, PRIMARY_DARK)));
        title.setAlignment(Element.ALIGN_RIGHT);
        title.setSpacingAfter(1);
        cell.addElement(title);

        // Receipt number
        Paragraph receiptNo = new Paragraph("#" + nvl(balanceDeposite.getId()),
                new Font(fontReceiptNumber.getBaseFont(), 12, Font.BOLD, PRIMARY_ACCENT));
        receiptNo.setAlignment(Element.ALIGN_RIGHT);
        receiptNo.setSpacingAfter(2);
        cell.addElement(receiptNo);

        // Date
        Paragraph date = new Paragraph();
        date.add(new Chunk("📅 ", new Font(fontEmoji.getBaseFont(), 7, Font.NORMAL, TEXT_DARK)));
        date.add(new Chunk("Date: " + formatLocalDate(balanceDeposite.getDate()),
                new Font(fontNormal.getBaseFont(), 8, Font.BOLD, TEXT_DARK)));
        date.setAlignment(Element.ALIGN_RIGHT);
        date.setSpacingAfter(1);
        cell.addElement(date);

        return cell;
    }

    private void addCustomerInfo(Document document, CustProfile customer) throws Exception {
        PdfPTable table = new PdfPTable(3);
        table.setWidthPercentage(100);
        table.setSpacingAfter(2f);
        table.setWidths(new float[]{45, 25, 30});

        table.addCell(createCustomerCell("👤 Customer: " + nvl(customer.getCustName())));
        table.addCell(createCustomerCell("📞 Mobile: " + nvl(customer.getPhoneNo())));
        table.addCell(createCustomerCell("📍 Address: " + nvl(customer.getAddress())));

        document.add(table);
    }

    private PdfPCell createCustomerCell(String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text, new Font(fontBold.getBaseFont(), 9, Font.BOLD, TEXT_DARK)));
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(PRIMARY_ACCENT);
        cell.setBorderWidth(1f);
        cell.setPadding(5);
        cell.setBackgroundColor(BG_ACCENT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        return cell;
    }

    private void addPaymentDetailsSection(Document document,
                                          BalanceDeposite balanceDeposite,
                                          String amountInWords) throws Exception {

        PdfPTable mainTable = new PdfPTable(1);
        mainTable.setWidthPercentage(100);
        mainTable.setSpacingAfter(2f);

        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(PRIMARY_ACCENT);
        cell.setBorderWidth(2f);
        cell.setPadding(15);
        cell.setBackgroundColor(WHITE);

    /* ===============================
       RECEIVED AMOUNT (Single Line)
       =============================== */
        Paragraph receivedAmount = new Paragraph();
        receivedAmount.setAlignment(Element.ALIGN_CENTER);


        receivedAmount.add(new Chunk("💵 RECEIVED AMOUNT  ", fontSectionTitleBold));

        receivedAmount.add(new Chunk(
                "₹ " + String.format("%.2f", balanceDeposite.getAdvAmt()) + "  ",
                fontAmount
        ));

        receivedAmount.add(new Chunk(
                "(" + amountInWords + ")",
                fontAmountWords
        ));

        cell.addElement(receivedAmount);

    /* ===============================
       PAYMENT DETAILS TABLE
       =============================== */
        PdfPTable detailsTable = new PdfPTable(2);
        detailsTable.setWidthPercentage(90);
        detailsTable.setWidths(new float[]{35, 65});
        detailsTable.setHorizontalAlignment(Element.ALIGN_CENTER);
        detailsTable.setSpacingBefore(5f);

        addPaymentDetailRow(detailsTable, "💳 Mode of Payment:", nvl(balanceDeposite.getModeOfPayment()));
        addPaymentDetailRow(detailsTable, "📝 Comments:", nvl(balanceDeposite.getDescription()));
        addPaymentDetailRow(detailsTable, "🔢 Transaction ID:", nvl(balanceDeposite.getId()));
        addPaymentDetailRow(detailsTable, "👨‍💼 Deposited By:", nvl(balanceDeposite.getCreatedBy()));

        cell.addElement(detailsTable);

        mainTable.addCell(cell);
        document.add(mainTable);
    }


    private void addPaymentDetailRow(PdfPTable table, String label, String value) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, fontBold));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setPaddingBottom(5);
        labelCell.setPaddingTop(5);
        labelCell.setBackgroundColor(BG_LIGHT);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(value, fontNormal));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setPaddingBottom(5);
        valueCell.setPaddingTop(5);
        valueCell.setBackgroundColor(BG_LIGHT);
        table.addCell(valueCell);
    }

    private void addBalanceSummarySection(Document document, BalanceDeposite balanceDeposite) throws Exception {
        PdfPTable mainTable = new PdfPTable(1);
        mainTable.setWidthPercentage(100);

        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(PRIMARY_ACCENT);
        cell.setBorderWidth(1.5f);
        cell.setPadding(10);
        cell.setBackgroundColor(BG_LIGHT);

        Paragraph title = new Paragraph();
        title.add(new Chunk("📊 ", fontEmoji));
        title.add(new Chunk("Account Summary", fontSectionTitleBold));
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(8);
        cell.addElement(title);

        PdfPTable summaryTable = new PdfPTable(2);
        summaryTable.setWidthPercentage(100);

        addSummaryRow(summaryTable, "Previous Balance", "₹" + String.format("%.2f", balanceDeposite.getCurrentOusting()));
        addSummaryRow(summaryTable, "Credited Amount", "₹" + String.format("%.2f", balanceDeposite.getAdvAmt()));


        // Outstanding balance highlighted
        PdfPCell outstandingLabel = new PdfPCell(new Phrase("💰 Current Outstanding:",
                new Font(fontBold.getBaseFont(), 10, Font.BOLD, WHITE)));
        outstandingLabel.setBorder(Rectangle.BOX);
        outstandingLabel.setBorderColor(SUCCESS_GREEN);
        outstandingLabel.setBackgroundColor(SUCCESS_GREEN);
        outstandingLabel.setPadding(5);
        summaryTable.addCell(outstandingLabel);

        PdfPCell outstandingValue = new PdfPCell(new Phrase("₹" + String.format("%.2f", balanceDeposite.getCurrentOusting()),
                new Font(fontBold.getBaseFont(), 10, Font.BOLD, WHITE)));
        outstandingValue.setBorder(Rectangle.BOX);
        outstandingValue.setBorderColor(SUCCESS_GREEN);
        outstandingValue.setBackgroundColor(SUCCESS_GREEN);
        outstandingValue.setHorizontalAlignment(Element.ALIGN_RIGHT);
        outstandingValue.setPadding(5);
        summaryTable.addCell(outstandingValue);

        cell.addElement(summaryTable);
        mainTable.addCell(cell);
        document.add(mainTable);

    }

    private void addSummaryRow(PdfPTable table, String label, String value) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, fontNormal));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setPaddingBottom(4);
        labelCell.setBackgroundColor(WHITE);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(value, fontBold));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setPaddingBottom(4);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        valueCell.setBackgroundColor(WHITE);
        table.addCell(valueCell);
    }

    private void addFooter(Document document) throws Exception {
        Paragraph footer = new Paragraph();
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(2);

        Phrase footerText = new Phrase();
        footerText.add(new Chunk("✨ ", new Font(fontEmoji.getBaseFont(), 7, Font.NORMAL, TEXT_DARK)));
        footerText.add(new Chunk("Generated by ", new Font(fontSmall.getBaseFont(), 6, Font.NORMAL, TEXT_LIGHT)));
        footerText.add(new Chunk("BillMatePro",
                new Font(fontBold.getBaseFont(), 7, Font.BOLD, PRIMARY_ACCENT)));
        footerText.add(new Chunk(" | 📞 8180080378 | 📧 support@billmatepro.com",
                new Font(fontSmall.getBaseFont(), 6, Font.NORMAL, TEXT_LIGHT)));

        footer.add(footerText);
        document.add(footer);
    }

    private String nvl(Object value) {
        return nvl(value, "-");
    }

    private String nvl(Object value, String defaultValue) {
        return value == null || value.toString().trim().isEmpty() ? defaultValue : value.toString();
    }

    private String formatLocalDate(Object date) {
        if (date == null) return "-";
        try {
            if (date instanceof java.time.LocalDate) {
                return ((java.time.LocalDate) date).format(LOCAL_DATE_FORMAT);
            }
            return date.toString();
        } catch (Exception e) {
            return "-";
        }
    }
}