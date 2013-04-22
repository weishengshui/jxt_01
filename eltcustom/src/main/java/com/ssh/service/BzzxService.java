package com.ssh.service;

import java.util.List;
import java.util.Map;

import com.ssh.entity.TblBzzx;

public interface BzzxService {	
	public List<Map<String, Object>> getBz();
    public TblBzzx findById(Integer id);
}
