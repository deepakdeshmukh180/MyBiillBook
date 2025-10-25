package in.enp.sms.controller;

import in.enp.sms.config.AppInfo;
import in.enp.sms.entities.*;
import in.enp.sms.pojo.*;
import in.enp.sms.repository.*;
import in.enp.sms.service.*;
import in.enp.sms.utility.Utility;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.*;



@Controller
@RequestMapping("/login")
public class LoginController {

    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

    @Autowired private CustProfileRepository custProfileRepository;
    @Autowired private OwnerInfoRepository ownerInfoRepository;
    @Autowired private DocsService docsService;
    @Autowired private AppInfo appInfo;
    @Autowired private InvoiceDetailsRepository invoiceDetailsRepository;
    @Autowired private BalanceDepositeRepository balanceDepositeRepository;
    @Autowired private ProductRepository productRepository;
    @Autowired private LoginService loginService;

    @Autowired
    InvoiceNoRepository invoiceNoRepository;

    @Autowired
    private MonthlyExpenseSummaryRepository summaryRepository;

    @Autowired
    private DailyExpenseRepository expenseRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserRepository userRepository;

    @Autowired private UserService userService;

    @GetMapping("/home")
    public ModelAndView getWelcomePage(HttpServletRequest request) {
        ModelAndView modelAndView = new ModelAndView();
        try {
            HttpSession session = request.getSession();
            String ownerId = Utility.getOwnerIdFromSession(request);
            OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");
            session.setAttribute("ownerId", ownerId);
            Object[] result = custProfileRepository.findSumsByOwnerId(ownerId);
            if (result != null && result.length > 0 && result[0] instanceof Object[]) {
                Object[] values = (Object[]) result[0];

                Double totalAmount = values[0] instanceof Number ? ((Number) values[0]).doubleValue() : null;
                Double currentOutstanding = values[1] instanceof Number ? ((Number) values[1]).doubleValue() : null;
                Double paidAmount = values[2] instanceof Number ? ((Number) values[2]).doubleValue() : null;

                modelAndView.addObject("totalAmount", totalAmount);
                modelAndView.addObject("currentOutstanding", currentOutstanding);
                modelAndView.addObject("paidAmount", paidAmount);
            }


            List<CustProfile> custProfiles = custProfileRepository.findTop5ByOwnerIdOrderByLastModifiedDateDesc(ownerId);
            modelAndView.addObject("dailySummary", calculateDailySummary(request));

            modelAndView.setViewName("index");
            modelAndView.addObject("custmers", custProfiles);
            modelAndView.addObject("custmerCount",   custProfileRepository.countByOwnerId(ownerId));
            modelAndView.addObject("invoicesCount", invoiceDetailsRepository.countByOwnerId(ownerId));
            modelAndView.addObject("ownerInfo", ownerInfo);
            modelAndView.addObject("date", getCurretDate());
            modelAndView.addObject("productList", getExpProductByOwnerId(ownerId));
            modelAndView.addObject("daily_expenses", expenseRepository.getDailyTotal(new Date(),ownerId));
            modelAndView.addObject("monthly_expenses",expenseRepository.getCurrentMonthTotal(ownerId));//


            //modelAndView.addObject("dailyExpenses",expenseRepository.findByDateAndOwnerIdOrderByCreatedAtDesc(new Date(),ownerId));
           // modelAndView.addObject("monthlyExpenses",summaryRepository.findByOwnerIdOrderByMonth(ownerId));


        } catch (Exception e) {
            logger.error("Error while loading welcome page: ", e);
            modelAndView.setViewName("error");
            modelAndView.addObject("errorMessage", "Failed to load dashboard.");
        }
        return modelAndView;
    }

