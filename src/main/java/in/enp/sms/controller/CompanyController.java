package in.enp.sms.controller;

import com.google.zxing.WriterException;
import in.enp.sms.config.AppInfo;
import in.enp.sms.entities.*;
import in.enp.sms.pojo.BalanceDeposite;
import in.enp.sms.pojo.DateRange;
import in.enp.sms.pojo.DocUplod;
import in.enp.sms.pojo.ProductDto;
import in.enp.sms.repository.*;
import in.enp.sms.service.InvoiceService;
import in.enp.sms.service.PdfGenerator;
import in.enp.sms.service.UserService;
import in.enp.sms.utility.*;
import org.apache.commons.io.IOUtils;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import java.text.ParseException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import static in.enp.sms.utility.MailUtil.encodeLogoToBase64;

@Controller
@RequestMapping("/company")
public class CompanyController {

    private static final Logger logger = LoggerFactory.getLogger(CompanyController.class);

    @Autowired
    CustProfileRepository custProfileRepository;

    @Autowired
    ProductRepository productRepository;

    @Autowired
    InvoiceNoRepository invoiceNoRepository;

    @Autowired
    ItemRepository itemRepository;

    @Autowired
    InvoiceDetailsRepository invoiceDetailsRepository;

    @Autowired
    InvoiceService invoiceService;

    @Autowired
    AppInfo appInfo;

    @Autowired
    OwnerInfoRepository ownerInfoRepository;

    @Autowired
    UserService userService;

    @Autowired
    BalanceDepositeRepository balanceDepositeRepository;

    public static String getCurretDate() {
        logger.info("Getting current date in dd/MM/yyyy format");
        DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        Calendar cal = Calendar.getInstance();
        String currentDate = dateFormat.format(cal.getTime());
        logger.debug("Current date: {}", currentDate);
        return currentDate;
    }

    public static String getCurretDateByOther() {
        logger.info("Getting current date in yyyy-MM-dd format");
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        String currentDate = dateFormat.format(cal.getTime());
        logger.debug("Current date (other format): {}", currentDate);
        return currentDate;
    }

    public static String getCurretDateWithTime() {
        logger.info("Getting current date with time");
        DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        Calendar cal = Calendar.getInstance();
        String currentDateTime = dateFormat.format(cal.getTime());
        logger.debug("Current date with time: {}", currentDateTime);
        return currentDateTime;
    }

    @GetMapping("/delete-product-by-id")
    public String deleteProduct(HttpServletRequest request, HttpServletResponse response, Model model) {
        logger.info("Starting product deletion process");
        String ownerId = Utility.getOwnerIdFromSession(request);
        String productId = request.getParameter("productId");
        logger.info("Attempting to delete product with ID: {} for owner: {}", productId, ownerId);

        List<Product> ids = productRepository.findByProductIdAndOwnerId(Long.parseLong(productId), ownerId);
        if (!ids.isEmpty()) {
            productRepository.delete(ids.get(0));
            logger.info("Successfully deleted product with ID: {}", productId);
            model.addAttribute("msg", "Deleted product with Name : "+ids.get(0).getProductName());

        } else {
            logger.warn("No product found with ID: {} for owner: {}", productId, ownerId);
        }

        List<Product> products = productRepository.findByOwnerId(ownerId);
        products.sort(Comparator.comparing(Product::getProductName));
        logger.info("Retrieved {} products for owner: {}", products.size(), ownerId);

        model.addAttribute("products", products);
        model.addAttribute("product", new Product());
        return "products";
    }

    @GetMapping("/update-product-by-id")
    public String updateProduct(HttpServletRequest request, HttpServletResponse response, Model model) throws ParseException {
        logger.info("Starting product update process");
        String productId = request.getParameter("productId");
        logger.info("Updating product with ID: {}", productId);

        Product product = productRepository.findById(Long.parseLong(productId)).get();
        model.addAttribute("product", product);

        String ownerId = Utility.getOwnerIdFromSession(request);
        List<Product> products = productRepository.findByOwnerId(ownerId);
        products.sort(Comparator.comparing(Product::getProductName));

        for (Product p : products) {
            p.setCustId(getDateDiff(p.getExpdate()));
        }
        products.sort(Comparator.comparing(Product::getProductName));

        logger.info("Retrieved {} products for owner: {}", products.size(), ownerId);
        model.addAttribute("products", products);
        return "products";
    }

    @GetMapping("/get-product-by-id")
    public String getProductbyId(HttpServletRequest request, HttpServletResponse response, Model model) {
        logger.info("Retrieving product by ID");
        String productId = request.getParameter("productId");
        logger.info("Getting product with ID: {}", productId);

        Product product = productRepository.findById(Long.parseLong(productId)).get();
        model.addAttribute("product", product);

        String ownerId = Utility.getOwnerIdFromSession(request);
        List<Product> products = productRepository.findByOwnerId(ownerId);
        products.sort(Comparator.comparing(Product::getProductName));

        logger.info("Retrieved {} products for owner: {}", products.size(), ownerId);
        model.addAttribute("products", products);
        return "products";
    }

    @PostMapping("/add-product")
    public String addProduct(@ModelAttribute("PRODUCTS") Product product,
                             Model model,
                             HttpServletRequest request,
                             HttpServletResponse response) throws Exception {
        logger.info("Starting product addition process");
        String ownerId = Utility.getOwnerIdFromSession(request);
        logger.info("Adding product for owner: {}", ownerId);



        product.setOwnerId(ownerId);

        // Build product name
        StringBuilder productNameBuilder = new StringBuilder(product.getPname().trim().toUpperCase());
        if (product.getCompany() != null && !product.getCompany().trim().isEmpty()) {
            productNameBuilder.append("[").append(product.getCompany().trim().toUpperCase()).append("]");
        }
        productNameBuilder.append("-").append(product.getQuantity().trim().toUpperCase());

        product.setProductName(productNameBuilder.toString());
        product.setBatchNo(product.getBatchNo().trim().toUpperCase());
        product.setStatus(true);

        logger.info("Product details - Name: {}, Batch: {}", product.getProductName(), product.getBatchNo());
        if (product.getProductId() == 0) {
            model.addAttribute("msg", "New product added with Name: " + product.getProductName());
        } else {
            model.addAttribute("msg", "Product updated with Name: " + product.getProductName());
        }
        productRepository.save(product);
        logger.info("Successfully saved product: {}", product.getProductName());

        // Load customer profile
        custProfileRepository.findById(product.getCustId()).ifPresent(profile -> {
            model.addAttribute("profile", profile);
            logger.debug("Added customer profile to model for custId: {}", product.getCustId());
        });

        model.addAttribute("appInfo", appInfo);

        // Fetch and sort products for the owner
        List<Product> products = productRepository.findByOwnerId(ownerId);
        products.sort(Comparator.comparing(Product::getProductName));

        // Set exp-date difference
        for (Product p : products) {
            p.setCustId(getDateDiff(p.getExpdate()));
        }

        logger.info("Retrieved {} products for display", products.size());
        model.addAttribute("products", products);
        model.addAttribute("product", new Product());

        return "products";
    }

