package com.ssh.action;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

import com.ssh.base.BaseAction;
import com.ssh.entity.TblBzzx;
import com.ssh.service.BzzxService;

@Controller
@Results( { @Result(name = "detail", location = "/jsp/bzzx/detail.jsp")})
public class BzzxAction extends BaseAction {
	private static final long serialVersionUID = -3263062137944291791L;
	private static Logger logger = Logger
			.getLogger(BzzxAction.class.getName());
	@Resource
	private BzzxService bzzxserv;
	private TblBzzx bz;
	private int bzid;
	public void setBzid(int bzid) {
		this.bzid = bzid;
	}
	public int getBzid() {
		return bzid;
	}
	public void setBz(TblBzzx bz) {
		this.bz = bz;
	}
	public TblBzzx getBz() {
		return bz;
	}
	
	public String detail() {
		if(bzid != 0){
			setBz(bzzxserv.findById(bzid));
		}
		return "detail";
	}
	
}
