package com.ssh.dao;

import java.util.List;
import java.util.Map;

import com.googlecode.genericdao.dao.hibernate.GenericDAO;
import com.ssh.entity.TblShdz;

public interface ShdzDao extends GenericDAO<TblShdz, Integer> {
	public List<Map<String, Object>> getShdzByUid(String userid);
}
