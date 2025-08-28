package in.enp.sms.service;

import in.enp.sms.pojo.Login;

public interface LoginService {

    boolean validateUser(Login login);

    long registerNewUser(Login login);

    String updateNewPassword(Login login);

}
