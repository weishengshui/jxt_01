package com.chinarewards.metro.models.order;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class OrderResp {

	// 订单ID 必选
	private String ordered;

	// 应答码 必选
	private String responseCode;

	// 应答内容 可选
	private String responseText;

	// YYYYMMDDHHmmss 必选
	private String responseTime;

	public String getOrdered() {
		return ordered;
	}

	public void setOrdered(String ordered) {
		this.ordered = ordered;
	}

	public String getResponseCode() {
		return responseCode;
	}

	public void setResponseCode(String responseCode) {
		this.responseCode = responseCode;
	}

	public String getResponseText() {
		return responseText;
	}

	public void setResponseText(String responseText) {
		this.responseText = responseText;
	}

	public String getResponseTime() {
		return responseTime;
	}

	public void setResponseTime(String responseTime) {
		this.responseTime = responseTime;
	}

}
