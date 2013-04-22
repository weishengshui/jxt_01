package com.chinarewards.metro.model.discount;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class DiscountMode {
	private String couponCode ;
	private Integer userId ;
	private Integer couponId ;
	private String couponName ;
	private Integer isRepeat ;
	private String couponDescription ;
	private String errCode ;
	
	public DiscountMode(){}
	public DiscountMode(String couponCode, Integer userId, Integer couponId,
			String couponName, Integer isRepeat, String couponDescription,
			String errCode) {
		super();
		this.couponCode = couponCode;
		this.userId = userId;
		this.couponId = couponId;
		this.couponName = couponName;
		this.isRepeat = isRepeat;
		this.couponDescription = couponDescription;
		this.errCode = errCode;
	}
	public String getCouponCode() {
		return couponCode;
	}
	public void setCouponCode(String couponCode) {
		this.couponCode = couponCode;
	}
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public Integer getCouponId() {
		return couponId;
	}
	public void setCouponId(Integer couponId) {
		this.couponId = couponId;
	}
	public String getCouponName() {
		return couponName;
	}
	public void setCouponName(String couponName) {
		this.couponName = couponName;
	}
	public Integer getIsRepeat() {
		return isRepeat;
	}
	public void setIsRepeat(Integer isRepeat) {
		this.isRepeat = isRepeat;
	}
	public String getCouponDescription() {
		return couponDescription;
	}
	public void setCouponDescription(String couponDescription) {
		this.couponDescription = couponDescription;
	}
	public String getErrCode() {
		return errCode;
	}
	public void setErrCode(String errCode) {
		this.errCode = errCode;
	}
	
}
