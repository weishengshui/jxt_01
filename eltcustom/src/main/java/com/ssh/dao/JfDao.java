package com.ssh.dao;

import java.util.List;
import java.util.Map;

public interface JfDao extends PageDao{
	public String pagelySql(String param);
	public String countlySql(String param);
	public String pageSql(String param);
	public List<Map<String, Object>> getJfbyUid(String userid, int limit);
	public String countSql(String param);
	public List<Map<String, Object>> getJfLjsj(String yg);
}
