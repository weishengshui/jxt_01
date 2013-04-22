package com.chinarewards.metro.models.request;

import java.io.Serializable;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class SalesReq implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -315676998623916252L;

	private String token;

	Map<Long, Double> consumeDetails;

	private String posId;

	private String identify;

	private long serialId;

	private boolean resend ;
	
	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public Map<Long, Double> getConsumeDetails() {
		return consumeDetails;
	}

	public void setConsumeDetails(Map<Long, Double> consumeDetails) {
		this.consumeDetails = consumeDetails;
	}

	public String getPosId() {
		return posId;
	}

	public void setPosId(String posId) {
		this.posId = posId;
	}

	public String getIdentify() {
		return identify;
	}

	public void setIdentify(String identify) {
		this.identify = identify;
	}

	public long getSerialId() {
		return serialId;
	}

	public void setSerialId(long serialId) {
		this.serialId = serialId;
	}

	public boolean isResend() {
		return resend;
	}

	public void setResend(boolean resend) {
		this.resend = resend;
	}

}
