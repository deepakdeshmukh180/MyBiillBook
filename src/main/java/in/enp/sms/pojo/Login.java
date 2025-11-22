package in.enp.sms.pojo;

public class Login {

    private String username;

    private String password;


    private String confirmPassword;

    public Login() {
        super();
    }

    public Login(String username, String password, String confirmPassword) {
        super();
        this.username = username;
        this.password = password;
        this.confirmPassword = confirmPassword;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }


    @Override
    public String toString() {
        return String.format("Login [username=%s, password=%s, confirmPassword=%s]", username, password,
                confirmPassword);
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }


}
