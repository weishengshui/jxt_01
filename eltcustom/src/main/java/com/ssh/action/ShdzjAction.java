package com.ssh.action;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;

import net.sf.json.JSON;
import net.sf.json.JSONObject;

import com.ssh.service.ShdzService;
@Controller
public class ShdzjAction extends JsonAction {
	
	private static final long serialVersionUID = 4368381952669145433L;

	@Resource
	private ShdzService shdz;

	public String all(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", shdz.getShdzByUid(getParam()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String del(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows",shdz.removeById(Integer.parseInt(getParam())));
		JSON res = JSONObject.fromObject(map);
		setResult(res);		
		return SUCCESS;
	}
}
