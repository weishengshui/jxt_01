package com.ssh.action;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

import com.ssh.base.BaseAction;
import com.ssh.entity.TblQyyg;

@Controller
@Results( { @Result(name = "success", location = "/jsp/gsgg/list.jsp")})
public class GbAction extends BaseAction {
	private static final long serialVersionUID = 6729561183164431040L;
	private static Logger logger = Logger
			.getLogger(GbAction.class.getName());
	private int qy;
	private String param;
	public void setParam(String param) {
		this.param = param;
	}

	public String getParam() {
		return param;
	}

	public void setQy(int qy) {
		this.qy = qy;
	}

	public int getQy() {
		return qy;
	}

	public String list() {
		TblQyyg user = (TblQyyg) session.get("user");
		if(user!=null){
			setQy(user.getQy());
		}
		return SUCCESS;
	}
}