    @PostMapping("/save-profile-details")
    public String saveCustomerProfile(HttpServletRequest request,HttpSession session,
                                      @ModelAttribute("CustProfile") CustProfile custProfile,
                                      Model model) {
        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            if (ownerId == null) {
                model.addAttribute("msg", "Owner session expired. Please login again.");
                return "index";
            }
            OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");

            model.addAttribute("ownerInfo", ownerInfo);
            Object[] result = custProfileRepository.findSumsByOwnerId(ownerId);
            if (result != null && result.length > 0 && result[0] instanceof Object[]) {
                Object[] values = (Object[]) result[0];

                Double totalAmount = values[0] instanceof Number ? ((Number) values[0]).doubleValue() : null;
                Double currentOutstanding = values[1] instanceof Number ? ((Number) values[1]).doubleValue() : null;
                Double paidAmount = values[2] instanceof Number ? ((Number) values[2]).doubleValue() : null;

                model.addAttribute("totalAmount", totalAmount);
                model.addAttribute("currentOutstanding", currentOutstanding);
                model.addAttribute("paidAmount", paidAmount);
            }
            custProfile.setOwnerId(ownerId);
            custProfile.setStatus("ACTIVE");
            if (custProfile.getCurrentOusting() > 0) {
                custProfile.setTotalAmount(custProfile.getCurrentOusting());
            }

            custProfile.setCustName(custProfile.getCustName().trim().toUpperCase());
            String formattedPhone = custProfile.getPhoneNo().startsWith("+91") ?
                    custProfile.getPhoneNo() : "+91" + custProfile.getPhoneNo().trim();
            custProfile.setPhoneNo(formattedPhone);

            List<CustProfile> existingProfiles = custProfileRepository.findByPhoneNoAndOwnerId(formattedPhone, ownerId);
            if (!existingProfiles.isEmpty()) {
                model.addAttribute("custmers", existingProfiles);
                model.addAttribute("msg", "Customer already exists!");
                return "index";
            }
            custProfile.setId(UUID.randomUUID().toString().toUpperCase());
            custProfile.setAddress(custProfile.getAddress().trim().toUpperCase());
            custProfileRepository.save(custProfile);
            addBalanceTransaction(custProfile, request);

            List<CustProfile> updatedProfiles = custProfileRepository.findByPhoneNoAndOwnerId(formattedPhone, ownerId);
            model.addAttribute("custmers", updatedProfiles);
            model.addAttribute("msg", "Customer added successfully!");
        } catch (Exception e) {
            logger.error("Error saving customer profile: ", e);
            model.addAttribute("msg", "Error occurred while saving customer profile.");
        }
        String ownerId= Utility.getOwnerIdFromSession(request);
        model.addAttribute("productList", getExpProductByOwnerId(ownerId));
        model.addAttribute("dailySummary", calculateDailySummary(request));
        model.addAttribute("daily_expenses", expenseRepository.getDailyTotal(new Date(),ownerId));
        model.addAttribute("monthly_expenses",expenseRepository.getCurrentMonthTotal(ownerId));//


