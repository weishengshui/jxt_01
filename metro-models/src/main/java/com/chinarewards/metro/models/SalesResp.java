package com.chinarewards.metro.models;

import java.io.Serializable;
import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class SalesResp implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8324367055927126002L;

	/**
	 *  0:成功 1: 累积失败 ,2,会员不存在,3：无效的终端编号,other:非业务类错误
	 */
	private String result;

	/**
	 *  交易时间，请精确到时，分，秒
	 */
	private Date xactTime;

	/**
	 *  小票上的标题
	 */
	private String title;

	/**
	 *  小票/屏幕的内容
	 */
	private String tip;
	
	/**
	 * 交易号
	 */
	private String transactionNo;

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public Date getXactTime() {
		return xactTime;
	}

	public void setXactTime(Date xactTime) {
		this.xactTime = xactTime;
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
