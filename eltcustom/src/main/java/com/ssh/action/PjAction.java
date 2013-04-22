package com.ssh.action;


import java.sql.Timestamp;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

import com.ssh.base.BaseAction;
import com.ssh.entity.TblPj;
import com.ssh.entity.TblQyyg;
import com.ssh.service.DdService;
import com.ssh.service.PjService;

@Controller
@Results( { @Result(name = "success", location = "/jsp/pj/pop.jsp")})
public class PjAction extends BaseAction {
	private static final long serialVersionUID = 8762461611753754039L;
	private static Logger logger = Logger
			.getLogger(PjAction.class.getName());

	@Resource
	private DdService ddserv;
	@Resource
	private PjService pjserv;
	private String ddh;
	private String pjrs;
	private String pj;
	private String spl;
	private String fwpf;
	private String fhpf;
	private String wlpf;
	private String pjnr;
	public void setPjrs(String pjrs) {
		this.pjrs = pjrs;
	}

	public String getPjrs() {
		return pjrs;
	}

	public void setDdh(String ddh) {
		this.ddh = ddh;
	}

	public String getDdh() {
		return ddh;
	}

	public void setSpl(String spl) {
		this.spl = spl;
	}

	public String getSpl() {
		return spl;
	}

	public String getPj() {
		return pj;
	}

	public void setPj(String pj) {
		this.pj = pj;
	}

	public String getFwpf() {
		return fwpf;
	}

	public void setFwpf(String fwpf) {
		this.fwpf = fwpf;
	}

	public String getFhpf() {
		return fhpf;
	}

	public void setFhpf(String fhpf) {
		this.fhpf = fhpf;
	}

	public String getWlpf() {
		return wlpf;
	}

	public void setWlpf(String wlpf) {
		this.wlpf = wlpf;
	}

	public String getPjnr() {
		return pjnr;
	}

	public void setPjnr(String pjnr) {
		this.pjnr = pjnr;
	}

	public String pop() {
		TblQyyg tyg = (TblQyyg) session.get("user");
		if(ddserv.findZbByDdh(ddh).getYg().intValue()!=tyg.getNid().intValue()){
			setPjrs("订单没有找到。");
			return SUCCESS;
		}
		setDdh(ddh);
		return SUCCESS;
	}
	

	public String add() {
		TblQyyg tyg = (TblQyyg) session.get("user");
		Timestamp tsnow = new Timestamp(System.currentTimeMillis());
		if(ddserv.pingjia(ddh)==0){
			setPjrs("评价失败。");
			return SUCCESS;
		}
		else{
			String[] spls = spl.split(",");
			int splsize = spls.length;
			TblPj[] pjarr = new TblPj[splsize];
			if(splsize == 0){
				setPjrs("评价失败。");
				return SUCCESS;
			}
			String[] pjs = pj.split(",");
			String[] fwpfs = fwpf.split(",");
			String[] fhpfs = fhpf.split(",");
			String[] wlpfs = wlpf.split(",");
			String[] pjnrs = pjnr.split(",");
			for(int i=0;i<splsize;i++){
				TblPj pjobj = new TblPj();
				pjobj.setSpl(Integer.parseInt(spls[i].trim()));
				pjobj.setYg(tyg.getNid());
				pjobj.setRq(tsnow);
				pjobj.setPjnr(pjnrs[i].trim());
				pjobj.setYgxb(tyg.getXb());
				pjobj.setFhpf(Integer.parseInt(fhpfs[i].trim()));
				pjobj.setFwpf(Integer.parseInt(fwpfs[i].trim()));
				pjobj.setWlpf(Integer.parseInt(wlpfs[i].trim()));
				pjobj.setPj(Integer.parseInt(pjs[i].trim()));
				Double zpf = (Double.parseDouble(fwpfs[i].trim())+ Double.parseDouble(fhpfs[i].trim())
					+Double.parseDouble(wlpfs[i].trim()))/3;
				pjobj.setZpf(zpf);
				pjobj.setPjxj(zpf.intValue());
				pjarr[i]=pjobj;
			}
			pjserv.save(pjarr);
			setPjrs("评价成功。");
			return SUCCESS;			
		}
	}
}
