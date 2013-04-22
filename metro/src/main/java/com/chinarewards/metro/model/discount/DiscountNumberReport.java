package com.chinarewards.metro.model.discount;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.member.Member;


public class DiscountNumberReport  {

	private Integer source;//门店1，活动2
	private Integer status;// 优惠码状态: 0未使用、1已使用
	private String shopActivityName;
	private String memberName;
	private String memberCard;
	private String transactionNO;
	private Date usedDate;
	private String discountNum;
	private String description;
	private Date expiredDate;
	public Integer getSource() {
		return source;
	}
	public void setSource(Integer source) {
		this.source = source;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public String getShopActivityName() {
		return shopActivityName;
	}
	public void setShopActivityName(String shopActivityName) {
		this.shopActivityName = shopActivityName;
	}
	public String getMemberName() {
		return memberName;
	}
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	public String getMemberCard() {
		return memberCard;
	}
	public void setMemberCard(String memberCard) {
		this.memberCard = memberCard;
	}
	public String getTransactionNO() {
		return transactionNO;
	}
	public void setTransactionNO(String transactionNO) {
		this.transactionNO = transactionNO;
	}
	public Date getUsedDate() {
		return usedDate;
	}
	public void setUsedDate(Date usedDate) {
		this.usedDate = usedDate;
	}
	public String getDiscountNum() {
		return discountNum;
	}
	public void setDiscountNum(String discountNum) {
		this.discountNum = discountNum;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Date getExpiredDate() {
		return expiredDate;
	}
	public void setExpiredDate(Date expiredDate) {
		this.expiredDate = expiredDate;
	}
	
	
	

}
