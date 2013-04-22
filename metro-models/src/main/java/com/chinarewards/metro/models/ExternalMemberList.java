package com.chinarewards.metro.models;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 1.1.	与POS进销存系统会员交互
 * @author daocao
 *
 */
@XmlRootElement
public class ExternalMemberList implements Serializable {

	private static final long serialVersionUID = 1L;

	private Integer memberId;
	
	private String email;
	
	private String phone;
	
	private String registerDate;
	
	private Integer isActive; 
	
	private String grade;
	
	private String birth;
	
	private Integer integral;
	
	private Integer status;
	
	private String name;
//	private Integer target; //更新标记 1 新增 2 修改 3 其他
	
	private String updateTime; //YYYYMMDDHHmmss 必选
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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

	public Integer getIsActive() {
		return isActive;
	}

	public void setIsActive(Integer isActive) {
		this.isActive = isActive;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
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

//	public Integer getTarget() {
//		return target;
//	}
//
//	public void setTarget(Integer target) {
//		this.target = target;
//	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	public String getRegisterDate() {
		return registerDate;
	}

	public void setRegisterDate(String registerDate) {
		this.registerDate = registerDate;
	}

	public String getBirth() {
		return birth;
	}

	public void setBirth(String birth) {
		this.birth = birth;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((memberId == null) ? 0 : memberId.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		ExternalMemberList other = (ExternalMemberList) obj;
		if (memberId == null) {
			if (other.memberId != null)
				return false;
		} else if (!memberId.equals(other.memberId))
			return false;
		return true;
	}
	
}
