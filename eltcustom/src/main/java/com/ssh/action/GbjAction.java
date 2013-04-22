package com.ssh.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;

import net.sf.json.JSON;
import net.sf.json.JSONObject;

import com.ssh.entity.TblQyyg;
import com.ssh.service.GbService;
@Controller
public class GbjAction extends PageAction {
	
	private static final long serialVersionUID = -1575018137004936842L;
	@Resource
	private GbService gb;
	
	public String profile(){
		Map<String, Object> map = new HashMap<String,Object>();
		TblQyyg user = (TblQyyg) session.get("user");
		map.put("rows", gb.getGbbyQy(user.getQy(),user.getNid(),5));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}

	public String wdsl(){
		TblQyyg user = (TblQyyg) session.get("user");
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("count", gb.getYgGbwd(user.getNid(),user.getQy()));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
	
	public String page(){
		TblQyyg user = (TblQyyg) session.get("user");
		String param = " AND t.qy = "+user.getQy()+" AND m.yg = "+ user.getNid();
		List<Map<String,Object>> list = gb.page(param, getPage(), getRp());
		String total = gb.count(param);
		return super.pagelist(list, total);
	}

	public String idread(){
		TblQyyg user = (TblQyyg) session.get("user");
		String param = " AND t.lynid = "+getParam()+" AND t.yg = "+ user.getNid();
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("count", gb.setYgGbyd(param));
		JSON res = JSONObject.fromObject(map);
		setResult(res);
		return SUCCESS;
	}
}
