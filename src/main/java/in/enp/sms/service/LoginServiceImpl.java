package in.enp.sms.service;

import in.enp.sms.pojo.Login;
import in.enp.sms.repository.LoginRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LoginServiceImpl implements LoginService {


    @Autowired
    private LoginRepository loginRepository;

    @Override
    public boolean validateUser(Login login) {
        List<in.enp.sms.entities.Login> loginList = loginRepository.findByUserNameAndPassword(login.getUsername(), login.getPassword());
        return loginList.size() > 0;
    }

    @Override
    public long registerNewUser(Login login) {
        in.enp.sms.entities.Login entityLogin = new in.enp.sms.entities.Login();
        entityLogin.setUserName(login.getUsername());
        entityLogin.setPassword(login.getPassword());
        entityLogin.setStatus("ACTIVE");
        loginRepository.save(entityLogin);
        return entityLogin.getId();
    }

    @Override
    public String updateNewPassword(Login login) {
        List<in.enp.sms.entities.Login> loginList = loginRepository.findByUserNameAndPassword(login.getUsername(), login.getPassword());
        in.enp.sms.entities.Login entityLogin = loginList.get(0);
        entityLogin.setPassword(login.getConfirmPassword());
        loginRepository.save(entityLogin);
        return "Password changed for user :" + login.getUsername() + " Please login with new password..!";
    }

}