    @PostMapping("/invoice")
    public String getInvoicePage(@ModelAttribute("INVOICE_DETAILS") InvoiceDetails itemDetails, Model model,
                                 HttpServletRequest request) throws Exception {
        logger.info("Processing invoice generation");
        logger.info("Invoice ID: {}, Customer ID: {}", itemDetails.getInvoiceId(), itemDetails.getCustId());

        List<ItemDetails> items = itemRepository.findByInvoiceNoAndCustId(itemDetails.getInvoiceId(), itemDetails.getCustId());
        logger.info("Found {} items for invoice", items.size());

        itemDetails.setDate(LocalDate.now());

        CustProfile profile = custProfileRepository.findById(itemDetails.getCustId())
                .orElseThrow(() -> {
                    logger.error("Customer not found with ID: {}", itemDetails.getCustId());
                    return new RuntimeException("Customer not found");
                });

        if (!items.isEmpty()) {
            logger.info("Processing invoice with items");
            boolean isExist = invoiceDetailsRepository.existsById(itemDetails.getInvoiceId());
            logger.info("Invoice exists: {}", isExist);

            model.addAttribute("profile", profile);
            model.addAttribute("oldInvoicesFlag", itemDetails.getOldInvoicesFlag());
            model.addAttribute("date", getCurretDateWithTime());
            model.addAttribute("invoiceNo", itemDetails.getInvoiceId());

            String itemSummary = invoiceService.generateItemSummary(items);
            itemRepository.saveAll(items);

            Map<String, Double> totals = invoiceService.computeTotals(items);
            logger.info("Invoice totals calculated - Total Amount: {}", totals.get("totalAmount"));

            itemDetails.setItemDetails(itemSummary);
            invoiceService.populateInvoiceMetadata(itemDetails, profile, totals, SecurityContextHolder.getContext().getAuthentication().getName());
            itemDetails.setOwnerId(Utility.getOwnerIdFromSession(request));

            if ("Y".equals(itemDetails.getOldInvoicesFlag())) {
                model.addAttribute("oldinvoices", invoiceDetailsRepository.findByCustId(profile.getId()));
                model.addAttribute("balanceDeposits", balanceDepositeRepository.findByCustId(itemDetails.getCustId()));
            }

            invoiceDetailsRepository.save(itemDetails);
            logger.info("Invoice details saved for Invoice ID: {}", itemDetails.getInvoiceId());

            OwnerInfo ownerInfo = ownerInfoRepository.findById(Utility.getOwnerIdFromSession(request))
                    .orElseThrow(() -> {
                        logger.error("Owner not found with ID: {}", Utility.getOwnerIdFromSession(request));
                        return new RuntimeException("Owner not found");
                    });
            model.addAttribute("ownerInfo", ownerInfo);
            model.addAttribute("currentinvoiceitems", itemDetails);
            model.addAttribute("advamount", itemDetails.getAdvanAmt());

            if (!isExist) {
                profile = getUpdateBalance(profile, totals.get("totalAmount"), itemDetails.getAdvanAmt());
                updateInvoiceNo(Utility.getOwnerIdFromSession(request));
            }

            sendMailOwner(itemDetails, profile, ownerInfo);

            model.addAttribute("totalQty", totals.get("totalQty"));
            model.addAttribute("totalAmout", totals.get("totalAmount"));
            model.addAttribute("items", items);
            model.addAttribute("QRCODE", UPIQrUtil.generateUpiQrBase64(ownerInfo.getUpiId(), profile.getCurrentOusting()));
            model.addAttribute("invoiceTime", itemDetails.getCreatedAt());
            updateStockForOldInvoice(itemDetails.getInvoiceId());
            if (ownerInfo.getInvoiceType().equals("A4")) {
                return "invoiceindetails";
            } else {
                return "invoice";
            }
        } else {
            logger.warn("No items found for invoice ID: {}", itemDetails.getInvoiceId());
            model.addAttribute("profile", profile);
            model.addAttribute("date", getCurretDate());
            model.addAttribute("invoiceNo", getCurrentInvoiceNumber(Utility.getOwnerIdFromSession(request)));

            Map<String, Double> totals = invoiceService.computeTotals(items);

            model.addAttribute("preTaxAmt", totals.get("preTaxAmt"));
            model.addAttribute("totGst", totals.get("gst"));
            model.addAttribute("totalQty", totals.get("totalQty"));
            model.addAttribute("totalAmout", totals.get("totalAmount"));
            model.addAttribute("items", items);
            model.addAttribute("itemsNo", items.size() + 1);
            model.addAttribute("appInfo", appInfo);

            model.addAttribute("balanceDeposits", balanceDepositeRepository.findByCustId(profile.getId()));
            model.addAttribute("oldinvoices", invoiceDetailsRepository.findByCustId(profile.getId()));

            List<Product> products = productRepository.findByOwnerId(Utility.getOwnerIdFromSession(request));
            products.sort(Comparator.comparing(Product::getProductName));
            model.addAttribute("dropdown", products);

            return "createinvoice";
        }
    }

    public void updateStockForOldInvoice(String invoiceId) {
        logger.info("Updating stock for old invoice ID: {}", invoiceId);
        List<ItemDetails> itemsToDelete = itemRepository.findByInvoiceNoAndStatus(invoiceId, false);

        // Map to accumulate stock updates
        Map<Long, Double> stockAdjustments = new HashMap<>();

        // Aggregate quantity per product
        for (ItemDetails item : itemsToDelete) {
            stockAdjustments.merge(item.getProductId(), item.getQty(), Double::sum);
        }

        // Fetch all products at once
        Iterable<Product> products = productRepository.findAllById(stockAdjustments.keySet());

        for (Product product : products) {
            double adjustment = stockAdjustments.getOrDefault(product.getProductId(), 0.0);
            product.setStock(product.getStock() + Math.round(adjustment));
            logger.info("Adjusted stock for product: {} by {}", product.getProductName(), adjustment);
        }

        // Save all updates in batch
        productRepository.saveAll(products);
        logger.info("Stock updated for all products related to invoice ID: {}", invoiceId);

        // Delete all related items
        itemRepository.deleteAll(itemsToDelete);
        logger.info("Deleted all items related to invoice ID: {}", invoiceId);
    }

