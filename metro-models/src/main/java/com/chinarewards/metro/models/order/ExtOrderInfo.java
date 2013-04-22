package com.chinarewards.metro.models.order;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class ExtOrderInfo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6514851426243709293L;

	/**
	 * 会员ID
	 */
	private String userId;

	/**
	 * 订单ID
	 */
	private String orderId;

	/**
	 * 店铺ID
	 */
	private String shopId;

	/**
	 * 必选(IPAD 无,可能与ShopId 同)
	 */
	private String posId;

	/**
	 *  营业员ID
	 */
	private String clerkId;

	/**
	 * 	订单时间
	 *  20121016122542 必选
	 */
	private String orderTime;

	/**
	 * 	订单金额
	 *  以分为单位569 即5.69￥,必选
	 */
	private String orderPrice;

	/**
	 * 	发送时间
	 *  YYYYMMDDHHmmss 发送时间必选
	 */
	private String deliverTime;

	/**
	 *  可选 优惠码ID
	 */
	private String couponCode;

	/**
	 *  订单积分
	 *  必选 订单得到的积分
	 */
	private String integration;

	/**
	 *  可选 此订单的来源
	 */
	private String orderSource;

	/**
	 *  订单状态 1 正常 2 退单 3 冻结 4 订单修改(仅会被客服修改)
	 */
	private String orderState;

	/**
	 * 订单中银行支付的金额
	 */
	private String bankPay;

	/**
	 *  订单中使用现金支付的金额
	 */
	private String cash;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getShopId() {
		return shopId;
	}

	public void setShopId(String shopId) {
		this.shopId = shopId;
	}

	public String getPosId() {
		return posId;
	}

	public void setPosId(String posId) {
		this.posId = posId;
	}

	public String getClerkId() {
		return clerkId;
	}

	public void setClerkId(String clerkId) {
		this.clerkId = clerkId;
	}

	public String getOrderTime() {
		return orderTime;
	}

	public void setOrderTime(String orderTime) {
		this.orderTime = orderTime;
	}

	public String getOrderPrice() {
		return orderPrice;
	}

	public void setOrderPrice(String orderPrice) {
		this.orderPrice = orderPrice;
	}

	public String getDeliverTime() {
		return deliverTime;
	}

	public void setDeliverTime(String deliverTime) {
		this.deliverTime = deliverTime;
	}

	public String getCouponCode() {
		return couponCode;
	}

	public void setCouponCode(String couponCode) {
		this.couponCode = couponCode;
	}

	public String getIntegration() {
		return integration;
	}

	public void setIntegration(String integration) {
		this.integration = integration;
	}

	public String getOrderSource() {
		return orderSource;
	}

	public void setOrderSource(String orderSource) {
		this.orderSource = orderSource;
	}

	public String getOrderState() {
		return orderState;
	}

	public void setOrderState(String orderState) {
		this.orderState = orderState;
	}

	public String getBankPay() {
		return bankPay;
	}

	public void setBankPay(String bankPay) {
		this.bankPay = bankPay;
	}

	public void setCash(String cash) {
		this.cash = cash;
	}

	public String getCash() {
		return cash;
	}

}
