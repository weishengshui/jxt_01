package com.ssh.service;

import java.util.List;
import java.util.Map;

import com.ssh.entity.TblCxhd;

public interface CxhdService {
	public List<Map<String, Object>> getCxhd(int limit);
	public List<Map<String, Object>> getCxhdImg(int limit);
    public TblCxhd findById(Integer id);
}
