package com.ssh.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ssh.base.SqlDao;
import com.ssh.dao.DdDao;
import com.ssh.util.Page;

@Repository
public class DdDaoImpl extends PageDaoImpl implements DdDao{
	@Resource
	private SqlDao sqldao;

	private static Logger logger = Logger.getLogger(DdDaoImpl.class
			.getName());

	
	public List<Map<String, Object>> getJfqdhjl(String yg, int limit) {
		String sql = "SELECT s.nid,DATE_FORMAT(s.jsrq,'%Y.%m.%d') jsrq,t.sp,s.state,d.mc,p.spmc,t.ddh FROM tbl_ygddmx t " +
				" LEFT JOIN tbl_ygddzb s ON t.dd = s.nid " +
				" LEFT JOIN (SELECT DISTINCT n.nid,n.mc FROM tbl_jfqmc m LEFT JOIN tbl_jfq n ON m.jfq = n.nid) d ON t.jfq = d.nid " +
				" LEFT JOIN tbl_sp p ON t.sp = p.nid " +
				" WHERE t.yg = "+yg+" AND t.state !=9 AND t.jfq IS NOT NULL ORDER BY s.jsrq DESC ";
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("DdDaoImpl--getJfqdhjl", e);
		}
		return list;
	}
	
	
	public List<Map<String, Object>> getJfdhjl(String yg, int limit) {
		String sql = "SELECT s.nid,DATE_FORMAT(s.jsrq,'%Y.%m.%d') jsrq,t.sp,s.state,p.spmc,t.jf,t.je,t.ddh FROM tbl_ygddmx t " +
				" LEFT JOIN tbl_ygddzb s ON t.dd = s.nid " +
				" LEFT JOIN tbl_sp p ON t.sp = p.nid " +
				" WHERE t.yg = "+yg+"  AND t.state !=9 AND t.jf IS NOT NULL ORDER BY s.jsrq DESC  ";
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("DdDaoImpl--getJfdhjl", e);
		}
		return list;
	}

	
	public List<Map<String, Object>> getTsmsp(int yg, int qy, int limit) {
		String sql = "SELECT DISTINCT s.nid,s.sp,s.qbjf,s.mc,s.lj,s.je,s.jf FROM  tbl_qyyg t" +
				" LEFT JOIN tbl_ygddmx m ON t.nid = m.yg" +
				" LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc  FROM tbl_spl k" +
				" LEFT JOIN  tbl_sp m ON m.nid=k.sp" +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid) s  ON m.spl = s.nid " +
				" WHERE t.qy = "+qy+" AND m.state!=9 AND t.nid != "+yg+" ORDER BY s.nid DESC ";
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("DdDaoImpl--getTsmsp", e);
		}
		return list;
	}
	
	
	public List<Map<String, Object>> getZshy(String param, int limit) {
		String sql = "SELECT COUNT(t.spl) splcount,s.nid,s.sp,s.qbjf,s.mc,s.lj,s.je,s.jf FROM tbl_ygddmx t " +
				" LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc,k.zt  FROM tbl_spl k" +
				" LEFT JOIN  tbl_sp m ON m.nid=k.sp" +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid" +
				") s ON t.spl = s.nid" +
				" LEFT JOIN tbl_qyyg u ON t.yg = u.nid" +
				" WHERE t.state!=9 and s.zt=1 "+param+" GROUP BY t.spl ORDER BY splcount DESC, s.nid DESC ";
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("DdDaoImpl--getZshy", e);
		}
		return list;
	}

	public List<Map<String, Object>> getXdsp(String param, int limit) {
		String sql = "SELECT t.nid,t.dd,t.sp,t.sl,t.jf,t.je,t.jfq,p.spmc FROM tbl_ygddmx t " +
				" LEFT JOIN tbl_sp p ON t.sp = p.nid" +
				" WHERE t.state = 0 "+param;
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("DdDaoImpl--getXdsp", e);
		}
		return list;
	}

	public List<Map<String, Object>> getDdsp(String param) {
		String sql = "SELECT t.sp,t.sl,t.jf,t.je,t.jfq,p.spbh,p.lj,t.dd,t.ddh,t.state,q.mc,p.spmc FROM tbl_ygddmx t" +
				" LEFT JOIN (SELECT m.spbh,m.nid,n.lj,m.spmc FROM  tbl_sp m LEFT JOIN tbl_sptp n ON n.nid = m.zstp) p ON p.nid = t.sp" +
				" LEFT JOIN tbl_jfq q ON q.nid = t.jfq"+
				" WHERE 1=1 "+param;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("DdDaoImpl--getDdsp", e);
		}
		return list;
	}

	public List<Map<String, Object>> getDdspl(String param) {
		String sql = "SELECT DISTINCT t.spl,p.mc,p.sp,p.lj FROM tbl_ygddmx t" +
				" LEFT JOIN (SELECT m.mc,m.sp,n.lj,m.nid FROM tbl_spl m LEFT JOIN " +
				" (SELECT k.nid,l.lj FROM tbl_sp k LEFT JOIN tbl_sptp l ON k.zstp = l.nid)" +
				" n ON n.nid = m.sp) p ON t.spl = p.nid" +
				" WHERE 1=1 "+param;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("DdDaoImpl--getDdspl", e);
		}
		return list;
	}

	public List<Map<String, Object>> getDdZb(String param) {
		String sql = "SELECT t.nid,t.ddh,t.state,t.cjrq,DATE_FORMAT(t.jsrq,'%Y.%m.%d %H:%i') jsrq,t.ydh,t.shrq,t.fhrq,t.zjf,t.zje,t.jfqsl," +
				" t.fhr,t.yg,t.shdz,t.ddbz FROM tbl_ygddzb t" +
				" WHERE 1=1 "+param;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("DdDaoImpl--getDdZb", e);
		}
		return list;
	}

	public List<Map<String, Object>> getDdCount(String param) {
		String sql = "(SELECT COUNT(nid) AS ddc FROM tbl_ygddzb WHERE state = 0 "+param+")" +
				" UNION ALL (SELECT COUNT(nid) AS ddc FROM tbl_ygddzb WHERE state = 2 "+param+")" +
				" UNION ALL (SELECT COUNT(nid) AS ddc FROM tbl_ygddzb WHERE  state in (3,4) "+param+")";
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("DdDaoImpl--getDdCount", e);
		}
		return list;
	}	

	public String pageSql(String param) {
		String sql = "SELECT t.nid,t.ddh,t.state,t.cjrq,DATE_FORMAT(t.jsrq,'%Y.%m.%d %H:%i') jsrq,t.ydh,t.shrq,t.fhrq,t.zjf,t.zje,t.jfqsl," +
			" t.fhr,t.yg,t.shdz,t.ddbz, sp.spbh  FROM tbl_ygddzb t inner join tbl_ygddmx ddmx on t.nid=ddmx.dd, tbl_sp sp " +
			" WHERE 1=1 "+param+" and sp.nid=ddmx.sp order by t.jsrq desc";
		logger.info(sql);
		return sql;
	}
	
	public String countSql(String param) {
		String sql = "SELECT COUNT(t.nid) AS count  FROM tbl_ygddzb t" +
			" WHERE 1=1 "+param;
		return sql;
	}

}
