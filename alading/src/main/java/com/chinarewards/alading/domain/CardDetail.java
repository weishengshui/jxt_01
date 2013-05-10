package com.chinarewards.alading.domain;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class CardDetail {
	private String accountId;// 会员帐号
	private String cardName;// 卡类型名称
	private String picUrl;// 卡图片URL
	private String pointId;// 卡积分单位Id
	private String pointName;// 卡积分单位名称
	private String pointBalance;// 卡上剩余的积分数量
	private String pointRate;// 卡积分兑换抵用卷的单价

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

	public String getPointBalance() {
		return pointBalance;
	}

	public void setPointBalance(String pointBalance) {
		this.pointBalance = pointBalance;
	}

	public String getPointRate() {
		return pointRate;
	}

	public void setPointRate(String pointRate) {
		this.pointRate = pointRate;
	}

	public String getPointName() {
		return pointName;
	}

	public void setPointName(String pointName) {
		this.pointName = pointName;
	}

}
