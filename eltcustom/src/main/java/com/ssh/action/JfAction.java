package com.ssh.action;


import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

import com.ssh.base.BaseAction;
import com.ssh.entity.TblQyyg;

@Controller
@Results( { @Result(name = "success", location = "/jsp/jf/list.jsp"),
	@Result(name = "jfly", location = "/jsp/jf/ly.jsp")})
public class JfAction extends BaseAction {
	private static final long serialVersionUID = -1995477591182969767L;
	private static Logger logger = Logger
			.getLogger(JfAction.class.getName());
	private int yg;
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
	
	public String source(){
		TblQyyg tyq = (TblQyyg) session.get("user");
		if(tyq!=null){
			setYg(tyq.getNid());
		}		
		return "jfly";
		
	}
}
