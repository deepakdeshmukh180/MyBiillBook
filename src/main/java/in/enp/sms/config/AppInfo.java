package in.enp.sms.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration("appInfo")
@ConfigurationProperties(prefix = "app")
public class AppInfo {

    private String title;
    private String name;
    private String address1;
    private String address2;
    private String city;
    private String mobno;
    private String logo;
    private String qrcode;
    private String email;
    private String proprietor;

    public AppInfo(String address1, String address2, String city, String email, String logo, String mobno, String name, String proprietor, String qrcode, String title) {
        this.address1 = address1;
        this.address2 = address2;
        this.city = city;
        this.email = email;
        this.logo = logo;
        this.mobno = mobno;
        this.name = name;
        this.proprietor = proprietor;
        this.qrcode = qrcode;
        this.title = title;
    }

    public String getProprietor() {
        return proprietor;
    }

    public void setProprietor(String proprietor) {
        this.proprietor = proprietor;
    }

    public AppInfo() {
        super();
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress1() {
        return address1;
    }

    public void setAddress1(String address1) {
        this.address1 = address1;
    }

    public String getAddress2() {
        return address2;
    }

    public void setAddress2(String address2) {
        this.address2 = address2;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getMobno() {
        return mobno;
    }

    public void setMobno(String mobno) {
        this.mobno = mobno;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getQrcode() {
        return qrcode;
    }

    public void setQrcode(String qrcode) {
        this.qrcode = qrcode;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

}
