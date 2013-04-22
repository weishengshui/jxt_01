package com.chinarewards.metro.models;

import java.io.Serializable;
import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class VerifyDiscountResp implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1386728358086960316L;

	/**
	 * 0:成功 1: 优惠码不存在,2,暂无优惠活动,3：无效的终端编号,4:优惠码已使用,5:优惠码已过期,6: 该活动已结束！,7:该活动已取消 ;8:该活动未开始;other:非业务类错误
	 */
	private String result;

	/**
	 * 交易时间，请精确到时，分，秒
	 */
	private Date xactTime;

	/**
	 * 小票上的标题
	 */
	private String title;

	/**
	 * 小票/屏幕的内容
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
