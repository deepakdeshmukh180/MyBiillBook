package in.enp.sms.entities;

import javax.persistence.*;

@Entity
@Table(name = "login_tbl")
@SequenceGenerator(name = "seqid-gen", sequenceName = "LOGIN_SQS", initialValue = 1, allocationSize = 1)
public class Login {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seqid-gen")
    private long id;

    @Column(name = "user_name")
    private String userName;

    @Column(name = "password")
    private String password;

    @Column(name = "status")
    private String status;


    public Login() {
        super();
    }

    public Login(long id, String userName, String password, String status) {
        super();
        this.id = id;
        this.userName = userName;
        this.password = password;
        this.status = status;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return String.format("Login [id=%s, userName=%s, password=%s, status=%s]", id, userName, password, status);
    }


}
