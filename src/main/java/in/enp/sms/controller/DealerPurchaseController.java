package in.enp.sms.controller;

import in.enp.sms.entities.DealerInfo;
import in.enp.sms.entities.Product;
import in.enp.sms.entities.Purchase;
import in.enp.sms.entities.PurchaseItem;
import in.enp.sms.pojo.DealerPayment;
import in.enp.sms.pojo.PurchaseItemRequest;
import in.enp.sms.repository.ProductRepository;
import in.enp.sms.service.DealerService;
import in.enp.sms.service.PurchaseItemService;
import in.enp.sms.service.PurchaseService;
import in.enp.sms.utility.Utility;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
@RequestMapping("/dealers")
public class DealerPurchaseController {

    @Autowired
    private DealerService  dealerService;

    @Autowired
    private PurchaseService purchaseService;

    @Autowired
    private PurchaseItemService purchaseItemService;

    @Autowired
    private ProductRepository productService;



    @GetMapping("/info")
    public String addDealerForm(Model model , HttpServletRequest request) {
        model.addAttribute("dealer", new DealerInfo());
        model.addAttribute("dealers", dealerService.findByOwnerIdAndStatusOrderByLastModifiedDateDesc(Utility.getOwnerIdFromSession(request),"ACTIVE"));
        return "dealer";
    }



    /**
     * View dealer details with option to create purchase entry
     */
    @PostMapping("/view-dealer/{dealerId}")
    public String viewDealerDetails(
            @PathVariable String dealerId,
            @RequestParam(value = "billNo", required = false) String purchaseNo,
            Model model,
            HttpServletRequest request) {

        // Get Owner ID from session
        String ownerId = Utility.getOwnerIdFromSession(request);

        // Add dropdown data
        model.addAttribute("dropdown", productService.findByOwnerId(ownerId));

        // Fetch the dealer by Owner ID and Dealer ID
        Optional<DealerInfo> dealerOpt = dealerService.findByOwnerIdAndId(ownerId, dealerId);
        if (!dealerOpt.isPresent()) {
            model.addAttribute("error", "Dealer not found");
            return "redirect:/dealers/list";
        }

        DealerInfo dealer = dealerOpt.get();
        model.addAttribute("dealer", dealer);

        // Fetch purchase history
        List<Purchase> purchaseHistory = purchaseService.findByDealerId(dealerId);
        model.addAttribute("purchases", purchaseHistory);

        List<PurchaseItem> purchaseItems = purchaseItemService.findByPurchaseNoAndDealerIdAndStatus(purchaseNo,dealerId,false);
        model.addAttribute("purchaseItems", purchaseItems);


        // Add invoice and item count info
        model.addAttribute("itemNo", purchaseItems.size()+1);
        model.addAttribute("purchaseNo", purchaseNo != null ? purchaseNo : "");

        // Return the combined view
        return "viewdealerinfo"; // name of the JSP/Thymeleaf page
    }


    /**
     * Open create purchase entry form
     */
    @GetMapping("/create-purchase/{dealerId}")
    public String createPurchaseForm(@PathVariable String dealerId, Model model) {
        DealerInfo dealer = dealerService.findById(dealerId);

        if (dealer == null) {
            model.addAttribute("error", "Dealer not found");
            return "redirect:/dealers/list";
        }

        // Generate new purchase number
        String purchaseNo = purchaseService.generatePurchaseNumber();

        // Get current date
        String currentDate = LocalDate.now().format(DateTimeFormatter.ofPattern("dd-MM-yyyy"));

        // Get existing items for this purchase (if any)
        List<PurchaseItem> purchaseItems = purchaseItemService.findByPurchaseNo(purchaseNo);

        // Calculate next item number
        int itemNo = purchaseItems.size() + 1;

        model.addAttribute("dealer", dealer);
        model.addAttribute("purchaseNo", purchaseNo);
        model.addAttribute("date", currentDate);
        model.addAttribute("purchaseItems", purchaseItems);
        model.addAttribute("itemNo", itemNo);

        return "create-purchase";
    }

