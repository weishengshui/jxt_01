package com.ssh.dao;

import com.googlecode.genericdao.dao.hibernate.GenericDAO;
import com.ssh.entity.TblSyqyjfq;
import java.util.List;
import java.util.Map;

public abstract interface SyqyjfqDao extends GenericDAO<TblSyqyjfq, Integer> {
	public abstract List<Map<String, Object>> getylqmrjfq(String paramString);
}