        return "index";
    }

    @PostMapping("/update-profile-details")
    public String updateCustProfile(HttpServletRequest request,
                                    @ModelAttribute("CustProfile") CustProfile custProfile,
                                    Model model) {
        try {
          String ownerId=  Utility.getOwnerIdFromSession(request);
            CustProfile profile = custProfileRepository.getOne(custProfile.getId());
            profile.setCustName(custProfile.getCustName());
            profile.setAddress(custProfile.getAddress());
            profile.setEmail(custProfile.getEmail());
            profile.setPhoneNo(custProfile.getPhoneNo());
            profile.setAddharNo(custProfile.getAddharNo());
            custProfileRepository.save(profile);
            Object[] result = custProfileRepository.findSumsByOwnerId(profile.getOwnerId());
            if (result != null && result.length > 0 && result[0] instanceof Object[]) {
                Object[] values = (Object[]) result[0];

                Double totalAmount = values[0] instanceof Number ? ((Number) values[0]).doubleValue() : null;
                Double currentOutstanding = values[1] instanceof Number ? ((Number) values[1]).doubleValue() : null;
                Double paidAmount = values[2] instanceof Number ? ((Number) values[2]).doubleValue() : null;

                model.addAttribute("totalAmount", totalAmount);
                model.addAttribute("currentOutstanding", currentOutstanding);
                model.addAttribute("paidAmount", paidAmount);
            }


            model.addAttribute("msg", "Customer :" + custProfile.getCustName() + " updated successfully !!");
            model.addAttribute("custmers", custProfileRepository.findTop5ByOwnerIdOrderByLastModifiedDateDesc(Utility.getOwnerIdFromSession(request)));
            model.addAttribute("ownerInfo", ownerInfoRepository.getOne(ownerId));
            model.addAttribute("productList", getExpProductByOwnerId(ownerId));
            model.addAttribute("daily_expenses", expenseRepository.getDailyTotal(new Date(),ownerId));
            model.addAttribute("monthly_expenses",expenseRepository.getCurrentMonthTotal(ownerId));//

        } catch (Exception e) {
            logger.error("Error updating customer profile: ", e);
            model.addAttribute("msg", "Error occurred while updating customer profile.");
        }
        model.addAttribute("dailySummary", calculateDailySummary(request));


        return "index";
    }

    @PostMapping("/upload-invoice-pdf")
    public ResponseEntity<?> handleFileUpload(@RequestParam("file") MultipartFile file) {
        String fileName = file.getOriginalFilename();
        try {
            File dest = new File("C:\\upload\\" + fileName);
            file.transferTo(dest);
            return ResponseEntity.ok("File uploaded successfully.");
        } catch (Exception e) {
            logger.error("File upload failed for: " + fileName, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("File upload failed.");
        }
    }

    private void addBalanceTransaction(CustProfile profile, HttpServletRequest request) {
        try {
            String ownerId = Utility.getOwnerIdFromSession(request);
            if (ownerId == null || profile == null) return;

            Date now = new Date();
            String createdAt = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(now);
            String transactionId = "TX" + invoiceNoRepository.findByOwnerId(ownerId).getBillNo()	 + new SimpleDateFormat("yyMMddhhmmssSSS").format(now);

            BalanceDeposite balanceDeposite = new BalanceDeposite();
            balanceDeposite.setId(transactionId);
            balanceDeposite.setCustId(profile.getId());
            balanceDeposite.setCustName(profile.getCustName());
            balanceDeposite.setDescription("OPENING BALANCE");
            balanceDeposite.setModeOfPayment("NA");
            balanceDeposite.setDate(LocalDate.now());
            balanceDeposite.setTotalAmount(profile.getTotalAmount());
            balanceDeposite.setPaidAmout(profile.getPaidAmout());
            balanceDeposite.setCurrentOusting(profile.getCurrentOusting());
            balanceDeposite.setCreatedBy(SecurityContextHolder.getContext().getAuthentication().getName());
            balanceDeposite.setCreatedAt(createdAt);
            balanceDeposite.setOwnerId(ownerId);
            balanceDepositeRepository.save(balanceDeposite);
            HttpSession session = request.getSession();
           OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");
           // sendMailCustomer(balanceDeposite, profile, ownerInfo);

        } catch (Exception e) {
            logger.error("Error adding balance transaction: ", e);
        }
    }

    public static String getCurretDate() {
        return new SimpleDateFormat("dd/MM/yyyy").format(Calendar.getInstance().getTime());
    }





    public List<ExpProduct> getExpProductByOwnerId(String ownerIdFromSession) {
        List<ExpProduct> expProducts = new ArrayList<>();

        try {
            List<Product> products = productRepository.findByOwnerIdOrderByExpdateAsc(ownerIdFromSession);
            LocalDate today = LocalDate.now();
            LocalDate threshold = today.plusDays(30);
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            for (Product product : products) {
                String expDateStr = product.getExpdate();

                if (expDateStr == null || expDateStr.trim().isEmpty()) {

                    logger.warn("Skipping product {} due to null/empty expDate", product.getProductName());
                    continue;
                }

                LocalDate expDate;
                try {
                    expDate = LocalDate.parse(expDateStr, formatter);
                } catch (DateTimeParseException ex) {
                    logger.error("Invalid expDate format for product {}: {}", product.getProductName(), expDateStr);
                    continue;
                }

                if (!expDate.isBefore(today) && !expDate.isAfter(threshold)) {
                    long daysUntilExpiry = ChronoUnit.DAYS.between(today, expDate);

                    expProducts.add(new ExpProduct(
                            product.getProductName(),
                            Math.toIntExact(product.getStock()),  // safer than (int)
                            (int) daysUntilExpiry
                    ));
                }
            }
        } catch (Exception e) {
            logger.error("Error generating product expiration notification: ", e);
        }


        return expProducts;
    }

    public DailySummary calculateDailySummary(HttpServletRequest request){
        String ownerId = Utility.getOwnerIdFromSession(request);
        LocalDate today = LocalDate.now();
        DailySummary dailySummary = new DailySummary();
        List<InvoiceDetails> invoiceDetails = invoiceDetailsRepository.findByOwnerIdAndDate(ownerId, today);
        List<BalanceDeposite> balanceDeposites = balanceDepositeRepository.findByOwnerIdAndDate(ownerId, today);
        dailySummary.setInvoiceCount(invoiceDetails.size());
        dailySummary.setTransactionCount(balanceDeposites.size());

        long totalAmount = Math.round(invoiceDetails.stream()
                .mapToDouble(InvoiceDetails::getTotInvoiceAmt)
                .sum());
        dailySummary.setTotalAmount(totalAmount);



        long totalAdv = Math.round(invoiceDetails.stream()
                .mapToDouble(InvoiceDetails::getAdvanAmt)
                .sum());

        long depositedAmount = Math.round(balanceDeposites.stream()
                .mapToDouble(BalanceDeposite::getAdvAmt)
                .sum());

        long collectedAmount = totalAdv + depositedAmount;

dailySummary.setCollectedAmount(collectedAmount);
dailySummary.setTotalBalanceAmount(totalAmount-collectedAmount);


        return  dailySummary;
    }

    @GetMapping("/password-reset-page")
    public String showResetPasswordForm() {
        return "passwordreset"; // JSP page name without .jsp
    }


}
