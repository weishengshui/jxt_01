package com.chinarewards.metro.models;

import java.io.Serializable;
import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 外部接口-会员注册
 * @author daocao
 *
 */
@XmlRootElement
public class ExternalMemberReg implements Serializable {

	private static final long serialVersionUID = 1L;

	private Integer memberId;
	
	private String email;
	
	private String phone;
	
	private Date createTime;
	
	private Integer isActive;  //1 激活  2未激活
	
	private String activePhone;
	
	private String grade;
	
	private Date birth;
	
	private Integer integral;
	
	private Integer status;
	
	private String password;
	/**
	 * 注册来源
	 */
	private String source;
	
	private String checkStr;
	
	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getSignValue() {
		StringBuffer sbf = new StringBuffer();
		sbf.append("memberId="+memberId);
		sbf.append("&phone="+phone);
		sbf.append("&activePhone="+activePhone);
		sbf.append("&createTime="+createTime);
		return sbf.toString();
	}
	
	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}
	
	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public Date getBirth() {
		return birth;
	}

	public void setBirth(Date birth) {
		this.birth = birth;
	}

	public Integer getIntegral() {
		return integral;
	}

	public void setIntegral(Integer integral) {
		this.integral = integral;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	private String result;
	
	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public Integer getMemberId() {
		return memberId;
	}

	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Integer getIsActive() {
		return isActive;
	}

	public void setIsActive(Integer isActive) {
		this.isActive = isActive;
	}

	public String getActivePhone() {
		return activePhone;
	}

	public void setActivePhone(String activePhone) {
		this.activePhone = activePhone;
	}
}
