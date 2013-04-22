package com.chinarewards.metro.models.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class MemberActiveReq implements Serializable{

	private static final long serialVersionUID = 1L;

	private Integer memberId; // 会员ID

	private String phone; // 手机。

	private String activeCode; // 激活码

	private String checkStr;
	
	public String getSignValue() {
		StringBuffer sbf = new StringBuffer();
		sbf.append("memberId="+memberId);
		sbf.append("&phone="+phone);
		sbf.append("&activeCode="+activeCode);
		return sbf.toString();
	}
	
	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
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

	public String getActiveCode() {
		return activeCode;
	}

	public void setActiveCode(String activeCode) {
		this.activeCode = activeCode;
	}

}
