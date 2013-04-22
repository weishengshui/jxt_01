package com.ssh.dao;

import java.util.List;
import java.util.Map;

import com.googlecode.genericdao.dao.hibernate.GenericDAO;
import com.ssh.entity.TblBzzx;

public interface BzzxDao extends GenericDAO<TblBzzx, Integer> {
	public List<Map<String, Object>> getBz();
}
