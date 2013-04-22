package com.ssh.action;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;

import net.sf.json.JSON;
import net.sf.json.JSONObject;
import com.ssh.service.BzzxService;
@Controller
public class BzzxjAction extends JsonAction {
	private static final long serialVersionUID = -7542640835911123427L;
	@Resource
	private BzzxService bzzxserv;
	
	public String list(){ 
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", bzzxserv.getBz());
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
}
