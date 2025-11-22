package in.enp.sms.controller;

import in.enp.sms.entities.Product;
import in.enp.sms.repository.ProductRepository;
import in.enp.sms.utility.Utility;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
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

    // --- AJAX Delete Product ---
    @DeleteMapping("/delete-product-by-id")
    @ResponseBody
    public ResponseEntity<String> ajaxDeleteProduct(@RequestParam("productId") Long productId,
                                                    HttpServletRequest request) {
        String ownerId = Utility.getOwnerIdFromSession(request);
        List<Product> products = productRepository.findByProductIdAndOwnerId(productId, ownerId);

        if (products.isEmpty()) {
            return ResponseEntity.status(404).body("Product not found");
        }

        Product productToDelete = products.get(0);
        productRepository.delete(productToDelete);
        return ResponseEntity.ok("Deleted product: " + productToDelete.getProductName());
    }

    // --- AJAX Get Product (for Edit form fill) ---
    @GetMapping("/get-product")
    @ResponseBody
    public ResponseEntity<Product> ajaxGetProduct(@RequestParam("id") Long productId,
                                                  HttpServletRequest request) {
        String ownerId = Utility.getOwnerIdFromSession(request);
        List<Product> products = productRepository.findByProductIdAndOwnerId(productId, ownerId);

        return products.isEmpty()
                ? ResponseEntity.notFound().build()
                : ResponseEntity.ok(products.get(0));
    }

    // --- AJAX Update Product ---


    @PostMapping("/save-or-update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveOrUpdateProduct(
            @ModelAttribute Product product,
            HttpServletRequest request) {

        Map<String, Object> response = new HashMap<>();
        String ownerId = Utility.getOwnerIdFromSession(request);

        try {
            if (product.getProductId() == 0) {
                // ---- New Product ----
                product.setOwnerId(ownerId);
                product.setProductName(buildProductName(product));
                product.setBatchNo(product.getBatchNo().trim().toUpperCase());
                product.setStatus(true);

                productRepository.save(product);

                response.put("status", "success");
                response.put("message", "New product added: " + product.getProductName());
                return ResponseEntity.ok(response);

            } else {
                // ---- Update Existing ----
                List<Product> products = productRepository.findByProductIdAndOwnerId(product.getProductId(), ownerId);
                if (products.isEmpty()) {
                    response.put("status", "error");
                    response.put("message", "Product not found");
                    return ResponseEntity.status(404).body(response);
                }

                Product old = products.get(0);
                old.setProductName(buildProductName(product));                old.setCompany(product.getCompany());
                old.setQuantity(product.getQuantity());
                old.setBatchNo(product.getBatchNo());
                old.setExpdate(product.getExpdate());
                old.setMrp(product.getMrp());
                old.setDealerPrice(product.getDealerPrice()); // ✅ added
                old.setPrice(product.getPrice());
                old.setStock(product.getStock());
                old.setTaxPercentage(product.getTaxPercentage());

                productRepository.save(old);

                response.put("status", "success");
                response.put("message", "Product updated: " + old.getProductName());
                return ResponseEntity.ok(response);
            }
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "Error saving/updating product: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }



    private String buildProductName(Product product) {
        StringBuilder productNameBuilder = new StringBuilder(product.getPname().trim().toUpperCase());
        if (product.getCompany() != null && !product.getCompany().trim().isEmpty()) {
            productNameBuilder.append("[").append(product.getCompany().trim().toUpperCase()).append("]");
        }
        productNameBuilder.append("-").append(product.getQuantity().trim().toUpperCase());
        return productNameBuilder.toString();
    }

}




