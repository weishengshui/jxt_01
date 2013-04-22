package com.chinarewards.metro.models.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class VerifyDiscountReq implements Serializable {
	 
	 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String posId;
	private String discountCode;
	private int resend;//0-false；1-true;
	private long serialId;
	private double money;
	private String transactionNO;
	
	
	public String getPosId() {
		return posId;
	}
	public void setPosId(String posId) {
		this.posId = posId;
	}
	public String getDiscountCode() {
		return discountCode;
	}
	public void setDiscountCode(String discountCode) {
		this.discountCode = discountCode;
	}
	
	public int getResend() {
		return resend;
	}
	public void setResend(int resend) {
		this.resend = resend;
	}
	public long getSerialId() {
		return serialId;
	}
	public void setSerialId(long serialId) {
		this.serialId = serialId;
	}
	public double getMoney() {
		return money;
	}
	public void setMoney(double money) {
		this.money = money;
	}
	public String getTransactionNO() {
		return transactionNO;
	}
	public void setTransactionNO(String transactionNO) {
		this.transactionNO = transactionNO;
	}
	
	 
	
}
