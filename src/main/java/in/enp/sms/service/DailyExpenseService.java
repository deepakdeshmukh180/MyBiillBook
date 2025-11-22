package in.enp.sms.service;

import in.enp.sms.entities.DailyExpense;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;

public interface DailyExpenseService {
    DailyExpense save(DailyExpense dailyExpense);

    List<DailyExpense> findAll();

    List<DailyExpense> findByDate(Date date);
}
