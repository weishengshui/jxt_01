package com.ssh.dao;

import java.util.List;
import java.util.Map;

import com.googlecode.genericdao.dao.hibernate.GenericDAO;
import com.ssh.entity.TblCxhd;

public interface CxhdDao extends GenericDAO<TblCxhd, Integer>{
	public List<Map<String, Object>> getCxhd(String param,int limit);
}
