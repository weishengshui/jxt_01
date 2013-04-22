package com.ssh.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ssh.base.BaseDAO;
import com.ssh.base.SqlDao;
import com.ssh.dao.BzzxDao;
import com.ssh.entity.TblBzzx;

@Repository
public class BzzxDaoImpl extends BaseDAO<TblBzzx, Integer>  implements BzzxDao{
	@Resource
	private SqlDao sqldao;

	private static Logger logger = Logger.getLogger(BzzxDaoImpl.class
			.getName());


	public List<Map<String, Object>> getBz() {
		String sql = "SELECT t.bt,t.nid,t.nr,t.upid FROM tbl_bzzx t WHERE t.sfxz = 1 ORDER BY t.upid,t.xswz";
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("BzzxDaoImpl--getBz", e);
		}
		return list;
	}
}
