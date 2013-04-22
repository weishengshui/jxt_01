package com.ssh.action;


import java.sql.Timestamp;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

import com.ssh.base.BaseAction;
import com.ssh.entity.TblQyyg;
import com.ssh.entity.TblShdz;
import com.ssh.service.ShdzService;

@Controller
@Results( { @Result(name = "success", location = "/jsp/shdz/list.jsp"),
	@Result(name = "pop", location = "/jsp/shdz/pop.jsp")})
public class ShdzAction extends BaseAction {
	
	private static final long serialVersionUID = 3372630938495018033L;
	private static Logger logger = Logger
			.getLogger(ShdzAction.class.getName());
	
	@Resource
	private ShdzService shdzService;
	private int rs;
	private int userid;
	private int nid;
	private String shdzshr;
	private TblShdz shdz;


	public void setShdzshr(String shdzshr) {
		this.shdzshr = shdzshr;
	}

	public String getShdzshr() {
		return shdzshr;
	}

	public void setShdz(TblShdz shdz) {
		this.shdz = shdz;
	}

	public void setNid(int nid) {
		this.nid = nid;
	}

	public int getNid() {
		return nid;
	}

	public TblShdz getShdz() {
		return shdz;
	}

	public void setUserid(int userid) {
		this.userid = userid;
	}

	public int getUserid() {
		return userid;
	}

	public void setRs(int rs) {
		this.rs = rs;
	}

	public int getRs() {
		return rs;
	}

	public String list() {
		TblQyyg tyq = (TblQyyg) session.get("user");
		setUserid(tyq.getNid());
		return SUCCESS;
	}
	public String pop() {
		TblShdz dz = new TblShdz();
		if(nid!=0){
			dz = shdzService.findById(nid);
		}
		setShdz(dz);
		setShdzshr(dz.getShr());
		return "pop";
	}
	
	public String popchg() {
		TblQyyg tyq = (TblQyyg) session.get("user");
		shdz.setShr(shdzshr);
		shdz.setYg(tyq.getNid());
		shdz.setRq(new Timestamp(System.currentTimeMillis()));
		shdzService.save(shdz);
		setRs(2);
		return pop();
	}
	
	public String chg() {
		TblQyyg tyq = (TblQyyg) session.get("user");
		shdz.setShr(shdzshr);
		shdz.setYg(tyq.getNid());
		shdz.setRq(new Timestamp(System.currentTimeMillis()));
		shdzService.save(shdz);
		setRs(2);
		return list();
	}
	
	
}
