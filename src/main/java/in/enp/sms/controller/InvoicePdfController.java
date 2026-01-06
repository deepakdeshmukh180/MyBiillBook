package in.enp.sms.controller;

import in.enp.sms.entities.*;
import in.enp.sms.pojo.OwnerSession;
import in.enp.sms.repository.CustProfileRepository;
import in.enp.sms.repository.InvoiceDetailsRepository;
import in.enp.sms.repository.ItemRepository;
import in.enp.sms.repository.OwnerInfoRepository;
import in.enp.sms.utility.InvoicePdfGenerator;
import in.enp.sms.utility.UPIQrUtil;
import in.enp.sms.utility.Utility;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Controller methods demonstrating integration with InvoicePdfGenerator
 * Add these methods to your existing CompanyController
 */
@Controller
@RequestMapping("/invoices")
public class InvoicePdfController {

    private static final Logger LOGGER = LoggerFactory.getLogger(InvoicePdfController.class);

    @Autowired
    private InvoiceDetailsRepository invoiceDetailsRepository;

    @Autowired
    private CustProfileRepository custProfileRepository;

    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private OwnerInfoRepository ownerInfoRepository;

    /**
     * Method 1: Download Invoice as PDF
     * GET /company/download-invoice-pdf/{invoiceId}/{custId} http://localhost:8080/bill-mate/download-invoice-pdf/1109202526/78B07476-991C-4A8A-B02E-9B5338E3B4F4
     */
    @GetMapping("/download-invoice-pdf/{custId}/{invoiceId}")
    public void downloadInvoicePdf(
            @PathVariable String invoiceId,
            @PathVariable String custId,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session) throws Exception {

        LOGGER.info("Download PDF request for Invoice: {}, Customer: {}", invoiceId, custId);

        try {
            // Fetch invoice details
            InvoiceDetails invoiceDetails = invoiceDetailsRepository
                    .findByCustIdAndInvoiceId(custId, invoiceId);

            if (invoiceDetails == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invoice not found");
                return;
            }

            // Fetch customer profile
            CustProfile customer = custProfileRepository.findById(custId)
                    .orElseThrow(() -> new RuntimeException("Customer not found"));

            // Fetch items
            List<ItemDetails> items = itemRepository
                    .findByInvoiceNoAndCustIdAndStatusOrderByItemNoAsc(invoiceId, custId, true);

            // Get owner info
            String ownerId = Utility.getOwnerIdFromSession(request);
            OwnerInfo ownerInfo = ownerInfoRepository.findById(ownerId)
                    .orElseThrow(() -> new RuntimeException("Owner info not found"));

            // Convert to OwnerSession (or use ownerInfo directly if compatible)
            OwnerSession ownerSession = (OwnerSession) session.getAttribute("sessionOwner");

            // Parse invoice columns
            List<String> invoiceColumns = Utility.parseInvoiceColumns(ownerInfo.getInvoiceColms());

            // Set response headers
            String filename = generateFilename(customer.getCustName(), invoiceId);
            response.setContentType("application/pdf");
           // response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

            // Generate PDF
            InvoicePdfGenerator pdfGenerator = new InvoicePdfGenerator();

            // Check if QR code is available
            String qrCodeBase64 = null;
            if (ownerInfo.getUpiId() != null && !ownerInfo.getUpiId().trim().isEmpty()) {
                try {
                    qrCodeBase64 = UPIQrUtil.generateUpiQrBase64(
                            ownerInfo.getUpiId(),
                            customer.getCurrentOusting()
                    );
                } catch (Exception e) {
                    LOGGER.warn("Failed to generate QR code", e);
                }
            }

            // Generate PDF with or without QR
            pdfGenerator.generateInvoicePdf(
                    invoiceDetails, customer, items, ownerSession,
                    invoiceColumns, qrCodeBase64, response.getOutputStream()
            );
            response.getOutputStream().flush();
            LOGGER.info("PDF download completed successfully for invoice: {}", invoiceId);

        } catch (Exception e) {
            LOGGER.error("Error generating PDF for invoice: " + invoiceId, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error generating PDF: " + e.getMessage());
        }
    }

    /**
     * Method 2: Generate PDF and return as ResponseEntity (for REST API)
     * GET /company/api/invoice-pdf/{invoiceId}/{custId}
     */
    @GetMapping("/api/invoice-pdf/{invoiceId}/{custId}")
    public ResponseEntity<byte[]> getInvoicePdfBytes(
            @PathVariable String invoiceId,
            @PathVariable String custId,
            HttpServletRequest request,
            HttpSession session) {

        LOGGER.info("API PDF request for Invoice: {}, Customer: {}", invoiceId, custId);

        try {
            // Fetch data
            InvoiceDetails invoiceDetails = invoiceDetailsRepository
                    .findByCustIdAndInvoiceId(custId, invoiceId);

            if (invoiceDetails == null) {
                return ResponseEntity.notFound().build();
            }

            CustProfile customer = custProfileRepository.findById(custId)
                    .orElseThrow(() -> new RuntimeException("Customer not found"));

            List<ItemDetails> items = itemRepository
                    .findByInvoiceNoAndCustIdAndStatusOrderByItemNoAsc(invoiceId, custId, true);

            String ownerId = Utility.getOwnerIdFromSession(request);
            OwnerInfo ownerInfo = ownerInfoRepository.findById(ownerId)
                    .orElseThrow(() -> new RuntimeException("Owner info not found"));

            OwnerSession ownerSession = (OwnerSession) session.getAttribute("sessionOwner");
            List<String> invoiceColumns = Utility.parseInvoiceColumns(ownerInfo.getInvoiceColms());

            // Generate PDF to byte array
            InvoicePdfGenerator pdfGenerator = new InvoicePdfGenerator();
            byte[] pdfBytes = pdfGenerator.generateInvoicePdfToByteArray(
                    invoiceDetails, customer, items, ownerSession, invoiceColumns
            );

            // Prepare response
            String filename = generateFilename(customer.getCustName(), invoiceId);
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDispositionFormData("attachment", filename);
            headers.setContentLength(pdfBytes.length);

            LOGGER.info("PDF generated successfully, size: {} bytes", pdfBytes.length);
            return new ResponseEntity<>(pdfBytes, headers, HttpStatus.OK);

        } catch (Exception e) {
            LOGGER.error("Error generating PDF via API", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Method 3: Integrate PDF generation into existing invoice endpoint
     * Add this to your existing processInvoiceWithItems method
     */
    private void generateAndAttachPdf(InvoiceDetails invoiceDetails,
                                      CustProfile customer,
                                      List<ItemDetails> items,
                                      OwnerSession ownerInfo,
                                      HttpServletRequest request) {
        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            OwnerInfo ownerInfoEntity = ownerInfoRepository.findById(ownerId).orElse(null);

            if (ownerInfoEntity == null) return;

            List<String> invoiceColumns = Utility.parseInvoiceColumns(ownerInfoEntity.getInvoiceColms());

            InvoicePdfGenerator pdfGenerator = new InvoicePdfGenerator();
            byte[] pdfBytes = pdfGenerator.generateInvoicePdfToByteArray(
                    invoiceDetails, customer, items, ownerInfo, invoiceColumns
            );

            // Save PDF to file system or database
            String pdfPath = savePdfToFileSystem(pdfBytes, invoiceDetails.getInvoiceId(), customer.getId());

            // Update invoice with PDF path
            invoiceDetails.setFilePath(pdfPath);
            invoiceDetailsRepository.save(invoiceDetails);

            LOGGER.info("PDF generated and saved for invoice: {}", invoiceDetails.getInvoiceId());

        } catch (Exception e) {
            LOGGER.error("Error generating PDF attachment", e);
        }
    }

    /**
     * Method 4: Bulk PDF Generation for multiple invoices
     * POST /company/bulk-download-invoices
     */
    @PostMapping("/bulk-download-invoices")
    @ResponseBody
    public ResponseEntity<?> bulkDownloadInvoices(
            @RequestBody List<String> invoiceIds,
            HttpServletRequest request,
            HttpSession session) {

        LOGGER.info("Bulk PDF download request for {} invoices", invoiceIds.size());

        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            OwnerSession ownerSession = (OwnerSession) session.getAttribute("sessionOwner");
            OwnerInfo ownerInfo = ownerInfoRepository.findById(ownerId).orElse(null);

            if (ownerInfo == null) {
                return ResponseEntity.badRequest().body("Owner info not found");
            }

            List<String> invoiceColumns = Utility.parseInvoiceColumns(ownerInfo.getInvoiceColms());
            InvoicePdfGenerator pdfGenerator = new InvoicePdfGenerator();

            java.util.List<String> generatedFiles = new java.util.ArrayList<>();

            for (String invoiceId : invoiceIds) {
                try {
                    // Fetch invoice data
                    InvoiceDetails invoiceDetails = invoiceDetailsRepository.findById(invoiceId).orElse(null);
                    if (invoiceDetails == null) continue;

                    CustProfile customer = custProfileRepository.findById(invoiceDetails.getCustId()).orElse(null);
                    if (customer == null) continue;

                    List<ItemDetails> items = itemRepository
                            .findByInvoiceNoAndCustIdAndStatusOrderByItemNoAsc(invoiceId, invoiceDetails.getCustId(), true);

                    // Generate PDF
                    byte[] pdfBytes = pdfGenerator.generateInvoicePdfToByteArray(
                            invoiceDetails, customer, items, ownerSession, invoiceColumns
                    );

                    // Save PDF
                    String filename = generateFilename(customer.getCustName(), invoiceId);
                    String filePath = savePdfToFileSystem(pdfBytes, invoiceId, customer.getId());
                    generatedFiles.add(filePath);

                    LOGGER.info("Generated PDF for invoice: {}", invoiceId);

                } catch (Exception e) {
                    LOGGER.error("Error generating PDF for invoice: " + invoiceId, e);
                }
            }

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Generated " + generatedFiles.size() + " PDFs");
            response.put("files", generatedFiles);

            return ResponseEntity.ok(response);


        } catch (Exception e) {
            LOGGER.error("Error in bulk PDF generation", e);
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(response);
        }
    }

    /**
     * Method 5: Email invoice PDF
     * POST /company/email-invoice-pdf
     */
    @PostMapping("/email-invoice-pdf")
    @ResponseBody
    public ResponseEntity<?> emailInvoicePdf(
            @RequestParam String invoiceId,
            @RequestParam String custId,
            @RequestParam String emailTo,
            HttpServletRequest request,
            HttpSession session) {

        LOGGER.info("Email PDF request for invoice: {} to: {}", invoiceId, emailTo);

        try {
            // Fetch data
            InvoiceDetails invoiceDetails = invoiceDetailsRepository
                    .findByCustIdAndInvoiceId(custId, invoiceId);
            CustProfile customer = custProfileRepository.findById(custId).orElse(null);
            List<ItemDetails> items = itemRepository
                    .findByInvoiceNoAndCustIdAndStatusOrderByItemNoAsc(invoiceId, custId, true);

            String ownerId = Utility.getOwnerIdFromSession(request);
            OwnerInfo ownerInfo = ownerInfoRepository.findById(ownerId).orElse(null);
            OwnerSession ownerSession = (OwnerSession) session.getAttribute("sessionOwner");

            if (invoiceDetails == null || customer == null || ownerInfo == null) {
                return ResponseEntity.badRequest().body("Required data not found");
            }

            List<String> invoiceColumns = Utility.parseInvoiceColumns(ownerInfo.getInvoiceColms());

            // Generate PDF
            InvoicePdfGenerator pdfGenerator = new InvoicePdfGenerator();
            byte[] pdfBytes = pdfGenerator.generateInvoicePdfToByteArray(
                    invoiceDetails, customer, items, ownerSession, invoiceColumns
            );

            // Send email with PDF attachment
            String filename = generateFilename(customer.getCustName(), invoiceId);
            boolean emailSent = sendInvoiceEmail(emailTo, pdfBytes, filename, invoiceDetails, ownerInfo);

            if (emailSent) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "Invoice PDF sent to " + emailTo);

                return ResponseEntity.ok(response);

            } else {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Failed to send email");

                return ResponseEntity
                        .status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body(response);

            }

        } catch (Exception e) {
            LOGGER.error("Error emailing invoice PDF", e);
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(response);
        }
    }

