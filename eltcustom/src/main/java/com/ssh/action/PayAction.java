package com.ssh.action;


import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

import com.ssh.base.BaseAction;
import com.ssh.entity.TblPay;
import com.ssh.service.DdService;
import com.ssh.service.PayService;

@Controller
@Results( { @Result(name = "success", location = "/jsp/dd/result.jsp"),
	@Result(name = "result", type = "stream", params = { "contentType",
		"text/html", "contentCharSet", "UTF-8", "allowCaching", "false"})})
public class PayAction extends BaseAction {
	
	private static final long serialVersionUID = 857508946370915324L;
	private static Logger logger = Logger
			.getLogger(PayAction.class.getName());
	
	@Resource
	private DdService ddserv;
	@Resource
	private PayService payserv;

    private transient InputStream inputStream;
    private String crddh;
    private String trade_no;				
    private String out_trade_no;
    private String total_fee;
    private String subject;
    private String body;
    private String buyer_email;
    private String trade_status;
    private String payrs;
    
	public void setCrddh(String crddh) {
		this.crddh = crddh;
	}
	public String getCrddh() {
		return crddh;
	}
	public void setPayrs(String payrs) {
		this.payrs = payrs;
	}
	public String getPayrs() {
		return payrs;
	}
	public void setOut_trade_no(String out_trade_no) {
		this.out_trade_no = out_trade_no;
	}
	public String getOut_trade_no() {
		return out_trade_no;
	}
	public void setTotal_fee(String total_fee) {
		this.total_fee = total_fee;
	}
	public String getTotal_fee() {
		return total_fee;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getSubject() {
		return subject;
	}
	public void setBody(String body) {
		this.body = body;
	}
	public String getBody() {
		return body;
	}
	public void setBuyer_email(String buyer_email) {
		this.buyer_email = buyer_email;
	}
	public String getBuyer_email() {
		return buyer_email;
	}
	public void setTrade_status(String trade_status) {
		this.trade_status = trade_status;
	}
	public String getTrade_status() {
		return trade_status;
	}
	public void setTrade_no(String trade_no) {
		this.trade_no = trade_no;
	}
	public String getTrade_no() {
		return trade_no;
	}
	public void setInputStream(InputStream inputStream) {
		this.inputStream = inputStream;
	}
	public InputStream getInputStream() {
		return inputStream;
	}
	
	public String payresult(){
		return SUCCESS;
	}
}
