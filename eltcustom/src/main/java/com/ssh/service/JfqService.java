package com.ssh.service;

import java.util.List;
import java.util.Map;

import com.ssh.entity.TblJfqmc;

public interface JfqService {
	public List<Map<String, Object>> getJfqbyUid(String userid, int limit);
	public List<Map<String,Object>> page(String param,String page,String rp);
	public String count (String param);
	public List<Map<String,Object>> pagely(String param,String page,String rp);
	public String countly (String param);
	public List<Map<String, Object>> getJfqLjsj(String yg);
	public List<Map<String, Object>> getDetail(String nid);
	public List<Map<String, Object>> getSpJfqCount(String sp);
	public List<Map<String, Object>> getSpsJfqCount(String sps);
	public List<Map<String, Object>> getSpJfq(String sps);
	public List<Map<String, Object>> getJfqs(int yg);
	
	public boolean save(TblJfqmc jfqmc);
    public boolean[] save(TblJfqmc[] jfqmc);
    public TblJfqmc findById(Integer id);
    public TblJfqmc[] findByIds(Integer[] ids);
	
}
