package com.ssh.service;

import java.util.List;
import java.util.Map;

import com.ssh.entity.TblShdz;

public interface ShdzService {
	public List<Map<String, Object>> getShdzByUid(String userid);
	public boolean save(TblShdz shdz);
    public boolean[] save(TblShdz[] shdz);
    public boolean remove(TblShdz shdz);
    public void remove(TblShdz[] shdz);
    public boolean removeById(Integer id);
    public void removeByIds(Integer[] ids);
    public List<TblShdz> findAll();
    public TblShdz findById(Integer id);
    public TblShdz[] findByIds(Integer[] ids);
    public void flush();
}
