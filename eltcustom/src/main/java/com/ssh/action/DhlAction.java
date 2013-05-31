package com.ssh.action;

import com.ssh.base.BaseAction;
import com.ssh.entity.TblQyyg;
import java.util.Map;
import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

@Controller
@Results({
		@org.apache.struts2.convention.annotation.Result(name = "success", location = "/jsp/dhl/list.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "hrlist", location = "/jsp/dhl/hrlist.jsp") })
public class DhlAction extends BaseAction {
	private static final long serialVersionUID = 6465477097875181934L;
	private static Logger logger = Logger.getLogger(DhlAction.class.getName());
	private int yg;

	public void setYg(int yg) {
		this.yg = yg;
	}

	public int getYg() {
		return this.yg;
	}

	public String list() {
		TblQyyg tyq = (TblQyyg) this.session.get("user");
		if (tyq != null) {
			setYg(tyq.getNid().intValue());
		}
		return "success";
	}

	public String hrlist() {
		if (this.session.get("hrygid") != null) {
			setYg(Integer.parseInt(this.session.get("hrygid").toString()));
		}
		return "hrlist";
	}
}