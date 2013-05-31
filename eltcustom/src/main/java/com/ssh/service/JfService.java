package com.ssh.service;

import java.util.List;
import java.util.Map;

import com.ssh.entity.TblJfffmc;

public interface JfService {
	public List<Map<String, Object>> getJfbyUid(String userid, int limit);
	public List<Map<String,Object>> page(String param,String page,String rp);
	public String count (String param);
	public List<Map<String,Object>> pagely(String param,String page,String rp);
	public String countly (String param);
	public List<Map<String, Object>> getJfLjsj(String yg);	

    public boolean lq(Integer id);
	public boolean save(TblJfffmc jfffmc);
    public boolean[] save(TblJfffmc[] jfffmc);
    public TblJfffmc findById(Integer id);
    public TblJfffmc[] findByIds(Integer[] ids);

	public List<Map<String, Object>> getJfbyUidForSy(String paramString, int paramInt);
	public boolean sylq(Integer paramInteger);
	public List<Map<String, Object>> getJfLjsjForSy(String paramString);
	public List<Map<String, Object>> pagelyForSy(String paramString1, String paramString2, String paramString3);
	public String countlyForSy(String paramString);
}
