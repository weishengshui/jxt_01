package com.ssh.dao;

import java.util.List;
import java.util.Map;

public interface GbDao extends PageDao{
	public List<Map<String, Object>> getGbbyQy(String param, int limit);
	public String pageSql(String param);
	public String countSql(String param);
	public List<Map<String, Object>> getYgGbwd(String param);
	public int setYgGbyd(String param);
}
