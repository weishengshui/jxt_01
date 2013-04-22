package com.ssh.dao;

import java.util.List;
import java.util.Map;

public interface JfqDao extends PageDao{
	public String pageSql(String param);
	public String countSql(String param);
	public String pagelySql(String param);
	public String countlySql(String param);
	public List<Map<String, Object>> getJfqbyUid(String userid, int limit);
	public List<Map<String, Object>> getJfqLjsj(String yg);
	public List<Map<String, Object>> getDetail(String nid);
	public List<Map<String, Object>> getSpJfqCount(String param);
	public List<Map<String, Object>> getSpJfq(String param);
	public List<Map<String, Object>> getJfqs(String param);
	public List<Map<String, Object>> getJfqmcs(String param,int limit);
}
