package com.ssh.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblSp entity. @author MyEclipse Persistence Tools
 */
/**
 * 员工支付宝支付表
 */
@Entity
@Table(name = "tbl_pay")
public class TblPay extends com.ssh.base.BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8469919691131090375L;
	private String ddh; //  员工订单号
	private String tradeno; // 付款单号
	private double fee; // 金额
	private String subject; // 标题
	private String body; // 付款单内容 
	private String buyer; // 购买人
	private Integer status; // 状态
	private Timestamp cteatetime; // 创建时间


	@Id
	@Column(name = "ddh", unique = true, nullable = false)
	public String getDdh() {
		return ddh;
	}

	public void setDdh(String ddh) {
		this.ddh = ddh;
	}
	@Column(name = "tradeno",length=50)
	public String getTradeno() {
		return tradeno;
	}

	public void setTradeno(String tradeno) {
		this.tradeno = tradeno;
	}

	@Column(name = "fee", precision = 10)
	public double getFee() {
		return fee;
	}

	public void setFee(double fee) {
		this.fee = fee;
	}
	@Column(name = "subject",length=100)
	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	@Column(name = "body",length=250)
	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

	@Column(name = "buyer",length=100)
	public String getBuyer() {
		return buyer;
	}

	public void setBuyer(String buyer) {
		this.buyer = buyer;
	}

	@Column(name = "status")
	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	@Column(name = "cteatetime")
	public Timestamp getCteatetime() {
		return cteatetime;
	}

	public void setCteatetime(Timestamp cteatetime) {
		this.cteatetime = cteatetime;
	}

}