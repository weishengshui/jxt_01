package com.ssh.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ssh.base.BaseDAO;
import com.ssh.base.SqlDao;
import com.ssh.dao.CxhdDao;
import com.ssh.entity.TblCxhd;

@Repository
public class CxhdDaoImpl extends BaseDAO<TblCxhd, Integer>  implements CxhdDao{
	@Resource
	private SqlDao sqldao;

	private static Logger logger = Logger.getLogger(CxhdDaoImpl.class
			.getName());

	//促销活动
	public List<Map<String, Object>> getCxhd(String param,int limit) {
		String sql = "SELECT t.nid,t.bt,t.tplj,t.syxs,t.sp FROM tbl_cxhd t " +
				" WHERE t.ksrq <= SYSDATE() AND jsrq >= SUBDATE(SYSDATE(), 1) "+param+" ORDER BY t.xswz DESC ";
		if(limit != 0) sql+=" LIMIT "+limit;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("CxhdDaoImpl--getCxhd", e);
		}
		return list;
	}
}
