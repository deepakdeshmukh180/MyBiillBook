package in.enp.sms.service;

import in.enp.sms.entities.Product;
import in.enp.sms.pojo.DataTable;
import org.springframework.data.domain.Page;

import java.util.List;

public interface ProductService {
    DataTable   getAllProduct(Integer pageNo, Integer pageSize, String sortBy);
}
