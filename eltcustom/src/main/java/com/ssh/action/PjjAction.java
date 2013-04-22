package com.ssh.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;

import net.sf.json.JSON;
import net.sf.json.JSONObject;

import com.ssh.service.PjService;
@Controller
public class PjjAction extends PageAction {
	private static final long serialVersionUID = -4558156321392924217L;
	@Resource
	private PjService pj;
	
	public String sum(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("xj", pj.getPjxj(getParam()));
		map.put("lx", pj.getPjlx(getParam()));
		map.put("total", pj.getSumPf(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String page(){
		List<Map<String,Object>> list = pj.page(getParam(), getPage(), getRp());
		String total = pj.count(getParam());
		return super.pagelist(list, total);
	}
}
