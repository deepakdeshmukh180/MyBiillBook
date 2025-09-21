package in.enp.sms.utility;

import in.enp.sms.controller.CompanyController;
import in.enp.sms.entities.CustProfile;
import in.enp.sms.entities.InvoiceDetails;
import in.enp.sms.entities.ItemDetails;
import in.enp.sms.entities.OwnerInfo;
import in.enp.sms.pojo.BalanceDeposite;
import in.enp.sms.pojo.OwnerSession;
import in.enp.sms.repository.InvoiceNoRepository;
import in.enp.sms.repository.ItemRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.StreamUtils;

import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SMTP_USER = "mybillbooksolution@gmail.com";
    private static final String SMTP_PASSWORD = "gjac rhjh hhxf uvzc";


    @Autowired
    InvoiceNoRepository invoiceNoRepository;


    private static final Logger logger = LoggerFactory.getLogger(CompanyController.class);

    @Autowired
    static ItemRepository itemRepository;


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
            msg.setFrom(new InternetAddress(SMTP_USER, "My Bill Book"));

            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            msg.setSubject(subject);
        } catch (MessagingException e) {
            handleException(e);
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
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


    public static String sendPassChangedNotification(OwnerSession ownerInfo, String encodedPassword) {
        return buildPasswordChangeEmail(ownerInfo.getUserName(), encodedPassword, LocalDateTime.now().toString());
    }

    public static String generateEmailContent(InvoiceDetails itemDetails, CustProfile profile, OwnerSession ownerInfo, String productTable) {
        String htmlContent = getMailFormat();

        return htmlContent
                .replace("{{CUST_NAME}}", profile.getCustName())
                .replace("{{CUST_PHONE}}", profile.getPhoneNo())
                .replace("{{CUST_ADDRESS}}", profile.getAddress())
                .replace("{{INVOICE_NO}}", itemDetails.getInvoiceId())
                .replace("{{SHOP_NAME}}", ownerInfo.getShopName())
                .replace("{{OWNER_NAME}}", ownerInfo.getOwnerName())
                .replace("{{ADDRESS}}", ownerInfo.getAddress())
                .replace("{{PHONE}}", ownerInfo.getMobNumber())
                .replace("{{DATE}}", itemDetails.getCreatedAt())
                .replace("{{PRODUCT_ROWS}}", productTable)
                .replace("{{TOTAL}}", String.valueOf(itemDetails.getTotInvoiceAmt()))
                .replace("{{ADV_AMT}}", String.valueOf(itemDetails.getAdvanAmt()))
                .replace("{{CUR_BAL}}", String.valueOf(profile.getCurrentOusting()));
    }



    private static String getMailFormat() {
        return "<!DOCTYPE html>" +
                "<html lang='en'>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "<style>" +
                "body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f7fafc; margin: 0; padding: 0; color: #333; }" +
                ".container { max-width: 750px; margin: 30px auto; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }" +
                ".header { background: linear-gradient(135deg, #4CAF50, #45a049); padding: 20px; text-align: center; color: white; }" +
                ".header h2 { margin: 0; font-size: 26px; }" +
                ".header p { font-size: 14px; margin-top: 5px; }" +

                ".content { padding: 20px; }" +
                ".details-row { display: flex; flex-wrap: wrap; justify-content: space-between; margin-top: 20px; }" +
                ".details-column { width: 48%; background: #f9f9f9; padding: 12px; border-radius: 6px; }" +
                ".details-column h4 { margin-bottom: 8px; font-size: 16px; color: #2e7d32; border-bottom: 2px solid #e0e0e0; padding-bottom: 4px; }" +
                ".details-column p { font-size: 14px; margin: 4px 0; }" +

                "table { width: 100%; border-collapse: collapse; margin-top: 25px; font-size: 14px; }" +
                "th, td { padding: 10px; text-align: left; border: 1px solid #ddd; }" +
                "th { background-color: #4CAF50; color: white; }" +
                "tr:nth-child(even) { background-color: #f9f9f9; }" +
                "tr:nth-child(odd) { background-color: #ffffff; }" +

                ".totals { margin-top: 25px; }" +
                ".totals table { border: none; }" +
                ".totals td { padding: 10px; font-size: 15px; font-weight: bold; border: none; }" +
                ".totals td:first-child { text-align: right; color: #555; width: 70%; }" +

                ".footer { background: #f0f0f0; padding: 12px; text-align: center; font-size: 12px; color: #777777; }" +
                "@media(max-width: 600px) { .details-column { width: 100%; margin-bottom: 15px; } }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +

                "<div class='header'>" +
                "<h2>{{SHOP_NAME}}</h2>" +
                "<p>{{OWNER_NAME}} | {{PHONE}}<br/>{{ADDRESS}}</p>" +
                "</div>" +

                "<div class='content'>" +
                "<div class='details-row'>" +
                "<div class='details-column'>" +
                "<h4>Customer Info</h4>" +
                "<p><strong>Name:</strong> {{CUST_NAME}}</p>" +
                "<p><strong>Phone:</strong> {{CUST_PHONE}}</p>" +
                "<p><strong>Address:</strong> {{CUST_ADDRESS}}</p>" +
                "</div>" +

                "<div class='details-column'>" +
                "<h4>Invoice Info</h4>" +
                "<p><strong>Invoice No:</strong> {{INVOICE_NO}}</p>" +
                "<p><strong>Date:</strong> {{DATE}}</p>" +
                "</div>" +
                "</div>" +

                "<div class='product-table'>{{PRODUCT_ROWS}}</div>" +

                "<div class='totals'>" +
                "<table>" +
                "<tr><td>Total Amount:</td><td>{{TOTAL}}</td></tr>" +
                "<tr><td>Advance Paid:</td><td>{{ADV_AMT}}</td></tr>" +
                "<tr><td>Current Balance:</td><td>{{CUR_BAL}}</td></tr>" +
                "</table>" +
                "</div>" +
                "</div>" +

                "<div class='footer'>This is a system-generated invoice from My Bill Book</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }



    public static String generateProductTable(List<ItemDetails> items) {
        StringBuilder productTable = new StringBuilder();

        productTable.append("<table style=\"width:100%; border-collapse:collapse; font-family:Arial, sans-serif; font-size:14px;\">")
                .append("<thead>")
                .append("<tr style=\"background-color:#f0f4f7; color:#333;\">")
                .append("<th style='border:1px solid #ccc; padding:8px;'>SR NO</th>")
                .append("<th style='border:1px solid #ccc; padding:8px;'>Description</th>")
                .append("<th style='border:1px solid #ccc; padding:8px;'>Batch No.</th>")
                .append("<th style='border:1px solid #ccc; padding:8px;'>Qty</th>")
                .append("<th style='border:1px solid #ccc; padding:8px;'>MRP</th>")
                .append("<th style='border:1px solid #ccc; padding:8px;'>Rate</th>")
                .append("<th style='border:1px solid #ccc; padding:8px;'>Total Amt</th>")
                .append("</tr>")
                .append("</thead><tbody>");

        int i = 0;
        for (ItemDetails details : items) {
            String rowColor = (i % 2 == 0) ? "#ffffff" : "#f9f9f9";
            productTable.append("<tr style='background-color:")
                    .append(rowColor)
                    .append(";'>")
                    .append("<td style='border:1px solid #ccc; padding:8px;'>").append(details.getItemNo()).append("</td>")
                    .append("<td style='border:1px solid #ccc; padding:8px;'>").append(details.getDescription()).append("</td>")
                    .append("<td style='border:1px solid #ccc; padding:8px;'>").append(details.getBatchNo()).append("</td>")
                    .append("<td style='border:1px solid #ccc; padding:8px;'>").append(details.getQty()).append("</td>")
                    .append("<td style='border:1px solid #ccc; padding:8px;'>").append(details.getMrp()).append("</td>")
                    .append("<td style='border:1px solid #ccc; padding:8px;'>").append(details.getRate()).append("</td>")
                    .append("<td style='border:1px solid #ccc; padding:8px;'>").append(details.getAmount()).append("</td>")
                    .append("</tr>");
            i++;
        }

        productTable.append("</tbody></table>");
        return productTable.toString();
    }

    public static void sendMailOwner(InvoiceDetails itemDetails, CustProfile profile, OwnerSession ownerInfo) throws Exception {
        logger.info("Sending email to owner and customer for invoice ID: {}", itemDetails.getInvoiceId());
        List<ItemDetails> items = itemRepository.findByInvoiceNoAndCustId(itemDetails.getInvoiceId(), itemDetails.getCustId());

        String productTable = MailUtil.generateProductTable(items);
        String emailContent = MailUtil.generateEmailContent(itemDetails, profile, ownerInfo, productTable);

        String subjectCust = "Invoice Receipt: " + itemDetails.getInvoiceId() + " - " + ownerInfo.getShopName();
        String subjectOwner = "Invoice Receipt: " + itemDetails.getInvoiceId() + " - " + profile.getCustName();

        ExecutorService emailExecutor = Executors.newSingleThreadExecutor();
        emailExecutor.execute(() -> {
            try {
                MailUtil.sendMail(profile.getEmail(), emailContent, subjectCust);
                MailUtil.sendMail(ownerInfo.getEmail(), emailContent, subjectOwner);
                logger.info("Emails sent successfully for invoice ID: {}", itemDetails.getInvoiceId());
            } catch (Exception e) {
                logger.error("Failed to send emails for invoice ID: {}", itemDetails.getInvoiceId(), e);
            }
        });
        emailExecutor.shutdown();
    }

    public static String getRegistrationApprovedReceipt(OwnerInfo ownerInfo, String password) {
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("MMMM dd, yyyy hh:mm a");
        String startDate = formatter.format(date);
        String endDate = formatter.format(ownerInfo.getExpDate());
        return "<!DOCTYPE html>\n" +
                "<html>\n" +
                "<head>\n" +
                "  <meta charset=\"UTF-8\">\n" +
                "  <title>Registration Approved</title>\n" +
                "  <style>\n" +
                "    body {\n" +
                "      font-family: Arial, sans-serif;\n" +
                "      background-color: #f4f4f4;\n" +
                "      margin: 0;\n" +
                "      padding: 0;\n" +
                "    }\n" +
                "    .container {\n" +
                "      background-color: #ffffff;\n" +
                "      padding: 20px;\n" +
                "      margin: 30px auto;\n" +
                "      max-width: 600px;\n" +
                "      border-radius: 8px;\n" +
                "      box-shadow: 0 2px 5px rgba(0,0,0,0.1);\n" +
                "    }\n" +
                "    .header {\n" +
                "      font-size: 24px;\n" +
                "      font-weight: bold;\n" +
                "      color: #333333;\n" +
                "    }\n" +
                "    .content {\n" +
                "      margin-top: 20px;\n" +
                "      font-size: 16px;\n" +
                "      color: #555555;\n" +
                "    }\n" +
                "    .footer {\n" +
                "      margin-top: 30px;\n" +
                "      font-size: 14px;\n" +
                "      color: #888888;\n" +
                "    }\n" +
                "    .credentials {\n" +
                "      background-color: #f1f1f1;\n" +
                "      padding: 10px;\n" +
                "      border-radius: 5px;\n" +
                "      margin-top: 15px;\n" +
                "      font-family: monospace;\n" +
                "    }\n" +
                "    .note {\n" +
                "      margin-top: 20px;\n" +
                "      padding: 10px;\n" +
                "      background-color: #fff3cd;\n" +
                "      border: 1px solid #ffeeba;\n" +
                "      border-radius: 4px;\n" +
                "      color: #856404;\n" +
                "      font-size: 14px;\n" +
                "    }\n" +
                "    a.button {\n" +
                "      display: inline-block;\n" +
                "      margin-top: 20px;\n" +
                "      padding: 10px 15px;\n" +
                "      background-color: #007BFF;\n" +
                "      color: #ffffff;\n" +
                "      text-decoration: none;\n" +
                "      border-radius: 4px;\n" +
                "    }\n" +
                "  </style>\n" +
                "</head>\n" +
                "<body>\n" +
                "  <div class=\"container\">\n" +
                "    <div class=\"header\">\uD83C\uDF89 Registration Approved!</div>\n" +
                "    <div class=\"content\">\n" +
                "      Hello <strong>"+ ownerInfo.getOwnerName() +"</strong>,<br><br>\n" +
                "      Your registration has been successfully approved.<br><br>\n" +
                "      Your subscribed plan starts on <strong>"+ startDate +"</strong> and is valid until <strong>"+ endDate +"</strong>.<br><br>\n" +
                "      You can log in using the following credentials:\n" +
                "      <div class=\"credentials\">\n" +
                "        URL: <a href=\"[Login URL]\" target=\"_blank\">[Login URL]</a><br>\n" +
                "        Username: "+ ownerInfo.getUserName()+"<br>\n" +
                "        Password: "+password+"\n" +
                "      </div>\n" +
                "      <a href=\"[Login URL]\" class=\"button\">Login Now</a>\n" +
                "      <div class=\"note\">\n" +
                "        ⚠\uFE0F For your security, please delete this email after saving your login credentials.\n" +
                "      </div>\n" +
                "    </div>\n" +
                "    <div class=\"footer\">\n" +
                "      If you have any questions, feel free to contact our support team.<br>\n" +
                "      — The My Bill Book Team\n" +
                "    </div>\n" +
                "  </div>\n" +
                "</body>\n" +
                "</html>\n";
    }
}
