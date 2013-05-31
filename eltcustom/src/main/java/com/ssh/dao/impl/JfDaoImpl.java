package com.ssh.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ssh.base.SqlDao;
import com.ssh.dao.JfDao;

@Repository
public class JfDaoImpl extends PageDaoImpl implements JfDao {
	@Resource
	private SqlDao sqldao;

	private static Logger logger = Logger.getLogger(JfDaoImpl.class
			.getName());

	public List<Map<String, Object>> getJfbyUid(String userid, int limit) {
		String sql = " SELECT t.nid,t.ffjf,t.sflq,IF(mm2 IS NULL,mm1,mm2) AS mm FROM tbl_jfffmc t  LEFT JOIN (SELECT f.nid,m1.mmmc AS mm1,m2.mmmc AS mm2 FROM tbl_jfff f LEFT JOIN tbl_jfmm m1  ON f.mm1 = m1.nid LEFT JOIN  tbl_jfmm m2 ON f.mm2 = m2.nid) s ON t.jfff = s.nid  WHERE t.sfff = 1 and t.hqr = "
				+ userid + " ORDER BY t.sflq,t.ffsj DESC LIMIT " + limit;

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("JfDaoImpl--getJfbyUid", e);
		}
		return list;
	}

	public String pagelySql(String param) {
		String sql = "SELECT t.nid,DATE_FORMAT(t.ffsj,'%Y.%m.%d') ffsj,t.ffly,t.sflq,t.ffjf,IF(s.bz IS NULL,t.bz,s.bz) bz,IF(IF(mm2 IS NULL,mm1,mm2) IS NULL,t.ffyy,IF(mm2 IS NULL,mm1,mm2)) AS mm  FROM tbl_jfffmc t LEFT JOIN  (SELECT f.nid,f.bz,m1.mmmc AS mm1,m2.mmmc AS mm2 FROM tbl_jfff f LEFT JOIN tbl_jfmm m1  ON f.mm1 = m1.nid LEFT JOIN  tbl_jfmm m2 ON f.mm2 = m2.nid) s ON t.jfff = s.nid   WHERE  t.sfff = 1 "
				+ param + " ORDER BY t.sflq asc, t.ffsj desc";

		return sql;
	}
	
	public String countlySql(String param) {
		String sql = "SELECT COUNT(t.nid) AS count FROM tbl_jfffmc t WHERE t.sfff = 1 "
				+ param;
		return sql;
	}
	
	public String pageSql(String param) {
		String sql = "SELECT t.nid,t.dd,t.ddh,t.sl,DATE_FORMAT(t.jssj,'%Y.%m.%d') jssj,t.jf,t.je,t.sp,p.spmc, p.spbh FROM tbl_ygddmx t  LEFT JOIN tbl_ygddzb s ON t.dd = s.nid  LEFT JOIN tbl_sp p ON p.nid = t.sp  WHERE t.jf IS NOT NULL AND s.ddtype IS NULL AND t.state!=9 "
				+ param + " ORDER BY t.jssj desc";

		return sql;
	}
	
	public String countSql(String param) {
		String sql = "SELECT COUNT(t.nid) as count FROM tbl_ygddmx t  LEFT JOIN tbl_ygddzb s ON t.dd = s.nid  LEFT JOIN tbl_sp p ON p.nid = t.sp  WHERE t.jf IS NOT NULL AND s.ddtype IS NULL AND t.state!=9 "
				+ param;

		return sql;
	}

	public List<Map<String, Object>> getJfLjsj(String yg) {
		String sql = "(SELECT SUM(ffjf) AS jfsl FROM tbl_jfffmc WHERE ffsj > SUBDATE(SYSDATE(), 92) AND sfff = 1 AND  hqr = "
				+ yg
				+ ")"
				+ " UNION ALL "
				+ " (SELECT SUM(jf) AS jfsl FROM tbl_ygddmx t LEFT JOIN tbl_ygddzb s ON t.dd = s.nid WHERE t.yg = "
				+ yg
				+ " AND s.ddtype IS NULL AND t.state!=9 and t.jssj > SUBDATE(SYSDATE(), 92) )"
				+ " UNION ALL "
				+ " (SELECT jf AS jfsl FROM tbl_qyyg WHERE nid = "
				+ yg
				+ ")"
				+ " UNION ALL "
				+ " (SELECT SUM(ffjf) AS jfsl FROM tbl_jfffmc  WHERE  sfff = 1 AND hqr = "
				+ yg + " AND sflq =0)";

		List list = new ArrayList();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("JfDaoImpl--getJfLjsj", e);
		}
		return list;
	}

	public List<Map<String, Object>> getJfByUidForSy(String userid, int limit) {
		String sql = " SELECT f.nid, f.jf AS ffjf, f.sflq, f.bz AS mm FROM tbl_syqyjf f  WHERE f.yg = "
				+ userid + " ORDER BY f.sflq, f.zjsj DESC LIMIT " + limit;

		List list = new ArrayList();
		try {
			list = this.sqldao.query(sql);
		} catch (Exception e) {
			logger.error("JfDaoImpl--getJfByUidForSyyg", e);
		}
		return list;
	}

	public List<Map<String, Object>> getJfLjsjForSy(String yg) {
		String sql = "(SELECT SUM(jf) AS jfsl FROM tbl_syqyjf WHERE zjsj > SUBDATE(SYSDATE(), 92) AND yg = "
				+ yg
				+ ")"
				+ " UNION ALL "
				+ " (SELECT SUM(jf) AS jfsl FROM tbl_ygddmx WHERE yg = "
				+ yg
				+ "  AND state!=9 and  jssj > SUBDATE(SYSDATE(), 92) )"
				+ " UNION ALL "
				+ " (SELECT jf AS jfsl FROM tbl_qyyg WHERE nid = "
				+ yg
				+ ")"
				+ " UNION ALL "
				+ " (SELECT SUM(jf) AS jfsl FROM tbl_syqyjf WHERE yg = "
				+ yg
				+ " AND sflq =0)";

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("JfDaoImpl--getJfLjsj", e);
		}
		return list;
	}

	public String pagelySqlForSy(String param) {
		String sql = "SELECT t.nid,DATE_FORMAT(t.zjsj,'%Y.%m.%d') ffsj, '系统发放' AS ffly, t.sflq, t.jf AS ffjf, t.bz, '试用帐号体验' AS mm  FROM tbl_syqyjf t WHERE  1 = 1 "
				+ param + " ORDER BY t.sflq asc, t.zjsj desc";

		return sql;
	}

	public String countlySqlForSy(String param) {
		String sql = "SELECT COUNT(t.nid) AS count FROM tbl_syqyjf t WHERE 1 = 1 "
				+ param;
		return sql;
	}
}
