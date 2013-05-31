package com.ssh.action;

import com.ssh.base.BaseAction;
import com.ssh.entity.TblJfqmc;
import com.ssh.entity.TblQyyg;
import com.ssh.service.JfqService;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

@Controller
@Results({
		@org.apache.struts2.convention.annotation.Result(name = "success", location = "/jsp/jfq/list.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "detail", location = "/jsp/jfq/detail.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "jfqly", location = "/jsp/jfq/ly.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "sydetail", location = "/jsp/jfq/sydetail.jsp"),
		@org.apache.struts2.convention.annotation.Result(name = "scflq", location = "/jsp/jfq/jifenjuanbianji.jsp") })
public class JfqAction extends BaseAction {
	private static final long serialVersionUID = -5256870210389064102L;
	private static Logger logger = Logger.getLogger(JfqAction.class.getName());

	@Resource
	private JfqService jfqserv;
	private int yg;
	private int jfq;
	private TblJfqmc jfqmc;

	public void setJfq(int jfq) {
		this.jfq = jfq;
	}

	public int getJfq() {
		return this.jfq;
	}

	public void setJfqmc(TblJfqmc jfqmc) {
		this.jfqmc = jfqmc;
	}

	public TblJfqmc getJfqmc() {
		return this.jfqmc;
	}

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

	public String detail() {
		if (isTrialAccount()) {
			return "sydetail";
		}
		setJfqmc(this.jfqserv.findById(Integer.valueOf(this.jfq)));
		return "detail";
	}

	public String source() {
		TblQyyg tyq = (TblQyyg) this.session.get("user");
		if (tyq != null) {
			setYg(tyq.getNid().intValue());
		}
		return "jfqly";
	}

	public String scflq() {
		return "scflq";
	}
}