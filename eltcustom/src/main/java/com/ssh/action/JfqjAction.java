package com.ssh.action;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;

import com.ssh.entity.TblJfqmc;
import com.ssh.entity.TblQyyg;
import com.ssh.entity.TblSyqyjfq;
import com.ssh.service.JfqService;
@Controller
public class JfqjAction extends PageAction {
	private static final long serialVersionUID = -4681753361100453511L;
	@Resource
	private JfqService jfq;
	
	public String profile(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", jfq.getJfqbyUid(getParam(), 4));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	public String page(){
		List<Map<String,Object>> list = jfq.page(getParam(), getPage(), getRp());
		String total = jfq.count(getParam());
		return super.pagelist(list, total);
	}

	public String pagely(){
		List<Map<String,Object>> list = jfq.pagely(getParam(), getPage(), getRp());
		String total = jfq.countly(getParam());
		return super.pagelist(list, total);
	}
	
	public String lqsj(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", jfq.getJfqLjsj(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	public String detail(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", jfq.getDetail(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String lq(){
		Map<String, Object> map = new HashMap<String,Object>();
		if (isTrialAccount()) {
			TblQyyg user = (TblQyyg) session.get("user");
			if (user != null) {
				TblSyqyjfq syqyjfq = new TblSyqyjfq();
				syqyjfq.setQyyg(user.getNid());
				syqyjfq.setJfqId(Integer.parseInt(getParam()));
				map.put("rs", Boolean.valueOf(jfq.syqylqjfq(syqyjfq)));
			}
		} else {
			TblJfqmc jfqmc = jfq.findById(Integer.parseInt(getParam()));
			jfqmc.setSflq(1);
			jfqmc.setLqsj(new Timestamp(System.currentTimeMillis()));
			map.put("rs", jfq.save(jfqmc));
		}
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	public String syqylqjl() {
		List list = new ArrayList();
		TblQyyg user = (TblQyyg) this.session.get("user");
		if (user != null) {
			list = this.jfq.getylqmrjfq(Integer.toString(user.getNid()
					.intValue()));
		}
		JSON res = JSONArray.fromObject(list);
		setResult(res);
		return "success";
	}

	
	public String spsjfq(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", jfq.getSpJfq(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	
	public String spsjfqcount(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", jfq.getSpsJfqCount(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	
	public String userjfqs(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", jfq.getJfqs(tyg.getNid()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
}
