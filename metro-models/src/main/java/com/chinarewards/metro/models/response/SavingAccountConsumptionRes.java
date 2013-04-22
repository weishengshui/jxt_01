package com.chinarewards.metro.models.response;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 储值卡消费res
 * 
 * @author weishengshui
 * 
 */
@XmlRootElement
public class SavingAccountConsumptionRes {

	private String orderId;

	private String orderSource;

	private String operateTime;

	private Double point; // 扣除金额。

	private Integer userId; // 会员Id

	private String description; // 订单描述。可选

	private Integer operateStatus; // 操作状态。1 成功 2失败

	private String statusDescription; // 操作状态描述。可选

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("orderId=" + orderId + "&orderSource=" + orderSource
				+ "&point=" + point + "&userId=" + userId + "&description="
				+ description + "operateStatus=" + operateStatus
				+ "&statusDescription=" + statusDescription);
		return str.toString();
	}

	public SavingAccountConsumptionRes() {
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getOrderSource() {
		return orderSource;
	}

	public void setOrderSource(String orderSource) {
		this.orderSource = orderSource;
	}

	public Double getPoint() {
		return point;
	}

	public void setPoint(Double point) {
		this.point = point;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Integer getOperateStatus() {
		return operateStatus;
	}

	public void setOperateStatus(Integer operateStatus) {
		this.operateStatus = operateStatus;
	}

	public String getStatusDescription() {
		return statusDescription;
	}

	public void setStatusDescription(String statusDescription) {
		this.statusDescription = statusDescription;
	}

	public String getOperateTime() {
		return operateTime;
	}

	public void setOperateTime(String operateTime) {
		this.operateTime = operateTime;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

}
