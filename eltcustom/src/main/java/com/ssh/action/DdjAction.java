package com.ssh.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;

import net.sf.json.JSON;
import net.sf.json.JSONObject;
import com.ssh.entity.TblQyyg;
import com.ssh.service.DdService;
import com.ssh.service.JfqService;
import com.ssh.service.QyygService;
@Controller
public class DdjAction extends PageAction {
	
	private static final long serialVersionUID = -1575018137004936842L;
	@Resource
	private DdService dd;
	@Resource
	private JfqService jfqserv;
	@Resource
	private QyygService qyyg;	
	
	private String qybm;
	private String dhlist;
	private String sllist;
	private int zjf;
	public void setZjf(int zjf) {
		this.zjf = zjf;
	}
	public int getZjf() {
		return zjf;
	}
	public void setSllist(String sllist) {
		this.sllist = sllist;
	}
	public String getSllist() {
		return sllist;
	}
	public void setDhlist(String dhlist) {
		this.dhlist = dhlist;
	}
	public String getDhlist() {
		return dhlist;
	}
	public String getQybm() {
		return qybm;
	}
	public void setQybm(String qybm) {
		this.qybm = qybm;
	}
	
	public String page(){
		List<Map<String,Object>> list = dd.page(getParam(), getPage(), getRp());
		String total = dd.count(getParam());
		return super.pagelist(list, total);
	}
	
	public String cancel(){
		String oprs = "";
		int rs = 0;
		TblQyyg tyg = (TblQyyg) session.get("user");
		if(dd.findZbByDdh(getParam()).getYg().intValue()!=tyg.getNid().intValue()){
			oprs = "订单没有找到。";
		}
		else {
			rs = dd.cancel(getParam());
			if(rs == 2){
				oprs = "订单取消成功。";
			}else{
				oprs = "操作失败。";
			}
		}
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rs", oprs);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}	
	public String confirm(){
		String oprs = "";
		int rs = 0;
		TblQyyg tyg = (TblQyyg) session.get("user");
		if(dd.findZbByDdh(getParam()).getYg().intValue()!=tyg.getNid().intValue()){
			oprs = "订单没有找到。";
		}
		else {
			rs = dd.confirm(getParam());
			if(rs == 2){
				oprs = "订单确认成功。";
			}else{
				oprs = "操作失败。";
			}
		}
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rs", oprs);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}	
	
	public String remind(){
		String oprs = "";
		int rs = 0;
		TblQyyg tyg = (TblQyyg) session.get("user");
		if(dd.findZbByDdh(getParam()).getYg().intValue()!=tyg.getNid().intValue()){
			oprs = "订单没有找到。";
		}
		else {
			rs = dd.remind(getParam());
			if(rs == 2){
				oprs = "提醒商家发货成功。";
			}else{
				oprs = "操作失败。";
			}
		}
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rs", oprs);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}	
	
	
	public String ddv(){
		String oprs = "";
		int ddvrs = dd.vertify(getParam());
		if(ddvrs==5){
			oprs = "success";
		}
		if(ddvrs==2){
			oprs = "无法支付，剩余积分不足。";
		}
		if(ddvrs==3){
			oprs = "无法支付，剩余积分券不足。";
		}
		if(ddvrs==4){
			oprs = "无法支付，商品库存不足。";
		}
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rs", oprs);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String vertify(){
		boolean jfEnough = false;
		boolean jfqEnough = true;
		String rs = "success";
		Map<String,Long> jfqmap = new HashMap<String,Long>(); 
		Map<String,Long> jfqyfmap = new HashMap<String,Long>(); 
		TblQyyg tyg = (TblQyyg) session.get("user");
		TblQyyg user = qyyg.findById(tyg.getNid());
		if(user.getJf()>=zjf){
			jfEnough = true;
		}
		if(dhlist.indexOf("jfq")==-1){
			jfqEnough = true;
		}
		else{
			List<Map<String, Object>> jfqlist = jfqserv.getJfqs(user.getNid());
			for(Map<String, Object> l:jfqlist){
				jfqmap.put(Long.toString((Long)l.get("jfq")), (Long) l.get("jfqcount"));
			}
			String[] tdh = dhlist.split(",");
			String[] tsl = sllist.split(",");
			for(int i=0;i<tdh.length;i++){
				if(tdh[i].indexOf("jfq")!=-1){
					String yfjfq = tdh[i].substring(3);
					if(jfqyfmap.get(yfjfq)==null){
						jfqyfmap.put(yfjfq, Long.parseLong(tsl[i]));
					}
					else if(jfqyfmap.get(yfjfq)!=null){
						jfqyfmap.put(yfjfq, jfqyfmap.get(yfjfq)+Long.parseLong(tsl[i]));
					}
				}
			}
			for(Map.Entry<String, Long> entry : jfqyfmap.entrySet()){
				if(jfqmap.get(entry.getKey())==null||jfqmap.get(entry.getKey())<entry.getValue()){
						jfqEnough = false; 
						break;
					}				
			}
		}	
		if(jfEnough&&!jfqEnough){
			rs = "您的积分券不足，请选择其他兑换方式，或者减少兑换数量。";
		}
		else if(!jfEnough&&jfqEnough){
			rs = "您的积分不足，请选择其他兑换方式，或者减少兑换数量。";
		}
		else if(!jfEnough&&!jfqEnough){
			rs = "您的积分券和积分不足，请选择其他兑换方式，或者减少兑换数量。";
		}
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rs", rs);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	public String mxspl(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", dd.getDdspl(tyg.getNid(), getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}	

	public String ddmx(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", dd.getDdMx(tyg.getNid(), getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String ddc(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", dd.getDdCount(tyg.getNid()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String listzb(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", dd.getDdZb(tyg.getNid(),getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}	
	public String listmx(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", dd.getDdByDdh(tyg.getNid(),getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}	
	public String jfdhjl(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", dd.getJfdhjl(getParam(), 5));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String jfqdhjl(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", dd.getJfqdhjl(getParam(), 6));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	public String tsmsp(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", dd.getTsmsp(tyg.getNid(),tyg.getQy(), 4));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	
	public String xdsp(){ 
		TblQyyg tyg = (TblQyyg) session.get("user");
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", dd.getXdsp(tyg.getNid(),Integer.parseInt(getParam()),0));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
}
