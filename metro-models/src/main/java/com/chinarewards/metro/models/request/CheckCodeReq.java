package com.chinarewards.metro.models.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class CheckCodeReq implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4579983335019450087L;

	// 优惠码
	private String couponCode;
	// 优惠码类型
	private Integer CouponId;
	// 必选 门店id或活动id
	private String shopOrActivityId;

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("couponCode=" + couponCode + "&couponId=" + CouponId);
		return str.toString();
	}

	public String getCouponCode() {
		return couponCode;
	}

	public void setCouponCode(String couponCode) {
		this.couponCode = couponCode;
	}

	public Integer getCouponId() {
		return CouponId;
	}

	public void setCouponId(Integer couponId) {
		CouponId = couponId;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

	public String getShopOrActivityId() {
		return shopOrActivityId;
	}

	public void setShopOrActivityId(String shopOrActivityId) {
		this.shopOrActivityId = shopOrActivityId;
	}
	
	
	
	
	

}