    private void sendMailOwner(InvoiceDetails itemDetails, CustProfile profile, OwnerInfo ownerInfo) throws Exception {
        logger.info("Sending email to owner and customer for invoice ID: {}", itemDetails.getInvoiceId());
        List<ItemDetails> items = itemRepository.findByInvoiceNoAndCustId(itemDetails.getInvoiceId(), itemDetails.getCustId());

        String productTable = generateProductTable(items);
        String emailContent = generateEmailContent(itemDetails, profile, ownerInfo, productTable);

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

    private String generateEmailContent(InvoiceDetails itemDetails, CustProfile profile, OwnerInfo ownerInfo, String productTable) {
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



    private String getMailFormat() {
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



    private String generateProductTable(List<ItemDetails> items) {
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




    @GetMapping("/get-cust-by-id")
    public String getInvoicePage(HttpServletRequest request, HttpServletResponse response, Model model) {
        logger.info("Retrieving customer by ID");
        String custId = request.getParameter("custid");
        logger.info("Customer ID: {}", custId);

        if (custId == null || custId.trim().isEmpty()) {
            logger.warn("Customer ID is missing or invalid");
            model.addAttribute("error", "Customer ID is missing or invalid.");
            return "error-page";
        }

        CustProfile profile = custProfileRepository.findById(custId).orElse(null);
        if (profile == null) {
            logger.warn("Customer not found with ID: {}", custId);
            model.addAttribute("error", "Customer not found.");
            return "error-page";
        }
        model.addAttribute("profile", profile);

        String currentDate = getCurretDate();
        model.addAttribute("date", currentDate);

        String invoiceNo = getCurrentInvoiceNumber(Utility.getOwnerIdFromSession(request));
        model.addAttribute("invoiceNo", invoiceNo);

        List<ItemDetails> items = itemRepository.findByInvoiceNoAndCustId(invoiceNo, custId);
        Double totalAmount = items.stream().mapToDouble(ItemDetails::getAmount).sum();
        Double totalQty = items.stream().mapToDouble(ItemDetails::getQty).sum();
        Double preTaxAmt = items.stream().mapToDouble(ItemDetails::getPriTaxAmt).sum();
        Double totGst = items.stream().mapToDouble(ItemDetails::getTaxAmount).sum();

        model.addAttribute("preTaxAmt", preTaxAmt);
        model.addAttribute("totGst", totGst);
        model.addAttribute("totalQty", totalQty);
        model.addAttribute("totalAmout", totalAmount);
        model.addAttribute("items", items);
        model.addAttribute("itemsNo", items.size() + 1);
        model.addAttribute("appInfo", appInfo);

        List<BalanceDeposite> balanceDeposits = balanceDepositeRepository.findByCustId(profile.getId());
        model.addAttribute("balanceDeposits", balanceDeposits);

        List<InvoiceDetails> oldInvoices = invoiceDetailsRepository.findByCustId(profile.getId());
        model.addAttribute("oldinvoices", oldInvoices);

        List<Product> products = productRepository.findByOwnerId(Utility.getOwnerIdFromSession(request));
        products.sort(Comparator.comparing(Product::getProductName));
        model.addAttribute("dropdown", products);

        logger.info("Customer data retrieved successfully for ID: {}", custId);
        return "createinvoice";
    }

    @GetMapping("/get-custmer-by-id/{custId}")
    public String getInvoicePage(@PathVariable String custId, HttpServletRequest request, HttpServletResponse response, Model model) {
        logger.info("Retrieving customer by ID: {}", custId);
        CustProfile profile = custProfileRepository.getOne(custId);
        model.addAttribute("profile", profile);
        model.addAttribute("date", getCurretDate());
        String invoiceNo = getCurrentInvoiceNumber(Utility.getOwnerIdFromSession(request));
        model.addAttribute("invoiceNo", invoiceNo);
        List<ItemDetails> items = itemRepository.findByInvoiceNoAndCustId(invoiceNo, request.getParameter("custid"));
        Double totalAmout = items.stream()
                .map(x -> x.getAmount())
                .reduce(0.0, Double::sum);
        Double totalQty = items.stream()
                .map(x -> x.getQty())
                .reduce(0.0, Double::sum);
        Double preTaxAmt = items.stream()
                .map(x -> x.getPriTaxAmt())
                .reduce(0.0, Double::sum);

        Double totGst = items.stream()
                .map(x -> x.getTaxAmount())
                .reduce(0.0, Double::sum);

        model.addAttribute("preTaxAmt", preTaxAmt);
        model.addAttribute("totGst", totGst);
        model.addAttribute("totalQty", totalQty);
        model.addAttribute("totalAmout", totalAmout);
        model.addAttribute("items", items);
        model.addAttribute("itemsNo", items.size() + 1);
        model.addAttribute("appInfo", appInfo);

        List<BalanceDeposite> balanceDeposits = balanceDepositeRepository.findByCustId(profile.getId());
        model.addAttribute("balanceDeposits", balanceDeposits);

        List<InvoiceDetails> details = invoiceDetailsRepository.findByCustId(profile.getId());
        model.addAttribute("oldinvoices", details);
        List<Product> products = productRepository.findByOwnerId(Utility.getOwnerIdFromSession(request));
        model.addAttribute("dropdown", products);
        logger.info("Customer data retrieved successfully for ID: {}", custId);
        return "createinvoice";
    }

    public String getCurrentInvoiceNumber(String ownerId) {
        logger.info("Getting current invoice number for owner ID: {}", ownerId);
        String finYear;
        int year = Calendar.getInstance().get(Calendar.YEAR);
        int month = Calendar.getInstance().get(Calendar.MONTH) + 1;

        if (month <= 3) {
            finYear = year - 1 + "" + year;
        } else {
            finYear = year + "" + (year + 1);
        }
        if (!invoiceNoRepository.existsByOwnerId(ownerId)) {
            InvoiceNo invoiceNo = new InvoiceNo();
            invoiceNo.setInvoiceId(ownerId);
            invoiceNo.setInvoiceNumber(1000);
            invoiceNoRepository.save(invoiceNo);
            logger.info("Initialized invoice number for owner ID: {}", ownerId);
        }
        InvoiceNo invoiceNo = invoiceNoRepository.findByOwnerId(ownerId);
        finYear = finYear.replaceAll("20","");
        String currentInvoiceNumber = invoiceNo.getInvoiceNumber() + "" + invoiceNo.getBillNo() + "" + finYear;
        logger.info("Current invoice number for owner ID: {} is {}", ownerId, currentInvoiceNumber);
        return currentInvoiceNumber;
    }

    public String getCurrentFY() {
        logger.info("Getting current financial year");
        String finYear;
        int year = Calendar.getInstance().get(Calendar.YEAR);
        int month = Calendar.getInstance().get(Calendar.MONTH) + 1;

        if (month <= 3) {
            finYear = year - 1 + "" + year;
        } else {
            finYear = year + "" + (year + 1);
        }
        finYear = finYear.replaceAll("20","");
        logger.info("Current financial year is {}", finYear);
        return finYear;
    }


    public String getCurrentFYWithFull() {
        logger.info("Getting current financial year");

        int year = Calendar.getInstance().get(Calendar.YEAR);
        int month = Calendar.getInstance().get(Calendar.MONTH) + 1;

        String finYear;
        if (month <= 3) {
            // Jan-Mar -> FY of previous year to current year
            finYear = (year - 1) + "-" + String.valueOf(year).substring(2);
        } else {
            // Apr-Dec -> FY of current year to next year
            finYear = year + "-" + String.valueOf(year + 1).substring(2);
        }

        logger.info("Current financial year is {}", finYear);
        return finYear;
    }


    @PostMapping("/save-items")
    public String saveItems(@ModelAttribute("ItemDetails") ItemDetails itemDetails, Model model,
                            HttpServletRequest request, HttpServletResponse response) {
        logger.info("Saving item details for product ID: {}", itemDetails.getProductId());
        itemDetails.setAmount(Math.floor(itemDetails.getAmount()));

        Product product = productRepository.findById(itemDetails.getProductId()).get();

        if (product.getStock() < itemDetails.getQty()) {
            logger.warn("Out of stock for product ID: {}. Available stock: {}", product.getProductId(), product.getStock());
            model.addAttribute("message", "Out of stock, available stock: " + product.getStock());
            return loadInvoiceView(model, itemDetails.getCustId(), request);
        }

        product.setStock(product.getStock() - Math.round(itemDetails.getQty()));
        productRepository.save(product);
        logger.info("Updated stock for product ID: {}", product.getProductId());

        itemDetails.setTaxPercetage(product.getTaxPercentage());
        itemDetails.setPriTaxAmt(getGstAmt(product.getTaxPercentage(), itemDetails.getAmount()));
        itemDetails.setTaxAmount(itemDetails.getAmount() - itemDetails.getPriTaxAmt());
        itemDetails.setDescription(product.getProductName().toUpperCase());
        itemDetails.setMrp(product.getMrp());
        itemDetails.setBatchNo(product.getBatchNo());
        itemDetails.setId(UUID.randomUUID().toString());
        itemRepository.save(itemDetails);
        logger.info("Item details saved successfully for product ID: {}", itemDetails.getProductId());
        return loadInvoiceView(model, itemDetails.getCustId(), request);
    }

    @GetMapping("/delete-item-by-id")
    public String deleteItem(HttpServletRequest request, HttpServletResponse response, Model model) {
        logger.info("Deleting item by ID");
        String itemId = request.getParameter("itemid");

        if (itemId == null || itemId.isEmpty()) {
            logger.warn("Invalid item ID");
            model.addAttribute("message", "Invalid item ID.");
            return "createinvoice";
        }

        Optional<ItemDetails> optionalItem = itemRepository.findById(itemId);
        if (!optionalItem.isPresent()) {
            logger.warn("Item not found with ID: {}", itemId);
            model.addAttribute("message", "Item not found.");
            return "createinvoice";
        }

        ItemDetails item = optionalItem.get();

        Optional<Product> optionalProduct = productRepository.findByProductName(item.getDescription().toUpperCase())
                .stream()
                .findFirst();
        optionalProduct.ifPresent(product -> {
            product.setStock(product.getStock() + (int) Math.round(item.getQty()));

            productRepository.save(product);
            logger.info("Restored stock for product: {}", product.getProductName());
        });

        itemRepository.delete(item);
        logger.info("Deleted item with ID: {}", itemId);

        return loadInvoiceView(model, item.getCustId(), request);
    }

    public void updateSerialNumbers(List<ItemDetails> products) {
        logger.info("Updating serial numbers for items");
        for (int i = 0; i < products.size(); i++) {
            products.get(i).setItemNo(i + 1);
        }
        logger.info("Serial numbers updated successfully");
    }

    private String loadInvoiceView(Model model, String custId, HttpServletRequest request) {
        logger.info("Loading invoice view for customer ID: {}", custId);
        String invoiceNo = getCurrentInvoiceNumber(Utility.getOwnerIdFromSession(request));
        List<ItemDetails> items = itemRepository.findByInvoiceNoAndCustId(invoiceNo, custId);

        double totalAmount = 0, totalQty = 0, preTaxAmt = 0, totalGst = 0;
        for (ItemDetails item : items) {
            totalAmount += item.getAmount();
            totalQty += item.getQty();
            preTaxAmt += item.getPriTaxAmt();
            totalGst += item.getTaxAmount();
        }
        updateSerialNumbers(items);
        CustProfile profile = custProfileRepository.findById(custId).orElse(null);
        model.addAttribute("profile", profile);
        model.addAttribute("date", getCurretDate());
        model.addAttribute("invoiceNo", invoiceNo);
        model.addAttribute("itemsNo", items.size() + 1);
        model.addAttribute("items", items);
        model.addAttribute("preTaxAmt", preTaxAmt);
        model.addAttribute("totGst", totalGst);
        model.addAttribute("totalQty", totalQty);
        model.addAttribute("totalAmout", totalAmount);
        model.addAttribute("appInfo", appInfo);
        model.addAttribute("balanceDeposits", balanceDepositeRepository.findByCustId(custId));
        model.addAttribute("oldinvoices", invoiceDetailsRepository.findByCustId(custId));
        model.addAttribute("dropdown", productRepository.findByOwnerId(Utility.getOwnerIdFromSession(request)));

        logger.info("Invoice view loaded successfully for customer ID: {}", custId);
        return "createinvoice";
    }

    private CustProfile getUpdateBalance(CustProfile profile, Double totalAmout, Double advanceAmout) {
        logger.info("Updating balance for customer ID: {}", profile.getId());
        profile.setTotalAmount((double)((int) profile.getTotalAmount() + totalAmout));
        profile.setCurrentOusting((double)((int) profile.getCurrentOusting() + totalAmout - advanceAmout));
        profile.setPaidAmout((double)((int) profile.getPaidAmout() + advanceAmout));
        logger.info("Balance updated successfully for customer ID: {}", profile.getId());
        return profile;
    }

    public void updateInvoiceNo(String ownerId) {
        logger.info("Updating invoice number for owner ID: {}", ownerId);
        InvoiceNo invoiceNo = invoiceNoRepository.findByOwnerId(ownerId);
        invoiceNo.setInvoiceNumber(invoiceNo.getInvoiceNumber() + 1);
        invoiceNoRepository.save(invoiceNo);
        logger.info("Invoice number updated successfully for owner ID: {}", ownerId);
    }

    @GetMapping("/get-all-invoices")
    public String getAllInvoiceList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model,
            HttpServletRequest request) {
        logger.info("Retrieving all invoices for page: {}, size: {}", page, size);
        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            if (ownerId == null) {
                logger.warn("User session is invalid or has expired");
                model.addAttribute("error", "User session is invalid or has expired.");
                return "error";
            }

            String currentFY = getCurrentFY();
            Pageable pageable = PageRequest.of(page, size, Sort.by("invoiceId").descending());

            Page<InvoiceDetails> invoicePage = invoiceDetailsRepository
                    .findByInvoiceIdEndingWithFyAndOwnerId(currentFY, ownerId, pageable);

            model.addAttribute("invoices", invoicePage.getContent());
            model.addAttribute("currentPage", invoicePage.getNumber());
            model.addAttribute("totalPages", invoicePage.getTotalPages());
            model.addAttribute("totalCustomers", invoicePage.getTotalElements());
            model.addAttribute("fy", currentFY);
            int startPage = Math.max(0, page - 2);
            int endPage = Math.min(invoicePage.getTotalPages() - 1, page + 2);

            model.addAttribute("startPage", startPage);
            model.addAttribute("endPage", endPage);

            model.addAttribute("page", page);

            logger.info("Invoices retrieved successfully for page: {}", page);
            return "invoicesearch";
        } catch (Exception ex) {
            logger.error("Error occurred while fetching invoice list", ex);
            model.addAttribute("error", "An unexpected error occurred while retrieving the invoices.");
            return "error";
        }
    }

    @GetMapping("/get-all-invoice-fy")
    public String getAllInvoiceListByFY(@RequestParam("fy") String fy, Model model, HttpServletRequest request) throws IOException {
        logger.info("Retrieving all invoices for financial year: {}", fy);
        List<InvoiceDetails> invoices = invoiceDetailsRepository.getByInvoiceIdContainingIgnoreCaseAndOwnerIdOrderByDateDesc(fy, Utility.getOwnerIdFromSession(request));
        model.addAttribute("invoices", invoices);
        model.addAttribute("fy", fy);
        logger.info("Invoices retrieved successfully for financial year: {}", fy);
        return "invoicesearch";
    }

    @GetMapping("/get-all-products")
    public String getAllProductList(Model model, HttpServletRequest request) throws IOException, ParseException {
        logger.info("Retrieving all products");
        List<Product> products = productRepository.findByOwnerId(Utility.getOwnerIdFromSession(request));
        products.sort(Comparator.comparing(Product::getProductName));
        for (Product p : products) {
            p.setCustId(getDateDiff(p.getExpdate()));
        }
        model.addAttribute("products", products);
        model.addAttribute("product", new Product());
        logger.info("Products retrieved successfully");
        return "products";
    }

    @PostMapping("/update-product")
    public String updateProductPage(@ModelAttribute("PRODUCTS") Product product, Model model,
                                    HttpServletRequest request, HttpServletResponse response) throws Exception {
        logger.info("Updating product with ID: {}", product.getProductId());
        if (product.getProductId() != 0) {
            Product product1 = productRepository.findById(product.getProductId()).get();
            product1.setProductName(product.getProductName().toUpperCase());
            product1.setStatus(true);
            product1.setPrice(product.getPrice());
            product1.setBatchNo(product.getBatchNo().toUpperCase());
            if (product.getBatchNo().equals(null) || product.getBatchNo().equals("")) {
                product1.setBatchNo("N/A");
            }
            if (product.getProductName().contains("-")) {
                String[] strs = product.getProductName().split("-");
                product.setProductName(strs[0] + " - " + product.getQuantity());
            }

            productRepository.save(product1);
            logger.info("Product updated successfully with ID: {}", product.getProductId());
        }
        List<Product> products = productRepository.findByStatus(true);
        model.addAttribute("products", products);
        model.addAttribute("product", new Product());
        return "products";
    }

    @GetMapping("/get-all-customers")
    public String getAllCustomersList(
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "search", required = false) String search,
            Model model,
            HttpServletRequest request) {
        logger.info("Retrieving all customers for page: {}, search: {}", page, search);
        String ownerId = Utility.getOwnerIdFromSession(request);
        if (ownerId == null) {
            logger.warn("Owner ID not found in session");
            model.addAttribute("error", "Owner ID not found in session.");
            return "error";
        }

        Pageable pageable = PageRequest.of(page, 10, Sort.by("custName").ascending());
        Page<CustProfile> custPage;

        if (search != null && !search.trim().isEmpty()) {
            custPage = custProfileRepository.findByOwnerIdAndCustNameContainingIgnoreCase(ownerId, search.trim(), pageable);
        } else {
            custPage = custProfileRepository.findByOwnerId(ownerId, pageable);
        }

        if (custPage == null) {
            custPage = Page.empty();
        }

        model.addAttribute("custmers", custPage.getContent());
        model.addAttribute("page", page);
        model.addAttribute("totalcustomers", custPage.getTotalElements());
        model.addAttribute("totalPages", custPage.getTotalPages());
        model.addAttribute("search", search);

        ownerInfoRepository.findById(ownerId)
                .ifPresent(ownerInfo -> model.addAttribute("ownerInfo", ownerInfo));

        model.addAttribute("date", getCurretDate());

        logger.info("Customers retrieved successfully for page: {}", page);
        return "customers";
    }

    @GetMapping("/search-cust")
    public @ResponseBody List<Map<String, Object>> searchCustomersAjax(
            @RequestParam("search") String search,
            HttpServletRequest request) {
        logger.info("Searching customers with query: {}", search);
        String ownerId = Utility.getOwnerIdFromSession(request);
        Pageable pageable = PageRequest.of(0, 20, Sort.by("custName").ascending());

        List<CustProfile> customers = custProfileRepository
                .findByOwnerIdAndCustNameContainingIgnoreCase(ownerId, search.trim(), pageable)
                .getContent();

        logger.info("Found {} customers for search query: {}", customers.size(), search);
        return customers.stream().map(c -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", c.getId());
            map.put("custName", c.getCustName());
            map.put("address", c.getAddress());
            map.put("phoneNo", c.getPhoneNo());
            map.put("totalAmount", c.getTotalAmount());
            map.put("paidAmout", c.getPaidAmout());
            map.put("currentOusting", c.getCurrentOusting());
            return map;
        }).collect(Collectors.toList());
    }

