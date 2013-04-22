package com.chinarewards.metro.models;

import java.io.Serializable;
import java.util.Date;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class IntegralConsumeResp implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -315676998623916252L;

	private String orderId;// 订单ID
	private String orderSource;// 订单来源
	private double point;// 扣除积分
	private Date operateTime;
	private String userId;// 用户ID
	private String description;// 订单描述
	private int operateStatus;// 操作状态  
	private String statusDescription;// 操作状态说明
	private String errorInformation;

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("orderId=" + orderId + "&orderSource=" + orderSource
				+ "&point=" + point + "&operateTime=" + operateTime
				+ "&userId=" + userId + "&description=" + description
				+ "&operateStatus=" + operateStatus + "&statusDescription="
				+ statusDescription + "&errorInformation=" + errorInformation);

		return str.toString();
	}

	public String getErrorInformation() {
		return errorInformation;
	}

	public void setErrorInformation(String errorInformation) {
		this.errorInformation = errorInformation;
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

	public double getPoint() {
		return point;
	}

	public void setPoint(double point) {
		this.point = point;
	}

	public void setOrderSource(String orderSource) {
		this.orderSource = orderSource;
	}

	public void setPoint(long point) {
		this.point = point;
	}

	public Date getOperateTime() {
		return operateTime;
	}

	public void setOperateTime(Date operateTime) {
		this.operateTime = operateTime;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getOperateStatus() {
		return operateStatus;
	}

	public void setOperateStatus(int operateStatus) {
		this.operateStatus = operateStatus;
	}

	public String getStatusDescription() {
		return statusDescription;
	}

	public void setStatusDescription(String statusDescription) {
		this.statusDescription = statusDescription;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

}
