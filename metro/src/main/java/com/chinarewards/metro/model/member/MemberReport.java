package com.chinarewards.metro.model.member;

import java.math.BigDecimal;
import java.util.Date;
import com.chinarewards.metro.domain.member.MemberCard;

public class MemberReport{
	private Integer id;
	private String name;	
	private Integer sex;
	private String phone;
	private String email;
	private String surname;
	private String address ;
	private String province;
	private String city;
	private String area;
	private String source;	
	private Integer status;
	private String account;
	private Date createStart;
	private Date createEnd;
	private BigDecimal expenseStart;
	private BigDecimal expenseEnd;
	private int ageStart;
	private int ageEnd;
	private String cardNumber;
	private Date createDate;
	private Date birthDay;
	private Integer age;
	private BigDecimal orderPriceSum;
	
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getSex() {
		return sex;
	}
	public void setSex(Integer sex) {
		this.sex = sex;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
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
	
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public String getAccount() {
		return account;
	}
	public void setAccount(String account) {
		this.account = account;
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
	public int getAgeStart() {
		return ageStart;
	}
	public void setAgeStart(int ageStart) {
		this.ageStart = ageStart;
	}
	public int getAgeEnd() {
		return ageEnd;
	}
	public void setAgeEnd(int ageEnd) {
		this.ageEnd = ageEnd;
	}
	public String getSurname() {
		return surname;
	}
	public void setSurname(String surname) {
		this.surname = surname;
	}
	public String getCardNumber() {
		return cardNumber;
	}
	public void setCardNumber(String cardNumber) {
		this.cardNumber = cardNumber;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public Date getBirthDay() {
		return birthDay;
	}
	public void setBirthDay(Date birthDay) {
		this.birthDay = birthDay;
	}
	public Integer getAge() {
		return age;
	}
	public void setAge(Integer age) {
		this.age = age;
	}
	public BigDecimal getOrderPriceSum() {
		return orderPriceSum;
	}
	public void setOrderPriceSum(BigDecimal orderPriceSum) {
		this.orderPriceSum = orderPriceSum;
	}
	
	
	
	
	
	
}