    private Sort sortByIdDesc() {
        logger.info("Sorting by customer name in ascending order");
        return new Sort(Sort.Direction.ASC, "custName");
    }

    @PostMapping("/upload-invoice-pdf")
    public ModelAndView uploadDocuments(@ModelAttribute("DOCSUP") DocUplod docUplod)
            throws UnsupportedEncodingException {
        logger.info("Uploading invoice PDF for invoice number: {}", docUplod.getInvoiceNo());
        ModelAndView modelAndView = new ModelAndView();
        String fileName = docUplod.getFile().getOriginalFilename();
        logger.info("File name: {}", fileName);
        InvoiceDetails details = invoiceDetailsRepository.getOne(docUplod.getInvoiceNo());
        String directory = "D:\\DWIL\\" + details.getCustId() + "\\";
        File dir = new File(directory);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        String path = directory + fileName;
        logger.info("File path: {}", path);
        try {
            docUplod.getFile().transferTo(new File(directory + fileName));
            logger.info("File uploaded successfully to path: {}", path);
        } catch (Exception e) {
            logger.error("Error uploading file to path: {}", path, e);
        }
        details.setFilePath(Base64.getEncoder().encodeToString(path.getBytes("utf-8")));
        invoiceDetailsRepository.save(details);
        List<InvoiceDetails> invoices = invoiceDetailsRepository.findAll();
        modelAndView.addObject("invoices", invoices);
        modelAndView.setViewName("invoicesearch");
        return modelAndView;
    }

    @GetMapping("/update-customer/{custId}")
    public String getCustomer(@PathVariable String custId, HttpServletResponse response, Model model) {
        logger.info("Updating customer profile for ID: {}", custId);
        model.addAttribute("financialYear", getCurrentFYWithFull());
        CustProfile profile = custProfileRepository.getOne(custId);
        model.addAttribute("profile", profile);
        logger.info("Customer profile updated successfully for ID: {}", custId);
        return "customer-profile";
    }

