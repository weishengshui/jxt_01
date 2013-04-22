package com.ssh.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ssh.base.SqlDao;
import com.ssh.dao.SpDao;

@Repository
public class SpDaoImpl extends PageDaoImpl implements SpDao{
	@Resource
	private SqlDao sqldao;

	private static Logger logger = Logger.getLogger(SpDaoImpl.class
			.getName());
	
	
	public List<Map<String, Object>> querySpl(String param, int limit) {
		String sql = "SELECT t.nid,t.sp,s.qbjf,s.spmc,s.lj,s.je,s.jf,t.mc FROM tbl_spl t" +
		" LEFT JOIN (SELECT m.nid,m.qbjf,m.yf,m.kcsl,m.wcdsl,m.xsl,m.scj,m.spmc,n.jf,n.je,p.lj FROM tbl_sp m" +
		" LEFT JOIN tbl_sptp p ON m.zstp = p.nid" +
		" LEFT JOIN tbl_dhfs n ON m.zsdhfs = n.nid ) s ON t.sp = s.nid" +
		" WHERE t.sp IS NOT NULL AND t.zt = 1 "+param;
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getTjsp", e);
		}
		return list;
	}
	
	
	public List<Map<String, Object>> getTjsp(Long jf, int limit) {
		String sql = " SELECT t.nid,t.sp,s.qbjf,t.mc,s.lj,s.je,s.jf FROM tbl_spl t LEFT JOIN " +
				" (SELECT m.nid,m.qbjf,p.lj,m.spmc,d.je,d.jf FROM tbl_sp m " +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs  " +
				"LEFT JOIN tbl_sptp p ON m.zstp = p.nid) " +
				" s ON t.sp = s.nid WHERE t.sp IS NOT NULL AND t.zt=1 AND s.qbjf <= " +
				+jf+" ORDER BY s.qbjf DESC ";
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getTjsp", e);
		}
		return list;
	}

	
	public List<Map<String, Object>> getRmsp(int limit) {
		String sql = " SELECT t.nid,t.sp,s.qbjf,t.mc,s.lj,s.je,s.jf FROM tbl_spl t" +
				" LEFT JOIN (SELECT m.nid,m.qbjf,n.lj,d.je,d.jf FROM tbl_sp m " +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid)" +
				" s ON t.sp = s.nid WHERE t.sp IS NOT NULL AND t.zt=1 ORDER BY t.sftj desc, t.ydsl DESC ";
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getRmsp", e);
		}
		return list;
	}

	
	public List<Map<String, Object>> getFkqd(String param,int limit) {
		String sql = " SELECT t.nid,t.sp,s.qbjf,t.mc,s.lj,s.je,s.jf FROM tbl_spl t" +
				" LEFT JOIN (SELECT m.nid,m.qbjf,n.lj,d.je,d.jf FROM tbl_sp m " +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid)" +
				" s ON t.sp = s.nid WHERE t.sp IS NOT NULL AND t.zt=1 ";
		if(!param.equals(""))sql+= param;
		sql+=" ORDER BY t.rm desc,t.ydsl desc ";
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getFkqd", e);
		}
		return list;
	}

	
	public List<Map<String, Object>> getNew(String param,int limit) {
		String sql = " SELECT t.nid,t.sp,s.qbjf,t.mc,s.lj,s.je,s.jf FROM tbl_spl t" +
				" LEFT JOIN (SELECT m.nid,m.qbjf,n.lj,d.je,d.jf FROM tbl_sp m " +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid)" +
				" s ON t.sp = s.nid WHERE t.sp IS NOT NULL AND t.zt=1 ";
		if(!param.equals(""))sql+= param;
		sql+=" ORDER BY t.rq DESC ";
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getNew", e);
		}
		return list;
	}
	
	
	public List<Map<String, Object>> getSpByJfq(String param) {
		String sql = "SELECT t.nid,t.spmc,p.lj FROM tbl_sp t " +
				" LEFT JOIN tbl_sptp p ON t.zstp = p.nid WHERE  t.zt=1 AND t.nid IN " +
				" (SELECT r.sp FROM tbl_jfqspref r WHERE 1=1 "+ param+")";
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getSpByJfq", e);
		}
		return list;
	}
	
	
	public List<Map<String, Object>> getAllsplInfo(String param) {
		String sql = "SELECT t.nid,t.sp,t.mc,t.lb1,t.lb2,t.lb3,l3.mc AS lb3mc,l2.mc AS lb2mc,l1.mc AS lb1mc,t.ydsl,t.cpjs,t.shfw,t.rq,t.zt,k.nid,k.qbjf,k.yf,k.kcsl,k.wcdsl,k.xsl,k.scj,k.sprq,k.spmc,k.dhjf,k.dhje,k.tplj,k.spbh" +
				" FROM tbl_spl t " +
				" LEFT JOIN (SELECT m.nid,m.spbh,m.qbjf,m.yf,m.kcsl,m.wcdsl,m.xsl,m.scj,m.rq AS sprq,m.spmc,n.jf AS dhjf,n.je AS dhje,p.lj AS tplj FROM tbl_sp m " +
				" LEFT JOIN tbl_sptp p ON m.zstp = p.nid " +
				" LEFT JOIN tbl_dhfs n ON m.zsdhfs = n.nid) k ON t.sp = k.nid " +
				" LEFT JOIN tbl_splm l3 ON t.lb3 = l3.nid " +
				" LEFT JOIN tbl_splm l2 ON t.lb2 = l2.nid " +
				" LEFT JOIN tbl_splm l1 ON t.lb1 = l1.nid " +
				" WHERE t.sp IS NOT NULL AND t.zt = 1 and t.nid = " +param; 
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getAllsplInfo", e);
		}
		return list;
	}
	
	
	public List<Map<String, Object>> getAllspInfo(String param) {
		String sql = "SELECT t.nid,t.qbjf,t.yf,t.kcsl,t.wcdsl,t.xsl,t.scj,t.rq,t.spmc,n.jf,n.je ,p.lj,t.zt,k.mc,k.lb3,k.lb2,k.lb1,k.ydsl,k.cpjs,k.shfw,k.splrq,t.spbh,k.lb1 FROM tbl_sp t" +
				" LEFT JOIN tbl_sptp p ON t.zstp = p.nid" +
				" LEFT JOIN tbl_dhfs n ON t.zsdhfs = n.nid" +
				" LEFT JOIN (SELECT m.nid,m.mc,m.lb1,l3.mc AS lb3mc,l2.mc AS lb2mc,l1.mc AS lb1mc,m.ydsl,m.cpjs,m.shfw,m.rq AS splrq" +
				" FROM tbl_spl m" +
				"  LEFT JOIN tbl_splm l3 ON m.lb3 = l3.nid " +
				"  LEFT JOIN tbl_splm l2 ON m.lb2 = l2.nid " +
				"  LEFT JOIN tbl_splm l1 ON m.lb1 = l1.nid ) k ON k.nid = t.spl" +
				" WHERE t.zt = 1 and t.nid = " +param; 
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getAllspInfo", e);
		}
		return list;
	}

	
	public List<Map<String, Object>> getSplInfo(String param) {
		String sql = "SELECT t.nid,t.sp,t.mc,t.lb1,t.lb2,t.lb3,l3.mc AS lb3mc,l2.mc AS lb2mc,l1.mc AS lb1mc,t.ydsl,t.cpjs,t.shfw,t.rq" +
				" FROM tbl_spl t" +
				" LEFT JOIN tbl_splm l3 ON t.lb3 = l3.nid " +
				" LEFT JOIN tbl_splm l2 ON t.lb2 = l2.nid " +
				" LEFT JOIN tbl_splm l1 ON t.lb1 = l1.nid " +
				" WHERE t.sp IS NOT NULL AND t.zt = 1 " +param; 
		Map<Integer,String> namemap = new HashMap<Integer,String>();
		namemap.put(7, "lb3mc");
		namemap.put(8, "lb2mc");
		namemap.put(9, "lb1mc");
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql,namemap);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getSplInfo", e);
		}
		return list;
	}
	
	
	public List<Map<String, Object>> getSpInfo(String param) {
		String sql = "SELECT t.nid,t.qbjf,t.cxjf,t.yf,t.kcsl,t.wcdsl,t.xsl,t.scj,t.rq,t.spmc,t.zstp,n.jf,n.je ,p.lj,t.zt,t.spbh,t.spnr,t.kcyj" +
				" FROM tbl_sp t" +
				" LEFT JOIN tbl_sptp p ON t.zstp = p.nid" +
				" LEFT JOIN tbl_dhfs n ON t.zsdhfs = n.nid" +
				" WHERE t.zt = 1 " + param; 
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getSpInfo", e);
		}
		return list;
	}
	
	
	public List<Map<String, Object>> getSplb1(){
		String sql = "SELECT t.nid,t.mc,t.lmtp FROM tbl_splm t WHERE t.sfxs = 1 AND t.flm = 0  ORDER BY t.xswz DESC ";
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getSplb1", e);
		}
		return list;
	}
	
	public List<Map<String, Object>> getSplb2() {
		String sql = "SELECT t.nid,t.mc,t.lmtp FROM tbl_splm t WHERE t.sfxs = 1 AND t.flm = 0 AND rm = 1 ORDER BY t.xswz DESC ";
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getSplb1", e);
		}
		return list;
	}
	
	public String pageSqlsp(String param) {
		String sql = "SELECT t.nid,t.spl,t.qbjf,t.spmc,p.lj,n.je,n.jf,s.mc FROM tbl_sp t" +
				" LEFT JOIN tbl_sptp p ON t.zstp = p.nid" +
				" LEFT JOIN tbl_dhfs n ON t.zsdhfs = n.nid" +
				" LEFT JOIN tbl_spl s ON s.nid = t.spl WHERE t.zt = 1 "+param;
		return sql;
	}
	public String countSqlsp(String param) {
		String sql = "SELECT count(s.nid) as count FROM tbl_sp t" +
				" LEFT JOIN tbl_sptp p ON t.zstp = p.nid" +
				" LEFT JOIN tbl_dhfs n ON t.zsdhfs = n.nid" +
				" LEFT JOIN tbl_spl s ON s.nid = t.spl WHERE t.zt = 1 "+param;
		return sql;
	}
	
	
	public String pageSqlspl(String param) {
		String sql = "SELECT t.nid,t.sp,s.qbjf,s.spmc,s.lj,s.je,s.jf,t.mc FROM tbl_spl t" +
				" LEFT JOIN (SELECT m.nid,m.qbjf,m.yf,m.kcsl,m.wcdsl,m.xsl,m.scj,m.spmc,n.jf,n.je,p.lj FROM tbl_sp m" +
				" LEFT JOIN tbl_sptp p ON m.zstp = p.nid" +
				" LEFT JOIN tbl_dhfs n ON m.zsdhfs = n.nid ) s ON t.sp = s.nid" +
				" WHERE t.sp IS NOT NULL AND t.zt = 1 "+param;
		return sql;
	}
	public String countSqlspl(String param) {

		String sql = "SELECT count(s.nid) as count FROM tbl_spl t" +
				" LEFT JOIN (SELECT m.nid,m.qbjf,m.yf,m.kcsl,m.wcdsl,m.xsl,m.scj,m.spmc,n.jf,n.je,p.lj FROM tbl_sp m" +
				" LEFT JOIN tbl_sptp p ON m.zstp = p.nid" +
				" LEFT JOIN tbl_dhfs n ON m.zsdhfs = n.nid ) s ON t.sp = s.nid" +
				" WHERE t.sp IS NOT NULL AND t.zt = 1 "+param;
		return sql;
	}
	
	public String pageSqltszd(String param) {
		String sql = "SELECT DISTINCT s.nid,s.sp,s.qbjf,s.mc,s.lj,s.je,s.jf FROM  tbl_qyyg t" +
				" LEFT JOIN tbl_ygddmx m ON t.nid = m.yg" +
				"  LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc,k.zt  FROM tbl_spl k" +
				" LEFT JOIN  tbl_sp m ON m.nid=k.sp" +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid) s  ON m.spl = s.nid" +
				" WHERE  s.zt=1  AND m.state != 9 "+param;
		return sql;
	}
	public String countSqltszd(String param) {
		String sql = "SELECT COUNT(b.nid) AS COUNT FROM (SELECT DISTINCT s.nid,s.sp,s.qbjf,s.mc,s.lj,s.je,s.jf FROM  tbl_qyyg t" +
				" LEFT JOIN tbl_ygddmx m ON t.nid = m.yg" +
				"  LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc,k.zt  FROM tbl_spl k" +
				" LEFT JOIN  tbl_sp m ON m.nid=k.sp LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				"  LEFT JOIN tbl_sptp n ON m.zstp = n.nid) s  ON m.spl = s.nid " +
				"   WHERE  s.zt=1   AND m.state != 9 "+ param +" ) b;";
		return sql;
	}
	
	public String pageSqlzjll(String param) {
		String sql = "SELECT DISTINCT s.nid,s.sp,s.qbjf,s.mc,s.lj,s.je,s.jf FROM tbl_lljl t " +
				" LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc,k.zt  FROM tbl_spl k" +
				" LEFT JOIN  tbl_sp m ON m.nid=k.sp" +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs  LEFT JOIN tbl_sptp n ON m.zstp = n.nid" +
				") s ON t.spl = s.nid WHERE  s.zt=1 "+param;
		return sql;
	}
	public String countSqlzjll(String param) {
		String sql = "SELECT COUNT(b.nid) AS COUNT FROM (SELECT DISTINCT s.nid FROM tbl_lljl t" +
				" LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc,k.zt  FROM tbl_spl k" +
				" LEFT JOIN  tbl_sp m ON m.nid=k.sp LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid) s ON t.spl = s.nid " +
				" WHERE  s.zt=1 "+param+" ) b";
		return sql;
	}
	
	public String pageSqltjsp(String param) {
		String sql = " SELECT t.nid,t.sp,s.qbjf,s.spmc,s.lj,s.je,s.jf,t.mc FROM tbl_spl t LEFT JOIN " +
				" (SELECT m.nid,m.qbjf,p.lj,m.spmc,d.je,d.jf FROM tbl_sp m " +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs  " +
				" LEFT JOIN tbl_sptp p ON m.zstp = p.nid) s " +
				" ON t.sp = s.nid WHERE t.sp IS NOT NULL AND t.zt=1 "+param;
		return sql;
	}
	public String countSqltjsp(String param) {
		String sql = "SELECT COUNT(t.nid) AS COUNT FROM tbl_spl t LEFT JOIN " +
				"  (SELECT m.nid,m.qbjf,p.lj,m.spmc,d.je,d.jf FROM tbl_sp m " +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp p ON m.zstp = p.nid) s" +
				" ON t.sp = s.nid WHERE t.sp IS NOT NULL  AND t.zt=1 "+param;
		return sql;
	}
	
	public String pageSqlrmdh(String param) {
		String sql = " SELECT t.nid,t.sp,s.qbjf,t.mc,s.lj,s.je,s.jf FROM tbl_spl t" +
				" LEFT JOIN (SELECT m.nid,m.qbjf,n.lj,d.je,d.jf FROM tbl_sp m " +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid)" +
				" s ON t.sp = s.nid WHERE t.sp IS NOT NULL  AND t.zt=1 "+param;
		return sql;
	}
	public String countSqlrmdh(String param) {
		String sql = " SELECT COUNT(t.nid) AS COUNT FROM tbl_spl t" +
				" LEFT JOIN (SELECT m.nid,m.qbjf,n.lj,d.je,d.jf FROM tbl_sp m " +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid)" +
				" s ON t.sp = s.nid WHERE t.sp IS NOT NULL  AND t.zt=1 "+param;
		return sql;
	}
	
	public String pageSqlzshy(String param,String order) {
		String sql = "SELECT COUNT(t.spl) splcount,s.nid,s.sp,s.qbjf,s.mc,s.lj,s.je,s.jf FROM tbl_ygddmx t " +
				"  LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc,k.zt  FROM tbl_spl k" +
				" LEFT JOIN  tbl_sp m ON m.nid=k.sp" +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid) s ON t.spl = s.nid" +
				" LEFT JOIN tbl_qyyg u ON t.yg = u.nid" +
				" WHERE  s.zt=1   AND t.state != 9  "+param+" GROUP BY t.spl "+order;
		return sql;
	}
	
	public String countSqlzshy(String param) {
		String sql = "SELECT COUNT(b.nid) AS COUNT FROM (SELECT COUNT(t.spl) splcount,s.nid FROM tbl_ygddmx t " +
				"  LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc,k.zt  FROM tbl_spl k" +
				" LEFT JOIN  tbl_sp m ON m.nid=k.sp" +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid) s ON t.spl = s.nid" +
				" LEFT JOIN tbl_qyyg u ON t.yg = u.nid WHERE  s.zt=1   AND t.state != 9  " +
				 param +" GROUP BY t.spl ) b";
		return sql;
	}
	
	
	public String pageSqltszk(String param) {
		String sql = "SELECT DISTINCT s.nid,s.sp,s.qbjf,s.mc,s.lj,s.je,s.jf FROM tbl_lljl t" +
				" LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc,k.zt  FROM tbl_spl k" +
				" LEFT JOIN  tbl_sp m ON m.nid=k.sp" +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid) s ON t.spl = s.nid " +
				" WHERE  s.zt=1  "+param;
		return sql;
	}
	
	public String countSqltszk(String param) {
		String sql = "SELECT COUNT(b.nid) AS count FROM (SELECT DISTINCT s.nid FROM tbl_lljl t " +
				" LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc,k.zt  FROM tbl_spl k" +
				" LEFT JOIN  tbl_sp m ON m.nid=k.sp" +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid" +
				" ) s ON t.spl = s.nid WHERE s.zt=1 "+param+") b";
		return sql;
	}
	
	
	public List<Map<String, Object>> getDhfs(String param) {
		String sql = "SELECT t.nid,t.jf,t.je,t.sp FROM tbl_dhfs t" +
				" WHERE 1=1 "+param;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getDhfs", e);
		}
		return list;
	}
	
	
	public List<Map<String, Object>> getGmsp(String sps,int limit) {
		String sql = "SELECT t.nid,t.spl,t.qbjf,t.spmc,p.lj,n.je,n.jf,s.mc FROM tbl_sp t" +
				" LEFT JOIN tbl_sptp p ON t.zstp = p.nid" +
				" LEFT JOIN tbl_dhfs n ON t.zsdhfs = n.nid" +
				" LEFT JOIN tbl_spl s ON s.nid = t.spl" +
				" WHERE t.zt = 1 AND s.sp IN (SELECT DISTINCT j.sp FROM tbl_ygddmx j WHERE j.dd IN " +
				" (SELECT DISTINCT f.dd FROM tbl_ygddmx f WHERE f.sp IN ("+sps+") AND f.state !=9) " +
				" AND j.sp NOT IN ("+sps+")) ORDER BY  t.xsl DESC ";
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getGmsp", e);
		}
		return list;
	}

	
	public List<Map<String, Object>> getSpQuery(String param) {
		String sql = "SELECT t.nid,t.spl,t.qbjf,t.cxjf,t.spmc,p.lj,n.je,n.jf,s.mc,t.spbh,t.wcdsl FROM tbl_sp t" +
			" LEFT JOIN tbl_sptp p ON t.zstp = p.nid" +
			" LEFT JOIN tbl_dhfs n ON t.zsdhfs = n.nid" +
			" LEFT JOIN tbl_spl s ON s.nid = t.spl WHERE t.zt = 1 "+param;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getSpQuery", e);
		}
		return list;
	}
	
	
	public List<Map<String, Object>> getSpTp(String param) {
		String sql = "SELECT t.sp,t.lj,t.tpmc,p.zstp FROM tbl_sptp t " +
				" LEFT JOIN tbl_sp p ON t.nid = p.zstp WHERE 1 = 1 "+param;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("SpDaoImpl--getSpTp", e);
		}
		return list;
	}
	
}
