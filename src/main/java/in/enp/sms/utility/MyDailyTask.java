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

    @Scheduled(cron = "0 45 10 * * ?")
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
                "<html lang=\"en\">\n" +
                "<head>\n" +
                "  <meta charset=\"UTF-8\">\n" +
                "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
                "  <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n" +
                "  <title>Daily Business Summary</title>\n" +
                "  <style>\n" +
                "    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');\n" +
                "    \n" +
                "    * {\n" +
                "      margin: 0;\n" +
                "      padding: 0;\n" +
                "      box-sizing: border-box;\n" +
                "    }\n" +
                "\n" +
                "    body {\n" +
                "      font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;\n" +
                "      line-height: 1.6;\n" +
                "      color: #1a202c;\n" +
                "      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);\n" +
                "      min-height: 100vh;\n" +
                "      padding: 20px 0;\n" +
                "    }\n" +
                "\n" +
                "    .email-wrapper {\n" +
                "      max-width: 680px;\n" +
                "      margin: 0 auto;\n" +
                "      background: #ffffff;\n" +
                "      border-radius: 16px;\n" +
                "      overflow: hidden;\n" +
                "      box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);\n" +
                "    }\n" +
                "\n" +
                "    .header {\n" +
                "      background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);\n" +
                "      color: white;\n" +
                "      padding: 40px 30px;\n" +
                "      text-align: center;\n" +
                "      position: relative;\n" +
                "      overflow: hidden;\n" +
                "    }\n" +
                "\n" +
                "    .header::before {\n" +
                "      content: '';\n" +
                "      position: absolute;\n" +
                "      top: -50%;\n" +
                "      right: -50%;\n" +
                "      width: 200%;\n" +
                "      height: 200%;\n" +
                "      background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);\n" +
                "      animation: float 6s ease-in-out infinite;\n" +
                "    }\n" +
                "\n" +
                "    @keyframes float {\n" +
                "      0%, 100% { transform: translateY(0px) rotate(0deg); }\n" +
                "      50% { transform: translateY(-20px) rotate(5deg); }\n" +
                "    }\n" +
                "\n" +
                "    .header h1 {\n" +
                "      font-size: 28px;\n" +
                "      font-weight: 700;\n" +
                "      margin-bottom: 8px;\n" +
                "      position: relative;\n" +
                "      z-index: 1;\n" +
                "    }\n" +
                "\n" +
                "    .header .date {\n" +
                "      font-size: 16px;\n" +
                "      font-weight: 400;\n" +
                "      opacity: 0.9;\n" +
                "      position: relative;\n" +
                "      z-index: 1;\n" +
                "    }\n" +
                "\n" +
                "    .content {\n" +
                "      padding: 40px 30px;\n" +
                "    }\n" +
                "\n" +
                "    .stats-grid {\n" +
                "      display: grid;\n" +
                "      grid-template-columns: 1fr 1fr;\n" +
                "      gap: 20px;\n" +
                "      margin-bottom: 32px;\n" +
                "    }\n" +
                "\n" +
                "    .stat-card {\n" +
                "      background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);\n" +
                "      padding: 24px;\n" +
                "      border-radius: 12px;\n" +
                "      text-align: center;\n" +
                "      border: 1px solid #e2e8f0;\n" +
                "      transition: transform 0.2s ease, box-shadow 0.2s ease;\n" +
                "      position: relative;\n" +
                "      overflow: hidden;\n" +
                "    }\n" +
                "\n" +
                "    .stat-card::before {\n" +
                "      content: '';\n" +
                "      position: absolute;\n" +
                "      top: 0;\n" +
                "      left: 0;\n" +
                "      right: 0;\n" +
                "      height: 4px;\n" +
                "      background: linear-gradient(90deg, #4f46e5, #7c3aed);\n" +
                "    }\n" +
                "\n" +
                "    .stat-card:hover {\n" +
                "      transform: translateY(-2px);\n" +
                "      box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);\n" +
                "    }\n" +
                "\n" +
                "    .stat-icon {\n" +
                "      font-size: 32px;\n" +
                "      margin-bottom: 12px;\n" +
                "      display: block;\n" +
                "    }\n" +
                "\n" +
                "    .stat-number {\n" +
                "      font-size: 36px;\n" +
                "      font-weight: 700;\n" +
                "      color: #4f46e5;\n" +
                "      margin-bottom: 4px;\n" +
                "    }\n" +
                "\n" +
                "    .stat-label {\n" +
                "      font-size: 14px;\n" +
                "      color: #64748b;\n" +
                "      font-weight: 500;\n" +
                "      text-transform: uppercase;\n" +
                "      letter-spacing: 0.5px;\n" +
                "    }\n" +
                "\n" +
                "    .business-info {\n" +
                "      background: linear-gradient(135deg, #fefefe 0%, #f8fafc 100%);\n" +
                "      border: 1px solid #e2e8f0;\n" +
                "      border-radius: 16px;\n" +
                "      padding: 32px;\n" +
                "      margin-bottom: 32px;\n" +
                "      position: relative;\n" +
                "    }\n" +
                "\n" +
                "    .business-info::before {\n" +
                "      content: '';\n" +
                "      position: absolute;\n" +
                "      top: 0;\n" +
                "      left: 0;\n" +
                "      right: 0;\n" +
                "      height: 4px;\n" +
                "      background: linear-gradient(90deg, #10b981, #059669);\n" +
                "      border-radius: 16px 16px 0 0;\n" +
                "    }\n" +
                "\n" +
                "    .business-title {\n" +
                "      font-size: 20px;\n" +
                "      font-weight: 600;\n" +
                "      color: #1a202c;\n" +
                "      margin-bottom: 24px;\n" +
                "      display: flex;\n" +
                "      align-items: center;\n" +
                "      gap: 8px;\n" +
                "    }\n" +
                "\n" +
                "    .info-grid {\n" +
                "      display: grid;\n" +
                "      grid-template-columns: 1fr 1fr;\n" +
                "      gap: 16px;\n" +
                "    }\n" +
                "\n" +
                "    .info-item {\n" +
                "      display: flex;\n" +
                "      align-items: flex-start;\n" +
                "      gap: 12px;\n" +
                "    }\n" +
                "\n" +
                "    .info-icon {\n" +
                "      font-size: 18px;\n" +
                "      margin-top: 2px;\n" +
                "      opacity: 0.7;\n" +
                "    }\n" +
                "\n" +
                "    .info-content {\n" +
                "      flex: 1;\n" +
                "    }\n" +
                "\n" +
                "    .info-label {\n" +
                "      font-size: 12px;\n" +
                "      font-weight: 600;\n" +
                "      color: #64748b;\n" +
                "      text-transform: uppercase;\n" +
                "      letter-spacing: 0.5px;\n" +
                "      margin-bottom: 4px;\n" +
                "    }\n" +
                "\n" +
                "    .info-value {\n" +
                "      font-size: 14px;\n" +
                "      font-weight: 500;\n" +
                "      color: #1a202c;\n" +
                "      word-break: break-word;\n" +
                "    }\n" +
                "\n" +
                "    .footer {\n" +
                "      background: #f8fafc;\n" +
                "      padding: 24px 30px;\n" +
                "      text-align: center;\n" +
                "      border-top: 1px solid #e2e8f0;\n" +
                "    }\n" +
                "\n" +
                "    .footer-text {\n" +
                "      font-size: 13px;\n" +
                "      color: #64748b;\n" +
                "      margin-bottom: 8px;\n" +
                "    }\n" +
                "\n" +
                "    .brand {\n" +
                "      font-weight: 600;\n" +
                "      color: #4f46e5;\n" +
                "    }\n" +
                "\n" +
                "    /* Responsive Design */\n" +
                "    @media only screen and (max-width: 600px) {\n" +
                "      body {\n" +
                "        padding: 10px;\n" +
                "      }\n" +
                "      \n" +
                "      .email-wrapper {\n" +
                "        margin: 0;\n" +
                "        border-radius: 12px;\n" +
                "      }\n" +
                "      \n" +
                "      .header {\n" +
                "        padding: 30px 20px;\n" +
                "      }\n" +
                "      \n" +
                "      .header h1 {\n" +
                "        font-size: 24px;\n" +
                "      }\n" +
                "      \n" +
                "      .content {\n" +
                "        padding: 30px 20px;\n" +
                "      }\n" +
                "      \n" +
                "      .stats-grid {\n" +
                "        grid-template-columns: 1fr;\n" +
                "        gap: 16px;\n" +
                "      }\n" +
                "      \n" +
                "      .info-grid {\n" +
                "        grid-template-columns: 1fr;\n" +
                "      }\n" +
                "      \n" +
                "      .business-info {\n" +
                "        padding: 24px 20px;\n" +
                "      }\n" +
                "      \n" +
                "      .footer {\n" +
                "        padding: 20px;\n" +
                "      }\n" +
                "    }\n" +
                "  </style>\n" +
                "</head>\n" +
                "<body>\n" +
                "  <div class=\"email-wrapper\">\n" +
                "    <div class=\"header\">\n" +
                "      <h1>📊 Daily Business Summary</h1>\n" +
                "      <p class=\"date\">{{date}}</p>\n" +
                "    </div>\n" +
                "\n" +
                "    <div class=\"content\">\n" +
                "      <div class=\"stats-grid\">\n" +
                "        <div class=\"stat-card\">\n" +
                "          <div class=\"stat-icon\">📄</div>\n" +
                "          <div class=\"stat-number\">{{invoiceCount}}</div>\n" +
                "          <div class=\"stat-label\">Invoices Generated</div>\n" +
                "        </div>\n" +
                "        <div class=\"stat-card\">\n" +
                "          <div class=\"stat-icon\">💰</div>\n" +
                "          <div class=\"stat-number\">{{depositCount}}</div>\n" +
                "          <div class=\"stat-label\">Deposit Transactions</div>\n" +
                "        </div>\n" +
                "      </div>\n" +
                "\n" +
                "      <div class=\"business-info\">\n" +
                "        <h2 class=\"business-title\">\n" +
                "          🏪 Business Information\n" +
                "        </h2>\n" +
                "        \n" +
                "        <div class=\"info-grid\">\n" +
                "          <div class=\"info-item\">\n" +
                "            <span class=\"info-icon\">🏢</span>\n" +
                "            <div class=\"info-content\">\n" +
                "              <div class=\"info-label\">Shop Name</div>\n" +
                "              <div class=\"info-value\">{{shopName}}</div>\n" +
                "            </div>\n" +
                "          </div>\n" +
                "          \n" +
                "          <div class=\"info-item\">\n" +
                "            <span class=\"info-icon\">👤</span>\n" +
                "            <div class=\"info-content\">\n" +
                "              <div class=\"info-label\">Owner Name</div>\n" +
                "              <div class=\"info-value\">{{ownerName}}</div>\n" +
                "            </div>\n" +
                "          </div>\n" +
                "          \n" +
                "          <div class=\"info-item\">\n" +
                "            <span class=\"info-icon\">📧</span>\n" +
                "            <div class=\"info-content\">\n" +
                "              <div class=\"info-label\">Email</div>\n" +
                "              <div class=\"info-value\">{{email}}</div>\n" +
                "            </div>\n" +
                "          </div>\n" +
                "          \n" +
                "          <div class=\"info-item\">\n" +
                "            <span class=\"info-icon\">📱</span>\n" +
                "            <div class=\"info-content\">\n" +
                "              <div class=\"info-label\">Mobile</div>\n" +
                "              <div class=\"info-value\">{{mobNumber}}</div>\n" +
                "            </div>\n" +
                "          </div>\n" +
                "          \n" +
                "          <div class=\"info-item\">\n" +
                "            <span class=\"info-icon\">🏷️</span>\n" +
                "            <div class=\"info-content\">\n" +
                "              <div class=\"info-label\">GST Number</div>\n" +
                "              <div class=\"info-value\">{{gstNumber}}</div>\n" +
                "            </div>\n" +
                "          </div>\n" +
                "          \n" +
                "          <div class=\"info-item\">\n" +
                "            <span class=\"info-icon\">📍</span>\n" +
                "            <div class=\"info-content\">\n" +
                "              <div class=\"info-label\">Address</div>\n" +
                "              <div class=\"info-value\">{{address}}</div>\n" +
                "            </div>\n" +
                "          </div>\n" +
                "        </div>\n" +
                "      </div>\n" +
                "    </div>\n" +
                "\n" +
                "    <div class=\"footer\">\n" +
                "      <p class=\"footer-text\">\n" +
                "        This is an automated report from <span class=\"brand\">My Bill Book Solutions</span>\n" +
                "      </p>\n" +
                "      <p class=\"footer-text\">Please do not reply to this email.</p>\n" +
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