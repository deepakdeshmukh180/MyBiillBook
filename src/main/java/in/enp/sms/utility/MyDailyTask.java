package in.enp.sms.utility;

import in.enp.sms.entities.CustProfile;
import in.enp.sms.entities.InvoiceDetails;
import in.enp.sms.entities.OwnerInfo;
import in.enp.sms.entities.User;
import in.enp.sms.pojo.BalanceDeposite;
import in.enp.sms.repository.*;
import in.enp.sms.service.PdfGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Component
public class MyDailyTask {

    private static final Logger logger = LoggerFactory.getLogger(MyDailyTask.class);

    @Autowired
    OwnerInfoRepository ownerInfoRepository;

    @Autowired
    InvoiceDetailsRepository invoiceDetailsRepository;

    @Autowired
    BalanceDepositeRepository balanceDepositeRepository;

    @Autowired
    CustProfileRepository custProfileRepository;

    @Autowired
    private UserRepository userRepository;

    @Scheduled(cron = "0 00 21 * * ?")
    public void DailyReports() {
        logger.info("Starting daily reports generation at {}", new Date());
        
        try {
            // Clean up unregistered users
            List<User> unRegisterUser = userRepository.findByOwnerIdIsNull();
            if (!unRegisterUser.isEmpty()) {
                userRepository.deleteAll(unRegisterUser);
                logger.info("Deleted {} unregistered users", unRegisterUser.size());
            }
            
            List<OwnerInfo> ownerInfoList = ownerInfoRepository.findByStatus("ACTIVE");
            logger.info("Found {} active owners for daily report generation", ownerInfoList.size());
            
            DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            PdfGenerator generator = new PdfGenerator();
            String currentDateTime = dateFormat.format(new Date());
            
            int successCount = 0;
            int failureCount = 0;
            
            for (OwnerInfo ownerInfo : ownerInfoList) {
                try {
                    logger.debug("Processing daily report for owner: {} ({})", 
                               ownerInfo.getShopName(), ownerInfo.getOwnerId());
                    
                    List<InvoiceDetails> invoices = invoiceDetailsRepository.findByOwnerIdAndDate(
                        ownerInfo.getOwnerId(), Utility.getDate(currentDateTime));
                    List<BalanceDeposite> deposits = balanceDepositeRepository.findByOwnerIdAndDate(
                        ownerInfo.getOwnerId(), Utility.getDate(currentDateTime));
                    List<CustProfile> custProfiles = custProfileRepository.findByOwnerIdOrderByCustNameAsc(
                        ownerInfo.getOwnerId());
                    
                    String date = LocalDate.now().toString();
                    ByteArrayOutputStream pdfOutput = generator.generateStatementPdf(
                        invoices, deposits, custProfiles, ownerInfo, date);
                    
                    File pdfFile = writePdfToTempFile(pdfOutput, 
                        "DailyReport_" + ownerInfo.getShopName().replaceAll(" ", "_") + date, ".pdf");
                    
                    logger.debug("Generated PDF report for {}: {} invoices, {} deposits", 
                               ownerInfo.getShopName(), invoices.size(), deposits.size());
                    
                    ExecutorService emailExecutor = Executors.newSingleThreadExecutor();
                    emailExecutor.execute(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                MailUtil.sendMailWithAttachment(
                                    ownerInfo.getEmail(),
                                    getHtmlMailFormat(ownerInfo, invoices.size(), deposits.size()),
                                    "DAILY REPORTS: " + ownerInfo.getShopName(),
                                    pdfFile
                                );
                                logger.info("Daily report email sent successfully to {} ({})", 
                                          ownerInfo.getShopName(), ownerInfo.getEmail());
                            } catch (Exception e) {
                                logger.error("Failed to send daily report email to {} ({}): {}", 
                                           ownerInfo.getShopName(), ownerInfo.getEmail(), e.getMessage(), e);
                            }
                        }
                    });
                    emailExecutor.shutdown();
                    
                    successCount++;
                    
                } catch (Exception e) {
                    failureCount++;
                    logger.error("Failed to generate daily report for owner {} ({}): {}", 
                               ownerInfo.getShopName(), ownerInfo.getOwnerId(), e.getMessage(), e);
                }
            }
            
            logger.info("Daily reports generation completed. Success: {}, Failures: {}", 
                       successCount, failureCount);
            
        } catch (Exception e) {
            logger.error("Critical error in daily reports generation: {}", e.getMessage(), e);
        }
    }

    private String getHtmlMailFormat(OwnerInfo ownerInfo, int size, int size1) {
        String htmlTemplate = "<!DOCTYPE html>\n" +
                "<html>\n" +
                "<head>\n" +
                "  <meta charset=\"UTF-8\">\n" +
                "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
                "  <style>\n" +
                "    body {\n" +
                "      font-family: 'Segoe UI', sans-serif;\n" +
                "      margin: 0;\n" +
                "      padding: 0;\n" +
                "      background-color: #f4f4f4;\n" +
                "      color: #333;\n" +
                "    }\n" +
                "\n" +
                "    .container {\n" +
                "      max-width: 600px;\n" +
                "      margin: auto;\n" +
                "      background: #fff;\n" +
                "      padding: 20px;\n" +
                "      border-radius: 8px;\n" +
                "      box-shadow: 0 0 8px rgba(0,0,0,0.05);\n" +
                "    }\n" +
                "\n" +
                "    .header {\n" +
                "      text-align: center;\n" +
                "      padding-bottom: 15px;\n" +
                "      border-bottom: 1px solid #ddd;\n" +
                "    }\n" +
                "\n" +
                "    .header h2 {\n" +
                "      margin: 0;\n" +
                "      color: #2c3e50;\n" +
                "    }\n" +
                "\n" +
                "    .owner-card {\n" +
                "      background-color: #f0f8ff;\n" +
                "      padding: 15px;\n" +
                "      margin-top: 20px;\n" +
                "      border-radius: 6px;\n" +
                "      border: 1px solid #d0e6f7;\n" +
                "    }\n" +
                "\n" +
                "    .owner-card p {\n" +
                "      margin: 6px 0;\n" +
                "      font-size: 14px;\n" +
                "    }\n" +
                "\n" +
                "    .label {\n" +
                "      font-weight: bold;\n" +
                "      color: #2c3e50;\n" +
                "    }\n" +
                "\n" +
                "    .summary {\n" +
                "      margin-top: 30px;\n" +
                "      padding: 15px;\n" +
                "      background-color: #f9f9f9;\n" +
                "      border-top: 1px solid #eee;\n" +
                "      border-radius: 6px;\n" +
                "    }\n" +
                "\n" +
                "    .summary h3 {\n" +
                "      color: #2c3e50;\n" +
                "    }\n" +
                "\n" +
                "    .summary p {\n" +
                "      font-size: 16px;\n" +
                "      margin: 8px 0;\n" +
                "    }\n" +
                "\n" +
                "    .footer {\n" +
                "      text-align: center;\n" +
                "      font-size: 12px;\n" +
                "      color: #888;\n" +
                "      margin-top: 30px;\n" +
                "    }\n" +
                "  </style>\n" +
                "</head>\n" +
                "<body>\n" +
                "  <div class=\"container\">\n" +
                "    <div class=\"header\">\n" +
                "      <h2>\uD83D\uDCCA Daily Business Summary</h2>\n" +
                "      <p><strong>Date:</strong> {{date}}</p>\n" +
                "    </div>\n" +
                "\n" +
                "    <div class=\"owner-card\">\n" +
                "      <p><span class=\"label\">\uD83C\uDFEC Shop Name:</span> {{shopName}}</p>\n" +
                "      <p><span class=\"label\">\uD83D\uDC64 Owner Name:</span> {{ownerName}}</p>\n" +
                "      <p><span class=\"label\">\uD83D\uDCE7 Email:</span> {{email}}</p>\n" +
                "      <p><span class=\"label\">\uD83E\uDDFE GST:</span> {{gstNumber}}</p>\n" +
                "      <p><span class=\"label\">\uD83D\uDCDE Mobile:</span> {{mobNumber}}</p>\n" +
                "      <p><span class=\"label\">\uD83D\uDCCD Address:</span> {{address}}</p>\n" +
                "    </div>\n" +
                "\n" +
                "    <div class=\"summary\">\n" +
                "      <h3>📋 Today's Report</h3>\n" +
                "      <p><span class=\"label\">Invoices Generated:</span> {{invoiceCount}}</p>\n" +
                "      <p><span class=\"label\">Deposit Transactions:</span> {{depositCount}}</p>\n" +
                "    </div>\n" +
                "\n" +
                "    <div class=\"footer\">\n" +
                "      This is an automated report from My Bill Book Solutions. Please do not reply.\n" +
                "    </div>\n" +
                "  </div>\n" +
                "</body>\n" +
                "</html>";
        return htmlTemplate
                .replace("{{date}}", LocalDate.now().toString())
                .replace("{{invoiceCount}}", String.valueOf(size))
                .replace("{{depositCount}}", String.valueOf(size1))
                .replace("{{shopName}}", ownerInfo.getShopName())
                .replace("{{email}}", ownerInfo.getEmail())
                .replace("{{gstNumber}}", ownerInfo.getGstNumber())
                .replace("{{ownerName}}", ownerInfo.getOwnerName())
                .replace("{{mobNumber}}", ownerInfo.getMobNumber())
                .replace("{{address}}", ownerInfo.getAddress());

    }


    public File writePdfToTempFile(ByteArrayOutputStream baos, String prefix, String suffix) throws IOException {
        File tempFile = File.createTempFile(prefix, suffix); // e.g., prefix = "DailyReport_", suffix = ".pdf"
        try (FileOutputStream fos = new FileOutputStream(tempFile)) {
            baos.writeTo(fos);
        }
        return tempFile;
    }
}