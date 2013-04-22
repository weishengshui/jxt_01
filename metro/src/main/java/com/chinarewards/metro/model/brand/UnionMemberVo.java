package com.chinarewards.metro.model.brand;

import java.util.Date;

/**
 * 导出联合会员EXCEL VO
 * 
 * @author weishengshui
 *
 */

public class UnionMemberVo {
	
	private String memberName;
	private String cardNumber;
	private Date joinDate;
	
	public UnionMemberVo() {
	}
	
	public UnionMemberVo(String surName, String name, String cardNumber, Date joinDate) {
		this.memberName = surName + name;
		this.cardNumber = cardNumber;
		this.joinDate = joinDate;
	}
	
	public UnionMemberVo(String allName, String cardNumber, Date joinDate) {
		this.memberName = allName;
		this.cardNumber = cardNumber;
		this.joinDate = joinDate;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getCardNumber() {
		return cardNumber;
	}

	public void setCardNumber(String cardNumber) {
		this.cardNumber = cardNumber;
	}

	public Date getJoinDate() {
		return joinDate;
	}

	public void setJoinDate(Date joinDate) {
		this.joinDate = joinDate;
	}
	
	
}
