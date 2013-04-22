package com.ssh.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ssh.base.BaseDAO;
import com.ssh.base.SqlDao;
import com.ssh.dao.QyygDao;
import com.ssh.entity.TblQyyg;

@Repository
public class QyygDaoImpl extends BaseDAO<TblQyyg, Integer> implements QyygDao {
	@Resource
	private SqlDao sqldao;

	private static Logger logger = Logger.getLogger(QyygDaoImpl.class
			.getName());
	
	public List<Map<String, Object>> getQyinfo(int qy){
		String sql = "SELECT t.nid,t.qymc,t.qybh,t.qydz,t.qh,t.log FROM tbl_qy t WHERE t.nid = "+qy;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("QyygDaoImpl--getQyinfo", e);
		}
		return list;
	}
}