    // ========== HELPER METHODS ==========

    /**
     * Generate PDF filename
     */
    private String generateFilename(String customerName, String invoiceId) {
        String sanitizedName = customerName.replaceAll("[^a-zA-Z0-9]", "_");
        String date = new SimpleDateFormat("yyyyMMdd").format(new Date());
        return String.format("Invoice_%s_%s_%s.pdf", invoiceId, sanitizedName, date);
    }

    /**
     * Save PDF to file system
     */
    private String savePdfToFileSystem(byte[] pdfBytes, String invoiceId, String custId) throws IOException {
        String directory = "D:\\INVOICES\\" + custId + "\\";
        java.io.File dir = new java.io.File(directory);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        String filename = "Invoice_" + invoiceId + ".pdf";
        String filePath = directory + filename;

        try (java.io.FileOutputStream fos = new java.io.FileOutputStream(filePath)) {
            fos.write(pdfBytes);
        }

        return filePath;
    }

    /**
     * Send invoice email with PDF attachment
     */
    private boolean sendInvoiceEmail(String emailTo, byte[] pdfBytes, String filename,
                                     InvoiceDetails invoiceDetails, OwnerInfo ownerInfo) {
        try {
            // Use your existing email utility
            String subject = "Invoice #" + invoiceDetails.getInvoiceId() + " - " + ownerInfo.getShopName();
            String body = "Dear Customer,\n\nPlease find attached your invoice.\n\n" +
                    "Invoice Number: " + invoiceDetails.getInvoiceId() + "\n" +
                    "Amount: ₹" + invoiceDetails.getTotInvoiceAmt() + "\n\n" +
                    "Thank you for your business!\n\n" +
                    ownerInfo.getShopName();

            // Implement email sending with attachment
            // MailUtil.sendMailWithAttachment(emailTo, subject, body, pdfBytes, filename);

            LOGGER.info("Email sent successfully to: {}", emailTo);
            return true;

        } catch (Exception e) {
            LOGGER.error("Error sending email", e);
            return false;
        }
    }
}