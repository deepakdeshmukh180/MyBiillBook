package in.enp.sms.controller;

import com.google.gson.Gson;
import in.enp.sms.config.AppInfo;
import in.enp.sms.entities.*;
import in.enp.sms.pojo.BalanceDeposite;
import in.enp.sms.pojo.DailySummary;
import in.enp.sms.pojo.ExpProduct;
import in.enp.sms.pojo.OwnerSession;
import in.enp.sms.repository.*;
import in.enp.sms.service.UserService;
import in.enp.sms.utility.MailUtil;
import in.enp.sms.utility.Utility;
import in.enp.sms.validator.UserValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


@Controller
public class UserController {
    @Autowired
    private UserService userService;

    @Autowired
    private UserValidator userValidator;

    @Autowired
    CustProfileRepository custProfileRepository;

    @Autowired
     BalanceDepositeRepository balanceDepositeRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    AppInfo appInfo;

    @Autowired
    InvoiceDetailsRepository invoiceDetailsRepository;

    @Autowired
    private DailyExpenseRepository expenseRepository;


    @Autowired
    ValidityRepository validityRepository;


    @Autowired
    OwnerInfoRepository ownerInfoRepository;

    @Autowired
    ProductRepository productRepository;

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);


    @RequestMapping(value = "/registration", method = RequestMethod.GET)
    public String registration(Model model) {
        model.addAttribute("userForm", new User());
        //verifiedPayment();
        return "welcome";
    }

    @RequestMapping(value = "/demo", method = RequestMethod.GET)
    public String demo(Model model) {
        //  model.addAttribute("userForm", new User());
        //verifiedPayment();
        return "demo";
    }

    @RequestMapping(value = "/onboarding", method = RequestMethod.GET)
    public String onboarding(Model model) {
        model.addAttribute("userForm", new User());
        //verifiedPayment();
        return "onboarding";
    }



    @Autowired
    private UserRepository userRepository;

    @PostMapping("/save-owner-info")
    public String shopRegistration(@ModelAttribute("OWNER_INFO") OwnerInfo ownerInfo, Model model,
                                   HttpServletRequest request, HttpServletResponse response) throws Exception {
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("MMMM dd, yyyy hh:mm a");
        ownerInfo.setDate(formatter.format(date));
        ownerInfo.setOwnerId(UUID.randomUUID().toString());
        ownerInfo.setInvoiceColms("BATCHNO,MRP");
        ownerInfo.setInvoiceType("A4");

        ownerInfoRepository.save(ownerInfo);

        model.addAttribute("userForm", new User());
        ExecutorService emailExecutor = Executors.newSingleThreadExecutor();
        emailExecutor.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    MailUtil.sendMail(ownerInfo.getEmail(),getRegistrationReceiptMailFormate(ownerInfo),"Registration : MY BILL BOOK : "+ownerInfo.getShopName());
                } catch (Exception e) {
               e.printStackTrace();
                }
            }
        });
        emailExecutor.shutdown();
        model.addAttribute("message", "You have register successfully!!");

        return "login";


    }

    private String getRegistrationReceiptMailFormate(OwnerInfo ownerInfo) {
        return "<!DOCTYPE html>\n" +
                "<html lang=\"en\">\n" +
                "<head>\n" +
                "  <meta charset=\"UTF-8\">\n" +
                "  <title>Registration Payment Receipt</title>\n" +
                "  <style>\n" +
                "    body {\n" +
                "      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;\n" +
                "      background-color: #f3f3f3;\n" +
                "      padding: 20px;\n" +
                "      color: #333;\n" +
                "    }\n" +
                "    .container {\n" +
                "      background: #fff;\n" +
                "      padding: 30px;\n" +
                "      max-width: 700px;\n" +
                "      margin: auto;\n" +
                "      border-radius: 12px;\n" +
                "      box-shadow: 0 4px 12px rgba(0,0,0,0.1);\n" +
                "    }\n" +
                "    .header {\n" +
                "      text-align: center;\n" +
                "      margin-bottom: 30px;\n" +
                "    }\n" +
                "    .header h2 {\n" +
                "      color: #28a745;\n" +
                "      margin-bottom: 5px;\n" +
                "    }\n" +
                "    .header p {\n" +
                "      font-size: 1rem;\n" +
                "      color: #555;\n" +
                "    }\n" +
                "    table {\n" +
                "      width: 100%;\n" +
                "      border-collapse: collapse;\n" +
                "      margin-top: 20px;\n" +
                "    }\n" +
                "    th, td {\n" +
                "      padding: 12px 15px;\n" +
                "      border: 1px solid #ccc;\n" +
                "      text-align: left;\n" +
                "    }\n" +
                "    th {\n" +
                "      background-color: #f8f9fa;\n" +
                "      font-weight: bold;\n" +
                "      color: #333;\n" +
                "    }\n" +
                "    .qr-section {\n" +
                "      text-align: center;\n" +
                "      margin-top: 40px;\n" +
                "    }\n" +
                "    .qr-section img {\n" +
                "      width: 180px;\n" +
                "      height: 180px;\n" +
                "      margin-bottom: 10px;\n" +
                "      border: 2px solid #ddd;\n" +
                "      border-radius: 10px;\n" +
                "    }\n" +
                "    .payment-info {\n" +
                "      margin-top: 20px;\n" +
                "      font-size: 1.1rem;\n" +
                "      font-weight: bold;\n" +
                "      text-align: center;\n" +
                "      color: #444;\n" +
                "    }\n" +
                "    .footer {\n" +
                "      text-align: center;\n" +
                "      margin-top: 50px;\n" +
                "      font-size: 0.9em;\n" +
                "      color: #777;\n" +
                "      border-top: 1px solid #ddd;\n" +
                "      padding-top: 15px;\n" +
                "    }\n" +
                "    a {\n" +
                "      color: #007bff;\n" +
                "      text-decoration: none;\n" +
                "    }\n" +
                "    a:hover {\n" +
                "      text-decoration: underline;\n" +
                "    }\n" +
                "  </style>\n" +
                "</head>\n" +
                "<body>\n" +
                "  <div class=\"container\">\n" +
                "    <div class=\"header\">\n" +
                "      <h2>\uD83C\uDF89 My Bill Book : Registration Successful!</h2>\n" +
                "      <p>Thank you for registering with us. Below are your submitted details and payment receipt.</p>\n" +
                "    </div>\n" +
                "\n" +
                "    <table>\n" +
                "      <tr><th colspan=\"2\">Personal Info</th></tr>\n" +
                "      <tr><td>Owner Name</td><td>"+ownerInfo.getOwnerName()+ "</td></tr>\n" +
                "      <tr><td>Mobile Number</td><td>"+ownerInfo.getMobNumber()+ "</td></tr>\n" +
                "\n" +
                "      <tr><th colspan=\"2\">Shop Info</th></tr>\n" +
                "      <tr><td>Shop Name</td><td>"+ownerInfo.getShopName()+ "</td></tr>\n" +
                "      <tr><td>Address</td><td>"+ownerInfo.getAddress()+ "</td></tr>\n" +
                "      <tr><td>Email</td><td>"+ownerInfo.getEmail()+ "</td></tr>\n" +
                "\n" +
                "      <tr><th colspan=\"2\">Documents</th></tr>\n" +
                "      <tr><td>GST Number</td><td>"+ownerInfo.getGstNumber()+ "</td></tr>\n" +
                "      <tr><td>LC Number</td><td>"+ownerInfo.getLcNo()+ "</td></tr>\n" +
                "\n" +
                "      <tr><th colspan=\"2\">Payment Details</th></tr>\n" +
                "      <tr><td>Payment Amount</td><td>₹"+Utility.getPlanOptions(ownerInfo.getPlanDuration())+ "</td></tr>\n" +
                "      <tr><td>Payment Method</td><td>UPI</td></tr>\n" +
                "    </table>\n" +
                "\n" +
                "    <div class=\"payment-info\">\n" +
                "      \uD83D\uDCCC <strong>Bill Payment: ₹"+ Utility.getPlanOptions(ownerInfo.getPlanDuration())+ "</strong>\n" +
                "    </div>\n" +
                "\n" +
                "    <div class=\"qr-section\">\n" +
                "      <h3>\uD83D\uDCB3 Please proceed with payment</h3>\n" +
                "      <p>Scan the QR code below or click the link to complete your payment:</p>\n" +
                "      <img src=\"https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=upi://pay?pa=8180080378@ybl&pn=MyBillBook&am=500&cu=INR\" alt=\"Payment QR Code\">\n" +
                "      <p><strong>UPI Link:</strong> <a href=\"upi://pay?pa=8180080378@ybl&pn=MyBillBook&am="+Utility.getPlanOptions(ownerInfo.getPlanDuration())+"&cu=INR\">Click here to pay</a></p>\n" +
                "      <p>Once payment is received, your account will be activated.</p>\n" +
                "    </div>\n" +
                "\n" +
                "    <div class=\"footer\">\n" +
                "      &copy; 2025 MyBillBook Solution | All rights reserved.\n" +
                "    </div>\n" +
                "  </div>\n" +
                "</body>\n" +
                "</html>\n";

    }


    @RequestMapping(value = "/registration", method = RequestMethod.POST)
    public String registration(@ModelAttribute("userForm") User userForm, BindingResult bindingResult, Model model) {
        userValidator.validate(userForm, bindingResult);

        userForm.setStatus("PENDING");
        userForm.setExpDate(new Date());

        if (bindingResult.hasErrors()) {
            model.addAttribute("error", "Registration is not completed, Please check on 'Registration' tab");
            return "login"; // or return back to "registration" if more appropriate
        }

        userService.save(userForm);
        model.addAttribute("user", userForm);
        model.addAttribute("planOptions", Utility.getPlanOptions());

        return "shop-registration";
    }



    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login(Model model, String error, String logout) {
        model.addAttribute("userForm", new User());
        if (error != null)
            model.addAttribute("error", "Invalid credentials Or Account is expired");

        if (logout != null)
            model.addAttribute("message", "You have been logged out successfully.");

        return "login";
    }


    @RequestMapping(value = {"/", "/welcome"}, method = RequestMethod.GET)
    public ModelAndView getWelcomePage(HttpServletRequest request) throws ParseException {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("index");
       String ownerId = userService.findByUsername(request.getUserPrincipal().getName()).getOwnerId() ;
        HttpSession session = request.getSession();
        session.setAttribute("ownerId", ownerId);
        List<CustProfile> custProfiles = custProfileRepository.findTop5ByOwnerIdOrderByLastModifiedDateDesc(ownerId);
        modelAndView.addObject("custmers", custProfiles);
        modelAndView.addObject("profilecount", custProfiles.size());
        modelAndView.addObject("invoicescount", invoiceDetailsRepository.count());
        modelAndView.addObject("appInfo", appInfo);
        modelAndView.addObject("productList", getExpProductByOwnerId(ownerId));
        modelAndView.addObject("dailySummary", calculateDailySummary(request));
        modelAndView.addObject("daily_expenses", expenseRepository.getDailyTotal(new Date(),ownerId));
        modelAndView.addObject("monthly_expenses",expenseRepository.getCurrentMonthTotal(ownerId));//

        Object[] result = custProfileRepository.findSumsByOwnerId(ownerId);
        if (result != null && result.length > 0 && result[0] instanceof Object[]) {
            Object[] values = (Object[]) result[0];

            Double totalAmount = values[0] instanceof Number ? ((Number) values[0]).doubleValue() : null;
            Double currentOutstanding = values[1] instanceof Number ? ((Number) values[1]).doubleValue() : null;
            Double paidAmount = values[2] instanceof Number ? ((Number) values[2]).doubleValue() : null;
            OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");
            modelAndView.addObject("ownerInfo", ownerInfo);
            modelAndView.addObject("totalAmount", totalAmount);
            modelAndView.addObject("currentOutstanding", currentOutstanding);
            modelAndView.addObject("paidAmount", paidAmount);
        }

        return modelAndView;

    }

    public List<ExpProduct> getExpProductByOwnerId(String ownerIdFromSession) {

        List<ExpProduct> expProducts = new ArrayList<ExpProduct>();

        try {
            List<Product> products =
                    productRepository.findByOwnerIdOrderByExpdateAsc(ownerIdFromSession);

            LocalDate today = LocalDate.now();
            LocalDate threshold = today.plusDays(30);

            for (Product product : products) {

                // ---- SKIP if expiry is disabled ----
                if (product.getExpFlag() == null || !product.getExpFlag()) {
                    continue;
                }

                String expdateStr = product.getExpdate();

                // ---- NULL / EMPTY SAFETY ----
                if (expdateStr == null || expdateStr.trim().isEmpty()) {
                    continue;
                }

                LocalDate expDate;
                try {
                    expDate = LocalDate.parse(expdateStr); // yyyy-MM-dd
                } catch (Exception e) {
                    logger.warn("Invalid expiry date for product: "
                            + product.getProductName());
                    continue;
                }

                // ---- EXPIRY WINDOW CHECK (0–30 days) ----
                if (!expDate.isBefore(today) && !expDate.isAfter(threshold)) {

                    long daysUntilExpiry =
                            ChronoUnit.DAYS.between(today, expDate);

                    expProducts.add(new ExpProduct(
                            product.getProductName(),
                            product.getStock() > 0 ? (int) product.getStock() : 0,
                            (int) daysUntilExpiry
                    ));

                }
            }

        } catch (Exception e) {
            logger.error("Error generating product expiration notification", e);
        }

        return expProducts;
    }


    private String getJsonString1(List<CustProfile> custProfiles) {
        Gson gsonObj = new Gson();
        List<Map<Object, Object>> list = new ArrayList<Map<Object, Object>>();
        for (CustProfile profile : custProfiles) {
            Map<Object, Object> map = new HashMap<Object, Object>();
            if (profile.getCustName().length() >= 10) {
                map.put("label", profile.getCustName().substring(0, 10));
            }
            map.put("y", profile.getTotalAmount());
            list.add(map);
        }
        return gsonObj.toJson(list);
    }


    private String getJsonString2(List<CustProfile> custProfiles) {
        Gson gsonObj = new Gson();
        List<Map<Object, Object>> list = new ArrayList<Map<Object, Object>>();
        for (CustProfile profile : custProfiles) {
            Map<Object, Object> map = new HashMap<Object, Object>();
            if (profile.getCustName().length() >= 10) {
                map.put("label", profile.getCustName().substring(0, 10));
            }
            map.put("y", profile.getPaidAmout());
            list.add(map);
        }
        return gsonObj.toJson(list);
    }

    private String getJsonString3(List<CustProfile> custProfiles) {
        Gson gsonObj = new Gson();
        List<Map<Object, Object>> list = new ArrayList<Map<Object, Object>>();
        for (CustProfile profile : custProfiles) {
            Map<Object, Object> map = new HashMap<Object, Object>();
            if (profile.getCustName().length() >= 10) {
                map.put("label", profile.getCustName().substring(0, 10));
            }
            map.put("y", profile.getCurrentOusting());
            list.add(map);
        }
        return gsonObj.toJson(list);
    }

    public static String getCurretDate() {
        DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        Calendar cal = Calendar.getInstance();
        return dateFormat.format(cal.getTime());

    }

    public static String getCurretDateWithTime() {
        DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        Calendar cal = Calendar.getInstance();
        return dateFormat.format(cal.getTime());

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


    static char[] geek_Password(int len) {
        System.out.println("Generating password using random() : ");


        // A strong password has Cap_chars, Lower_chars,
        // numeric value and symbols. So we are using all of
        // them to generate our password
        String Capital_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String numbers = "0123456789";
        String values = Capital_chars +
                numbers;

        // Using random method
        Random rndm_method = new Random();

        char[] password = new char[len];

        for (int i = 0; i < len; i++) {
            // Use of charAt() method : to get character value
            // Use of nextInt() as it is scanning the value as int
            password[i] =
                    values.charAt(rndm_method.nextInt(values.length()));

        }
        return password;
    }









    @GetMapping("/check-username")
    public @ResponseBody ResponseEntity<Boolean> checkUsername(@RequestParam String username) {
        boolean exists = userService.usernameExists(username);
        return ResponseEntity.ok(exists);
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


    @PostMapping("/reset-password")
    public String processResetPassword(
            @RequestParam("email") String email,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            Model model) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();
        if (!email.equals(username)) {
            model.addAttribute("error", "Please enter your username correct!");
            return "passwordreset";
        }

        // Check if passwords match
        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match!");
            return "passwordreset";
        }

        // Find user by email
        User user = userRepository.findByUsername(email);
        if (user == null) {
            model.addAttribute("error", "No user found with this email.");
            return "passwordreset";
        }

        // Update password
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        model.addAttribute("success", "Password updated successfully! You can now log in.");
        return "passwordreset";
    }






    @PostMapping("/reset-pass")
    public String processPasswordReset(HttpServletRequest request,HttpSession session,
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword, RedirectAttributes redirectAttributes,
            Model model) {
        OwnerSession ownerInfo = (OwnerSession) session.getAttribute("sessionOwner");

        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "Passwords do not match.");
            return "passwordreset";
        }

        // Encode the password before saving
        String encodedPassword = passwordEncoder.encode(newPassword);

        // Update password in DB
        userService.updatePassword(userDetails.getUsername(), encodedPassword);
        ExecutorService emailExecutor = Executors.newSingleThreadExecutor();
        emailExecutor.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    MailUtil.sendMail(ownerInfo.getEmail(),MailUtil.sendPassChangedNotification(ownerInfo , newPassword),"Update : Password Changed - "+ownerInfo.getShopName());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
        emailExecutor.shutdown();
        redirectAttributes.addFlashAttribute("message", "Password updated successfully! Please log in again.");
        session.invalidate();
        return "redirect:/login";
    }

}

