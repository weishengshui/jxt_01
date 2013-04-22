package com.ssh.action;


import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

import com.ssh.base.BaseAction;
import com.ssh.entity.TblJfqmc;
import com.ssh.entity.TblQyyg;
import com.ssh.service.JfqService;

@Controller
@Results( { @Result(name = "success", location = "/jsp/jfq/list.jsp"), 
	@Result(name = "detail", location = "/jsp/jfq/detail.jsp"),
	@Result(name = "jfqly", location = "/jsp/jfq/ly.jsp")})
public class JfqAction extends BaseAction {
	
	private static final long serialVersionUID = -5256870210389064102L;
	private static Logger logger = Logger
			.getLogger(JfqAction.class.getName());
	@Resource
	private JfqService jfqserv;
	
	private int yg;
	private int jfq;
	private TblJfqmc jfqmc;
	
	public void setJfq(int jfq) {
		this.jfq = jfq;
	}
	public int getJfq() {
		return jfq;
	}
	public void setJfqmc(TblJfqmc jfqmc) {
		this.jfqmc = jfqmc;
	}
	public TblJfqmc getJfqmc() {
		return jfqmc;
	}
	public void setYg(int yg) {
		this.yg = yg;
	}
	public int getYg() {
		return yg;
	}
	public String list() {
		TblQyyg tyq = (TblQyyg) session.get("user");
		if(tyq!=null){
			setYg(tyq.getNid());
		}		
		return SUCCESS;
	}

	public String detail() {
		setJfqmc((TblJfqmc) jfqserv.findById(jfq));
		return "detail";
	}
	
	public String source(){
		TblQyyg tyq = (TblQyyg) session.get("user");
		if(tyq!=null){
			setYg(tyq.getNid());
		}		
		return "jfqly";
		
	}
}
