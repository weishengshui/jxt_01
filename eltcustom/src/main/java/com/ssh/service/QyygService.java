package com.ssh.service;

import java.util.List;
import java.util.Map;

import com.ssh.entity.TblQyyg;
public interface QyygService {
	public boolean save(TblQyyg qyyg);
    public boolean[] save(TblQyyg[] qyyg);
    public boolean remove(TblQyyg qyyg);
    public void remove(TblQyyg[] qyyg);
    public boolean removeById(Integer id);
    public void removeByIds(Integer[] ids);
    public List<TblQyyg> findAll();
    public TblQyyg findById(Integer id);
    public TblQyyg findByEmail(String email);
    public TblQyyg[] findByIds(Integer[] ids);
    public void flush();
	public List<Map<String, Object>> getQyinfo(int qy);
}
