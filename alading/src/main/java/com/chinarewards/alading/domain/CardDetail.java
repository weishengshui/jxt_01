package com.chinarewards.alading.domain;

import java.io.Serializable;

public class CardDetail implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -2311112247598376901L;
	private String accountId; // 会员账户id
	private String cardName; // 卡类型名称
	private String picUrl; // 卡图片URL
	private String pointId; // 卡积分单位id
	private String pointName; // 卡积分单位名称
	private Integer accountBalance; // 卡剩余积分数量
	private Integer pointRate; // 卡积分兑换抵用券单价

	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}

	public String getCardName() {
		return cardName;
	}

	public void setCardName(String cardName) {
		this.cardName = cardName;
	}

	public String getPicUrl() {
		return picUrl;
	}

	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
	}

	public String getPointId() {
		return pointId;
	}

	public void setPointId(String pointId) {
		this.pointId = pointId;
	}

	public String getPointName() {
		return pointName;
	}

	public void setPointName(String pointName) {
		this.pointName = pointName;
	}

	public Integer getAccountBalance() {
		return accountBalance;
	}

	public void setAccountBalance(Integer accountBalance) {
		this.accountBalance = accountBalance;
	}

	public Integer getPointRate() {
		return pointRate;
	}

	public void setPointRate(Integer pointRate) {
		this.pointRate = pointRate;
	}

}
