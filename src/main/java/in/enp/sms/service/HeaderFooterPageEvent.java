package in.enp.sms.service;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;


// Event handler for header logo
class HeaderFooterPageEvent extends PdfPageEventHelper {

    private Image logo;

    public HeaderFooterPageEvent() throws Exception {
        logo = Image.getInstance("src/main/resources/img.png"); // your path
        logo.scaleToFit(150, 50); // small size
    }

    @Override
    public void onEndPage(PdfWriter writer, Document document) {
        PdfContentByte canvas = writer.getDirectContentUnder();

        float x = document.rightMargin(); // align to left margin
        float y = document.getPageSize().getHeight() - 50; // near top

        logo.setAbsolutePosition(x, y);

        try {
            canvas.addImage(logo);
        } catch (DocumentException e) {
            e.printStackTrace();
        }
    }
}