    @GetMapping("/download-invoice/{path}")
    public void getDownload(@PathVariable String path, HttpServletResponse response) {
        logger.info("Downloading invoice from path: {}", path);
        byte[] decoded = Base64.getDecoder().decode(path);
        String decodedPath = new String(decoded, StandardCharsets.UTF_8);
        try {
            File fileToDownload = new File(decodedPath);
            InputStream inputStream = new FileInputStream(fileToDownload);
            response.setContentType("application/force-download");
            response.setHeader("Content-Disposition", "attachment; filename=" + fileToDownload.getName());
            IOUtils.copy(inputStream, response.getOutputStream());
            response.flushBuffer();
            inputStream.close();
            logger.info("Invoice downloaded successfully from path: {}", decodedPath);
        } catch (Exception e) {
            logger.error("Error downloading invoice from path: {}",e);
        }

    }


    @GetMapping("/get-invoice/{custId}/{invoiceNo}")
    public String getInvoicePage(Model model, @PathVariable String custId, @PathVariable String invoiceNo,
                                 HttpServletRequest request, HttpServletResponse response) throws IOException, WriterException {
        logger.info("Retrieving invoice page for customer ID: {} and invoice number: {}", custId, invoiceNo);
        InvoiceDetails itemDetails = invoiceDetailsRepository.findByCustIdAndInvoiceId(custId, invoiceNo);
        CustProfile profile = custProfileRepository.getOne(itemDetails.getCustId());
        model.addAttribute("profile", profile);
        model.addAttribute("date", itemDetails.getCreatedAt());
        model.addAttribute("biller", itemDetails.getCreatedBy());
        model.addAttribute("invoiceNo", itemDetails.getInvoiceId());
        List<ItemDetails> items = itemRepository.findByInvoiceNoAndCustIdAndStatus(itemDetails.getInvoiceId(), itemDetails.getCustId(), true);
        model.addAttribute("totalQty", itemDetails.getTotQty());
        model.addAttribute("totalAmout", itemDetails.getTotInvoiceAmt());
        model.addAttribute("items", items);
        model.addAttribute("invoiceTime", itemDetails.getDate());
        OwnerInfo ownerInfo = ownerInfoRepository.getOne(Utility.getOwnerIdFromSession(request));
        model.addAttribute("ownerInfo", ownerInfo);
        model.addAttribute("advamount", itemDetails.getAdvanAmt());
        model.addAttribute("currentinvoiceitems", itemDetails);
        model.addAttribute("QRCODE", UPIQrUtil.generateUpiQrBase64(ownerInfo.getUpiId(), profile.getCurrentOusting()));

        logger.info("Invoice page retrieved successfully for customer ID: {} and invoice number: {}", custId, invoiceNo);
        return ownerInfo.getInvoiceType().equals("A4") ? "invoiceindetails" : "invoice";
    }

    @GetMapping("/get-invoice-details/{custId}/{invoiceNo}")
    public String getInvoicePageDetails(Model model, @PathVariable String custId, @PathVariable String invoiceNo,
                                        HttpServletRequest request, HttpServletResponse response) throws IOException, WriterException {
        logger.info("Retrieving detailed invoice page for customer ID: {} and invoice number: {}", custId, invoiceNo);
        InvoiceDetails itemDetails = invoiceDetailsRepository.findByCustIdAndInvoiceId(custId, invoiceNo);
        CustProfile profile = custProfileRepository.getOne(itemDetails.getCustId());
        model.addAttribute("profile", profile);
        model.addAttribute("date", itemDetails.getCreatedAt());
        model.addAttribute("biller", itemDetails.getCreatedBy());
        model.addAttribute("invoiceNo", itemDetails.getInvoiceId());
        List<ItemDetails> items = itemRepository.findByInvoiceNoAndCustIdAndStatus(itemDetails.getInvoiceId(), itemDetails.getCustId(), true);
        model.addAttribute("totalQty", itemDetails.getTotQty());
        model.addAttribute("totalAmout", itemDetails.getTotInvoiceAmt());
        model.addAttribute("items", items);
        model.addAttribute("invoiceTime", itemDetails.getDate());
        OwnerInfo ownerInfo = ownerInfoRepository.getOne(Utility.getOwnerIdFromSession(request));
        model.addAttribute("ownerInfo", ownerInfo);
        model.addAttribute("advamount", itemDetails.getAdvanAmt());
        model.addAttribute("currentinvoiceitems", itemDetails);
        model.addAttribute("QRCODE", UPIQrUtil.generateUpiQrBase64(ownerInfo.getUpiId(), profile.getCurrentOusting()));

        logger.info("Detailed invoice page retrieved successfully for customer ID: {} and invoice number: {}", custId, invoiceNo);
        return ownerInfo.getInvoiceType().equals("A4") ? "invoiceindetails" : "invoice";
    }

    @GetMapping("/get-bal-credit-page/{custId}")
    public String getBalCreditPage(@PathVariable String custId, HttpServletRequest request, HttpServletResponse response, Model model) {
        logger.info("Retrieving balance credit page for customer ID: {}", custId);
        CustProfile profile = custProfileRepository.getOne(custId);
        model.addAttribute("profile", profile);
        List<BalanceDeposite> balanceDeposits = balanceDepositeRepository.findByCustId(profile.getId());
        model.addAttribute("balanceDeposits", balanceDeposits);
        logger.info("Balance credit page retrieved successfully for customer ID: {}", custId);
        return "deposit";
    }

    @GetMapping("/get-my-profile")
    public String getMyProfilePage(HttpServletRequest request, HttpServletResponse response, Model model) {
        logger.info("Retrieving my profile page");
        OwnerInfo info = ownerInfoRepository.getOne(Objects.requireNonNull(Utility.getOwnerIdFromSession(request)));
        model.addAttribute("ownerInfo", info);
        logger.info("My profile page retrieved successfully");
        return "my-profile";
    }

    @PostMapping("/update-owner-details")
    public String updateOwnerProfile(@ModelAttribute("OwnerInfo") OwnerInfo ownerInfo, HttpServletRequest request, HttpServletResponse response, Model model) {
        logger.info("Updating owner profile for owner ID: {}", ownerInfo.getOwnerId());
        OwnerInfo info = ownerInfoRepository.getOne(Utility.getOwnerIdFromSession(request));
        ownerInfo.setExpDate(info.getExpDate());
        ownerInfo.setUserName(info.getUserName());
        ownerInfoRepository.save(ownerInfo);
        model.addAttribute("ownerInfo", ownerInfo);
        model.addAttribute("msg", "Profile Updated Successfully!!");
        logger.info("Owner profile updated successfully for owner ID: {}", ownerInfo.getOwnerId());
        return "my-profile";
    }

    @GetMapping("/get-shop-profile/{ownerId}")
    public String getShopDetailsByOwnerId(Model model, @PathVariable String ownerId, HttpServletRequest request) {
        logger.info("Retrieving shop details for owner ID: {}", ownerId);
        Boolean isSuperAdmin = Utility.getSuperAdminFromSession(request);
        if (isSuperAdmin) {
            List<OwnerInfo> ownerDetails = ownerInfoRepository.findAll();
            model.addAttribute("ownerDetails", ownerDetails);
            OwnerInfo matchedOwner = ownerDetails.stream().filter(o -> o.getOwnerId().equals(ownerId)).findFirst().orElse(null);
            model.addAttribute("ownerInfo", matchedOwner);
            logger.info("Shop details retrieved successfully for owner ID: {}", ownerId);
        }
        return "admin-dashoard";
    }

    @GetMapping("/reports")
    public String getReportPage(HttpServletRequest request, HttpServletResponse response, Model model, @ModelAttribute("DATERANGE") DateRange dateRange) {
        logger.info("Retrieving report page");
        List<InvoiceDetails> record = invoiceDetailsRepository.findByOwnerIdAndDate(Utility.getOwnerIdFromSession(request), LocalDate.now());
        List<BalanceDeposite> balanceDeposits = balanceDepositeRepository.findByOwnerIdAndDate(Utility.getOwnerIdFromSession(request), LocalDate.now());
        InvoiceDetails details = new InvoiceDetails();
        details.setBalanceAmt((double) (int) record.stream().map(InvoiceDetails::getBalanceAmt).mapToDouble(Double::doubleValue).sum());
        details.setTotInvoiceAmt((double) (int) record.stream().map(InvoiceDetails::getTotInvoiceAmt).mapToDouble(Double::doubleValue).sum());
        details.setAdvanAmt((double) (int) record.stream().map(InvoiceDetails::getAdvanAmt).mapToDouble(Double::doubleValue).sum());
        details.setBalanceAmt(details.getBalanceAmt() - balanceDeposits.stream().map(BalanceDeposite::getAdvAmt).mapToDouble(Double::doubleValue).sum());

        model.addAttribute("invoicetotal", details);
        model.addAttribute("Invoices", record);
        model.addAttribute("transactions", balanceDeposits);
        model.addAttribute("startDate", getCurretDateByOther());
        model.addAttribute("endDate", getCurretDateByOther());

        logger.info("Report page retrieved successfully");
        return "reports";
    }

