package in.enp.sms.service;

import in.enp.sms.entities.DailyExpense;
import in.enp.sms.repository.DailyExpenseRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@Service
public class DailyExpenseServiceImpl implements DailyExpenseService{

    private final DailyExpenseRepository repo;

    public DailyExpenseServiceImpl(DailyExpenseRepository repo) {
        this.repo = repo;
    }

    public List<DailyExpense> findAll() {
        return repo.findAll();
    }

    public List<DailyExpense> findByDate(Date date) {
        return repo.findByDate(date);
    }

    public DailyExpense save(DailyExpense expense) {
        return repo.save(expense);
    }

    public void delete(Long id) {
        repo.deleteById(id);
    }

    public DailyExpense getById(Long id) {
        return repo.findById(id).orElse(null);
    }

}
