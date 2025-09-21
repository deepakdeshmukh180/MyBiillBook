package in.enp.sms.controller;



import in.enp.sms.entities.DealerInfo;
import in.enp.sms.repository.DealerRepository;
import in.enp.sms.repository.ProductRepository;
import in.enp.sms.utility.Utility;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.UUID;

@Controller
@RequestMapping("/dealers")
public class DealerController {

    @Autowired
    private DealerRepository dealerRepository;

    @Autowired
    ProductRepository productRepository;

    @GetMapping
    public String listDealers(Model model ,HttpServletRequest request) {
        model.addAttribute("dealers", dealerRepository.findByOwnerIdAndStatusOrderByLastModifiedDateDesc(Utility.getOwnerIdFromSession(request),"ACTIVE"));
        return "dealer";
    }

    @GetMapping("/info")
    public String addDealerForm(Model model ,HttpServletRequest request) {
        model.addAttribute("dealer", new DealerInfo());
        model.addAttribute("dealers", dealerRepository.findByOwnerIdAndStatusOrderByLastModifiedDateDesc(Utility.getOwnerIdFromSession(request),"ACTIVE"));
        return "dealer";
    }

    @PostMapping("/save")
    public String saveDealer(HttpServletRequest request, @Valid @ModelAttribute("dealer") DealerInfo dealer,
                             BindingResult result,
                             Model model) {

        if (result.hasErrors()) {
            model.addAttribute("dealer", new DealerInfo());
            model.addAttribute("dealers", dealerRepository.findByOwnerIdAndStatusOrderByLastModifiedDateDesc(Utility.getOwnerIdFromSession(request),"ACTIVE"));
            return "dealer";
        }
        dealer.setStatus("ACTIVE");
        dealer.setTotalAmount(dealer.getBalanceAmount());
        dealer.setPaidAmount(0.00);
        if (dealer.getId().isEmpty()){
            dealer.setId(UUID.randomUUID().toString().toUpperCase());
        }
        dealer.setOwnerId(Utility.getOwnerIdFromSession(request));
        dealerRepository.save(dealer);
        model.addAttribute("dealer", new DealerInfo());
        model.addAttribute("dealers", dealerRepository.findByOwnerIdAndStatusOrderByLastModifiedDateDesc(Utility.getOwnerIdFromSession(request),"ACTIVE"));

        return "dealer";
    }



     @GetMapping("/update-dealer/{dealerId}")
    public String getDealerDetailsById(Model model ,@PathVariable String dealerId,HttpServletRequest request) {
        model.addAttribute("dealer", dealerRepository.getOne(dealerId));
        model.addAttribute("dealers", dealerRepository.findByOwnerIdAndStatusOrderByLastModifiedDateDesc(Utility.getOwnerIdFromSession(request),"ACTIVE"));
        return "dealer";
    }


    @GetMapping("/view-dealer/{dealerId}")
    public String getViewDealerDetailsById(Model model ,@PathVariable String dealerId,HttpServletRequest request, @RequestParam("billNo") String billNo) {
        model.addAttribute("dealer", dealerRepository.getOne(dealerId));
        model.addAttribute("dropdown", productRepository.findByOwnerId(Utility.getOwnerIdFromSession(request)));
        model.addAttribute("itemsNo",  1); // Item count + 1
        model.addAttribute("billNo",  billNo);
        return "viewdealerinfo";
    }
}
