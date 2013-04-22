package com.ssh.dao;

import java.util.List;
import java.util.Map;

import com.ssh.entity.TblQyyg;
import com.googlecode.genericdao.dao.hibernate.GenericDAO;

public interface QyygDao extends GenericDAO<TblQyyg, Integer> {
	public List<Map<String, Object>> getQyinfo(int qy);
}
