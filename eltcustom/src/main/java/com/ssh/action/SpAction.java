package com.ssh.action;


import java.sql.Timestamp;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

import com.ssh.base.BaseAction;
import com.ssh.entity.TblLljl;
import com.ssh.entity.TblQyyg;
import com.ssh.entity.TblSp;
import com.ssh.entity.TblSpl;
import com.ssh.service.LljlService;
import com.ssh.service.SpService;

@Controller
@Results( { @Result(name = "success", location = "/jsp/sp/list.jsp"),
	@Result(name = "base", location = "/jsp/sp/base.jsp"),
	@Result(name = "detail", location = "/jsp/sp/detail.jsp")})
public class SpAction extends BaseAction {

	private static final long serialVersionUID = 1950908825912457153L;
	private static Logger logger = Logger
			.getLogger(SpAction.class.getName());
	@Resource
	private SpService spserv;
	@Resource
	private LljlService lljlserv;
	
	private int userid;
	private String param;
	private String key;
	private String lm;
	private String order;
	private String query;
	private String jfq;
	private String jfqmcid;
	private int sp;
	private int spl;
	public void setKey(String key) {
		this.key = key;
	}

	public String getKey() {
		return key;
	}

	public void setLm(String lm) {
		this.lm = lm;
	}

	public String getLm() {
		return lm;
	}

	public void setSp(int sp) {
		this.sp = sp;
	}

	public void setQuery(String query) {
		this.query = query;
	}

	public String getQuery() {
		return query;
	}

	public void setOrder(String order) {
		this.order = order;
	}

	public String getOrder() {
		return order;
	}

	public void setSpl(int spl) {
		this.spl = spl;
	}

	public int getSpl() {
		return spl;
	}

	public int getSp() {
		return sp;
	}

	public void setParam(String param) {
		this.param = param;
	}

	public String getParam() {
		return param;
	}

	public void setUserid(int userid) {
		this.userid = userid;
	}

	public int getUserid() {
		return userid;
	}

	public void setJfqmcid(String jfqmcid) {
		this.jfqmcid = jfqmcid;
	}

	public String getJfqmcid() {
		return jfqmcid;
	}
	
	public void setJfq(String jfq) {
		this.jfq = jfq;
	}

	public String getJfq() {
		return jfq;
	}

	public String list() {
		if(param!=null&&!param.equals("")){
			if(param.equals("zxsj")){
				setParam("spl");
				setOrder(" t.rq desc ");
			}
			if(param.equals("fkqd")){
				setParam("spl");
				setOrder(" ydsl desc ");
			}
			if(param.equals("tjsp")){
				setParam(param);
				setOrder(" s.qbjf DESC ");
			}
			if(param.equals("rmdh")){
				setParam("spl");
				setOrder("sftj desc , ydsl DESC ,t.nid desc ");
			} 
			if(param.equals("zshy")){
				setParam(param);
				setOrder(" splcount DESC, s.nid DESC  ");
			}
			if(param.equals("tszk")){
				setParam(param);
				setOrder(" t.llsj DESC ");
			}
			if(param.equals("zjll")){
				setParam(param);
				setOrder(" t.llsj DESC ");
			}
			if(param.equals("tszd")){
				setParam(param);
				setOrder(" s.nid DESC ");
			}
			else setParam(param);
		}
		else setParam("spl");
		if(query!=null&&!query.equals("")){
			setQuery("?query="+query);
		}
		TblQyyg user = (TblQyyg) session.get("user");
		if(user!=null){
			setUserid(user.getNid());
		}
		setKey(key);
		setLm(lm);
		return SUCCESS;
	}

	public String base() {
		TblQyyg user = (TblQyyg) session.get("user");
		if(user!=null){
			setUserid(user.getNid());
		}		
		return "base";
	}
	public String detail(){
		Timestamp tsnow = new Timestamp(System.currentTimeMillis());
		setJfq(jfq);
		TblQyyg user = (TblQyyg) session.get("user");
		if(sp!=0){
			setSp(sp);
			TblSp tsp = spserv.findSpById(sp);
			int ttspl = tsp.getSpl();
			setSpl(ttspl);
			List<TblLljl> ll = lljlserv.findBySpYg(user.getNid(), sp, ttspl);
			if(ll.size()>0){
				TblLljl tl = ll.get(0);
				tl.setLlsj(tsnow);
				lljlserv.save(tl);
			}
			else{
				TblLljl tl = new TblLljl();
				tl.setQy(user.getQy());
				tl.setYg(user.getNid());
				tl.setSp(sp);
				tl.setSpl(ttspl);
				tl.setLlsj(tsnow);
				lljlserv.save(tl);
			}
			return "detail";			
		}
		else if(spl!=0){
			setSp(spl);
			TblSpl tspl = spserv.findSplById(spl);
			int ttsp = tspl.getSp();
			setSp(ttsp);
			List<TblLljl> ll = lljlserv.findBySpYg(user.getNid(), ttsp, spl);
			if(ll.size()>0){
				TblLljl tl = ll.get(0);
				tl.setLlsj(tsnow);
				lljlserv.save(tl);
			}
			else{
				TblLljl tl = new TblLljl();
				tl.setQy(user.getQy());
				tl.setYg(user.getNid());
				tl.setSp(ttsp);
				tl.setSpl(spl);
				tl.setLlsj(tsnow);
				lljlserv.save(tl);
			}
			return "detail";
		}
		else return SUCCESS;
	}
}
