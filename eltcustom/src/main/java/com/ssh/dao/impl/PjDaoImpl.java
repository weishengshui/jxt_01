package com.ssh.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ssh.base.SqlDao;
import com.ssh.dao.PjDao;

@Repository
public class PjDaoImpl extends PageDaoImpl implements PjDao{
	@Resource
	private SqlDao sqldao;

	private static Logger logger = Logger.getLogger(PjDaoImpl.class
			.getName());


	public String pageSql(String param) {
		String sql = "SELECT t.nid,t.spl,t.yg,t.zpf,t.pjxj,t.pjnr,t.pj,u.ygxm,u.nc," +
				" DATE_FORMAT(t.rq,'%Y.%m.%d %H:%i') pjrq FROM tbl_pj t " +
				" LEFT JOIN tbl_qyyg u ON u.nid = t.yg WHERE 1=1 "+param +" ORDER BY t.rq DESC";
		return sql;
	}
	public String countSql(String param) {
		String sql = "SELECT COUNT(t.nid) AS count FROM tbl_pj t where 1=1 "+param;
		return sql;
	}

	public List<Map<String, Object>> getPjxj(String param) {
		String sql = " SELECT COUNT(t.nid) AS countxj,t.pjxj  FROM tbl_pj t where 1=1 " +
				param+" GROUP BY t.pjxj ORDER BY t.pjxj DESC";
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("PjDaoImpl--getPjxj", e);
		}
		return list;
	}

	public List<Map<String, Object>> getPjlx(String param) {
		String sql = " SELECT COUNT(t.nid) AS countxj,t.pj  FROM tbl_pj t where 1=1 " +
				param+" GROUP BY t.pj ORDER BY t.pjxj DESC";
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("PjDaoImpl--getPjxj", e);
		}
		return list;
	}

	public List<Map<String, Object>> getSumPf(String param) {
		String sql = " SELECT COUNT(t.nid) AS totalcount,SUM(t.zpf)" +
			" AS sumxj FROM tbl_pj t where 1=1 " +param;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("PjDaoImpl--getSumPf", e);
		}
		return list;
	}
}
