package com.ssh.dao;

import java.util.List;
import java.util.Map;

public interface PageDao{

	public List<Map<String,Object>> page(String sql,String page,String rp,String total);
	public String getCount(String sql);
}
