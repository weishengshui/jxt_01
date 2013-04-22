package com.ssh.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSON;
import net.sf.json.JSONObject;


public class PageAction extends JsonAction {
	private static final long serialVersionUID = -84881611355028273L;
	private String page;
	private String rp;
	
	public String getPage() {
		return page;
	}
	public void setPage(String page) {
		this.page = page;
	}
	public String getRp() {
		return rp;
	}
	public void setRp(String rp) {
		this.rp = rp;
	}
	
	public String pagelist(List<Map<String,Object>> list,String total) {
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", list);
		map.put("page", page);
		map.put("total", total);
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
}
