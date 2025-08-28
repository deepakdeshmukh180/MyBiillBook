package in.enp.sms.service;

import in.enp.sms.entities.Product;
import in.enp.sms.pojo.DataTable;
import in.enp.sms.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.springframework.data.domain.PageRequest.*;

@Service
public class ProductServiceImpl implements  ProductService{

    @Autowired
    ProductRepository  productRepository;


    @Override
    public DataTable  getAllProduct(Integer pageNo, Integer pageSize, String sortBy) {
        Pageable paging = PageRequest.of(pageNo, pageSize, Sort.by(sortBy));
        Page<Product> pagedResult = productRepository.findAll(paging);
        DataTable dataTable = new DataTable();

        dataTable.setData(pagedResult.getContent());
        dataTable.setRecordsTotal(pagedResult.getTotalElements());
        dataTable.setRecordsFiltered(pagedResult.getTotalElements());

        dataTable.setDraw(pageNo);
        dataTable.setStart(pageSize);

        return dataTable;
    }
}
