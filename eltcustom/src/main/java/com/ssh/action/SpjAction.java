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
import com.ssh.service.LljlService;
import com.ssh.service.QyygService;
import com.ssh.service.SpService;
@Controller
public class SpjAction extends PageAction {

	private static final long serialVersionUID = 5326658715321832684L;
	@Resource
	private SpService sp;
	@Resource
	private DdService dds;
	@Resource
	private QyygService qyyg;	
	@Resource
	private	LljlService lls;
	private String query;
	
	public void setQuery(String query) {
		this.query = query;
	}

	public String getQuery() {
		return query;
	}
	
	public String tlxsl(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getLmxsl(Integer.parseInt(getParam()), 5));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String tltjw(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getLmtjw(Integer.parseInt(getParam()),Integer.parseInt(getQuery()),5));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String dhfs(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getDhfs(Integer.parseInt(getParam())));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String splm(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getSplb1());
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	//热门推荐
	public String splm2(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getSplb2());
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String tj(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		TblQyyg user = qyyg.findById(tyg.getNid());
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getTjsp(user.getJf(), 4));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String tj3(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		TblQyyg user = qyyg.findById(tyg.getNid());
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getTjsp(user.getJf(), 3));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String ffqd(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getFkqd(" and lb1 = "+getParam(), 4));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	
	public String zxsj(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getNew(" and lb1 = "+getParam(), 4));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	
	public String zshy(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", dds.getZshy(" and xb= "+getParam(), 8));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	
	public String tszk(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", lls.getTszk(tyg.getNid(), tyg.getQy(), 8));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	
	public String rm3(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getRmsp(3));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String rm(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getRmsp(4));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	
	
	public String rm5(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getRmsp(5));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String jfqsp(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getSpByJfq(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	
	public String pagesp(){
		List<Map<String,Object>> list = sp.pagesp(getParam(), getPage(), getRp());
		String total = sp.countsp(getParam());
		return super.pagelist(list, total);
	}

	
	public String pagespl(){
		List<Map<String,Object>> list = sp.pagespl(getParam(), getPage(), getRp());
		String total = sp.countspl(getParam());
		return super.pagelist(list, total);
	}

	
	public String pagetszd(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		TblQyyg user = qyyg.findById(tyg.getNid());
		List<Map<String,Object>> list = sp.pagetszd(getParam(),user.getQy(),user.getNid(), getPage(), getRp());
		String total = sp.counttszd(user.getQy(),user.getNid());
		return super.pagelist(list, total);
	}

	
	public String pagezjll(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		TblQyyg user = qyyg.findById(tyg.getNid());
		List<Map<String,Object>> list = sp.pagezjll(getParam(),user.getNid(), getPage(), getRp());
		String total = sp.countzjll(user.getNid());
		return super.pagelist(list, total);
	}

	
	public String pagetjsp(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		TblQyyg user = qyyg.findById(tyg.getNid());
		List<Map<String,Object>> list = sp.pagetjsp(getParam(),Long.toString(user.getJf()), getPage(), getRp());
		String total = sp.counttjsp(Long.toString(user.getJf()));
		return super.pagelist(list, total);
	}

	
	public String pagermdh(){
		List<Map<String,Object>> list = sp.pagermdh(getParam(), getPage(), getRp());
		String total = sp.countrmdh(getParam());
		return super.pagelist(list, total);
	}

	
	public String pagezshy(){
		List<Map<String,Object>> list = sp.pagezshy(getParam(),Integer.parseInt(getQuery()), getPage(), getRp());
		String total = sp.countzshy(Integer.parseInt(getQuery()));
		return super.pagelist(list, total);
	}

	
	public String pagetszk(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		TblQyyg user = qyyg.findById(tyg.getNid());
		List<Map<String,Object>> list = sp.pagetszk(getParam(),user.getQy(),user.getNid(), getPage(), getRp());
		String total = sp.counttszk(user.getQy(),user.getNid());
		return super.pagelist(list, total);
	}
	

	
	public String spinfo(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getSpInfo(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	
	public String splinfo(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getSplInfo(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	
	public String spbyspl(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getSpBySpl(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	
	public String gmbysps(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getGmsp(getParam(),4));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}


	
	public String spbysps(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getSpQuery(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	
	public String spsdhfs(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getSpsDhfs(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	
	public String sptp(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", sp.getSpTp(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
}
