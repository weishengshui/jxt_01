package com.ssh.dao;

import java.util.List;
import java.util.Map;

public interface PjDao extends PageDao{
	public List<Map<String, Object>> getSumPf(String param);
	public List<Map<String, Object>> getPjxj(String param);
	public List<Map<String, Object>> getPjlx(String param);
	public String pageSql(String param);
	public String countSql(String param);
}
