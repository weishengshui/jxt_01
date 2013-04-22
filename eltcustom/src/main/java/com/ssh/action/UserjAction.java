package com.ssh.action;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;

import net.sf.json.JSON;
import net.sf.json.JSONObject;

import com.ssh.entity.TblQyyg;
import com.ssh.service.QyygService;
@Controller
public class UserjAction extends JsonAction {
	private static final long serialVersionUID = 358792833705760904L;
	@Resource
	private QyygService qyyg;
	
	private int yg;
	private int shdz;
	
	public void setShdz(int shdz) {
		this.shdz = shdz;
	}
	public int getShdz() {
		return shdz;
	}
	public void setYg(int yg) {
		this.yg = yg;
	}
	public int getYg() {
		return yg;
	}
	public String modifyshdz(){
		TblQyyg user = qyyg.findById(yg);
		user.setShdz(shdz);
		qyyg.save(user);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("result", 2);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	

	public String getjf(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		TblQyyg user = qyyg.findById(tyg.getNid());		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("rs", user);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	public String getqy(){
		TblQyyg tyg = (TblQyyg) session.get("user");	
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("rs", qyyg.getQyinfo(tyg.getQy()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
}
