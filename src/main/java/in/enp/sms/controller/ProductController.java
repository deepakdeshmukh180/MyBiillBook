package in.enp.sms.controller;

import in.enp.sms.entities.Product;
import in.enp.sms.repository.ProductRepository;
import in.enp.sms.utility.Utility;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    ProductRepository productRepository;

    // --- Main Page ---
    @GetMapping("/manage")
    public String managePage(Model model, HttpServletRequest request) {
        String ownerId = Utility.getOwnerIdFromSession(request);
        List<Product> products = productRepository.findByOwnerId(ownerId);
        model.addAttribute("products", products);
        return "product/manage";
    }

    // --- AJAX Search Products ---
    @GetMapping("/search")
    @ResponseBody
    public ResponseEntity<List<Product>> searchProducts(@RequestParam("query") String query,
                                                        HttpServletRequest request) {
        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            List<Product> results = productRepository.searchProducts(query.toUpperCase(), ownerId);
            return ResponseEntity.ok(results);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // --- AJAX Get Product (for Edit) ---
    @GetMapping("/get-product")
    @ResponseBody
    public ResponseEntity<Product> getProduct(@RequestParam("id") Long productId,
                                              HttpServletRequest request) {
        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            List<Product> products = productRepository.findByProductIdAndOwnerId(productId, ownerId);

            if (products.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(products.get(0));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // --- AJAX Save or Update Product ---
    @PostMapping("/save-or-update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveOrUpdateProduct(

            @RequestParam(value = "productId", defaultValue = "0") Long productId,
            @RequestParam("pname") String pname,
            @RequestParam(value = "company", required = false) String company,
            @RequestParam("quantity") String quantity,
            @RequestParam(value = "batchNo", required = false) String batchNo,

            @RequestParam(value = "expFlag", defaultValue = "false") Boolean expFlag,
            @RequestParam(value = "lowStock", defaultValue = "10") Long lowStock,
            @RequestParam(value = "expdate", required = false) String expdate,

            @RequestParam(value = "mrp", required = false) Double mrp,
            @RequestParam(value = "dealerPrice", required = false) Double dealerPrice,
            @RequestParam(value = "price", required = false) Double price,
            @RequestParam(value = "stock", required = false) Long stock,
            @RequestParam(value = "taxPercentage", required = false) Integer taxPercentage,

            HttpServletRequest request) {

        Map<String, Object> response = new HashMap<String, Object>();
        String ownerId = Utility.getOwnerIdFromSession(request);

        try {
            Product product;
            boolean isNewProduct = (productId == null || productId == 0);

            if (isNewProduct) {
                product = new Product();
                product.setOwnerId(ownerId);
                product.setStatus(true);
            } else {
                List<Product> products =
                        productRepository.findByProductIdAndOwnerId(productId, ownerId);

                if (products == null || products.isEmpty()) {
                    response.put("status", "error");
                    response.put("message", "Product not found");
                    return new ResponseEntity<Map<String, Object>>(response, HttpStatus.NOT_FOUND);
                }
                product = products.get(0);
            }

            // ---------- BASIC FIELDS ----------
            product.setPname(pname.trim());
            product.setCompany(company != null ? company.trim() : "");
            product.setQuantity(quantity.trim());
            product.setBatchNo(batchNo != null ? batchNo.trim().toUpperCase() : "");

            product.setMrp(mrp != null ? mrp : 0.0);
            product.setDealerPrice(dealerPrice != null ? dealerPrice : 0.0);
            product.setPrice(price != null ? price : 0.0);
            product.setStock(stock != null ? stock : 0L);
            product.setLowStock(lowStock != null ? lowStock : 0L);
            product.setTaxPercentage(taxPercentage != null ? taxPercentage : 0);

            // ---------- EXPIRY YES / NO LOGIC ----------
            product.setExpFlag(expFlag);

            if (Boolean.TRUE.equals(expFlag)) {
                if (expdate == null || expdate.trim().isEmpty()) {
                    response.put("status", "error");
                    response.put("message", "Expiry Date is required when Expiry is YES");
                    return new ResponseEntity<Map<String, Object>>(response, HttpStatus.BAD_REQUEST);
                }
                product.setExpdate(expdate.trim());
            } else {
                product.setExpdate(null); // clear date if NO
            }

            // ---------- BUILD PRODUCT NAME ----------
            product.setProductName(buildProductName(product));

            Product savedProduct = productRepository.save(product);

            response.put("status", "success");
            response.put("message", isNewProduct
                    ? "Product added successfully"
                    : "Product updated successfully");
            response.put("product", savedProduct);

            return new ResponseEntity<Map<String, Object>>(response, HttpStatus.OK);

        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Error saving product: " + e.getMessage());
            return new ResponseEntity<Map<String, Object>>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


    // --- AJAX Delete Product ---
    @DeleteMapping("/delete-product-by-id")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteProduct(@RequestParam("productId") Long productId,
                                                             HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();
        String ownerId = Utility.getOwnerIdFromSession(request);

        try {
            List<Product> products = productRepository.findByProductIdAndOwnerId(productId, ownerId);

            if (products.isEmpty()) {
                response.put("status", "error");
                response.put("message", "Product not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }

            Product productToDelete = products.get(0);
            String productName = productToDelete.getProductName();

            productRepository.delete(productToDelete);

            response.put("status", "success");
            response.put("message", "Product deleted successfully: " + productName);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Error deleting product: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    // Helper method to build product name
    private String buildProductName(Product product) {
        StringBuilder productNameBuilder = new StringBuilder(product.getPname().trim().toUpperCase());

        if (product.getCompany() != null && !product.getCompany().trim().isEmpty()) {
            productNameBuilder.append("[").append(product.getCompany().trim().toUpperCase()).append("]");
        }

        productNameBuilder.append("-").append(product.getQuantity().trim().toUpperCase());

        return productNameBuilder.toString();
    }
}