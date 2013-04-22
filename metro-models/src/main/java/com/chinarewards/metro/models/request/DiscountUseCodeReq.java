package com.chinarewards.metro.models.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class DiscountUseCodeReq implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4579983335019450087L;

	private String userId;// 必选 用户ID
	private String shopOrActivityId;// 必选 门店id或活动id
	private String orderId;// 可选 订单ID可选 订单ID
	private String description;// 可选 使用描述
	private String couponCode;// 优惠码ID 必选
	private String transactionNO;//
	
	private Integer couponType;//优惠码类型( 0--活动；1--门店）

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("userId=" + userId + "&shopOrActivityId=" + shopOrActivityId
				+ "&orderId=" + orderId + "&description=" + description
				+ "&couponCode=" + couponCode + "&transactionNO="+transactionNO);
		return str.toString();
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getShopOrActivityId() {
		return shopOrActivityId;
	}

	public void setShopOrActivityId(String shopOrActivityId) {
		this.shopOrActivityId = shopOrActivityId;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getCouponCode() {
		return couponCode;
	}

	public void setCouponCode(String couponCode) {
		this.couponCode = couponCode;
	}

	public String getTransactionNO() {
		return transactionNO;
	}

	public void setTransactionNO(String transactionNO) {
		this.transactionNO = transactionNO;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

	public Integer getCouponType() {
		return couponType;
	}

	public void setCouponType(Integer couponType) {
		this.couponType = couponType;
	}
	
	

}
