package com.chinarewards.metro.models.response;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class DiscountResp implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -2841660360558799593L;
	private String couponCode;
	private Integer userId;
	private Integer couponId;
	private String couponName;
	private Integer isRepeat;
	private String couponDescription;
	private String errCode;

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("couponCode=" + couponCode + "&userId=" + userId
				+ "&couponId=" + couponId + "&couponName=" + couponName
				+ "&isRepeat=" + isRepeat + "&couponDescription="
				+ couponDescription + "&errCode=" + errCode);

		return str.toString();
	}

	public DiscountResp() {
	}

	public DiscountResp(String couponCode, Integer userId, Integer couponId,
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

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

}
