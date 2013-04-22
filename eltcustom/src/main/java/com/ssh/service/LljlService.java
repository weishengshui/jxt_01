package com.ssh.service;

import java.util.List;
import java.util.Map;

import com.ssh.entity.TblLljl;

public interface LljlService {
	public List<Map<String, Object>> getLljjTitle(String yg, int limit);
	public List<Map<String, Object>> getTszk(int yg, int qy, int limit);
	
	public List<TblLljl> findBySpYg(Integer yg,Integer sp,Integer spl);
	public boolean save(TblLljl lljl);
    public boolean[] save(TblLljl[] lljl);
    public TblLljl findById(Integer id);
    public TblLljl[] findByIds(Integer[] ids);
}
