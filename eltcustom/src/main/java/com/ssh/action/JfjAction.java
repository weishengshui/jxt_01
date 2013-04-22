package com.ssh.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;

import net.sf.json.JSON;
import net.sf.json.JSONObject;

import com.ssh.service.JfService;
@Controller
public class JfjAction extends PageAction {
	private static final long serialVersionUID = 7186830814075543941L;
	@Resource
	private JfService jf;
	
	public String profile(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", jf.getJfbyUid(getParam(), 4));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	public String page(){
		List<Map<String,Object>> list = jf.page(getParam(), getPage(), getRp());
		String total = jf.count(getParam());
		return super.pagelist(list, total);
	}

	public String pagely(){
		List<Map<String,Object>> list = jf.pagely(getParam(), getPage(), getRp());
		String total = jf.countly(getParam());
		return super.pagelist(list, total);
	}

	public String lqsj(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", jf.getJfLjsj(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String lq(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rs", jf.lq(Integer.parseInt(getParam())));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
}
