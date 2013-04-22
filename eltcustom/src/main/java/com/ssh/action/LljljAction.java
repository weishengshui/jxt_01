package com.ssh.action;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;

import net.sf.json.JSON;
import net.sf.json.JSONObject;

import com.ssh.entity.TblQyyg;
import com.ssh.service.LljlService;
@Controller
public class LljljAction extends JsonAction {
	
	private static final long serialVersionUID = -3646246882231918104L;
	@Resource
	private LljlService lljl;
	
	public String profile(){
		TblQyyg tyg = (TblQyyg) session.get("user");
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("rows", lljl.getLljjTitle(Integer.toString(tyg.getNid()), 4));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
}
