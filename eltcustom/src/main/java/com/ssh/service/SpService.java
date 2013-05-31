package com.ssh.service;

import java.util.List;
import java.util.Map;
import com.ssh.entity.TblSp;
import com.ssh.entity.TblSpl;

public interface SpService {

	public List<Map<String, Object>> getLmxsl(int lm, int limit);
	public List<Map<String, Object>> getLmtjw(int lm,int jf, int limit);
	public List<Map<String, Object>> getTjsp(Long jf, int limit);
	public List<Map<String, Object>> getRmsp(int limit);
	public List<Map<String, Object>> getSpByJfq(String jfq);
	public List<Map<String, Object>> getSpBySpJfq(int jfq,int sp);
	public List<Map<String, Object>> getFkqd(String param,int limit);
	public List<Map<String, Object>> getNew(String param,int limit);
	public List<Map<String, Object>> getSplb1();
	public List<Map<String, Object>> getSplb2(); //热门推荐
	public List<Map<String, Object>> getSplInfo(String spl);
	public List<Map<String, Object>> getSpInfo(String sp);
	public List<Map<String, Object>> getDhfs(int sp);
	public List<Map<String, Object>> getGmsp(String sps,int limit);
	public List<Map<String, Object>> getSpsDhfs(String sps);
	public List<Map<String, Object>> getSpQuery(String sps);
	public List<Map<String, Object>> getSpTp(String sp);
	
	public List<Map<String,Object>> pagesp(String param,String page,String rp);
	public String countsp (String param);
	public List<Map<String,Object>> pagespl(String param,String page,String rp);
	public String countspl (String param);
	public List<Map<String,Object>> pagetszd(String order,int qy,int yg,String page,String rp);
	public String counttszd (int qy,int yg);
	public List<Map<String,Object>> pagezjll(String order,int yg,String page,String rp);
	public String countzjll (int yg);
	public List<Map<String,Object>> pagetjsp(String order,String jf,String page,String rp);
	public String counttjsp (String jf);
	public List<Map<String,Object>> pagermdh(String param,String page,String rp);
	public String countrmdh (String param);
	public List<Map<String,Object>> pagezshy(String query,int xb,String page,String rp);
	public String countzshy (int xb);
	public List<Map<String,Object>> pagetszk(String query,int qy,int yg,String page,String rp);
	public String counttszk (int qy,int yg);
    public TblSp findSpById(Integer id);
    public TblSpl findSplById(Integer id);
    public List<Map<String, Object>> getSpBySpl(String spl);

	public Boolean checkInQyList(String paramString);
}
