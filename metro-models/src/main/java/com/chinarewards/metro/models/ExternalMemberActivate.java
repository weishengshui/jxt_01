package com.chinarewards.metro.models;

import java.io.Serializable;
import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 验证会员激活
 * @author daocao
 *
 */
@XmlRootElement
public class ExternalMemberActivate implements Serializable {

	private static final long serialVersionUID = 1L;

	private Integer memberId;
	
	private String phone;
	
	private Date createTime;
	
	private Integer isActive; 
	
	private String activePhone;
	
	private String activeCode;
	
	private String result;
	
	private String checkStr;
	
	public String getSignValue() {
		StringBuffer sbf = new StringBuffer();
		sbf.append("memberId="+memberId);
		sbf.append("&phone="+phone);
		sbf.append("&activeCode="+activeCode);
		sbf.append("&createTime="+createTime);
		sbf.append("&isActive="+isActive);
		sbf.append("&activePhone="+activePhone);
		return sbf.toString();
	}
	
	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}
	
	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public String getActiveCode() {
		return activeCode;
	}

	public void setActiveCode(String activeCode) {
		this.activeCode = activeCode;
	}

	public Integer getMemberId() {
		return memberId;
	}

	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
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
		ExternalMemberActivate other = (ExternalMemberActivate) obj;
		if (memberId == null) {
			if (other.memberId != null)
				return false;
		} else if (!memberId.equals(other.memberId))
			return false;
		return true;
	}
	
}
