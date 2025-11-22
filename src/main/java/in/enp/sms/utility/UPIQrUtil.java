package in.enp.sms.utility;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

public class UPIQrUtil {

    public static String generateUpiQrBase64(String upiId, double amount) throws WriterException, IOException {
        // Format amount to 2 decimal places (e.g., 150.75)
        String formattedAmount = String.format("%.2f", amount);

        // Build UPI URI
        String upiString = String.format(
                "upi://pay?pa=%s&am=%s&cu=INR",
                URLEncoder.encode(upiId, StandardCharsets.UTF_8.toString()),
                URLEncoder.encode(formattedAmount, StandardCharsets.UTF_8.toString())
        );

        // QR writer with high error correction
        QRCodeWriter qrWriter = new QRCodeWriter();
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H); // High error correction
        hints.put(EncodeHintType.MARGIN, 1); // Small white border

        // HD size (e.g., 1000x1000 pixels)
        int size = 600;
        BitMatrix bitMatrix = qrWriter.encode(upiString, BarcodeFormat.QR_CODE, size, size, hints);
        BufferedImage qrImage = MatrixToImageWriter.toBufferedImage(bitMatrix);

        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            ImageIO.write(qrImage, "PNG", baos);
            byte[] imageBytes = baos.toByteArray();
            return Base64.getEncoder().encodeToString(imageBytes);
        }
    }
}
