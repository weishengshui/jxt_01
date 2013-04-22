package com.chinarewards.metro.models;

import java.io.Serializable;
import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 手机注册响应vo
 * 
 * @author qingminzou
 * 
 */
@XmlRootElement
public class RegisterResp implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2281619590049013372L;

	/**
	 *  0:成功 1: 已注册过 other:非业务类错误
	 */
	private String result;

	/**
	 *  交易时间，请精确到时，分，秒
	 */
	private Date XactTime;

	/**
	 *  小票上的标题
	 */
	private String title;

	/**
	 *  小票/屏幕的内容
	 */
	private String tip;

	private String phone; //手机
	
	private String posId;
	
	private Integer resend;
	/**
	 * 交易号
	 */
	private String transactionNo;
	
	public Integer getResend() {
		return resend;
	}

	public void setResend(Integer resend) {
		this.resend = resend;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getPosId() {
		return posId;
	}

	public void setPosId(String posId) {
		this.posId = posId;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public Date getXactTime() {
		return XactTime;
	}

	public void setXactTime(Date xactTime) {
		XactTime = xactTime;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getTip() {
		return tip;
	}

	public void setTip(String tip) {
		this.tip = tip;
	}

	public String getTransactionNo() {
		return transactionNo;
	}

	public void setTransactionNo(String transactionNo) {
		this.transactionNo = transactionNo;
	}
}
