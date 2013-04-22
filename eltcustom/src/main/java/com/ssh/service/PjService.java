package com.ssh.service;

import java.util.List;
import java.util.Map;

import com.ssh.entity.TblPj;

public interface PjService {
	public List<Map<String, Object>> getSumPf(String spl);
	public List<Map<String, Object>> getPjxj(String spl);
	public List<Map<String, Object>> getPjlx(String spl);
	public List<Map<String,Object>> page(String param,String page,String rp);
	public String count (String param);
	

	public boolean save(TblPj pj);
    public boolean[] save(TblPj[] pjs);
    public TblPj findById(Integer id);
    public TblPj[] findByIds(Integer[] ids);
}
