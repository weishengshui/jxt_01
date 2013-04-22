package com.ssh.dao;

import java.util.List;
import java.util.Map;

public interface SpDao extends PageDao{
	public List<Map<String, Object>> querySpl(String param, int limit);
	public List<Map<String, Object>> getTjsp(Long jf, int limit);
	public List<Map<String, Object>> getRmsp(int limit);
	public List<Map<String, Object>> getFkqd(String param,int limit);
	public List<Map<String, Object>> getSpByJfq(String param);
	public List<Map<String, Object>> getAllsplInfo(String param);
	public List<Map<String, Object>> getAllspInfo(String param);
	public List<Map<String, Object>> getSplb1();
	public List<Map<String, Object>> getSplb2();//热门推荐
	public List<Map<String, Object>> getDhfs(String param);
	public List<Map<String, Object>> getNew(String param,int limit);
	public List<Map<String, Object>> getSplInfo(String param);
	public List<Map<String, Object>> getSpInfo(String param);
	public List<Map<String, Object>> getGmsp(String sps,int limit);
	public List<Map<String, Object>> getSpQuery(String param);
	public List<Map<String, Object>> getSpTp(String param);
	
	public String pageSqlsp(String param);
	public String countSqlsp(String param);
	public String pageSqlspl(String param);
	public String countSqlspl(String param);
	public String pageSqltszd(String param);
	public String countSqltszd(String param);
	public String pageSqlzjll(String param);
	public String countSqlzjll(String param);
	public String pageSqltjsp(String param);
	public String countSqltjsp(String param);
	public String pageSqlrmdh(String param);
	public String countSqlrmdh(String param);
	public String pageSqlzshy(String param,String order);
	public String countSqlzshy(String param);
	public String pageSqltszk(String param);
	public String countSqltszk(String param);
}