    @PostMapping("/reportbydate")
    public String getReportBy(HttpServletRequest request, HttpServletResponse response, Model model, @ModelAttribute("DATERANGE") DateRange dateRange) {
        logger.info("Retrieving report by date range: {} to {}", dateRange.getStartDate(), dateRange.getEndDate());
        model.addAttribute("startDate", dateRange.getStartDate());
        model.addAttribute("endDate", dateRange.getEndDate());
        List<InvoiceDetails> record = null;
        List<BalanceDeposite> balanceDeposits = null;
        String ownerId = Utility.getOwnerIdFromSession(request);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate startDate = LocalDate.parse(dateRange.getStartDate(), formatter);
        LocalDate endDate = LocalDate.parse(dateRange.getEndDate(), formatter);
        if (dateRange.getStartDate().equals(dateRange.getEndDate())) {
            record = invoiceDetailsRepository.findByOwnerIdAndDate(ownerId, startDate);
            balanceDeposits = balanceDepositeRepository.findByOwnerIdAndDate(ownerId, startDate);
        } else {
            record = invoiceDetailsRepository.findByDateBetweenAndOwnerId(startDate, endDate, ownerId);
            balanceDeposits = balanceDepositeRepository.findByDateBetweenAndOwnerId(startDate, endDate, ownerId);
        }
        InvoiceDetails details = new InvoiceDetails();
        details.setBalanceAmt((double) (int) record.stream().map(InvoiceDetails::getBalanceAmt).mapToDouble(Double::doubleValue).sum());
        details.setTotInvoiceAmt((double) (int) record.stream().map(InvoiceDetails::getTotInvoiceAmt).mapToDouble(Double::doubleValue).sum());
        details.setAdvanAmt((double) (int) record.stream().map(InvoiceDetails::getAdvanAmt).mapToDouble(Double::doubleValue).sum());
        details.setBalanceAmt(details.getBalanceAmt() - balanceDeposits.stream().map(BalanceDeposite::getAdvAmt).mapToDouble(Double::doubleValue).sum());

        model.addAttribute("invoicetotal", details);
        model.addAttribute("Invoices", record);
        model.addAttribute("transactions", balanceDeposits);
        logger.info("Report by date range retrieved successfully");
        return "reports";
    }

    @PostMapping("/balance-credit")
    public String creditBalance(@ModelAttribute("BalanceDeposite") BalanceDeposite balanceDeposite,
                                Model model,
                                HttpServletRequest request) {
        logger.info("Crediting balance for customer ID: {}", balanceDeposite.getCustId());
        CustProfile profile = custProfileRepository.findById(balanceDeposite.getCustId())
                .orElseThrow(() -> new IllegalArgumentException("Customer not found"));

        balanceDeposite.setCustName(profile.getCustName());
        balanceDeposite.setAdvAmt(Math.floor(balanceDeposite.getAdvAmt()));
        balanceDeposite.setTotalAmount(Math.floor(profile.getTotalAmount()));
        balanceDeposite.setPaidAmout(Math.floor(profile.getPaidAmout()));
        balanceDeposite.setCurrentOusting(Math.floor(profile.getCurrentOusting()));
        balanceDeposite.setCreatedBy(SecurityContextHolder.getContext().getAuthentication().getName());

        String ownerId = Utility.getOwnerIdFromSession(request);
        balanceDeposite.setOwnerId(ownerId);

        String txId = "TX" + invoiceNoRepository.findByOwnerId(ownerId).getBillNo() + new SimpleDateFormat("yyMMddhhmmssSSS").format(new Date());
        balanceDeposite.setId(txId);

        balanceDeposite.setCreatedAt(new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()));
        balanceDeposite.setDescription(balanceDeposite.getDescription().toUpperCase());

        balanceDepositeRepository.save(balanceDeposite);
        CustProfile updatedProfile = getUpdateBalance(profile, 0.0, balanceDeposite.getAdvAmt());
        custProfileRepository.save(updatedProfile);

        populateInvoiceModel(model, updatedProfile, request, balanceDeposite.getCustId());

