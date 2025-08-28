package in.enp.sms.controller;

import in.enp.sms.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import in.enp.sms.pojo.DataTable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    ProductService productService;

    @GetMapping
    public ResponseEntity<DataTable> getAllEmployees(
            @RequestParam(defaultValue = "1") Integer pageNo,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(defaultValue = "productName") String sortBy)
    {
        DataTable dataTable = productService.getAllProduct(0, pageSize, sortBy);

        return ResponseEntity.ok(dataTable);
    }


    }




