package com.ssh.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ssh.base.SqlDao;
import com.ssh.dao.GbDao;

@Repository
public class GbDaoImpl extends PageDaoImpl implements GbDao{
	@Resource
	private SqlDao sqldao;

	private static Logger logger = Logger.getLogger(GbDaoImpl.class
			.getName());

	public List<Map<String, Object>> getGbbyQy(String param, int limit) {
		String sql = " SELECT t.nid,t.bt,DATE_FORMAT(t.fbsj,'%Y.%m.%d') fbsj,m.sfyd  FROM tbl_hrgb t " +
				" LEFT JOIN tbl_ygmsg m ON t.nid = m.lynid AND m.lylx = 0  WHERE 1=1 "+ param +" ORDER BY m.sfyd asc , t.fbsj DESC LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("GbDaoImpl--getGbbyQy", e);
		}
		return list;
	}

	public List<Map<String, Object>> getYgGbwd(String param) {
		String sql = " SELECT COUNT(t.nid) AS count  FROM tbl_hrgb t  LEFT JOIN tbl_ygmsg m " +
				" ON t.nid = m.lynid AND m.lylx = 0  WHERE 1=1 AND m.sfyd = 0 "+param;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("GbDaoImpl--getYgGbwd", e);
		}
		return list;
	}
	public String pageSql(String param) {
		String sql = "SELECT t.nid,t.bt,t.nr,DATE_FORMAT(t.fbsj,'%Y.%m.%d') fbsj,m.sfyd FROM tbl_hrgb t" +
				" LEFT JOIN tbl_ygmsg m ON t.nid = m.lynid AND m.lylx = 0" +
				" WHERE 1=1 "+param+" ORDER BY m.sfyd asc , t.fbsj DESC ";
		return sql;
	}
	public String countSql(String param) {
		String sql = "SELECT count(t.nid) as count FROM tbl_hrgb t " +
				" left join tbl_ygmsg m on t.nid = m.lynid and m.lylx = 0 WHERE 1=1 "+param;
		return sql;
	}

	
	public int setYgGbyd(String param) {
		int rs = 0;
		String sql = "update tbl_ygmsg t set t.sfyd = 1 where t.lylx = 0 "+ param;
		try {
			rs = sqldao.update(sql);
		} catch (Exception e) {
			logger.error("GbDaoImpl--setYgGbyd", e);
		}
		return rs;
	}
}
