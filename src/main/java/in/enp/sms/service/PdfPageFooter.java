package in.enp.sms.service;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.pdf.ColumnText;
import com.itextpdf.text.pdf.PdfPageEventHelper;
import com.itextpdf.text.pdf.PdfWriter;

class PdfPageFooter extends PdfPageEventHelper {
    private final String shopName;

    private final Font footerFont = FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 8, BaseColor.GRAY);

    public PdfPageFooter(String shopName) {
        this.shopName = shopName;
    }

    @Override
    public void onEndPage(PdfWriter writer, Document document) {
        Phrase footer = new Phrase(shopName + " - Page " + writer.getPageNumber(), footerFont);
        ColumnText.showTextAligned(writer.getDirectContent(),
                Element.ALIGN_CENTER, footer,
                (document.right() - document.left()) / 2 + document.leftMargin(),
                document.bottom() - 10, 0);
    }
}
