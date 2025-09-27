package in.enp.sms.utility;

import in.enp.sms.entities.Product;
import in.enp.sms.entities.User;
import in.enp.sms.pojo.OwnerSession;
import in.enp.sms.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.TimeUnit;

public class Utility {


    @Autowired
    static UserService userService;



    public static String getOwnerIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // Don't create new session
        if (session != null) {
            String ownerId = (String) session.getAttribute("ownerId");
            if (ownerId != null) {
                return ownerId;
            }
        }

        if (request.getUserPrincipal() != null) {
            String username = request.getUserPrincipal().getName();
            // Ideally null-check and log
            User user = userService.findByUsername(username);
            if (user != null && user.getOwnerId() != null) {
                return user.getOwnerId();
            }
        }

        // Return null or throw custom exception if needed
        return null;
    }


    public static Boolean getSuperAdminFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // Don't create new session
        if (session != null) {
            OwnerSession ownerSession = (OwnerSession) session.getAttribute("sessionOwner");
            if (ownerSession != null) {
                return ownerSession.isSuperAdmin();
            }
        }

        // fallback: check directly from DB
        if (request.getUserPrincipal() != null) {
            String username = request.getUserPrincipal().getName();
            User user = userService.findByUsername(username);
            if (user != null) {
                return user.isSuperAdmin();
            }
        }

        return null; // or false if you prefer default
    }


    public static  boolean isSubscriptionExpire(String expDate ) throws ParseException {
       boolean flag = false;
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date expD = dateFormat.parse(expDate);
        Date currD = Calendar.getInstance().getTime();
        long diffInDays =  TimeUnit.MILLISECONDS.toDays(expD.getTime() - currD.getTime());
        if(diffInDays<0){
            flag = true;
        }
        return flag;

    }


    public static Map<Integer, Integer> getPlanOptions() {
        Map<Integer, Integer> planOptions = new LinkedHashMap<>();
        planOptions.put(3, 599);
        planOptions.put(6, 999);
        planOptions.put(9, 1399);
        planOptions.put(12, 1899);
        planOptions.put(24, 2999);
        return planOptions;
    }

    public static int getPlanOptions(int key) {
        Map<Integer, Integer> planOptions = getPlanOptions();
        return planOptions.get(key);
    }



    public static String getProductName(Product product){
        StringBuilder productNameBuilder = new StringBuilder(product.getPname().trim().toUpperCase());
        if (product.getCompany() != null && !product.getCompany().trim().isEmpty()) {
            productNameBuilder.append("[").append(product.getCompany().trim().toUpperCase()).append("]");
        }
        productNameBuilder.append("-").append(product.getQuantity().trim().toUpperCase());
        return productNameBuilder.toString();
    }


    public static String convertToISODate(String inputDate) {
        try {
            SimpleDateFormat inputFormat = new SimpleDateFormat("dd-MMM-yyyy");
            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");

            Date date = inputFormat.parse(inputDate);
            return outputFormat.format(date);
        } catch (ParseException e) {
            e.printStackTrace();  // or handle error as needed
            return null;
        }
    }


    public static LocalDate getDate(String dateString) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDate localDate = LocalDate.parse(dateString, formatter);
        System.out.println("Parsed LocalDate: " + localDate);  // Output: 2025-06-04
        return localDate;
    }

    public static String formatToMonthYear(String inputDate) {
        try {
            // Parse the input date
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date date = inputFormat.parse(inputDate);

            // Format to MMM-yy
            SimpleDateFormat outputFormat = new SimpleDateFormat("MMM-yy");
            String formatted = outputFormat.format(date).toUpperCase(); // To get DEC-26

            return formatted;
        } catch (Exception e) {
            e.printStackTrace();
            return "INVALID";
        }
    }


    public static String extractBrand(String input) {
        if (input == null || !input.contains("[") || !input.contains("]")) {
            return "NA";
        }
        int start = input.indexOf('[') + 1;
        int end = input.indexOf(']');
        if (start >= 0 && end > start) {
            return input.substring(start, end).trim();
        }
        return "NA";
    }


    public static List<String> parseInvoiceColumns(String invoiceColms) {
        if (invoiceColms == null || invoiceColms.trim().isEmpty()) {
            return Collections.emptyList();
        }
        return Arrays.asList(invoiceColms.split("\\s*,\\s*"));
    }


    public static String buildProductNameWithoutBrand(String description) {
        if (description == null || description.trim().isEmpty()) {
            return "";
        }

        // Remove anything inside [ ... ]
        String result = description.replaceAll("\\[.*?\\]", "").trim();

        // Remove double spaces if any left
        result = result.replaceAll("\\s{2,}", " ");

        return result;
    }



}
