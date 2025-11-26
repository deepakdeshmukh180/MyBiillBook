package in.enp.sms.controller;

import com.google.zxing.WriterException;
import in.enp.sms.config.AppInfo;
import in.enp.sms.entities.*;
import in.enp.sms.pojo.*;
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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import static in.enp.sms.utility.MailUtil.sendMailOwner;

@Controller
@RequestMapping("/company")
public class CompanyController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CompanyController.class);
    private static final String ERROR_PAGE = "error-page";
    private static final String PRODUCTS_VIEW = "products";
    private static final String CREATE_INVOICE_VIEW = "createinvoice";
    private static final String CUSTOMERS_VIEW = "customers";
    private static final String INVOICE_SEARCH_VIEW = "invoicesearch";
    private static final String DD_MM_YYYY_FORMAT = "dd/MM/yyyy";
    private static final String YYYY_MM_DD_FORMAT = "yyyy-MM-dd";
    private static final String DATE_TIME_FORMAT = "dd/MM/yyyy HH:mm:ss";
    private static final String PRODUCT_NAME_KEY = "productName";
    private static final String CUSTOMER_NOT_FOUND_MSG = "Customer not found";
    private static final String OUT_OF_STOCK_MSG = "Out of stock, available stock: ";

    // Repositories
    @Autowired
    private CustProfileRepository custProfileRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private InvoiceNoRepository invoiceNoRepository;

    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private InvoiceDetailsRepository invoiceDetailsRepository;

    @Autowired
    private OwnerInfoRepository ownerInfoRepository;

    @Autowired
    private BalanceDepositeRepository balanceDepositeRepository;

    // Services
    @Autowired
    private InvoiceService invoiceService;

    @Autowired
    private UserService userService;

    @Autowired
    private AppInfo appInfo;

    // Date utility methods
    public static String getCurrentDate() {
        LOGGER.info("Getting current date in {} format", DD_MM_YYYY_FORMAT);
        DateFormat dateFormat = new SimpleDateFormat(DD_MM_YYYY_FORMAT);
        Calendar cal = Calendar.getInstance();
        String currentDate = dateFormat.format(cal.getTime());
        LOGGER.debug("Current date: {}", currentDate);
        return currentDate;
    }

    public static String getCurrentDateOtherFormat() {
        LOGGER.info("Getting current date in {} format", YYYY_MM_DD_FORMAT);
        DateFormat dateFormat = new SimpleDateFormat(YYYY_MM_DD_FORMAT);
        Calendar cal = Calendar.getInstance();
        String currentDate = dateFormat.format(cal.getTime());
        LOGGER.debug("Current date (other format): {}", currentDate);
        return currentDate;
    }

    public static String getCurrentDateWithTime() {
        LOGGER.info("Getting current date with time");
        DateFormat dateFormat = new SimpleDateFormat(DATE_TIME_FORMAT);
        Calendar cal = Calendar.getInstance();
        String currentDateTime = dateFormat.format(cal.getTime());
        LOGGER.debug("Current date with time: {}", currentDateTime);
        return currentDateTime;
    }

    public static String getFirstDayOfMonth() {
        LocalDate today = LocalDate.now();
        LocalDate firstDay = today.withDayOfMonth(1);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return firstDay.format(formatter);
    }

    // Product management methods
    @GetMapping("/delete-product-by-id")
    public String deleteProduct(HttpServletRequest request, Model model) {
        LOGGER.info("Starting product deletion process");
        String ownerId = Utility.getOwnerIdFromSession(request);
        String productId = request.getParameter("productId");
        LOGGER.info("Attempting to delete product with ID: {} for owner: {}", productId, ownerId);

        if (productId == null || productId.trim().isEmpty()) {
            LOGGER.warn("Product ID is missing or invalid");
            model.addAttribute("error", "Product ID is missing or invalid.");
            return loadProductsView(model, ownerId);
        }

        try {
            Long productIdLong = Long.parseLong(productId);
            List<Product> products = productRepository.findByProductIdAndOwnerId(productIdLong, ownerId);

            if (!products.isEmpty()) {
                Product productToDelete = products.get(0);
                productRepository.delete(productToDelete);
                LOGGER.info("Successfully deleted product with ID: {}", productId);
                model.addAttribute("msg", "Deleted product with Name: " + productToDelete.getProductName());
            } else {
                LOGGER.warn("No product found with ID: {} for owner: {}", productId, ownerId);
                model.addAttribute("error", "Product not found.");
            }
        } catch (NumberFormatException e) {
            LOGGER.error("Invalid product ID format: {}", productId, e);
            model.addAttribute("error", "Invalid product ID format.");
        }

        return loadProductsView(model, ownerId);
    }

    @GetMapping("/update-product-by-id")
    public String updateProduct(HttpServletRequest request, Model model) {
        LOGGER.info("Starting product update process");
        String productId = request.getParameter("productId");
        LOGGER.info("Updating product with ID: {}", productId);

        if (productId == null || productId.trim().isEmpty()) {
            LOGGER.warn("Product ID is missing");
            model.addAttribute("error", "Product ID is required.");
            return loadProductsView(model, Utility.getOwnerIdFromSession(request));
        }

        try {
            Optional<Product> productOpt = productRepository.findById(Long.parseLong(productId));
            if (productOpt.isPresent()) {
                model.addAttribute("product", productOpt.get());
            } else {
                model.addAttribute("error", "Product not found.");
            }
        } catch (NumberFormatException e) {
            LOGGER.error("Invalid product ID format: {}", productId, e);
            model.addAttribute("error", "Invalid product ID format.");
        }

        String ownerId = Utility.getOwnerIdFromSession(request);
        return loadProductsView(model, ownerId);
    }

    @PostMapping("/add-product")
    public String addProduct(@ModelAttribute("PRODUCTS") Product product,
                             Model model,
                             HttpServletRequest request) {
        LOGGER.info("Starting product addition process");
        String ownerId = Utility.getOwnerIdFromSession(request);
        LOGGER.info("Adding product for owner: {}", ownerId);

        try {
            product.setOwnerId(ownerId);
            product.setProductName(buildProductName(product));
            product.setBatchNo(product.getBatchNo().trim().toUpperCase());
            product.setStatus(true);

            LOGGER.info("Product details - Name: {}, Batch: {}", product.getProductName(), product.getBatchNo());

            String message = (product.getProductId() == 0)
                    ? "New product added with Name: " + product.getProductName()
                    : "Product updated with Name: " + product.getProductName();

            model.addAttribute("msg", message);
            productRepository.save(product);
            LOGGER.info("Successfully saved product: {}", product.getProductName());

            // Load customer profile if provided
            if (product.getCustId() != null) {
                custProfileRepository.findById(String.valueOf(product.getCustId())).ifPresent(profile -> {
                    model.addAttribute("profile", profile);
                    LOGGER.debug("Added customer profile to model for custId: {}", product.getCustId());
                });
            }

            model.addAttribute("appInfo", appInfo);
        } catch (Exception e) {
            LOGGER.error("Error adding/updating product", e);
            model.addAttribute("error", "Error processing product: " + e.getMessage());
        }

        return loadProductsView(model, ownerId);
    }

    private String buildProductName(Product product) {
        StringBuilder productNameBuilder = new StringBuilder(product.getPname().trim().toUpperCase());
        if (product.getCompany() != null && !product.getCompany().trim().isEmpty()) {
            productNameBuilder.append("[").append(product.getCompany().trim().toUpperCase()).append("]");
        }
        productNameBuilder.append("-").append(product.getQuantity().trim().toUpperCase());
        return productNameBuilder.toString();
    }

    private String loadProductsView(Model model, String ownerId) {
        List<Product> products = productRepository.findByOwnerId(ownerId);
        products.sort(Comparator.comparing(Product::getProductName));

        // Set expiration date difference
        products.forEach(product -> {
            try {
                product.setCustId(getDateDifference(product.getExpdate()));
            } catch (ParseException e) {
                LOGGER.warn("Error parsing expiry date for product: {}", product.getProductName(), e);
                product.setCustId("unknown");
            }
        });

        LOGGER.info("Retrieved {} products for display", products.size());
        model.addAttribute("products", products);
        model.addAttribute("product", new Product());
        return PRODUCTS_VIEW;
    }

    // Invoice management methods
    @PostMapping("/invoice")
    public String getInvoicePage(@ModelAttribute("INVOICE_DETAILS") InvoiceDetails itemDetails,
                                 Model model,
                                 HttpServletRequest request,
                                 HttpSession session) {
        LOGGER.info("Processing invoice generation");
        LOGGER.info("Invoice ID: {}, Customer ID: {}", itemDetails.getInvoiceId(), itemDetails.getCustId());

        try {
            List<ItemDetails> items = itemRepository.findByInvoiceNoAndCustId(
                    itemDetails.getInvoiceId(), itemDetails.getCustId());
            LOGGER.info("Found {} items for invoice", items.size());



            CustProfile profile = custProfileRepository.findById(itemDetails.getCustId())
                    .orElseThrow(() -> {
                        LOGGER.error("Customer not found with ID: {}", itemDetails.getCustId());
                        return new RuntimeException(CUSTOMER_NOT_FOUND_MSG);
                    });

            if (!items.isEmpty()) {
                return processInvoiceWithItems(itemDetails, items, profile, model, request, session);
            } else {
                return processEmptyInvoice(itemDetails, profile, model, request);
            }


        } catch (Exception e) {
            LOGGER.error("Error processing invoice", e);
            model.addAttribute("error", "Error processing invoice: " + e.getMessage());
            return ERROR_PAGE;
        }
    }

    private String processInvoiceWithItems(InvoiceDetails itemDetails,
                                           List<ItemDetails> items,
                                           CustProfile profile,
                                           Model model,
                                           HttpServletRequest request,
                                           HttpSession session) {
        LOGGER.info("Processing invoice with items");

        boolean isExisting = invoiceDetailsRepository.existsById(itemDetails.getInvoiceId());
        LOGGER.info("Invoice exists: {}", isExisting);

        model.addAttribute("profile", profile);
        model.addAttribute("oldInvoicesFlag", itemDetails.getOldInvoicesFlag());
        model.addAttribute("date", itemDetails.getDate());
        model.addAttribute("invoiceNo", itemDetails.getInvoiceId());
        model.addAttribute("downloadflag", true);



        String itemSummary = invoiceService.generateItemSummary(items);
        itemRepository.saveAll(items);

        Map<String, Double> totals = invoiceService.computeTotals(items);
        LOGGER.info("Invoice totals calculated - Total Amount: {}", totals.get("totalAmount"));

        itemDetails.setItemDetails(itemSummary);
        invoiceService.populateInvoiceMetadata(itemDetails, profile, totals,
                SecurityContextHolder.getContext().getAuthentication().getName());
        itemDetails.setOwnerId(Utility.getOwnerIdFromSession(request));

        if ("Y".equals(itemDetails.getOldInvoicesFlag())) {
            model.addAttribute("oldinvoices", invoiceDetailsRepository.findByCustId(profile.getId()));
            model.addAttribute("balanceDeposits", balanceDepositeRepository.findByCustId(itemDetails.getCustId()));
        }

        invoiceDetailsRepository.save(itemDetails);
        LOGGER.info("Invoice details saved for Invoice ID: {}", itemDetails.getInvoiceId());

        OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");
        model.addAttribute("ownerInfo", ownerInfo);
        model.addAttribute("currentinvoiceitems", itemDetails);
        model.addAttribute("advamount", itemDetails.getAdvanAmt());
        if (!isExisting) {
            profile = updateCustomerBalance(profile, totals.get("totalAmount"), itemDetails.getAdvanAmt());
            updateInvoiceNumber(Utility.getOwnerIdFromSession(request));
        }

        // Send mail asynchronously
        CustProfile finalProfile = profile;
        CompletableFuture.runAsync(() -> {
            try {
                sendMailOwner(itemDetails, finalProfile, ownerInfo,items);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });

        populateInvoiceModelAttributes(model, totals, items, itemDetails, ownerInfo);
        updateStockForOldInvoice(itemDetails.getInvoiceId());

        return determineInvoiceView(ownerInfo, model, profile);
    }

    private String processEmptyInvoice(InvoiceDetails itemDetails,
                                       CustProfile profile,
                                       Model model,
                                       HttpServletRequest request) {
        LOGGER.warn("No items found for invoice ID: {}", itemDetails.getInvoiceId());

        model.addAttribute("profile", profile);
        model.addAttribute("date", getCurrentDateOtherFormat());
        model.addAttribute("invoiceNo", getCurrentInvoiceNumber(Utility.getOwnerIdFromSession(request)));

        List<ItemDetails> emptyItems = new ArrayList<>();
        Map<String, Double> totals = invoiceService.computeTotals(emptyItems);

        populateEmptyInvoiceModel(model, totals, emptyItems, profile, request);
        return CREATE_INVOICE_VIEW;
    }

    private void populateInvoiceModelAttributes(Model model,
                                                Map<String, Double> totals,
                                                List<ItemDetails> items,
                                                InvoiceDetails itemDetails,
                                                OwnerSession ownerInfo) {
        model.addAttribute("totalQty", totals.get("totalQty"));
        model.addAttribute("totalAmout", totals.get("totalAmount"));
        model.addAttribute("items", items);
        model.addAttribute("invoiceTime", itemDetails.getCreatedAt());
    }

    private String determineInvoiceView(OwnerSession ownerInfo, Model model, CustProfile profile) {
        if ("A4".equals(ownerInfo.getInvoiceType())) {
            try {
                model.addAttribute("QRCODE", UPIQrUtil.generateUpiQrBase64(ownerInfo.getUpiId(), profile.getCurrentOusting()));
            } catch (Exception e) {
                LOGGER.warn("Error generating QR code", e);
            }
            model.addAttribute("invoiceColms", Utility.parseInvoiceColumns(ownerInfo.getInvoiceColms()));
            return "invoiceindetails";
        } else {
            return "invoice";
        }
    }

    private void populateEmptyInvoiceModel(Model model,
                                           Map<String, Double> totals,
                                           List<ItemDetails> items,
                                           CustProfile profile,
                                           HttpServletRequest request) {
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
    }

    // Item management methods
    @PostMapping("/add-item")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveItems(@RequestBody ItemDetails itemDetails) {
        Map<String, Object> response = new HashMap<>();

        try {
            LOGGER.info("Saving item details for product ID: {}", itemDetails.getProductId());
            itemDetails.setAmount(Math.floor(itemDetails.getAmount()));

            Product product = productRepository.findById(itemDetails.getProductId())
                    .orElseThrow(() -> new RuntimeException("Product not found"));

            if (product.getStock() < itemDetails.getQty()) {
                LOGGER.warn("Out of stock for product ID: {}. Available stock: {}",
                        product.getProductId(), product.getStock());
                response.put("status", "error");
                response.put("message", OUT_OF_STOCK_MSG + product.getStock());
                return ResponseEntity.ok(response);
            }

            // Update stock
            product.setStock(product.getStock() - Math.round(itemDetails.getQty()));
            productRepository.save(product);
            LOGGER.info("Updated stock for product ID: {}", product.getProductId());

            // Populate item details
            populateItemDetails(itemDetails, product);
            itemRepository.save(itemDetails);

            // Calculate totals
            List<ItemDetails> allItems = itemRepository.findByInvoiceNoAndCustId(
                    itemDetails.getInvoiceNo(), itemDetails.getCustId());
            Map<String, Double> totals = calculateItemTotals(allItems);

            // Prepare response
            response.put("status", "success");
            response.put("message", "Item saved successfully");
            response.put("updatedStock", product.getStock());
            response.put("item", itemDetails);
            response.putAll(totals);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            LOGGER.error("Error saving item: {}", e.getMessage(), e);
            response.put("status", "error");
            response.put("message", "Something went wrong: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    private void populateItemDetails(ItemDetails itemDetails, Product product) {
        itemDetails.setTaxPercetage(product.getTaxPercentage());
        itemDetails.setPriTaxAmt(calculateGstAmount(product.getTaxPercentage(), itemDetails.getAmount()));
        itemDetails.setTaxAmount(itemDetails.getAmount() - itemDetails.getPriTaxAmt());
        itemDetails.setDescription(itemDetails.getDescription().toUpperCase());
        itemDetails.setMrp(product.getMrp());
        itemDetails.setBatchNo(product.getBatchNo());
        itemDetails.setId(UUID.randomUUID().toString().toUpperCase());
        itemDetails.setExpDate(Utility.formatToMonthYear(product.getExpdate()));
        itemDetails.setBrand(Utility.extractBrand(product.getProductName()));
    }

    private Map<String, Double> calculateItemTotals(List<ItemDetails> items) {
        Map<String, Double> totals = new HashMap<>();
        double totalAmount = 0;
        double totalQty = 0;
        double preTaxAmt = 0;
        double totalGst = 0;

        for (ItemDetails item : items) {
            totalAmount += item.getAmount();
            totalQty += item.getQty();
            preTaxAmt += item.getPriTaxAmt();
            totalGst += item.getTaxAmount();
        }

        totals.put("totalAmount", totalAmount);
        totals.put("totalQty", totalQty);
        totals.put("preTaxAmt", preTaxAmt);
        totals.put("totGst", totalGst);

        return totals;
    }

    @DeleteMapping("/delete-item")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteItem(@RequestBody Map<String, String> payload) {
        String itemId = payload.get("itemId");
        Map<String, Object> response = new HashMap<>();

        if (itemId == null || itemId.isEmpty()) {
            response.put("status", "error");
            response.put("message", "Invalid item ID.");
            return ResponseEntity.badRequest().body(response);
        }

        Optional<ItemDetails> optionalItem = itemRepository.findById(itemId);
        if (!optionalItem.isPresent()) {
            response.put("status", "error");
            response.put("message", "Item not found.");
            return ResponseEntity.badRequest().body(response);
        }

        ItemDetails item = optionalItem.get();

        // Restore stock using productId
        productRepository.findById(item.getProductId()).ifPresent(product -> {
            product.setStock(product.getStock() + Math.round(item.getQty()));
            productRepository.save(product);
            LOGGER.info("Restored stock for product: {}", product.getProductName());
        });

        itemRepository.delete(item);
        LOGGER.info("Deleted item with ID: {}", itemId);

        response.put("status", "success");
        response.put("message", "Item deleted successfully");
        response.put("deletedItemId", itemId);

        return ResponseEntity.ok(response);
    }

    // Customer management methods
    @GetMapping("/get-cust-by-id")
    public String getCustomerById(HttpServletRequest request, Model model) {
        LOGGER.info("Retrieving customer by ID");
        String custId = request.getParameter("custid");
        LOGGER.info("Customer ID: {}", custId);

        if (custId == null || custId.trim().isEmpty()) {
            LOGGER.warn("Customer ID is missing or invalid");
            model.addAttribute("error", "Customer ID is missing or invalid.");
            return ERROR_PAGE;
        }

        CustProfile profile = custProfileRepository.findById(custId).orElse(null);
        if (profile == null) {
            LOGGER.warn("Customer not found with ID: {}", custId);
            model.addAttribute("error", CUSTOMER_NOT_FOUND_MSG);
            return ERROR_PAGE;
        }

        return loadInvoiceView(model, custId, request);
    }

    @GetMapping("/get-all-customers")
    public String getAllCustomersList(
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "search", required = false) String search,
            Model model,
            HttpServletRequest request,
            HttpSession session) {

        LOGGER.info("Retrieving all customers for page: {}, search: {}", page, search);
        String ownerId = Utility.getOwnerIdFromSession(request);

        if (ownerId == null) {
            LOGGER.warn("Owner ID not found in session");
            model.addAttribute("error", "Owner ID not found in session.");
            return "error";
        }

        Pageable pageable = PageRequest.of(page, 12, Sort.by("custName").ascending());
        Page<CustProfile> custPage = getCustomerPage(ownerId, search, pageable);

        model.addAttribute("custmers", custPage.getContent());
        model.addAttribute("page", page);
        model.addAttribute("totalcustomers", custPage.getTotalElements());
        model.addAttribute("totalPages", custPage.getTotalPages());
        model.addAttribute("search", search);

        OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");
        model.addAttribute("ownerInfo", ownerInfo);
        model.addAttribute("date", getCurrentDate());

        LOGGER.info("Customers retrieved successfully for page: {}", page);
        return CUSTOMERS_VIEW;
    }

    private Page<CustProfile> getCustomerPage(String ownerId, String search, Pageable pageable) {
        if (search != null && !search.trim().isEmpty()) {
            return custProfileRepository.findByOwnerIdAndCustNameContainingIgnoreCase(
                    ownerId, search.trim(), pageable);
        } else {
            return custProfileRepository.findByOwnerId(ownerId, pageable);
        }
    }

    // Search methods
    @GetMapping("/search-cust")
    @ResponseBody
    public List<Map<String, Object>> searchCustomersAjax(
            @RequestParam("search") String search,
            HttpServletRequest request) {

        LOGGER.info("Searching customers with query: {}", search);
        String ownerId = Utility.getOwnerIdFromSession(request);
        Pageable pageable = PageRequest.of(0, 20, Sort.by("custName").ascending());

        List<CustProfile> customers = custProfileRepository
                .findByOwnerIdAndCustNameContainingIgnoreCase(ownerId, search.trim(), pageable)
                .getContent();

        LOGGER.info("Found {} customers for search query: {}", customers.size(), search);
        return customers.stream()
                .map(this::mapCustomerToResponse)
                .collect(Collectors.toList());
    }

    private Map<String, Object> mapCustomerToResponse(CustProfile customer) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", customer.getId());
        map.put("custName", customer.getCustName());
        map.put("address", customer.getAddress());
        map.put("phoneNo", customer.getPhoneNo());
        map.put("totalAmount", customer.getTotalAmount());
        map.put("paidAmout", customer.getPaidAmout());
        map.put("currentOusting", customer.getCurrentOusting());
        return map;
    }

    @GetMapping("/search-product")
    @ResponseBody
    public List<ProductDto> searchProducts(
            @RequestParam(name = "query", required = false, defaultValue = "") String query,
            HttpServletRequest request) {

        String ownerId = Utility.getOwnerIdFromSession(request);

        if (query == null || query.trim().isEmpty()) {
            return new ArrayList<>();
        }

        List<Product> products = productRepository
                .findByProductNameContainingIgnoreCaseAndOwnerId(query.trim(), ownerId);

        return products.stream()
                .map(product -> new ProductDto(
                        product.getProductId(),
                        product.getProductName(),
                        product.getBatchNo(),
                        product.getStock(),
                        product.getExpdate(),
                        product.getTaxPercentage(),
                        product.getPname(),
                        product.getPrice(),
                        product.getMrp(),
                        product.getDealerPrice()
                ))
                .collect(Collectors.toList());

    }

    // Invoice number and financial year methods
    public String getCurrentInvoiceNumber(String ownerId) {
        LOGGER.info("Getting current invoice number for owner ID: {}", ownerId);
        String finYear = getCurrentFinancialYear();

        if (!invoiceNoRepository.existsByOwnerId(ownerId)) {
            InvoiceNo invoiceNo = new InvoiceNo();
            invoiceNo.setInvoiceId(ownerId);
            invoiceNo.setInvoiceNumber(1000);
            invoiceNoRepository.save(invoiceNo);
            LOGGER.info("Initialized invoice number for owner ID: {}", ownerId);
        }

        InvoiceNo invoiceNo = invoiceNoRepository.findByOwnerId(ownerId);
        String currentInvoiceNumber = invoiceNo.getInvoiceNumber() + "" + invoiceNo.getBillNo() + "" + finYear;
        LOGGER.info("Current invoice number for owner ID: {} is {}", ownerId, currentInvoiceNumber);
        return currentInvoiceNumber;
    }

    public String getCurrentFinancialYear() {
        LOGGER.info("Getting current financial year");
        int year = Calendar.getInstance().get(Calendar.YEAR);
        int month = Calendar.getInstance().get(Calendar.MONTH) + 1;

        String finYear;
        if (month <= 3) {
            finYear = (year - 1) + "" + year;
        } else {
            finYear = year + "" + (year + 1);
        }
        finYear = finYear.replaceAll("20", "");
        LOGGER.info("Current financial year is {}", finYear);
        return finYear;
    }

    public String getCurrentFullFinancialYear() {
        LOGGER.info("Getting current full financial year");
        int year = Calendar.getInstance().get(Calendar.YEAR);
        int month = Calendar.getInstance().get(Calendar.MONTH) + 1;

        String finYear;
        if (month <= 3) {
            finYear = (year - 1) + "-" + String.valueOf(year).substring(2);
        } else {
            finYear = year + "-" + String.valueOf(year + 1).substring(2);
        }

        LOGGER.info("Current full financial year is {}", finYear);
        return finYear;
    }

    // Utility methods
    public void updateStockForOldInvoice(String invoiceId) {
        LOGGER.info("Updating stock for old invoice ID: {}", invoiceId);
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
            LOGGER.info("Adjusted stock for product: {} by {}", product.getProductName(), adjustment);
        }

        // Save all updates in batch
        productRepository.saveAll(products);
        LOGGER.info("Stock updated for all products related to invoice ID: {}", invoiceId);

        // Delete all related items
        itemRepository.deleteAll(itemsToDelete);
        LOGGER.info("Deleted all items related to invoice ID: {}", invoiceId);
    }

    private String loadInvoiceView(Model model, String custId, HttpServletRequest request) {
        LOGGER.info("Loading invoice view for customer ID: {}", custId);
        String invoiceNo = getCurrentInvoiceNumber(Utility.getOwnerIdFromSession(request));
        List<ItemDetails> items = itemRepository.findByInvoiceNoAndCustId(invoiceNo, custId);

        Map<String, Double> totals = calculateItemTotals(items);
        updateSerialNumbers(items);

        Optional<CustProfile> profileOpt = custProfileRepository.findById(custId);
        if (!profileOpt.isPresent()) {
            LOGGER.warn("Customer not found with ID: {}", custId);
            model.addAttribute("error", CUSTOMER_NOT_FOUND_MSG);
            return ERROR_PAGE;
        }

        CustProfile profile = profileOpt.get();

        model.addAttribute("profile", profile);
        model.addAttribute("date", getCurrentDateOtherFormat());
        model.addAttribute("invoiceNo", invoiceNo);
        model.addAttribute("itemsNo", items.size() + 1);
        model.addAttribute("items", items);
        model.addAttribute("preTaxAmt", totals.get("preTaxAmt"));
        model.addAttribute("totGst", totals.get("totGst"));
        model.addAttribute("totalQty", totals.get("totalQty"));
        model.addAttribute("totalAmout", totals.get("totalAmount"));
        model.addAttribute("appInfo", appInfo);
        model.addAttribute("balanceDeposits", balanceDepositeRepository.findByCustId(custId));
        model.addAttribute("oldinvoices", invoiceDetailsRepository.findByCustId(custId));
        model.addAttribute("dropdown", productRepository.findByOwnerId(Utility.getOwnerIdFromSession(request)));

        LOGGER.info("Invoice view loaded successfully for customer ID: {}", custId);
        return CREATE_INVOICE_VIEW;
    }

    private CustProfile updateCustomerBalance(CustProfile profile, Double totalAmount, Double advanceAmount) {
        LOGGER.info("Updating balance for customer ID: {}", profile.getId());
        profile.setTotalAmount(Math.floor(profile.getTotalAmount() + totalAmount));
        profile.setCurrentOusting(Math.floor(profile.getCurrentOusting() + totalAmount - advanceAmount));
        profile.setPaidAmout(Math.floor(profile.getPaidAmout() + advanceAmount));
        custProfileRepository.save(profile);
        LOGGER.info("Balance updated successfully for customer ID: {}", profile.getId());
        return profile;
    }

    public void updateInvoiceNumber(String ownerId) {
        LOGGER.info("Updating invoice number for owner ID: {}", ownerId);
        InvoiceNo invoiceNo = invoiceNoRepository.findByOwnerId(ownerId);
        invoiceNo.setInvoiceNumber(invoiceNo.getInvoiceNumber() + 1);
        invoiceNoRepository.save(invoiceNo);
        LOGGER.info("Invoice number updated successfully for owner ID: {}", ownerId);
    }

    public void updateSerialNumbers(List<ItemDetails> products) {
        LOGGER.info("Updating serial numbers for items");
        for (int i = 0; i < products.size(); i++) {
            products.get(i).setItemNo(i + 1);
        }
        LOGGER.info("Serial numbers updated successfully");
    }

    private double calculateGstAmount(int gstPercentage, double sellingPrice) {
        int gstDivisor = 100 + gstPercentage;
        double gstDiv = sellingPrice / gstDivisor;
        double gstAmount = gstDiv * 100;
        return Math.floor(gstAmount);
    }

    public static String getDateDifference(String expiryDate) throws ParseException {
        DateFormat dateFormat = new SimpleDateFormat(YYYY_MM_DD_FORMAT);
        Date expDate = dateFormat.parse(expiryDate);

        // Normalize current date (remove time part)
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        Date currentDate = cal.getTime();

        long diffInDays = TimeUnit.MILLISECONDS.toDays(expDate.getTime() - currentDate.getTime());

        if (diffInDays < 0) {
            return "expired";
        } else if (diffInDays == 0) {
            return "today";
        } else {
            return diffInDays + " days";
        }
    }

    // Invoice search and listing methods
    @GetMapping("/get-all-invoices")
    public String getAllInvoiceList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "12") int size,
            Model model,
            HttpServletRequest request) {

        LOGGER.info("Retrieving all invoices for page: {}, size: {}", page, size);
        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            if (ownerId == null) {
                LOGGER.warn("User session is invalid or has expired");
                model.addAttribute("error", "User session is invalid or has expired.");
                return "error";
            }

            String currentFY = getCurrentFinancialYear();
            Pageable pageable = PageRequest.of(page, size, Sort.by("invoiceId").descending());

            Page<InvoiceDetails> invoicePage = invoiceDetailsRepository
                    .findByInvoiceIdEndingWithFyAndOwnerId(currentFY, ownerId, pageable);

            populateInvoiceListModel(model, invoicePage, page, currentFY);

            LOGGER.info("Invoices retrieved successfully for page: {}", page);
            return INVOICE_SEARCH_VIEW;
        } catch (Exception ex) {
            LOGGER.error("Error occurred while fetching invoice list", ex);
            model.addAttribute("error", "An unexpected error occurred while retrieving the invoices.");
            return "error";
        }
    }

    private void populateInvoiceListModel(Model model, Page<InvoiceDetails> invoicePage, int page, String currentFY) {
        model.addAttribute("invoices", invoicePage.getContent());
        model.addAttribute("currentPage", invoicePage.getNumber());
        model.addAttribute("totalPages", invoicePage.getTotalPages());
        model.addAttribute("totalInvoices", invoicePage.getTotalElements());
        model.addAttribute("fy", currentFY);

        int startPage = Math.max(0, page - 2);
        int endPage = Math.min(invoicePage.getTotalPages() - 1, page + 2);

        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("page", page);
    }

    @GetMapping("/search-invoices")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> searchInvoices(
            @RequestParam("query") String query,
            HttpServletRequest request) {

        LOGGER.info("Searching invoices with query: {}", query);
        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            if (ownerId == null) {
                LOGGER.warn("User session is invalid or has expired");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }

            String currentFY = getCurrentFinancialYear();
            List<InvoiceDetails> invoices = invoiceDetailsRepository
                    .findByOwnerIdAndInvoiceIdOrCustNameContainingIgnoreCase(ownerId, currentFY, query);

            List<Map<String, Object>> results = invoices.stream()
                    .map(this::mapInvoiceToResponse)
                    .collect(Collectors.toList());

            return ResponseEntity.ok(results);

        } catch (Exception ex) {
            LOGGER.error("Error occurred while searching invoices", ex);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    private Map<String, Object> mapInvoiceToResponse(InvoiceDetails invoice) {
        Map<String, Object> map = new HashMap<>();
        map.put("invoiceId", invoice.getInvoiceId());
        map.put("custId", invoice.getCustId());
        map.put("custName", invoice.getCustName());
        map.put("totQty", invoice.getTotQty());
        map.put("totInvoiceAmt", invoice.getTotInvoiceAmt());
        map.put("balanceAmt", invoice.getBalanceAmt());
        map.put("discount", invoice.getDiscount());
        map.put("advanAmt", invoice.getAdvanAmt());
        map.put("tax", invoice.getTax());
        map.put("invoiceType", invoice.getInvoiceType());
        return map;
    }


    @GetMapping("/get-shop-profile/{ownerId}")
    public String getShopDetailsByOwnerId(Model model, @PathVariable String ownerId, HttpServletRequest request) {
        Boolean isSuperAdmin = Utility.getSuperAdminFromSession(request);
        if (isSuperAdmin) {
            List<OwnerInfo> ownerDetails = ownerInfoRepository.findAll();
            model.addAttribute("ownerDetails", ownerDetails);
            OwnerInfo matchedOwner = ownerDetails.stream().filter(o -> o.getOwnerId().equals(ownerId)).findFirst().orElse(null);
            model.addAttribute("ownerInfo", matchedOwner);
        }
        return "admin-dashoard";
    }

    // Report methods
    @GetMapping("/reports")
    public String getReportPage(HttpServletRequest request, Model model,
                                @ModelAttribute("DATERANGE") DateRange dateRange) {
        LOGGER.info("Retrieving report page");

        String ownerId = Utility.getOwnerIdFromSession(request);
        LocalDate today = LocalDate.now();


        // Start date of the current month
        LocalDate startOfMonth = today.withDayOfMonth(1);

        List<InvoiceDetails> records = invoiceDetailsRepository.findByDateBetweenAndOwnerId(startOfMonth, today, ownerId);

        List<BalanceDeposite>   balanceDeposits = balanceDepositeRepository.findByDateBetweenAndOwnerId(startOfMonth, today, ownerId);




        InvoiceDetails summary = calculateDailySummary(records, balanceDeposits);

        model.addAttribute("invoicetotal", summary);
        model.addAttribute("Invoices", records);
        model.addAttribute("transactions", balanceDeposits);
        model.addAttribute("startDate", getFirstDayOfMonth());
        model.addAttribute("endDate", getCurrentDateOtherFormat());

        LOGGER.info("Report page retrieved successfully");
        return "reports";
    }

    @PostMapping("/reportbydate")
    public String getReportByDate(HttpServletRequest request, Model model,
                                  @ModelAttribute("DATERANGE") DateRange dateRange) {
        LOGGER.info("Retrieving report by date range: {} to {}", dateRange.getStartDate(), dateRange.getEndDate());

        model.addAttribute("startDate", dateRange.getStartDate());
        model.addAttribute("endDate", dateRange.getEndDate());

        String ownerId = Utility.getOwnerIdFromSession(request);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(YYYY_MM_DD_FORMAT);
        LocalDate startDate = LocalDate.parse(dateRange.getStartDate(), formatter);
        LocalDate endDate = LocalDate.parse(dateRange.getEndDate(), formatter);

        List<InvoiceDetails> records;
        List<BalanceDeposite> balanceDeposits;

        if (startDate.equals(endDate)) {
            records = invoiceDetailsRepository.findByOwnerIdAndDate(ownerId, startDate);
            balanceDeposits = balanceDepositeRepository.findByOwnerIdAndDate(ownerId, startDate);
        } else {
            records = invoiceDetailsRepository.findByDateBetweenAndOwnerId(startDate, endDate, ownerId);
            balanceDeposits = balanceDepositeRepository.findByDateBetweenAndOwnerId(startDate, endDate, ownerId);
        }

        InvoiceDetails summary = calculateDailySummary(records, balanceDeposits);

        model.addAttribute("invoicetotal", summary);
        model.addAttribute("Invoices", records);
        model.addAttribute("transactions", balanceDeposits);

        LOGGER.info("Report by date range retrieved successfully");
        return "reports";
    }

    private InvoiceDetails calculateDailySummary(List<InvoiceDetails> records, List<BalanceDeposite> balanceDeposits) {
        InvoiceDetails summary = new InvoiceDetails();

        double totalBalance = records.stream()
                .mapToDouble(InvoiceDetails::getBalanceAmt)
                .sum();
        double totalInvoiceAmount = records.stream()
                .mapToDouble(InvoiceDetails::getTotInvoiceAmt)
                .sum();
        double totalAdvanceAmount = records.stream()
                .mapToDouble(InvoiceDetails::getAdvanAmt)
                .sum();
        double depositsAmount = balanceDeposits.stream()
                .mapToDouble(BalanceDeposite::getAdvAmt)
                .sum();

        summary.setBalanceAmt(Math.floor(totalBalance - depositsAmount));
        summary.setTotInvoiceAmt(Math.floor(totalInvoiceAmount));
        summary.setAdvanAmt(Math.floor(totalAdvanceAmount));

        return summary;
    }

    // Balance and payment methods
    @PostMapping("/balance-credit")
    public String creditBalance(@ModelAttribute("BalanceDeposite") BalanceDeposite balanceDeposite,
                                Model model, HttpSession session,
                                HttpServletRequest request) {
        LOGGER.info("Crediting balance for customer ID: {}", balanceDeposite.getCustId());

        try {
            CustProfile profile = custProfileRepository.findById(balanceDeposite.getCustId())
                    .orElseThrow(() -> new IllegalArgumentException(CUSTOMER_NOT_FOUND_MSG));

            processBalanceCredit(balanceDeposite, profile, request);
            balanceDepositeRepository.save(balanceDeposite);

            CustProfile updatedProfile = updateCustomerBalance(profile, 0.0, balanceDeposite.getAdvAmt());
            populatePaymentReceiptModel(model, updatedProfile, request, balanceDeposite.getCustId());

            OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");
            model.addAttribute("ownerInfo", ownerInfo);

            // Send mail asynchronously
            CompletableFuture.runAsync(() -> sendMailToCustomer(balanceDeposite, updatedProfile, ownerInfo));

            model.addAttribute("balanceDeposite", balanceDeposite);
            model.addAttribute("AMOUNT_WORD", AmountInWordUtility.convertToWords(balanceDeposite.getAdvAmt()));

            LOGGER.info("Balance credited successfully for customer ID: {}", balanceDeposite.getCustId());
            return "A4".equals(ownerInfo.getInvoiceType()) ? "payment-receipt" : "payment-receipt-th";


        } catch (Exception e) {
            LOGGER.error("Error crediting balance", e);
            model.addAttribute("error", "Error processing payment: " + e.getMessage());
            return ERROR_PAGE;
        }
    }

    private void processBalanceCredit(BalanceDeposite balanceDeposite, CustProfile profile,
                                      HttpServletRequest request) {
        balanceDeposite.setCustName(profile.getCustName());
        balanceDeposite.setAdvAmt(Math.floor(balanceDeposite.getAdvAmt()));
        balanceDeposite.setTotalAmount(Math.floor(profile.getTotalAmount()));
        balanceDeposite.setPaidAmout(Math.floor(profile.getPaidAmout()));
        balanceDeposite.setCurrentOusting(Math.floor(profile.getCurrentOusting()));
        balanceDeposite.setCreatedBy(SecurityContextHolder.getContext().getAuthentication().getName());

        String ownerId = Utility.getOwnerIdFromSession(request);
        balanceDeposite.setOwnerId(ownerId);

        String txId = "TX" + invoiceNoRepository.findByOwnerId(ownerId).getBillNo() +
                new SimpleDateFormat("yyMMddhhmmssSSS").format(new Date());
        balanceDeposite.setId(txId);
        balanceDeposite.setCreatedAt(new SimpleDateFormat(DATE_TIME_FORMAT).format(new Date()));
        balanceDeposite.setDescription(balanceDeposite.getDescription().toUpperCase());
    }

    private void populatePaymentReceiptModel(Model model, CustProfile profile,
                                             HttpServletRequest request, String custId) {
        LOGGER.info("Populating payment receipt model for customer ID: {}", custId);

        model.addAttribute("profile", profile);
        model.addAttribute("date", getCurrentDate());

        String invoiceNo = getCurrentInvoiceNumber(Utility.getOwnerIdFromSession(request));
        model.addAttribute("invoiceNo", invoiceNo);

        List<ItemDetails> items = itemRepository.findByInvoiceNoAndCustId(invoiceNo, custId);
        Map<String, Double> totals = calculateItemTotals(items);

        model.addAttribute("totalQty", totals.get("totalQty"));
        model.addAttribute("totalAmout", totals.get("totalAmount"));
        model.addAttribute("items", items);
        model.addAttribute("itemsNo", items.size() + 1);
        model.addAttribute("appInfo", appInfo);
        model.addAttribute("balanceDeposits", balanceDepositeRepository.findByCustId(custId));
        model.addAttribute("oldinvoices", invoiceDetailsRepository.findByCustId(custId));
        model.addAttribute("dropdown", productRepository.findByOwnerId(Utility.getOwnerIdFromSession(request)));

        LOGGER.info("Payment receipt model populated successfully for customer ID: {}", custId);
    }

    public static void sendMailToCustomer(BalanceDeposite balanceDeposite, CustProfile profile, OwnerSession ownerInfo) {
        String mailSignature = ownerInfo.getShopName() + "<br>" + ownerInfo.getAddress() +
                "<br>" + ownerInfo.getOwnerName() + "<br>" + ownerInfo.getMobNumber();
        String mailFormat = MailUtil.getBalanceCreditedMailFormat(balanceDeposite, profile, mailSignature);

        String ownerSubject = "Deposit : " + balanceDeposite.getCustName();
        String custSubject = "Deposit : " + balanceDeposite.getId() + " - " + ownerInfo.getShopName();

        ExecutorService emailExecutor = Executors.newSingleThreadExecutor();
        try {
            emailExecutor.execute(() -> {
                MailUtil.sendMail(profile.getEmail(), mailFormat, custSubject);
                MailUtil.sendMail(ownerInfo.getEmail(), mailFormat, ownerSubject);
            });
        } finally {
            emailExecutor.shutdown();
        }
    }

    // File upload and download methods
    @PostMapping("/upload")
    public String uploadExcel(@RequestParam("file") MultipartFile file, Model model,
                              HttpServletRequest request) {
        LOGGER.info("Starting Excel file upload process");

        if (file.isEmpty()) {
            model.addAttribute("message", "Please select a file to upload.");
            return PRODUCTS_VIEW;
        }

        try (InputStream inputStream = file.getInputStream();
             Workbook workbook = new XSSFWorkbook(inputStream)) {

            Sheet sheet = workbook.getSheetAt(0);
            String ownerId = Utility.getOwnerIdFromSession(request);
            LOGGER.info("Processing Excel upload for owner ID: {}", ownerId);

            List<Product> products = processExcelSheet(sheet, ownerId);

            LOGGER.info("Saving {} new products to database", products.size());
            productRepository.saveAll(products);

            LOGGER.info("Excel upload completed successfully");
            model.addAttribute("message", "Successfully uploaded " + products.size() + " products!");

        } catch (Exception e) {
            LOGGER.error("Error uploading Excel file", e);
            model.addAttribute("message", "Error: " + e.getMessage());
        }

        return loadProductsView(model, Utility.getOwnerIdFromSession(request));
    }

    private List<Product> processExcelSheet(Sheet sheet, String ownerId) {
        List<Product> products = new ArrayList<>();
        int totalRows = sheet.getLastRowNum();
        LOGGER.info("Found {} rows in Excel file (excluding header)", totalRows);

        for (int i = 1; i <= totalRows; i++) { // skip header row
            Row row = sheet.getRow(i);
            if (row == null) continue;

            Product product = createProductFromRow(row, ownerId);

            if (!productRepository.existsByProductNameAndOwnerId(product.getProductName(), ownerId)) {
                products.add(product);
                LOGGER.debug("Added product to import list: {}", product.getProductName());
            } else {
                LOGGER.debug("Skipping duplicate product: {}", product.getProductName());
            }
        }

        return products;
    }

    private Product createProductFromRow(Row row, String ownerId) {
        Product product = new Product();
        product.setPname(getCellStringValue(row, 0));
        product.setCompany(getCellStringValue(row, 1));
        product.setQuantity(getCellStringValue(row, 2));
        product.setBatchNo(getCellStringValue(row, 3));
        product.setExpdate(getCellStringValue(row, 4));
        product.setMrp(getCellDoubleValue(row, 5));
        product.setPrice(getCellDoubleValue(row, 6));
        product.setDealerPrice(getCellDoubleValue(row, 7));
        product.setStock(Math.round(getCellDoubleValue(row, 8)));
        product.setTaxPercentage((int) Math.round(getCellDoubleValue(row, 9)));
        product.setStatus(true);
        product.setProductName(Utility.getProductName(product));
        product.setOwnerId(ownerId);
        return product;
    }

    // Utility methods for Excel processing
    private String getCellStringValue(Row row, int cellIndex) {
        Cell cell = row.getCell(cellIndex);
        return (cell != null) ? cell.toString().trim() : "";
    }

    private Double getCellDoubleValue(Row row, int cellIndex) {
        try {
            return Double.valueOf(getCellStringValue(row, cellIndex));
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }

    // PDF generation methods
    @GetMapping("/export-to-pdf")
    public void generatePdfFile(HttpServletRequest request, HttpSession session,
                                HttpServletResponse response) throws Exception {
        String ownerId = Utility.getOwnerIdFromSession(request);
        OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");

        response.setContentType("application/pdf");
        List<CustProfile> custProfiles = custProfileRepository.findByOwnerId(ownerId);

        PdfGenerator generator = new PdfGenerator();
        generator.generate(custProfiles, response, ownerInfo);
    }

    @GetMapping("/download-template")
    public void downloadTemplate(HttpServletRequest request, HttpServletResponse response,
                                 HttpSession session) throws IOException {
        OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");
        LOGGER.info("Generating template for: {}", ownerInfo != null ? ownerInfo.getShopName() : "Unknown");

        String filename = generateTemplateFilename(ownerInfo);
        response.reset();
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        generateExcelTemplate(response);
    }

    private String generateTemplateFilename(OwnerSession ownerInfo) {
        String filename = "product_template.xlsx";
        if (ownerInfo != null && ownerInfo.getShopName() != null) {
            filename = ownerInfo.getShopName().replaceAll(" ", "_").toLowerCase() + "_product_template.xlsx";
        }
        return filename.replaceAll("[^a-zA-Z0-9._-]", "_");
    }

    private void generateExcelTemplate(HttpServletResponse response) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Products");

            String[] headers = {
                    "productName", "company", "quantity", "batchNo", "expdate",
                    "mrp", "price", "delarPrice", "stock", "taxPercentage"
            };

            createHeaderRow(workbook, sheet, headers);
            createSampleRow(sheet);

            workbook.write(response.getOutputStream());
        }
    }

    private void createHeaderRow(Workbook workbook, Sheet sheet, String[] headers) {
        Row header = sheet.createRow(0);
        CellStyle headerStyle = createHeaderStyle(workbook);

        for (int i = 0; i < headers.length; i++) {
            Cell cell = header.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
            sheet.autoSizeColumn(i);
        }
    }

    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle headerStyle = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        headerStyle.setFont(font);
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        return headerStyle;
    }

    private void createSampleRow(Sheet sheet) {
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
    }

    // Admin methods
    @GetMapping("/admin")
    public String adminPage(HttpServletRequest request, Model model) {
        Boolean isSuperAdmin = Utility.getSuperAdminFromSession(request);
        if (Boolean.TRUE.equals(isSuperAdmin)) {
            List<OwnerInfo> ownerDetails = ownerInfoRepository.findAll();
            model.addAttribute("ownerDetails", ownerDetails);
        }
        return "admin-dashoard";
    }

    @PostMapping("/update-owner-info")
    public String updateOwnerInfo(@ModelAttribute OwnerInfo ownerInfo,
                                  Model model,
                                  HttpServletRequest request) throws Exception {
        Boolean isSuperAdmin = Utility.getSuperAdminFromSession(request);
        if (Boolean.TRUE.equals(isSuperAdmin)) {
            processOwnerInfoUpdate(ownerInfo);
            model.addAttribute("ownerDetails", ownerInfoRepository.findAll());
        }
        return "admin-dashoard";
    }

    private void processOwnerInfoUpdate(OwnerInfo ownerInfo) throws Exception {
        OwnerInfo dbOwner = ownerInfoRepository.findById(ownerInfo.getOwnerId())
                .orElseThrow(() -> new RuntimeException("Owner not found: " + ownerInfo.getOwnerId()));

        User user = userService.findByUsernameWithoutStatus(ownerInfo.getUserName());

        if ("PENDING".equals(dbOwner.getStatus())) {
            activateOwnerAccount(dbOwner, user, ownerInfo);
        } else if ("DEACTIVATE".equals(ownerInfo.getStatus())) {
            deactivateOwnerAccount(dbOwner, user, ownerInfo);
        }

        updateOwnerDetails(dbOwner, ownerInfo);
        ownerInfoRepository.save(dbOwner);
    }

    private void activateOwnerAccount(OwnerInfo dbOwner, User user, OwnerInfo ownerInfo) throws Exception {
        Date newExpiry = getExpiryDateFromNow(ownerInfo.getPlanDuration());
        dbOwner.setExpDate(newExpiry);
        dbOwner.setStatus("ACTIVE");

        user.setExpDate(newExpiry);
        user.setOwnerId(ownerInfo.getOwnerId());
        user.setStatus(ownerInfo.getStatus());

        String generatedPassword = PasswordUtil.generateSecurePassword();
        user.setPassword(generatedPassword);
        userService.activateUser(user);

        // Send approval email asynchronously
        CompletableFuture.runAsync(() -> {
            try {
                MailUtil.sendMail(
                        ownerInfo.getEmail(),
                        MailUtil.getRegistrationApprovedReceipt(dbOwner, generatedPassword),
                        "Approved : MY BILL BOOK : " + ownerInfo.getShopName()
                );
            } catch (Exception e) {
                LOGGER.error("Error sending approval email", e);
            }
        });
    }

    private void deactivateOwnerAccount(OwnerInfo dbOwner, User user, OwnerInfo ownerInfo) {
        user.setStatus(ownerInfo.getStatus());
        userService.activateUser(user);
        dbOwner.setStatus("DEACTIVATE");
    }

    private void updateOwnerDetails(OwnerInfo dbOwner, OwnerInfo ownerInfo) {
        dbOwner.setOwnerName(ownerInfo.getOwnerName());
        dbOwner.setShopName(ownerInfo.getShopName());
        dbOwner.setMobNumber(ownerInfo.getMobNumber());
        dbOwner.setAddress(ownerInfo.getAddress());
        dbOwner.setEmail(ownerInfo.getEmail());
        dbOwner.setGstNumber(ownerInfo.getGstNumber());
        dbOwner.setLcNo(ownerInfo.getLcNo());
    }

    public Date getExpiryDateFromNow(int months) {
        Date currentDate = new Date();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(currentDate);
        calendar.add(Calendar.MONTH, months);
        Date newDate = calendar.getTime();
        LOGGER.info("Calculated expiry date: {}", newDate);
        return newDate;
    }

    // Profile management methods
    @GetMapping("/get-my-profile")
    public String getMyProfilePage(HttpServletRequest request, Model model) {
        LOGGER.info("Retrieving my profile page");
        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            if (ownerId == null) {
                LOGGER.warn("Owner ID not found in session");
                model.addAttribute("error", "Session expired or invalid");
                return ERROR_PAGE;
            }

            OwnerInfo info = ownerInfoRepository.findById(ownerId)
                    .orElseThrow(() -> new RuntimeException("Owner info not found"));

            model.addAttribute("ownerInfo", info);

            if (info.getUpiId() != null && !info.getUpiId().trim().isEmpty()) {
                String qrBase64 = UPIQrUtil.generateUpiQrBase64(info.getUpiId(), 0.00);
                model.addAttribute("QRCODE", qrBase64);
            }

            model.addAttribute("selectedCols", Utility.parseInvoiceColumns(info.getInvoiceColms()));

            LOGGER.info("My profile page retrieved successfully");
            return "my-profile";
        } catch (Exception e) {
            LOGGER.error("Error retrieving profile", e);
            model.addAttribute("error", "Error loading profile: " + e.getMessage());
            return ERROR_PAGE;
        }
    }

    @PostMapping("/update-owner-details")
    public String updateOwnerProfile(@ModelAttribute("OwnerInfo") OwnerInfo ownerInfo,
                                     @RequestParam(value = "invoiceColms", required = false) List<String> invoiceColms,
                                     HttpServletRequest request, Model model) {
        LOGGER.info("Updating owner profile for owner ID: {}", ownerInfo.getOwnerId());

        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            OwnerInfo existingInfo = ownerInfoRepository.findById(ownerId)
                    .orElseThrow(() -> new RuntimeException("Owner info not found"));

            String joinedCols = (invoiceColms != null) ? String.join(",", invoiceColms) : "";

            ownerInfo.setExpDate(existingInfo.getExpDate());
            ownerInfo.setInvoiceColms(joinedCols);
            ownerInfo.setUserName(existingInfo.getUserName());
            ownerInfoRepository.save(ownerInfo);

            model.addAttribute("ownerInfo", ownerInfo);
            model.addAttribute("msg", "Profile Updated Successfully!");

            if (ownerInfo.getUpiId() != null && !ownerInfo.getUpiId().trim().isEmpty()) {
                model.addAttribute("QRCODE", UPIQrUtil.generateUpiQrBase64(ownerInfo.getUpiId(), 0.00));
            }

            model.addAttribute("selectedCols", invoiceColms);

            LOGGER.info("Owner profile updated successfully for owner ID: {}", ownerInfo.getOwnerId());
            return "my-profile";

        } catch (Exception e) {
            LOGGER.error("Error updating owner profile", e);
            model.addAttribute("error", "Error updating profile: " + e.getMessage());
            return ERROR_PAGE;
        }
    }

    // Download methods
    @GetMapping("/download-customer")
    public void downloadCustomersCSV(HttpServletResponse response, HttpServletRequest request) throws IOException {
        String ownerId = Utility.getOwnerIdFromSession(request);
        List<CustProfile> customers = custProfileRepository.findByOwnerId(ownerId);

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=customers.csv");

        try (PrintWriter writer = response.getWriter()) {
            // CSV header
            writer.println("id,custName,address,email,phoneNo,addharNo,status,totalAmount,currentOusting,paidAmout,ownerId");

            for (CustProfile customer : customers) {
                writer.printf("%s,%s,%s,%s,%s,%s,%s,%.2f,%.2f,%.2f,%s%n",
                        escapeCsvField(customer.getId()),
                        escapeCsvField(customer.getCustName()),
                        escapeCsvField(customer.getAddress()),
                        escapeCsvField(customer.getEmail()),
                        escapeCsvField(customer.getPhoneNo()),
                        escapeCsvField(customer.getAddharNo()),
                        escapeCsvField(customer.getStatus()),
                        customer.getTotalAmount(),
                        customer.getCurrentOusting(),
                        customer.getPaidAmout(),
                        escapeCsvField(customer.getOwnerId()));
            }
        }

        LOGGER.info("Downloaded CSV for {} customers", customers.size());
    }

    private String escapeCsvField(String field) {
        if (field == null) return "";
        if (field.contains(",") || field.contains("\"") || field.contains("\n")) {
            return "\"" + field.replace("\"", "\"\"") + "\"";
        }
        return field;
    }

    // Invoice viewing methods
    @GetMapping("/get-invoice/{custId}/{invoiceNo}")
    public String getInvoicePage(Model model, @PathVariable String custId, @PathVariable String invoiceNo,
                                 HttpServletRequest request) {
        LOGGER.info("Retrieving invoice page for customer ID: {} and invoice number: {}", custId, invoiceNo);

        try {
            InvoiceDetails itemDetails = invoiceDetailsRepository.findByCustIdAndInvoiceId(custId, invoiceNo);
            if (itemDetails == null) {
                model.addAttribute("error", "Invoice not found");
                return ERROR_PAGE;
            }

            CustProfile profile = custProfileRepository.findById(itemDetails.getCustId())
                    .orElseThrow(() -> new RuntimeException(CUSTOMER_NOT_FOUND_MSG));

            populateInvoiceViewModel(model, itemDetails, profile, request);

            String ownerId = Utility.getOwnerIdFromSession(request);
            OwnerInfo ownerInfo = ownerInfoRepository.findById(ownerId)
                    .orElseThrow(() -> new RuntimeException("Owner info not found"));

            model.addAttribute("ownerInfo", ownerInfo);

            if (ownerInfo.getUpiId() != null) {
                model.addAttribute("QRCODE", UPIQrUtil.generateUpiQrBase64(ownerInfo.getUpiId(), profile.getCurrentOusting()));
            }
            model.addAttribute("invoiceColms", Utility.parseInvoiceColumns(ownerInfo.getInvoiceColms()));

            LOGGER.info("Invoice page retrieved successfully for customer ID: {} and invoice number: {}", custId, invoiceNo);
            return "A4".equals(ownerInfo.getInvoiceType()) ? "invoiceindetails" : "invoice";

        } catch (Exception e) {
            LOGGER.error("Error retrieving invoice", e);
            model.addAttribute("error", "Error loading invoice: " + e.getMessage());
            return ERROR_PAGE;
        }
    }

    @GetMapping("/get-invoice-details/{custId}/{invoiceNo}")
    public String getInvoicePageDetails(Model model, @PathVariable String custId, @PathVariable String invoiceNo,
                                        HttpServletRequest request, HttpSession session) {
        LOGGER.info("Retrieving detailed invoice page for customer ID: {} and invoice number: {}", custId, invoiceNo);

        try {
            InvoiceDetails itemDetails = invoiceDetailsRepository.findByCustIdAndInvoiceId(custId, invoiceNo);
            if (itemDetails == null) {
                model.addAttribute("error", "Invoice not found");
                return ERROR_PAGE;
            }

            CustProfile profile = custProfileRepository.findById(itemDetails.getCustId())
                    .orElseThrow(() -> new RuntimeException(CUSTOMER_NOT_FOUND_MSG));

            populateInvoiceViewModel(model, itemDetails, profile, request);

            OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");
            model.addAttribute("ownerInfo", ownerInfo);

            if (ownerInfo != null && ownerInfo.getUpiId() != null) {
                model.addAttribute("QRCODE", UPIQrUtil.generateUpiQrBase64(ownerInfo.getUpiId(), profile.getCurrentOusting()));
            }
            if (ownerInfo != null) {
                model.addAttribute("invoiceColms", Utility.parseInvoiceColumns(ownerInfo.getInvoiceColms()));
            }

            LOGGER.info("Detailed invoice page retrieved successfully for customer ID: {} and invoice number: {}", custId, invoiceNo);
            return (ownerInfo != null && "A4".equals(ownerInfo.getInvoiceType())) ? "invoiceindetails" : "invoice";

        } catch (Exception e) {
            LOGGER.error("Error retrieving invoice details", e);
            model.addAttribute("error", "Error loading invoice details: " + e.getMessage());
            return ERROR_PAGE;
        }
    }

    private void populateInvoiceViewModel(Model model, InvoiceDetails itemDetails, CustProfile profile,
                                          HttpServletRequest request) {
        model.addAttribute("profile", profile);
        model.addAttribute("date", itemDetails.getDate());
        model.addAttribute("biller", itemDetails.getCreatedBy());
        model.addAttribute("invoiceNo", itemDetails.getInvoiceId());

        List<ItemDetails> items = itemRepository
                .findByInvoiceNoAndCustIdAndStatusOrderByItemNoAsc(
                        itemDetails.getInvoiceId(),
                        itemDetails.getCustId(),
                        true
                );
        String ownerId = Utility.getOwnerIdFromSession(request);
        OwnerInfo existingInfo = ownerInfoRepository.findById(ownerId)
                .orElseThrow(() -> new RuntimeException("Owner info not found"));

     if( existingInfo.getInvoiceColms().contains("BRAND")){
         for (ItemDetails item : items) {
             String updatedName = Utility.buildProductNameWithoutBrand(item.getDescription());
             item.setDescription(updatedName);
         }

     }



        model.addAttribute("totalQty", itemDetails.getTotQty());
        model.addAttribute("totalAmout", itemDetails.getTotInvoiceAmt());
        model.addAttribute("items", items);
        model.addAttribute("invoiceTime", itemDetails.getDate());
        model.addAttribute("advamount", itemDetails.getAdvanAmt());
        model.addAttribute("currentinvoiceitems", itemDetails);
    }

    @GetMapping("/get-bal-credit-page/{custId}")
    public String getBalanceCreditPage(@PathVariable String custId, Model model) {
        LOGGER.info("Retrieving balance credit page for customer ID: {}", custId);

        try {
            CustProfile profile = custProfileRepository.findById(custId)
                    .orElseThrow(() -> new RuntimeException(CUSTOMER_NOT_FOUND_MSG));

            model.addAttribute("profile", profile);
            model.addAttribute("date", getCurrentDateOtherFormat());
            List<BalanceDeposite> balanceDeposits = balanceDepositeRepository.findByCustId(profile.getId());
            model.addAttribute("balanceDeposits", balanceDeposits);

            LOGGER.info("Balance credit page retrieved successfully for customer ID: {}", custId);
            return "deposit";

        } catch (Exception e) {
            LOGGER.error("Error retrieving balance credit page", e);
            model.addAttribute("error", "Error loading balance credit page: " + e.getMessage());
            return ERROR_PAGE;
        }
    }

    @GetMapping("/get-bal-credit-receipt/{slipNo}")
    public String getBalanceCreditReceipt(Model model, HttpSession session, @PathVariable String slipNo) {
        LOGGER.info("Retrieving balance credit receipt for slip: {}", slipNo);

        try {
            OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");

            BalanceDeposite balanceDeposite = balanceDepositeRepository.findById(slipNo)
                    .orElseThrow(() -> new RuntimeException("Receipt not found"));

            Optional<CustProfile> profileOpt = custProfileRepository.findById(balanceDeposite.getCustId());
            CustProfile profile = profileOpt.orElse(new CustProfile());

            if (profileOpt.isPresent()) {
                profile.setCurrentOusting(balanceDeposite.getCurrentOusting() - balanceDeposite.getAdvAmt());
            }

            model.addAttribute("profile", profile);
            model.addAttribute("balanceDeposite", balanceDeposite);
            model.addAttribute("AMOUNT_WORD", AmountInWordUtility.convertToWords(balanceDeposite.getAdvAmt()));
            model.addAttribute("ownerInfo", ownerInfo);

            LOGGER.info("Balance credit receipt retrieved successfully for slip: {}", slipNo);

            return "A4".equals(ownerInfo.getInvoiceType()) ? "payment-receipt" : "payment-receipt-th";


        } catch (Exception e) {
            LOGGER.error("Error retrieving balance credit receipt", e);
            model.addAttribute("error", "Error loading receipt: " + e.getMessage());
            return ERROR_PAGE;
        }
    }

    // PDF export methods
    @GetMapping("/cust-history")
    public void getCustomerHistoryPDF(HttpServletRequest request, HttpSession session,
                                      HttpServletResponse response) throws Exception {
        String custId = request.getParameter("custid");
        if (custId == null || custId.trim().isEmpty()) {
            throw new IllegalArgumentException("Customer ID is required");
        }

        CustProfile profile = custProfileRepository.findById(custId)
                .orElseThrow(() -> new IllegalArgumentException(CUSTOMER_NOT_FOUND_MSG));

        OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");
        List<InvoiceDetails> details = invoiceDetailsRepository.findByCustId(custId);
        List<BalanceDeposite> balanceDeposits = balanceDepositeRepository.findByCustId(custId);

        setupPdfResponse(response, profile.getCustName().replaceAll(" ", "_"));

        PdfGenerator generator = new PdfGenerator();
        generator.generateInvoiceHistory(profile, response, ownerInfo, details, balanceDeposits);
    }

    @GetMapping("/export-statement-file")
    public void generateStatementPdfFile(HttpServletRequest request, HttpServletResponse response,
                                         HttpSession session) throws Exception {
        OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");
        String currentDateTime = getCurrentDate();

        setupPdfResponse(response, ownerInfo.getShopName().replaceAll(" ", "_"));

        List<InvoiceDetails> invoiceDetails = invoiceDetailsRepository.findByOwnerIdAndDate(
                ownerInfo.getOwnerId(), Utility.getDate(currentDateTime));
        List<BalanceDeposite> balanceDeposites = balanceDepositeRepository.findByOwnerIdAndDate(
                ownerInfo.getOwnerId(), Utility.getDate(currentDateTime));

        PdfGenerator generator = new PdfGenerator();
        generator.generateStatement(invoiceDetails, balanceDeposites, response, ownerInfo, currentDateTime);
    }

    @GetMapping("/export-statement-file-date")
    public void generateStatementPdfFileByDate(HttpServletRequest request, HttpSession session,
                                               HttpServletResponse response,
                                               @ModelAttribute("DATERANGE") DateRange dateRange) throws Exception {
        String ownerId = Utility.getOwnerIdFromSession(request);
        OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");

        String currentDateTime = getCurrentDate();
        String filename = ownerInfo.getShopName() + "_" + currentDateTime + ".pdf";
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        LocalDate startDate = LocalDate.parse(dateRange.getStartDate(),
                DateTimeFormatter.ofPattern(YYYY_MM_DD_FORMAT));
        LocalDate endDate = LocalDate.parse(dateRange.getEndDate(),
                DateTimeFormatter.ofPattern(YYYY_MM_DD_FORMAT));
        String dateRange1 = dateRange.getStartDate() + "--" + dateRange.getEndDate();

        List<InvoiceDetails> records;
        List<BalanceDeposite> balanceDeposits;

        if (startDate.equals(endDate)) {
            records = invoiceDetailsRepository.findByOwnerIdAndDate(ownerId, startDate);
            balanceDeposits = balanceDepositeRepository.findByOwnerIdAndDate(ownerId, startDate);
        } else {
            records = invoiceDetailsRepository.findByDateBetweenAndOwnerId(startDate, endDate, ownerId);
            balanceDeposits = balanceDepositeRepository.findByDateBetweenAndOwnerId(startDate, endDate, ownerId);
        }

        PdfGenerator generator = new PdfGenerator();
        generator.generateStatement(records, balanceDeposits, response, ownerInfo, dateRange1);
    }

    private void setupPdfResponse(HttpServletResponse response, String baseFilename) {
        response.setContentType("application/pdf");
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MMM-dd");
        String currentDateTime = dateFormat.format(new Date());
        String headerValue = "attachment; filename=\"" + baseFilename + "_" + currentDateTime + ".pdf\"";
        response.setHeader("Content-Disposition", headerValue);
    }

    // Document upload method
    @PostMapping("/upload-invoice-pdf")
    public ModelAndView uploadDocuments(@ModelAttribute("DOCSUP") DocUplod docUplod)
            throws UnsupportedEncodingException {
        LOGGER.info("Uploading invoice PDF for invoice number: {}", docUplod.getInvoiceNo());
        ModelAndView modelAndView = new ModelAndView();

        try {
            String fileName = docUplod.getFile().getOriginalFilename();
            LOGGER.info("File name: {}", fileName);

            InvoiceDetails details = invoiceDetailsRepository.findById(docUplod.getInvoiceNo())
                    .orElseThrow(() -> new RuntimeException("Invoice not found"));

            String directory = "D:\\DWIL\\" + details.getCustId() + "\\";
            File dir = new File(directory);
            if (!dir.exists() && !dir.mkdirs()) {
                throw new IOException("Could not create directory: " + directory);
            }

            String path = directory + fileName;
            LOGGER.info("File path: {}", path);

            docUplod.getFile().transferTo(new File(path));
            LOGGER.info("File uploaded successfully to path: {}", path);

            details.setFilePath(Base64.getEncoder().encodeToString(path.getBytes(StandardCharsets.UTF_8)));
            invoiceDetailsRepository.save(details);

            List<InvoiceDetails> invoices = invoiceDetailsRepository.findAll();
            modelAndView.addObject("invoices", invoices);
            modelAndView.setViewName(INVOICE_SEARCH_VIEW);

        } catch (Exception e) {
            LOGGER.error("Error uploading file", e);
            modelAndView.addObject("error", "Error uploading file: " + e.getMessage());
            modelAndView.setViewName(ERROR_PAGE);
        }

        return modelAndView;
    }

    @GetMapping("/download-invoice/{path}")
    public void downloadInvoice(@PathVariable String path, HttpServletResponse response) {
        LOGGER.info("Downloading invoice from encoded path");

        try {
            byte[] decoded = Base64.getDecoder().decode(path);
            String decodedPath = new String(decoded, StandardCharsets.UTF_8);

            File fileToDownload = new File(decodedPath);
            if (!fileToDownload.exists()) {
                throw new FileNotFoundException("File not found: " + decodedPath);
            }

            try (InputStream inputStream = new FileInputStream(fileToDownload)) {
                response.setContentType("application/force-download");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + fileToDownload.getName() + "\"");
                IOUtils.copy(inputStream, response.getOutputStream());
                response.flushBuffer();
            }

            LOGGER.info("Invoice downloaded successfully from path: {}", decodedPath);

        } catch (Exception e) {
            LOGGER.error("Error downloading invoice", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // Customer update method
    @GetMapping("/update-customer/{custId}")
    public String getCustomer(@PathVariable String custId, Model model) {
        LOGGER.info("Updating customer profile for ID: {}", custId);

        try {
            model.addAttribute("financialYear", getCurrentFullFinancialYear());
            CustProfile profile = custProfileRepository.findById(custId)
                    .orElseThrow(() -> new RuntimeException(CUSTOMER_NOT_FOUND_MSG));

            model.addAttribute("profile", profile);
            LOGGER.info("Customer profile updated successfully for ID: {}", custId);
            return "customer-profile";

        } catch (Exception e) {
            LOGGER.error("Error updating customer profile", e);
            model.addAttribute("error", "Error loading customer profile: " + e.getMessage());
            return ERROR_PAGE;
        }
    }

    // Additional search methods
    @GetMapping("/search")
    @ResponseBody
    public List<Map<String, Object>> searchCustomers(@RequestParam("query") String query,
                                                     HttpServletRequest request) {
        LOGGER.info("Searching customers with query: {}", query);
        Pageable pageable = PageRequest.of(0, 12, Sort.by("custName").ascending());
        String ownerId = Utility.getOwnerIdFromSession(request);

        Page<CustProfile> customers = getCustomerPage(ownerId, query, pageable);

        LOGGER.info("Found {} customers for search query: {}", customers.getTotalElements(), query);
        return customers.stream()
                .map(this::mapCustomerToResponse)
                .collect(Collectors.toList());
    }

    @GetMapping("/search-invoice")
    @ResponseBody
    public List<Map<String, Object>> searchInvoice(@RequestParam("query") String query,
                                                   HttpServletRequest request) {
        LOGGER.info("Searching invoices with query: {}", query);
        Pageable pageable = PageRequest.of(0, 100, Sort.by("invoiceId").descending());
        String ownerId = Utility.getOwnerIdFromSession(request);

        Page<InvoiceDetails> invoiceDetailsPage;

        if (query.matches(".*\\d.*")) {
            LOGGER.info("Query contains digits, searching by invoiceId");
            invoiceDetailsPage = invoiceDetailsRepository.findByOwnerIdAndInvoiceIdContainingIgnoreCase(
                    ownerId, query, pageable);
        } else {
            LOGGER.info("Query does not contain digits, searching by custName");
            invoiceDetailsPage = invoiceDetailsRepository.findByOwnerIdAndCustNameContainingIgnoreCase(
                    ownerId, query, pageable);
        }

        LOGGER.info("Found {} invoices for search query: {}", invoiceDetailsPage.getTotalElements(), query);
        return invoiceDetailsPage.stream()
                .map(this::mapInvoiceDetailToResponse)
                .collect(Collectors.toList());
    }

    private Map<String, Object> mapInvoiceDetailToResponse(InvoiceDetails invoice) {
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
    }

    // Legacy methods with improved error handling
    @GetMapping("/get-all-invoice-fy")
    public String getAllInvoiceListByFY(@RequestParam("fy") String fy, Model model,
                                        HttpServletRequest request) {
        LOGGER.info("Retrieving all invoices for financial year: {}", fy);

        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            List<InvoiceDetails> invoices = invoiceDetailsRepository
                    .getByInvoiceIdContainingIgnoreCaseAndOwnerIdOrderByDateDesc(fy, ownerId);

            model.addAttribute("invoices", invoices);
            model.addAttribute("fy", fy);

            LOGGER.info("Invoices retrieved successfully for financial year: {}", fy);
            return INVOICE_SEARCH_VIEW;

        } catch (Exception e) {
            LOGGER.error("Error retrieving invoices for FY: {}", fy, e);
            model.addAttribute("error", "Error retrieving invoices: " + e.getMessage());
            return ERROR_PAGE;
        }
    }

    @GetMapping("/get-all-products")
    public String getAllProductList(Model model, HttpServletRequest request) {
        LOGGER.info("Retrieving all products");

        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            return loadProductsView(model, ownerId);

        } catch (Exception e) {
            LOGGER.error("Error retrieving products", e);
            model.addAttribute("error", "Error retrieving products: " + e.getMessage());
            return ERROR_PAGE;
        }
    }

    // Utility method for date conversion
    public static String convertDateFormat(String inputDate) {
        if (inputDate == null || inputDate.trim().isEmpty()) {
            return null;
        }

        try {
            SimpleDateFormat inputFormat = new SimpleDateFormat(YYYY_MM_DD_FORMAT);
            Date tempDate = inputFormat.parse(inputDate);
            SimpleDateFormat outputFormat = new SimpleDateFormat(DD_MM_YYYY_FORMAT);
            return outputFormat.format(tempDate);
        } catch (ParseException ex) {
            LOGGER.error("Error parsing date: {}", inputDate, ex);
            return inputDate; // Return original if parsing fails
        }
    }

    public static Date parseDate(String dateInString) {
        if (dateInString == null || dateInString.trim().isEmpty()) {
            return null;
        }

        SimpleDateFormat formatter = new SimpleDateFormat(DD_MM_YYYY_FORMAT);
        try {
            return formatter.parse(dateInString);
        } catch (ParseException e) {
            LOGGER.error("Error parsing date: {}", dateInString, e);
            return null;
        }
    }
}