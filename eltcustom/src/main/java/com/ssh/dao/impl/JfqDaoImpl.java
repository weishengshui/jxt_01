package com.ssh.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ssh.base.SqlDao;
import com.ssh.dao.JfqDao;

@Repository   
public class JfqDaoImpl extends PageDaoImpl implements JfqDao{
	@Resource
	private SqlDao sqldao;

	private static Logger logger = Logger.getLogger(JfqDaoImpl.class
			.getName());

	public List<Map<String, Object>> getJfqbyUid(String userid, int limit) {
		String sql = " SELECT t.nid,t.sflq,DATE_FORMAT(t.ffsj,'%m.%d') ffsj,DATE_FORMAT(m.yxq,'%Y%m%d') yxq,m.mc,t.zt FROM tbl_jfqmc t  LEFT JOIN tbl_jfq m ON t.jfq = m.nid  WHERE t.ffzt =1 AND t.zt <>7 AND t.qyyg = "
				+ userid + " ORDER BY t.sflq, t.zt, t.ffsj DESC LIMIT " + limit;

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("JfqDaoImpl--getJfqbyUid", e);
		}
		return list;
	}

	public String pagelySql(String param) {
		String sql = "SELECT t.nid,DATE_FORMAT(t.ffsj,'%Y.%m.%d') ffsj,DATE_FORMAT(s.yxq,'%Y%m%d') yxq,t.jfq,t.sflq,t.ffly,s.mc,t.ffyy,t.zt FROM tbl_jfqmc t LEFT JOIN tbl_jfq s ON t.jfq = s.nid WHERE  t.ffzt =1 and t.zt<>7 "
				+ param + " ORDER BY t.sflq asc ,t.zt asc , ffsj DESC ";

		return sql;
	}
	
	public String countlySql(String param) {
		String sql = "SELECT COUNT(t.nid) AS count FROM tbl_jfqmc t LEFT JOIN tbl_jfq s ON t.jfq = s.nid WHERE t.ffzt =1 and t.zt<>7 "
				+ param;

		return sql;
	}
	
	public String pageSql(String param) {
		String sql = "SELECT t.nid,t.ddh,t.sl,DATE_FORMAT(t.jssj,'%Y.%m.%d') jssj,s.mc FROM tbl_ygddmx t  LEFT JOIN (SELECT  DISTINCT  n.nid,n.mc  FROM tbl_jfqmc m LEFT JOIN tbl_jfq n ON m.jfq = n.nid) s ON t.jfq = s.nid WHERE t.jfq IS NOT NULL  AND t.state!=9 "
				+ param + " ORDER BY t.jssj desc";

		return sql;
	}
	
	public String countSql(String param) {
		String sql = "SELECT count(t.nid) as count FROM tbl_ygddmx t  LEFT JOIN (SELECT  DISTINCT n.nid,n.mc  FROM tbl_jfqmc m LEFT JOIN tbl_jfq n ON m.jfq = n.nid) s ON t.jfq = s.nid  WHERE t.jfq IS NOT NULL  AND t.state!=9 "
				+ param;

		return sql;
	}

	public List<Map<String, Object>> getJfqLjsj(String yg) {
		String sql = "(SELECT COUNT(nid) AS jfqsl FROM tbl_jfqmc WHERE qyyg ="
				+ yg
				+ " "
				+ " AND ffzt =1 AND zt =0) UNION ALL (SELECT COUNT(nid) AS jfqsl FROM tbl_jfqmc WHERE qyyg ="
				+ yg
				+ ""
				+ " AND ffzt =1 AND zt =1  AND sysj > SUBDATE(SYSDATE(), 92) ) UNION ALL (SELECT COUNT(nid) AS jfqsl FROM tbl_jfqmc WHERE ffsj > SUBDATE(SYSDATE(), 92) AND "
				+ " qyyg = "
				+ yg
				+ " AND ffzt = 1 )"
				+ " UNION ALL (SELECT COUNT(nid) AS jfqsl FROM tbl_jfqmc WHERE ffzt=1 AND sflq = 0 AND zt<>7 AND qyyg ="
				+ yg + ")";

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("JfqDaoImpl--getJfqLjsj", e);
		}
		return list;
	}

	public List<Map<String, Object>> getDetail(String nid) {
		String sql = "SELECT t.zt,s.mc,s.sp,s.bz,t.ddh,t.ffyy,p.spmc,t.sflq FROM tbl_jfqmc t LEFT JOIN (SELECT m.sp,m.nid,m.mc,n.bz FROM tbl_jfq m LEFT JOIN tbl_jfqff n ON m.nid = n.jfq) s ON t.jfq = s.nid  LEFT JOIN tbl_ygddmx k ON t.ddh = k.ddh AND t.jfq = k.jfq LEFT JOIN tbl_sp p ON k.sp = p.nid WHERE t.nid ="
				+ nid;

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("JfqDaoImpl--getDetail", e);
		}
		return list;
	}

	public List<Map<String, Object>> getSpJfqCount(String param) {
		String sql = "SELECT COUNT(t.jfq) AS spjfqcount,t.sp FROM tbl_jfqspref t LEFT JOIN tbl_jfq s ON t.jfq = s.nid WHERE s.yxq  > SUBDATE(SYSDATE(),1)  "
				+ param + " GROUP BY t.sp";

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("JfqDaoImpl--getSpJfqCount", e);
		}
		return list;	
	}


	public List<Map<String, Object>> getSpJfq(String param) {
		String sql = "SELECT DISTINCT t.jfq,t.sp,s.mc as jfqmc FROM tbl_jfqspref t LEFT JOIN tbl_jfq s ON t.jfq = s.nid WHERE s.yxq  > SUBDATE(SYSDATE(),1) "
				+ param;

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<Integer,String> m = new HashMap<Integer,String>();
		m.put(1, "jfq");
		m.put(2, "sp");
		m.put(3, "jfqmc");
		try {
			list = sqldao.query(sql,m);
		} catch (Exception e) {
			logger.error("JfqDaoImpl--getSpJfqCount", e);
		}
		return list;	
	}

	public List<Map<String, Object>> getJfqs(String param) {
		String sql = "SELECT t.jfq,COUNT(t.jfq) AS jfqcount FROM tbl_jfqmc t WHERE t.zt = 0 AND t.sflq = 1 AND t.yxq > SUBDATE(SYSDATE(),1) "
				+ param + " GROUP BY t.jfq ";

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("JfqDaoImpl--getJfqs", e);
		}
		return list;	
	}
	

	public List<Map<String, Object>> getJfqmcs(String param, int limit) {
		String sql = "SELECT t.nid FROM tbl_jfqmc t WHERE t.zt = 0 AND t.sflq = 1 AND t.yxq > SUBDATE(SYSDATE(),1)"
				+ param + " ORDER BY t.yxq ";

		if (limit > 0)
			sql = sql + " LIMIT " + limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("JfqDaoImpl--getJfqmcs", e);
		}
		return list;	
	}
}