        OwnerInfo ownerInfo = ownerInfoRepository.findById(ownerId)
                .orElseThrow(() -> new RuntimeException("Owner not found"));
        sendMailCustomer(balanceDeposite, updatedProfile, ownerInfo);
        model.addAttribute("balanceDeposite", balanceDeposite);
        model.addAttribute("AMOUNT_WORD", AmountInWordUtility.convertToWords(balanceDeposite.getAdvAmt()));
        model.addAttribute("ownerInfo", ownerInfoRepository.findById(ownerId).orElse(null));
        logger.info("Balance credited successfully for customer ID: {}", balanceDeposite.getCustId());
        return "payment-recipt";
    }



    @GetMapping("/get-bal-credit-receipt/{slipNo}")
    public String getBalanceCreditedReceipt(Model model, @PathVariable String slipNo, HttpServletRequest request) {
        String ownerId = Utility.getOwnerIdFromSession(request);  OwnerInfo ownerInfo = ownerInfoRepository.findById(ownerId)
                .orElseThrow(() -> new RuntimeException("Owner not found"));
      BalanceDeposite balanceDeposite =  balanceDepositeRepository.findById(slipNo).orElseThrow(() -> new RuntimeException("Receipt not found"));;
        Optional<CustProfile> profileOpt = custProfileRepository.findById(balanceDeposite.getCustId());
        profileOpt.get().setCurrentOusting(balanceDeposite.getCurrentOusting()-balanceDeposite.getAdvAmt());
        if (profileOpt.isPresent()) {
            model.addAttribute("profile", profileOpt.get());  // ✅ send actual object
        } else {
            model.addAttribute("profile", new CustProfile()); // fallback to avoid NPE
        }

        model.addAttribute("balanceDeposite", balanceDeposite);
        model.addAttribute("AMOUNT_WORD", AmountInWordUtility.convertToWords(balanceDeposite.getAdvAmt()));
        model.addAttribute("ownerInfo", ownerInfoRepository.findById(ownerId).orElse(null));
        logger.info("Balance credited successfully for customer ID: {}", balanceDeposite.getCustId());
        return "payment-recipt";
    }


    private void populateInvoiceModel(Model model, CustProfile profile, HttpServletRequest request, String custId) {
        logger.info("Populating invoice model for customer ID: {}", custId);
        model.addAttribute("profile", profile);
        model.addAttribute("date", getCurretDate());

        String invoiceNo = getCurrentInvoiceNumber(Utility.getOwnerIdFromSession(request));
        model.addAttribute("invoiceNo", invoiceNo);

        List<ItemDetails> items = itemRepository.findByInvoiceNoAndCustId(invoiceNo, custId);
        double totalAmount = 0, totalQty = 0;

        for (ItemDetails item : items) {
            totalAmount += item.getAmount();
            totalQty += item.getQty();
        }

        model.addAttribute("totalQty", totalQty);
        model.addAttribute("totalAmout", totalAmount);
        model.addAttribute("items", items);
        model.addAttribute("itemsNo", items.size() + 1);
        model.addAttribute("appInfo", appInfo);
        model.addAttribute("balanceDeposits", balanceDepositeRepository.findByCustId(custId));
        model.addAttribute("oldinvoices", invoiceDetailsRepository.findByCustId(custId));
        model.addAttribute("dropdown", productRepository.findByOwnerId(Utility.getOwnerIdFromSession(request)));
        logger.info("Invoice model populated successfully for customer ID: {}", custId);
    }



    public static void sendMailCustomer(BalanceDeposite balanceDeposite, CustProfile profile ,OwnerInfo ownerInfo) {
        String mailSignture = ownerInfo.getShopName()+"<br>"+ownerInfo.getAddress()+"<br>"+ownerInfo.getOwnerName()+"<br>"+ownerInfo.getMobNumber();
       String mailFormate =   MailUtil.getBalanceCreditedMailFormat(balanceDeposite, profile ,mailSignture);


        String ownerSubject = "Deposit : "+balanceDeposite.getCustName();
        String custSubject = "Deposit : "+balanceDeposite.getId()+" - "+ownerInfo.getShopName();

        ExecutorService emailExecutor = Executors.newSingleThreadExecutor();
        emailExecutor.execute(new Runnable() {
            @Override
            public void run() {
                MailUtil.sendMail(profile.getEmail(),mailFormate ,custSubject);
                MailUtil.sendMail(ownerInfo.getEmail(),mailFormate ,ownerSubject);
            }
        });
        emailExecutor.shutdown();
    }

    public static String dateConversion(String inputDate) {

        String outputDate = null;
        try {

            SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy-MM-dd");
            Date tempDate = simpledateformat.parse(inputDate);
            SimpleDateFormat outputDateFormat = new SimpleDateFormat("dd/MM/yyyy"); //2024-07-21
            outputDate = outputDateFormat.format(tempDate);
        } catch (ParseException ex) {
            System.out.println("Parse Exception");
        }
        return outputDate;

    }

    public static Date getDate(String dateInString) {
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
        Date date = null;
        try {
            date = formatter.parse(dateInString);

        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;

    }


    @GetMapping("/cust-history")
    public void getCustHistoryPDF(HttpServletRequest request ,HttpServletResponse response) throws Exception {
        String ownerId = Utility.getOwnerIdFromSession(request);
        String custId = request.getParameter("custid");
        CustProfile profile = custProfileRepository.findById(custId)
                .orElseThrow(() -> new IllegalArgumentException("Customer not found"));
        OwnerInfo ownerInfo = ownerInfoRepository.findById(ownerId).orElse(null);
        List<InvoiceDetails> details  = invoiceDetailsRepository.findByCustId(custId);
        List<BalanceDeposite> balanceDeposits = balanceDepositeRepository.findByCustId(custId);


        response.setContentType("application/pdf");
        DateFormat dateFormat = new SimpleDateFormat("YYYY-MMM-DD");
        String currentDateTime = dateFormat.format(new Date());
        String headerkey = "Content-Disposition";
        String headervalue = "attachment; filename="+profile.getCustName().replaceAll(" ","_")+"_" + currentDateTime + ".pdf";
        response.setHeader(headerkey, headervalue);

        PdfGenerator generator = new PdfGenerator();
        generator.generateInvoiceHistory(profile, response , ownerInfo ,details , balanceDeposits);


        }








    @GetMapping("/export-to-pdf")
    public void generatePdfFile(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String ownerId = Utility.getOwnerIdFromSession(request);
        OwnerInfo ownerInfo = ownerInfoRepository.findById(ownerId).orElse(null);

        response.setContentType("application/pdf");

        DateFormat dateFormat = new SimpleDateFormat("yyyy-MMM-dd");
        String currentDateTime = dateFormat.format(new Date());


        List<CustProfile> custProfiles = custProfileRepository.findByOwnerId(ownerId);

        PdfGenerator generator = new PdfGenerator();
        // Ensure this method does not set another Content-Disposition header
        generator.generate(custProfiles, response, ownerInfo);
    }



    @GetMapping("/export-statement-file")
    public void generateStatementPdfFile(HttpServletRequest request ,HttpServletResponse response) throws Exception
    {
        String ownerId = Utility.getOwnerIdFromSession(request);
        OwnerInfo ownerInfo = ownerInfoRepository.findById(ownerId).orElse(null);
        response.setContentType("application/pdf");
        DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        String currentDateTime = dateFormat.format(new Date());
        String headerkey = "Content-Disposition";
        String headervalue = "attachment; filename="+ownerInfo.getShopName().replaceAll(" ","_")+"_" + currentDateTime + ".pdf";
        response.setHeader(headerkey, headervalue);
        List<InvoiceDetails> invoiceDetails = invoiceDetailsRepository.findByOwnerIdAndDate(ownerId ,Utility.getDate(currentDateTime));
        List<BalanceDeposite> balanceDeposites = balanceDepositeRepository.findByOwnerIdAndDate(ownerId,Utility.getDate(currentDateTime));
        PdfGenerator generator = new PdfGenerator();
        generator.generateStatement(invoiceDetails, balanceDeposites, response ,ownerInfo,currentDateTime);
    }


    @GetMapping("/export-statement-file-date")
    public void generateStatementPdfFileByDate(HttpServletRequest request ,HttpServletResponse response, @ModelAttribute("DATERANGE") DateRange dateRange) throws Exception
    {
        String ownerId = Utility.getOwnerIdFromSession(request);
        OwnerInfo ownerInfo = ownerInfoRepository.findById(ownerId).orElse(null);
        response.setContentType("application/pdf");
        DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        String currentDateTime = dateFormat.format(new Date());
        String headerkey = "Content-Disposition";
        String headervalue = "attachment; filename=Customers_" + currentDateTime + ".pdf";
        response.setHeader(headerkey, headervalue);
        String date = dateRange.getStartDate() + "--" + dateRange.getEndDate();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate startDate = LocalDate.parse(dateRange.getStartDate(), formatter);
        LocalDate endDate = LocalDate.parse(dateRange.getEndDate() , formatter);
        List<InvoiceDetails> record = null;
        List<BalanceDeposite> balanceDeposits = null;
        if (dateRange.getStartDate().equals(dateRange.getEndDate())) {
            record = invoiceDetailsRepository.findByOwnerIdAndDate(ownerId ,startDate);
            balanceDeposits = balanceDepositeRepository.findByOwnerIdAndDate(ownerId,startDate);
        } else {
            record = invoiceDetailsRepository.findByDateBetweenAndOwnerId(startDate , endDate,ownerId);
            balanceDeposits = balanceDepositeRepository.findByDateBetweenAndOwnerId(startDate, endDate,ownerId);
        }

        PdfGenerator generator = new PdfGenerator();
        generator.generateStatement(record, balanceDeposits, response ,ownerInfo, date);
    }

    public static  String getDateDiff(String expDate ) throws ParseException {
     String str =null;
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date expD = dateFormat.parse(expDate);
        Date currD = Calendar.getInstance().getTime();

        long diffInDays =  TimeUnit.MILLISECONDS.toDays(expD.getTime() - currD.getTime());

        if(diffInDays<0){
            str = "expired";
        }else{
            str = diffInDays+" days";
        }
     return str;

    }




   private double getGstAmt(int gstPer , double sellingPrice){
   int gstDiveder = 100+gstPer;
   double gstDiv = sellingPrice/gstDiveder;
   double gstAmt = gstDiv*100;
   return (double) (int) gstAmt;

   }



    @GetMapping("/admin")
    public String adminPage(HttpServletRequest request, HttpServletResponse response, Model model) throws ParseException {
       Boolean isSuperAdmin = Utility.getSuperAdminFromSession(request);
        if(isSuperAdmin){
         List<OwnerInfo>  ownerDetails= ownerInfoRepository.findAll();
            model.addAttribute("ownerDetails", ownerDetails);
        }

        return "admin-dashoard";

    }


    @PostMapping("/approved-owner-info")
    public String shopApprovedRegistration(@ModelAttribute("OWNER_INFO") OwnerInfo ownerInfo, Model model,
                                           HttpServletRequest request, HttpServletResponse response) throws Exception {
        Boolean isSuperAdmin = Utility.getSuperAdminFromSession(request);
        if(isSuperAdmin) {
            ownerInfo.setExpDate(getExpDateFromNow(ownerInfo.getPlanDuration()));
            ownerInfo.setStatus(ownerInfo.getStatus());
            ownerInfoRepository.save(ownerInfo);
            User user = userService.findByUsernameWithoutStatus(ownerInfo.getUserName());
            user.setExpDate(ownerInfo.getExpDate());
            user.setOwnerId(ownerInfo.getOwnerId());
            user.setStatus(ownerInfo.getStatus());
            String genratedPassword= PasswordUtil.generateSecurePassword();
            user.setPassword(genratedPassword);
            userService.activateUser(user);
            ExecutorService emailExecutor = Executors.newSingleThreadExecutor();
            emailExecutor.execute(new Runnable() {
                @Override
                public void run() {
                    try {
                        MailUtil.sendMail(ownerInfo.getEmail(),getRegistrationApprovedReceiptMailFormate(ownerInfo , genratedPassword)," Approved : MY BILL BOOK : "+ownerInfo.getShopName());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
            emailExecutor.shutdown();
            List<OwnerInfo>  ownerDetails= ownerInfoRepository.findAll();
            model.addAttribute("ownerDetails", ownerDetails);
        }
        return "admin-dashoard";


    }

    private String getRegistrationApprovedReceiptMailFormate(OwnerInfo ownerInfo ,String password) {
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
                "        Password: ["+password+"]\n" +
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


    public Date getExpDateFromNow(int month) {
        Date date = new Date(); // current date
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.MONTH, month); // add 3 months
        Date newDate = calendar.getTime(); // new date after adding months
        System.out.println(newDate);
        return  newDate;
    }



    @GetMapping("/download-customer")
    public void downloadCSV(HttpServletResponse response,HttpServletRequest request) throws IOException {
        List<CustProfile> customers = custProfileRepository.findByOwnerId(Utility.getOwnerIdFromSession(request));

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=customers.csv");

        PrintWriter writer = response.getWriter();
        // CSV header
        writer.println("id,custName,address,email,phoneNo,addharNo,status,totalAmount,currentOusting,paidAmout,ownerId");

        for (CustProfile c : customers) {
            writer.printf("%s,%s,%s,%s,%s,%s,%s,%.2f,%.2f,%.2f,%s%n",
                    c.getId(), c.getCustName(), c.getAddress(), c.getEmail(),
                    c.getPhoneNo(), c.getAddharNo(), c.getStatus(),
                    c.getTotalAmount(), c.getCurrentOusting(),
                    c.getPaidAmout(), c.getOwnerId());
        }

        writer.flush();
        writer.close();
    }


    @GetMapping("/download-template")
    public void downloadTemplate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String ownerId = Utility.getOwnerIdFromSession(request);
        OwnerInfo ownerInfo = ownerInfoRepository.findById(ownerId).orElse(null);

        String filename = "product_template.xlsx";
        if (ownerInfo != null && ownerInfo.getShopName() != null) {
            filename = ownerInfo.getShopName().replaceAll(" ", "_").toLowerCase() + "_product_template.xlsx";
        }

        filename = filename.replaceAll("[^a-zA-Z0-9._-]", "_");
        response.reset();

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Products");

            String[] headers = {
                    "productName", "company", "quantity", "batchNo", "expdate",
                    "mrp", "price", "delarPrice", "stock", "taxPercentage"
            };

            Row header = sheet.createRow(0);
            CellStyle headerStyle = workbook.createCellStyle();
            Font font = workbook.createFont();
            font.setBold(true);
            headerStyle.setFont(font);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            for (int i = 0; i < headers.length; i++) {
                Cell cell = header.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
                sheet.autoSizeColumn(i);
            }

            // Add sample record
            Row sampleRow = sheet.createRow(1);
            sampleRow.createCell(0).setCellValue("Product");
            sampleRow.createCell(1).setCellValue("Sygenta");
            sampleRow.createCell(2).setCellValue("100 ml");
            sampleRow.createCell(3).setCellValue("NB989df4545");
            sampleRow.createCell(4).setCellValue("2025-05-30");
            sampleRow.createCell(5).setCellValue(300);
            sampleRow.createCell(6).setCellValue(280);
            sampleRow.createCell(7).setCellValue(200);
            sampleRow.createCell(8).setCellValue(50);
            sampleRow.createCell(9).setCellValue(18);

            workbook.write(response.getOutputStream());
        }
    }




    @PostMapping("/upload")
    public String uploadExcel(@RequestParam("file") MultipartFile file, Model model, HttpServletRequest request) {
        logger.info("Starting Excel file upload process");
        try (InputStream is = file.getInputStream()) {
            Workbook workbook = new XSSFWorkbook(is);
            Sheet sheet = workbook.getSheetAt(0);
            String ownerId = Utility.getOwnerIdFromSession(request);
            logger.info("Processing Excel upload for owner ID: {}", ownerId);

            List<Product> products = new ArrayList<>();
            int totalRows = sheet.getLastRowNum();
            logger.info("Found {} rows in Excel file (excluding header)", totalRows);

            for (int i = 1; i <= totalRows; i++) { // skip header row
                Row row = sheet.getRow(i);
                Product product = new Product();
                product.setPname(getCellString(row, 0));
                product.setCompany(getCellString(row, 1));
                product.setQuantity(getCellString(row, 2));
                product.setBatchNo(getCellString(row, 3));
                product.setExpdate(getCellString(row, 4));
                product.setMrp(getCellDouble(row, 5));
                product.setPrice(getCellDouble(row, 6));
                product.setDelarPrice(getCellDouble(row, 7));
                product.setStock((long) Math.round(getCellDouble(row, 8)));
                product.setTaxPercentage((int) Math.round(getCellDouble(row, 9)));
                product.setStatus(true);
                product.setProductName(Utility.getProductName(product));
                product.setOwnerId(ownerId);

                if (!productRepository.existsByProductNameAndOwnerId(product.getProductName(), product.getOwnerId())) {
                    products.add(product);
                    logger.debug("Added product to import list: {}", product.getProductName());
                } else {
                    logger.debug("Skipping duplicate product: {}", product.getProductName());
                }
            }

            logger.info("Saving {} new products to database", products.size());
            productRepository.saveAll(products);
            workbook.close();

            logger.info("Excel upload completed successfully");
            model.addAttribute("message", "Successfully uploaded!");
        } catch (Exception e) {
            logger.error("Error uploading Excel file", e);
            model.addAttribute("message", "Error: " + e.getMessage());
        }
        return "products"; // return JSP page
    }

    // Utility methods
    private String getCellString(Row row, int cellNo) {
        Cell cell = row.getCell(cellNo);
        return (cell != null) ? cell.toString().trim() : "";
    }


    private Double getCellDouble(Row row, int cellNo) {
        try {
            return Double.valueOf(getCellString(row, cellNo));
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }

    private Boolean getCellBoolean(Row row, int cellNo) {
        String value = getCellString(row, cellNo).toLowerCase();
        return value.equals("true") || value.equals("1") || value.equals("yes");
    }


    @GetMapping("/search")
    public @ResponseBody List<Map<String, Object>> searchCustomers(@RequestParam("query") String query, HttpServletRequest request) {
        logger.info("Searching customers with query: {}", query);
        Pageable pageable = PageRequest.of(0, 100, Sort.by("custName").ascending());
        String ownerId = Utility.getOwnerIdFromSession(request);
        Page<CustProfile> customers = null;
        if (query != null && !query.trim().isEmpty()) {
            customers = custProfileRepository.findByOwnerIdAndCustNameContainingIgnoreCase(ownerId, query.trim(), pageable);
        } else {
            customers = custProfileRepository.findByOwnerId(ownerId, pageable);
        }

        logger.info("Found {} customers for search query: {}", customers.getTotalElements(), query);
        return customers.stream().map(c -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", c.getId());
            map.put("custName", c.getCustName());
            map.put("address", c.getAddress());
            map.put("phoneNo", c.getPhoneNo());
            map.put("totalAmount", c.getTotalAmount());
            map.put("paidAmout", c.getPaidAmout());
            map.put("currentOusting", c.getCurrentOusting());
            return map;
        }).collect(Collectors.toList());
    }



    @GetMapping("/search-invoice")
    public @ResponseBody List<Map<String, Object>> searchInvoice(@RequestParam("query") String query, HttpServletRequest request) {
        logger.info("Searching invoices with query: {}", query);
        Pageable pageable = PageRequest.of(0, 100, Sort.by("invoiceId").descending());
        String ownerId = Utility.getOwnerIdFromSession(request);
        Page<InvoiceDetails> invoiceDetailsPage;

        if (query.matches(".*\\d.*")) {
            logger.info("Query contains digits, searching by invoiceId");
            invoiceDetailsPage = invoiceDetailsRepository.findByOwnerIdAndInvoiceIdContainingIgnoreCase(ownerId, query, pageable);
        } else {
            logger.info("Query does not contain digits, searching by custName");
            invoiceDetailsPage = invoiceDetailsRepository.findByOwnerIdAndCustNameContainingIgnoreCase(ownerId, query, pageable);
        }

        logger.info("Found {} invoices for search query: {}", invoiceDetailsPage.getTotalElements(), query);
        return invoiceDetailsPage.stream().map(invoice -> {
            Map<String, Object> map = new HashMap<>();
            map.put("invoiceId", invoice.getInvoiceId());
            map.put("custName", invoice.getCustName());
            map.put("custId", invoice.getCustId());
            map.put("totQty", invoice.getTotQty());
            map.put("totInvoiceAmt", invoice.getTotInvoiceAmt());
            map.put("totAmt", invoice.getTotAmt());
            map.put("balanceAmt", invoice.getBalanceAmt());
            map.put("discount", invoice.getDiscount());
            map.put("preBalanceAmt", invoice.getPreBalanceAmt());
            map.put("advanAmt", invoice.getAdvanAmt());
            map.put("preTaxAmt", invoice.getPreTaxAmt());
            map.put("tax", invoice.getTax());
            map.put("date", invoice.getDate());
            map.put("filePath", invoice.getFilePath());
            map.put("itemDetails", invoice.getItemDetails());
            map.put("oldInvoicesFlag", invoice.getOldInvoicesFlag());
            map.put("createdBy", invoice.getCreatedBy());
            map.put("createdAt", invoice.getCreatedAt());
            return map;
        }).collect(Collectors.toList());
    }

    @GetMapping("/search-product")
    public @ResponseBody  List<ProductDto> searchProducts(
            @RequestParam(name = "query", required = false, defaultValue = "") String query,
            HttpServletRequest request) {

        String ownerId = Utility.getOwnerIdFromSession(request);

        if (query == null || query.trim().isEmpty()) {
            return new ArrayList<>(); // Java 8 doesn’t have List.of()
        }

        List<Product> products = productRepository
                .findByProductNameContainingIgnoreCaseAndOwnerId(query.trim(), ownerId);

        return products.stream()
                .map(p -> new ProductDto(p.getProductId(), p.getProductName(), p.getPrice()))
                .collect(Collectors.toList());  //
    }



}


