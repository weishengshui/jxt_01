package com.chinarewards.metro.models;

import java.io.Serializable;
import java.util.Date;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class IntegralAddResp implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -315676998623916252L;

	private String requestRource;
	private double point;
	private Date operateTime;
	private Integer userId;
	private int operateStatus;
	private String statusDescription;
	private String errorInformation;

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("requestRource=" + requestRource + "&point=" + point
				+ "&operateTime=" + operateTime + "&userId=" + userId
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

	public String getRequestRource() {
		return requestRource;
	}

	public void setRequestRource(String requestRource) {
		this.requestRource = requestRource;
	}

	public double getPoint() {
		return point;
	}

	public void setPoint(double point) {
		this.point = point;
	}

	public Date getOperateTime() {
		return operateTime;
	}

	public void setOperateTime(Date operateTime) {
		this.operateTime = operateTime;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
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
