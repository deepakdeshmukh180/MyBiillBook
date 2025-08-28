package in.enp.sms.service;

import in.enp.sms.entities.CustProfile;
import in.enp.sms.entities.InvoiceDetails;
import in.enp.sms.entities.ItemDetails;
import org.springframework.stereotype.Service;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;

@Service
public class InvoiceServiceImpl implements InvoiceService{
    public String generateItemSummary(List<ItemDetails> items) {
        StringBuilder data = new StringBuilder();
        int i = 1;
        for (ItemDetails details : items) {
            details.setStatus(true);
            data.append("(").append(i).append(") ")
                    .append(details.getDescription())
                    .append("-Rs.").append(details.getRate())
                    .append("x").append(details.getQty())
                    .append("=Rs.").append(details.getAmount())
                    .append(", ");
            i++;
        }
        return data.toString();
    }

    public Map<String, Double> computeTotals(List<ItemDetails> items) {
        Map<String, Double> totals = new HashMap<>();
        totals.put("totalAmount", items.stream().mapToDouble(ItemDetails::getAmount).sum());
        totals.put("totalQty", items.stream().mapToDouble(ItemDetails::getQty).sum());
        totals.put("preTaxAmt", items.stream().mapToDouble(ItemDetails::getPriTaxAmt).sum());
        totals.put("gst", items.stream().mapToDouble(ItemDetails::getTaxAmount).sum());
        totals.put("mrp", items.stream()
                .mapToDouble(item -> item.getMrp() * item.getQty())
                .sum());
        return totals;
    }

    public void populateInvoiceMetadata(InvoiceDetails itemDetails, CustProfile profile, Map<String, Double> totals, String username) {
        itemDetails.setPreBalanceAmt(profile.getCurrentOusting());
        itemDetails.setTax(totals.get("gst"));
        itemDetails.setPreTaxAmt(totals.get("preTaxAmt"));
        itemDetails.setBalanceAmt(profile.getCurrentOusting());
        itemDetails.setCreatedBy(username);
        itemDetails.setDiscount(totals.get("mrp")- totals.get("totalAmount"));
        itemDetails.setDate(LocalDate.now());
        itemDetails.setCreatedAt(new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()));
    }

    public static String getCurretDate() {
        DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        Calendar cal = Calendar.getInstance();
        return dateFormat.format(cal.getTime());

    }
}
