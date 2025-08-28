package in.enp.sms.service;

import in.enp.sms.entities.CustProfile;
import in.enp.sms.entities.InvoiceDetails;
import in.enp.sms.entities.ItemDetails;

import java.util.List;
import java.util.Map;

public interface InvoiceService {
    void populateInvoiceMetadata(InvoiceDetails itemDetails, CustProfile profile, Map<String, Double> totals, String name);

    String generateItemSummary(List<ItemDetails> items);

    Map<String, Double> computeTotals(List<ItemDetails> items);
}
