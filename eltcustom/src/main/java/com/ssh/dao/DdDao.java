package com.ssh.dao;

import java.util.List;
import java.util.Map;

public interface DdDao extends PageDao{
	public String pageSql(String param);
	public String countSql(String param);
	public List<Map<String, Object>> getJfqdhjl(String yg, int limit);
	public List<Map<String, Object>> getJfdhjl(String yg, int limit);
	public List<Map<String, Object>> getTsmsp(int yg,int qy, int limit);
	public List<Map<String, Object>> getZshy(String param, int limit);
	public List<Map<String, Object>> getXdsp(String param, int limit);
	public List<Map<String, Object>> getDdsp(String param);
	public List<Map<String, Object>> getDdZb(String param);
	public List<Map<String, Object>> getDdspl(String param);
	public List<Map<String, Object>> getDdCount(String param);
}
