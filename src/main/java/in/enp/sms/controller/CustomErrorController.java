package in.enp.sms.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CustomErrorController implements ErrorController {
    @RequestMapping("/error")
    public String handleError() {
        return "error"; // returns error.html view
    }

    @Override
    public String getErrorPath() {
        return "";
    }
}