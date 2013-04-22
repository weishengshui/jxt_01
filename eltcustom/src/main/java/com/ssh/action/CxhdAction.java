package com.ssh.action;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;
import com.ssh.base.BaseAction;
@Controller
@Results( { @Result(name = "detail", location = "/jsp/cxhd/detail.jsp")})
public class CxhdAction extends BaseAction {
	private static final long serialVersionUID = 5015103922231428878L;
	private static Logger logger = Logger
			.getLogger(CxhdAction.class.getName());
	private int hdid;
	public void setHdid(int hdid) {
		this.hdid = hdid;
	}

	public int getHdid() {
		return hdid;
	}

	public String detail() {
		if(hdid!=0){
			setHdid(hdid);
		}
		return "detail";
	}
}
