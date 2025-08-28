package in.enp.sms.utility;

import in.enp.sms.entities.CustProfile;
import in.enp.sms.entities.OwnerInfo;
import in.enp.sms.pojo.BalanceDeposite;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.StreamUtils;

import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.Properties;

public class MailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SMTP_USER = "mybillbooksolution@gmail.com";
    private static final String SMTP_PASSWORD = "gjac rhjh hhxf uvzc";

    private static Session session;

    static {
        session = Session.getInstance(getMailProperties(), new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
            }
        });
    }

    private static Properties getMailProperties() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        return props;
    }

    public static void sendMail(String email, String html, String subject) {
        Message msg = createMessage(email, subject);
        try {
            Multipart multipart = createMultipart(html);
            msg.setContent(multipart);
            Transport.send(msg);
            // mail handling need to add
        } catch (MessagingException e) {
            handleException(e);
        }
    }

    public static void sendMailWithAttachment(String email, String html, String subject, File file) {
        Message msg = createMessage(email, subject);
        try {
            Multipart multipart = createMultipart(html);
            addAttachment(multipart, file);
            msg.setContent(multipart);
            Transport.send(msg);
            System.out.println("Mail Sent :" + email);
        } catch (MessagingException e) {
            handleException(e);
        }
    }

    private static Message createMessage(String email, String subject) {
        Message msg = new MimeMessage(session);
        try {
            msg.setFrom(new InternetAddress(SMTP_USER, false));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            msg.setSubject(subject);
        } catch (MessagingException e) {
            handleException(e);
        }
        return msg;
    }

    private static Multipart createMultipart(String html) throws MessagingException {
        Multipart multipart = new MimeMultipart("alternative");
        MimeBodyPart htmlPart = new MimeBodyPart();
        htmlPart.setContent(html, "text/html; charset=utf-8");
        multipart.addBodyPart(htmlPart);
        return multipart;
    }

    private static void addAttachment(Multipart multipart, File file) throws MessagingException {
        DataSource source = new FileDataSource(file);
        MimeBodyPart messageBodyPart = new MimeBodyPart();
        messageBodyPart.setDataHandler(new DataHandler(source));
        messageBodyPart.setFileName(file.getName());
        multipart.addBodyPart(messageBodyPart);
    }

    private static void handleException(MessagingException e) {
        // Handle exceptions more effectively (e.g., logging them)
        e.printStackTrace();
    }

    public static String getBalanceCreditedMailFormat(BalanceDeposite balanceDeposite, CustProfile custProfile, String mailSignature) {
        StringBuilder sb = new StringBuilder();

        sb.append("<!DOCTYPE html><html lang='en'><head>")
                .append("<meta charset='UTF-8' />")
                .append("<title>Balance Credited – ").append(balanceDeposite.getCustName()).append("</title>")
                .append("<meta name='viewport' content='width=device-width, initial-scale=1' />")
                .append("<style>")
                .append("body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f7fafc; margin: 0; padding: 0; }")
                .append(".container { max-width: 650px; margin: auto; background: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }")
                .append(".header { background: linear-gradient(135deg, #4CAF50, #45a049); padding: 20px; text-align: center; color: white; }")
                .append(".header h2 { margin: 0; font-size: 24px; }")
                .append(".content { padding: 20px; color: #333333; font-size: 14px; line-height: 1.6; }")
                .append(".detail { margin-bottom: 10px; }")
                .append(".label { font-weight: bold; color: #555555; display: inline-block; min-width: 160px; }")
                .append(".amount { font-weight: bold; color: #2e7d32; }")
                .append(".footer { background: #f0f0f0; padding: 12px; text-align: center; font-size: 12px; color: #777777; }")
                .append("</style>")
                .append("</head><body>")

                .append("<div class='container'>")
                .append("<div class='header'>")
                .append("<h2>💰 Balance Credited</h2>")
                .append("<p style='margin-top: 4px;'>Transaction Successful</p>")
                .append("</div>")

                .append("<div class='content'>")
                .append("<p>Hello <strong>").append(balanceDeposite.getCustName()).append("</strong>,</p>")
                .append("<p>We are pleased to inform you that the following transaction has been successfully processed:</p>")

                .append("<div class='detail'><span class='label'>Transaction ID:</span> ").append(balanceDeposite.getId()).append("</div>")
                .append("<div class='detail'><span class='label'>Credit Mode:</span> ").append(balanceDeposite.getModeOfPayment()).append("</div>")
                .append("<div class='detail'><span class='label'>Description:</span> ").append(balanceDeposite.getDescription()).append("</div>")
                .append("<div class='detail'><span class='label'>Previous Balance:</span> ₹ ").append(balanceDeposite.getCurrentOusting()).append("</div>")
                .append("<div class='detail'><span class='label'>Credited Amount:</span> <span class='amount'>₹ ").append(balanceDeposite.getAdvAmt()).append("</span></div>")
                .append("<div class='detail'><span class='label'>New Balance:</span> ₹ ").append(custProfile.getCurrentOusting()).append("</div>")
                .append("<div class='detail'><span class='label'>Credited By:</span> ").append(balanceDeposite.getCreatedBy()).append("</div>")
                .append("<div class='detail'><span class='label'>Credited On:</span> ").append(balanceDeposite.getCreatedAt()).append("</div>")

                .append("<p>Thank you for using <strong>MyBillBook Solution</strong>. We appreciate your trust in us.</p>")
                .append("</div>")

                .append("<div class='footer'>")
                .append(mailSignature)
                .append("</div>")
                .append("</div>")

                .append("</body></html>");

        return sb.toString();
    }



    public static String encodeLogoToBase64() throws IOException {
        ClassPathResource imgFile = new ClassPathResource("img.png"); // must match the path inside resources
        byte[] bytes = StreamUtils.copyToByteArray(imgFile.getInputStream());
        return Base64.getEncoder().encodeToString(bytes);
    }


    public static String buildPasswordChangeEmail(String userName, String password, String changeDate) {
        StringBuilder sb = new StringBuilder();

        sb.append("<!DOCTYPE html>");
        sb.append("<html lang='en'>");
        sb.append("<head>");
        sb.append("<meta charset='UTF-8'>");
        sb.append("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        sb.append("<title>Password Changed</title>");
        sb.append("</head>");
        sb.append("<body style='margin:0; padding:0; font-family: Arial, sans-serif; background-color:#f4f4f4;'>");

        sb.append("<div style='max-width:600px; margin:40px auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 12px rgba(0,0,0,0.1);'>");

        // Header
        sb.append("<div style='background:linear-gradient(90deg,#007bff,#17a2b8); padding:20px; text-align:center; color:#ffffff;'>");
        sb.append("<h1 style='margin:0; font-size:24px;'>🔐 Password Changed Successfully</h1>");
        sb.append("</div>");

        // Body
        sb.append("<div style='padding:30px;'>");
        sb.append("<p style='font-size:16px; color:#333;'>Hello <strong>")
                .append(userName)
                .append("</strong>,</p>");

        sb.append("<p style='font-size:15px; color:#555; line-height:1.6;'>");
        sb.append("We wanted to let you know that your account password was successfully changed on <strong>")
                .append(changeDate)
                .append("</strong>.");
        sb.append("</p>");

        sb.append("<p style='font-size:15px; color:#555; line-height:1.6;'>");
        sb.append("If you made this change, you can safely ignore this message. ");
        sb.append("If you did not change your password, please reset it immediately to protect your account.");
        sb.append("</p>");

        // Account details
        sb.append("<div style='background:#f8f9fa; border:1px solid #ddd; border-radius:6px; padding:15px; margin-top:15px;'>");
        sb.append("<p style='margin:0; font-size:14px;'><strong>Account Details:</strong></p>");
        sb.append("<p style='margin:5px 0; font-size:14px;'>Username: <strong>")
                .append(userName)
                .append("</strong></p>");
        sb.append("<p style='margin:5px 0; font-size:14px;'>New Password: <strong>")
                .append(password)
                .append("</strong></p>");
        sb.append("<p style='margin:5px 0; font-size:14px;'>Last Password Change: <strong>")
                .append(changeDate)
                .append("</strong></p>");
        sb.append("</div>");

        // Security note
        sb.append("<p style='font-size:13px; color:#d9534f; text-align:center; margin-top:20px;'>⚠️ If you did not request this change, your account may be compromised.</p>");
        sb.append("<p style='font-size:13px; color:#555; text-align:center;'>For your security, never share your password with anyone.</p>");
        sb.append("<p style='font-size:13px; color:#555; text-align:center;'>— The My Bill Book Team</p>");

        sb.append("</div>"); // End body
        sb.append("</div>"); // End container

        sb.append("</body>");
        sb.append("</html>");

        return sb.toString();
    }


    public static String sendPassChangedNotification(OwnerInfo ownerInfo, String encodedPassword) {
        return buildPasswordChangeEmail(ownerInfo.getUserName(), encodedPassword, LocalDateTime.now().toString());
    }
}
