package member;

import java.sql.Timestamp;

public class MemberBean {
   
	
    private String id;      
    private String passwd;  
    private String name;   
    private Timestamp reg_date;
    private String gender;  
    private String email;
    private int zipcode;
    private String address; 
    private String address2; 
    private String tel;     
    
    public MemberBean() {}	
	
	public MemberBean(String id, String passwd, String name, Timestamp reg_date,int age, String gender, String email, int zipcode, String address, String address2, String tel) {
		this.id = id;
		this.passwd = passwd;
		this.name = name;
		this.reg_date = reg_date;
		this.gender = gender;
		this.email = email;
		this.zipcode = zipcode;
		this.address = address;
		this.address2 = address2;
		this.tel = tel;
	}
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getPasswd() {
        return passwd;
    }
    public void setPasswd(String passwd) {
        this.passwd = passwd;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public Timestamp getReg_date() {
        return reg_date;
    }
    public void setReg_date(Timestamp reg_date) {
        this.reg_date = reg_date;
    }
    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }
    public String getAddress2() {
		return address2;
	}

	public int getZipcode() {
		return zipcode;
	}

	public void setZipcode(int zipcode) {
		this.zipcode = zipcode;
	}

	public void setAddress2(String address2) {
		this.address2 = address2;
	}
    public String getTel() {
        return tel;
    }
    public void setTel(String tel) {
        this.tel = tel;
    }

	
       
}