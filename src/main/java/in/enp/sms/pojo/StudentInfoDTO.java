package in.enp.sms.pojo;

public class StudentInfoDTO {

    private String stdId;
    private String firstName;
    private String lastName;
    private String mothersName;
    private String fatherName;
    private String address;
    private String gender;
    private String state;
    private String city;
    private String dob;
    private String pincode;
    private String classs;
    private String mailId;
    private String userId;

    public StudentInfoDTO() {
        super();
    }


    public StudentInfoDTO(String stdId, String firstName, String lastName, String mothersName, String fatherName,
                          String address, String gender, String state, String city, String dob, String pincode, String classs,
                          String mailId, String userId) {
        super();
        this.stdId = stdId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.mothersName = mothersName;
        this.fatherName = fatherName;
        this.address = address;
        this.gender = gender;
        this.state = state;
        this.city = city;
        this.dob = dob;
        this.pincode = pincode;
        this.classs = classs;
        this.mailId = mailId;
        this.userId = userId;
    }


    public String getStdId() {
        return stdId;
    }

    public void setStdId(String stdId) {
        this.stdId = stdId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getMothersName() {
        return mothersName;
    }

    public void setMothersName(String mothersName) {
        this.mothersName = mothersName;
    }

    public String getFatherName() {
        return fatherName;
    }

    public void setFatherName(String fatherName) {
        this.fatherName = fatherName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getPincode() {
        return pincode;
    }

    public void setPincode(String pincode) {
        this.pincode = pincode;
    }

    public String getClasss() {
        return classs;
    }

    public void setClasss(String classs) {
        this.classs = classs;
    }

    public String getMailId() {
        return mailId;
    }

    public void setMailId(String mailId) {
        this.mailId = mailId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }


    @Override
    public String toString() {
        return String.format(
                "StudentInfoDTO [firstName=%s, lastName=%s, mothersName=%s, fatherName=%s, address=%s, gender=%s, state=%s, city=%s, dob=%s, pincode=%s, classs=%s, mailId=%s, userId=%s]",
                firstName, lastName, mothersName, fatherName, address, gender, state, city, dob, pincode, classs,
                mailId, userId);
    }


}
