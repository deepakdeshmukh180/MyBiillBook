package in.enp.sms.service;


import in.enp.sms.entities.User;

public interface UserService {
    void save(User user);

    User findByUsername(String username);

    User findByUsernameWithoutStatus(String userName);

    void activateUser(User user);

    boolean usernameExists(String username);

    void updatePassword(String username, String encodedPassword);
}
