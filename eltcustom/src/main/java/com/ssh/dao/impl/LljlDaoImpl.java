package com.ssh.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ssh.base.SqlDao;
import com.ssh.dao.LljlDao;

@Repository
public class LljlDaoImpl implements LljlDao{
	@Resource
	private SqlDao sqldao;

	private static Logger logger = Logger.getLogger(LljlDaoImpl.class
			.getName());

	
	public List<Map<String, Object>> getLljjTitle(String yg, int limit) {
		String sql = "SELECT DISTINCT s.nid,s.sp,s.qbjf,s.mc,s.lj,s.je,s.jf FROM tbl_lljl t" +
				" LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc,k.zt AS kzt, m.zt AS mzt  FROM tbl_spl k" +
				" LEFT JOIN  tbl_sp m ON m.nid=k.sp" +
				"  LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				"  LEFT JOIN tbl_sptp n ON m.zstp = n.nid" +
				" ) s ON t.spl = s.nid " +
				" WHERE t.yg ="+yg+" AND s.mzt=1 AND s.kzt=1  ORDER BY t.llsj DESC ";
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("LljlDaoImpl--getLljjTitle", e);
		}
		return list;
	}
	
	
	public List<Map<String, Object>> getTszk(int yg, int qy, int limit) {
		String sql = "SELECT DISTINCT s.nid,s.sp,s.qbjf,s.mc,s.lj,s.je,s.jf FROM tbl_lljl t " +
				" LEFT JOIN (SELECT m.qbjf,n.lj,d.je,d.jf,k.nid,k.sp,k.mc,k.zt  FROM tbl_spl k" +
				" LEFT JOIN  tbl_sp m ON m.nid=k.sp" +
				" LEFT JOIN tbl_dhfs d ON d.nid = m.zsdhfs" +
				" LEFT JOIN tbl_sptp n ON m.zstp = n.nid" +
				") s ON t.spl = s.nid WHERE s.zt=1 and  t.qy = "+qy+" AND t.nid != "+yg+" ORDER BY t.llsj DESC ";
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("LljlDaoImpl--getTszk", e);
		}
		return list;
	}
}