    /**
     * Add item to purchase (AJAX)
     */
    @PostMapping("/add-purchase-item")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addPurchaseItem(@RequestBody PurchaseItemRequest request) {
        Map<String, Object> response = new HashMap<>();

        try {
            // Validate input
            if (request.getProductId() == null || request.getQuantity() <= 0) {
                response.put("status", "error");
                response.put("message", "Invalid product or quantity");
                return ResponseEntity.badRequest().body(response);
            }

            // Create purchase item
            PurchaseItem item = new PurchaseItem();
            item.setId(UUID.randomUUID().toString());
            item.setPurchaseNo(request.getPurchaseNo());
            item.setDealerId(request.getDealerId());
            item.setItemNo(request.getItemNo());
            item.setProductId(request.getProductId());
            item.setProductName(request.getProductName());
            item.setBatchNo(request.getBatchNo());
            item.setQuantity(request.getQuantity());
            item.setRate(request.getRate());
            item.setStatus(false);
            item.setGstPercent(request.getGstPercent());

            // Calculate amounts
            BigDecimal baseAmount = request.getRate().multiply(new BigDecimal(request.getQuantity()));
            BigDecimal gstAmount = baseAmount.multiply(request.getGstPercent()).divide(new BigDecimal(100));
            BigDecimal totalAmount = baseAmount.add(gstAmount);

            item.setGstAmount(gstAmount);
            item.setTotalAmount(totalAmount);
            item.setCreatedAt(new Date());

            // Save item
            purchaseItemService.save(item);

            // Prepare response
            response.put("status", "success");
            response.put("message", "Product added successfully");

            Map<String, Object> itemData = new HashMap<>();
            itemData.put("id", item.getId());
            itemData.put("itemNo", item.getItemNo());
            itemData.put("productName", item.getProductName());
            itemData.put("batchNo", item.getBatchNo());
            itemData.put("quantity", item.getQuantity());
            itemData.put("rate", item.getRate());
            itemData.put("gstPercent", item.getGstPercent());
            itemData.put("gstAmount", item.getGstAmount());
            itemData.put("totalAmount", item.getTotalAmount());

            response.put("item", itemData);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Error adding product: " + e.getMessage());
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Delete purchase item (AJAX)
     */
    @DeleteMapping("/delete-purchase-item")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deletePurchaseItem(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();

        try {
            String itemId = request.get("itemId");

            if (itemId == null || itemId.isEmpty()) {
                response.put("status", "error");
                response.put("message", "Invalid item ID");
                return ResponseEntity.badRequest().body(response);
            }

            purchaseItemService.deleteById(itemId);

            response.put("status", "success");
            response.put("message", "Item deleted successfully");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Error deleting item: " + e.getMessage());
            return ResponseEntity.noContent().build();
        }
    }

    /**
     * Save complete purchase entry
     */
    @PostMapping("/save-purchase")
    public String savePurchase(@RequestParam String dealerId,
                               @RequestParam String purchaseNo,
                               @RequestParam String dealerInvoiceNo,
                               @RequestParam String invoiceDate,
                               @RequestParam(required = false) String notes,
                               @RequestParam BigDecimal totalAmount,
                               @RequestParam BigDecimal totalGst,
                               @RequestParam int totalItems,
                               Model model) {
        try {
            // Get all items for this purchase
            List<PurchaseItem> items = purchaseItemService.findByPurchaseNo(dealerInvoiceNo);

            if (items.isEmpty()) {
                model.addAttribute("error", "No items found for this purchase");
                return "redirect:/dealers/create-purchase/" + dealerId;
            }

            items.forEach(item -> item.setStatus(true));  // update each item’s status

            purchaseItemService.saveAll(items);

            // Create purchase record
            Purchase purchase = new Purchase();
            purchase.setId(UUID.randomUUID().toString());
            purchase.setPurchaseNo(purchaseNo);
            purchase.setDealerId(dealerId);
            purchase.setDealerInvoiceNo(dealerInvoiceNo);
            purchase.setInvoiceDate(LocalDate.parse(invoiceDate));
            purchase.setTotalItems(totalItems);
            purchase.setTotalAmount(totalAmount);
            purchase.setTotalGst(totalGst);
            purchase.setNotes(notes);
            purchase.setStatus("COMPLETED");
            purchase.setCreatedAt(new Date());

            // Save purchase
            purchaseService.save(purchase);

            // Update dealer balance
            DealerInfo dealer = dealerService.findById(dealerId);
            BigDecimal newBalance = BigDecimal.valueOf(dealer.getBalanceAmount())
                    .add(totalAmount);
            dealer.setBalanceAmount(newBalance.doubleValue());
            dealer.setTotalAmount(dealer.getTotalAmount()+newBalance.doubleValue());
            dealerService.update(dealer);

            // Update product stock
            for (PurchaseItem item : items) {
                Optional<Product> existingProductOpt =
                        productService.findByProductIdAndBatchNo(Long.valueOf(item.getProductId()), item.getBatchNo());

                BigDecimal itemTotalAmount = item.getTotalAmount();
                double totalAmountAsDouble = itemTotalAmount.doubleValue();

                if (existingProductOpt.isPresent()) {
                    // ✅ Existing batch → update stock
                    Product existingProduct = existingProductOpt.get();
                    existingProduct.setStock(existingProduct.getStock() + item.getQuantity());
                    existingProduct.setDealerPrice(totalAmountAsDouble);
               //     existingProduct.setExpdate(item.getExpDate()); // optional if you track expiry
                    productService.save(existingProduct);
                } else {
                    // ✅ New batch → create new record
                    Product newProduct = new Product();
                    newProduct.setProductName(item.getProductName());
                    newProduct.setBatchNo(item.getBatchNo());
                    newProduct.setStock(item.getQuantity());
                    newProduct.setDealerPrice(totalAmountAsDouble);
               //     newProduct.setExpDate(item.getExpDate()); // optional
                    newProduct.setStatus(true);

                    productService.save(newProduct);
                }
            }


            model.addAttribute("purchase", purchase);
            model.addAttribute("dealer", dealer);
            model.addAttribute("items", items);

            return "purchase-invoice";

        } catch (Exception e) {
            model.addAttribute("error", "Error saving purchase: " + e.getMessage());
            return "redirect:/dealers/create-purchase/" + dealerId;
        }
    }

    /**
     * View purchase details
     */
    @GetMapping("/view-purchase/{purchaseId}")
    public String viewPurchase(@PathVariable String purchaseId, Model model) {
        Purchase purchase = purchaseService.findById(purchaseId);

        if (purchase == null) {
            model.addAttribute("error", "Purchase not found");
            return "redirect:/dealers/list";
        }

        DealerInfo dealer = dealerService.findById(purchase.getDealerId());
        List<PurchaseItem> items = purchaseItemService.findByPurchaseNo(purchase.getPurchaseNo());

        model.addAttribute("purchase", purchase);
        model.addAttribute("dealer", dealer);
        model.addAttribute("items", items);

        return "dealers/view-purchase";
    }

    /**
     * Get purchase invoice (for printing/download)
     */
    @GetMapping("/purchase-invoice/{purchaseId}")
    public String getPurchaseInvoice(@PathVariable String purchaseId, Model model) {
        Purchase purchase = purchaseService.findById(purchaseId);

        if (purchase == null) {
            model.addAttribute("error", "Purchase not found");
            return "redirect:/dealers/list";
        }

        DealerInfo dealer = dealerService.findById(purchase.getDealerId());
        List<PurchaseItem> items = purchaseItemService.findByPurchaseNo(purchase.getPurchaseNo());

        model.addAttribute("purchase", purchase);
        model.addAttribute("dealer", dealer);
        model.addAttribute("items", items);

        return "dealers/purchase-invoice";
    }

    /**
     * List all purchases
     */
    @GetMapping("/purchase-list")
    public String purchaseList(@RequestParam(required = false) String dealerId,
                               @RequestParam(required = false) String fromDate,
                               @RequestParam(required = false) String toDate,
                               Model model) {
        List<Purchase> purchases;

        if (dealerId != null && !dealerId.isEmpty()) {
            purchases = purchaseService.findByDealerId(dealerId);
        } else if (fromDate != null && toDate != null) {
            LocalDate from = LocalDate.parse(fromDate);
            LocalDate to = LocalDate.parse(toDate);
            purchases = purchaseService.findByDateRange(from, to);
        } else {
            purchases = purchaseService.findAll();
        }

        // Get all dealers for filter dropdown
        List<DealerInfo> dealers = dealerService.findAll();

        model.addAttribute("purchases", purchases);
        model.addAttribute("dealers", dealers);

        return "dealers/purchase-list";
    }
}

