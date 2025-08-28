package in.enp.sms.pojo;


public class Tag {

    private Integer key;

    private String value;

    public Tag( Integer key , String value) {
        this.key = key;

        this.value = value;

    }


    public Tag() {
    }

    public Integer getKey() {
        return key;
    }

    public void setKey(Integer key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
