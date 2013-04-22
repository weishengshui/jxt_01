package com.chinarewards.metro.domain.member;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Transient;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import org.codehaus.jackson.map.annotate.JsonSerialize;

import com.chinarewards.metro.core.common.DateTimeSerializer;
import com.chinarewards.metro.core.common.Page;

@Entity
@JsonIgnoreProperties (value={"hibernateLazyInitializer","card"})
public class Member implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	@Id 
	@GeneratedValue(strategy=GenerationType.AUTO)
	private Integer id;
	private String name;	//名
	private String surname; //姓
	private Integer sex;
	@Column(unique = true)
	private String phone;
	private Date birthDay;
	private String identityCard; //身份证
	private String email;
	
	private String address ;
	private String province;
	private String city;
	private String area;
	private String postcode;
	@Column(updatable = false)
	private String source;	//注册来源 网站1000 手机APP1001 微信1002 触摸屏1003 POS1004 CRM1005 	
	@Column(nullable = true)
	private Integer industry;  //行业
	private String company;
	
	private String posNum;	// pos机注册时 pos机编号
	
	@Column(nullable = true)
	private Integer profession;//职业
	
	@Column(nullable = true)
	private Integer position;  //职位
	
	@Column(nullable = true)
	private Integer salary;    //年薪
	
	@Column(nullable = true)
	private Integer education; //学历
	
	@Column(updatable = false)
	private Integer status;
	
	@Column(updatable = false)
	private Date createDate;
	
	@Column(updatable = false)
	private String createUser;
	private Date updateDate;
	private String updateUser;
	
	@Column(updatable = false)
	private String account;
	
	@Column(updatable = false)
	private String password;
	
	@OneToOne(cascade=CascadeType.ALL, fetch=FetchType.LAZY)
	@JoinColumn(name = "card_id")
	private MemberCard card;
	
	private String activePhone;
	
	private String qq;
	private String weixin;
	private String grade;
	
	@Transient
	private Integer integral;
	@Transient
	private String money;
	@Transient
	private Date createStart;
	@Transient
	private Date createEnd;
	@Transient
	private BigDecimal expenseStart;
	@Transient
	private BigDecimal expenseEnd;
	@Transient
	private Integer ageStart;
	@Transient
	private Integer ageEnd;
	@Transient
	private Integer age;
	@Transient
	private BigDecimal orderPriceSum;
	@Transient
	private String cardNumber;
	@Transient
	private Page paginationDetail;;
	
	public String getPosNum() {
		return posNum;
	}

	public void setPosNum(String posNum) {
		this.posNum = posNum;
	}

	public String getMoney() {
		return money;
	}

	public void setMoney(String money) {
		this.money = money;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getQq() {
		return qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}

	public String getWeixin() {
		return weixin;
	}

	public void setWeixin(String weixin) {
		this.weixin = weixin;
	}

	public Integer getIntegral() {
		return integral;
	}

	public void setIntegral(Integer integral) {
		this.integral = integral;
	}

	public String getActivePhone() {
		return activePhone;
	}

	public void setActivePhone(String activePhone) {
		this.activePhone = activePhone;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getSurname() {
		return surname;
	}

	public void setSurname(String surname) {
		this.surname = surname;
	}

	private String valiCode;
	
	public String getValiCode() {
		return valiCode;
	}

	public void setValiCode(String valiCode) {
		this.valiCode = valiCode;
	}

	public MemberCard getCard() {
		return card;
	}

	public void setCard(MemberCard card) {
		this.card = card;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Date getBirthDay() {
		return birthDay;
	}

	public void setBirthDay(Date birthDay) {
		this.birthDay = birthDay;
	}

	public String getIdentityCard() {
		return identityCard;
	}

	public void setIdentityCard(String identityCard) {
		this.identityCard = identityCard;
	}

	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}

	public String getPostcode() {
		return postcode;
	}

	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}

	public Integer getIndustry() {
		return industry;
	}

	public void setIndustry(Integer industry) {
		this.industry = industry;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public Integer getProfession() {
		return profession;
	}

	public void setProfession(Integer profession) {
		this.profession = profession;
	}

	public Integer getPosition() {
		return position;
	}

	public void setPosition(Integer position) {
		this.position = position;
	}

	public Integer getSalary() {
		return salary;
	}

	public void setSalary(Integer salary) {
		this.salary = salary;
	}

	public Integer getEducation() {
		return education;
	}

	public void setEducation(Integer education) {
		this.education = education;
	}
	
	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	@JsonSerialize(using = DateTimeSerializer.class)
	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	@JsonSerialize(using = DateTimeSerializer.class)
	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Integer getSex() {
		return sex;
	}

	public void setSex(Integer sex) {
		this.sex = sex;
	}

	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getAddress() {
		return address;
	}
	
	public void setAddress(String address) {
		this.address = address;
	}
	
	public String getPhone() {
		return phone;
	}
	
	public void setPhone(String phone) {
		this.phone = phone;
	}
	
	public Integer getId() {
		return id;
	}
	
	public void setId(Integer id) {
		this.id = id;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + id;
		return result;
	}

	public Date getCreateStart() {
		return createStart;
	}

	public void setCreateStart(Date createStart) {
		this.createStart = createStart;
	}

	public Date getCreateEnd() {
		return createEnd;
	}

	public void setCreateEnd(Date createEnd) {
		this.createEnd = createEnd;
	}

	public BigDecimal getExpenseStart() {
		return expenseStart;
	}

	public void setExpenseStart(BigDecimal expenseStart) {
		this.expenseStart = expenseStart;
	}

	public BigDecimal getExpenseEnd() {
		return expenseEnd;
	}

	public void setExpenseEnd(BigDecimal expenseEnd) {
		this.expenseEnd = expenseEnd;
	}


	public Integer getAgeStart() {
		return ageStart;
	}

	public void setAgeStart(Integer ageStart) {
		this.ageStart = ageStart;
	}

	public Integer getAgeEnd() {
		return ageEnd;
	}

	public void setAgeEnd(Integer ageEnd) {
		this.ageEnd = ageEnd;
	}

	public BigDecimal getOrderPriceSum() {
		return orderPriceSum;
	}

	public void setOrderPriceSum(BigDecimal orderPriceSum) {
		this.orderPriceSum = orderPriceSum;
	}



	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}
	

	public String getCardNumber() {
		return cardNumber;
	}

	public void setCardNumber(String cardNumber) {
		this.cardNumber = cardNumber;
	}
	

	public Page getPaginationDetail() {
		return paginationDetail;
	}

	public void setPaginationDetail(Page paginationDetail) {
		this.paginationDetail = paginationDetail;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Member other = (Member) obj;
		if (id != other.id)
			return false;
		return true;
	}

}
