package com.ssh.action;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;

import net.sf.json.JSON;
import net.sf.json.JSONObject;

import com.ssh.service.CxhdService;
@Controller
public class CxhdjAction extends JsonAction {
	private static final long serialVersionUID = 5185678948181297162L;
	@Resource
	private CxhdService cxhd;
	
	public String profile(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", cxhd.getCxhd(0));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String img(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", cxhd.getCxhdImg(0));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String hdnr(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", cxhd.findById(Integer.parseInt(getParam())));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
}
