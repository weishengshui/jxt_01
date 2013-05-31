package com.ssh.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.ssh.base.BaseDAO;
import com.ssh.base.SqlDao;
import com.ssh.dao.ShdzDao;
import com.ssh.entity.TblShdz;

@Repository
public class ShdzDaoImpl extends BaseDAO<TblShdz, Integer> implements ShdzDao {
	@Resource
	private SqlDao sqldao;

	private static Logger logger = Logger.getLogger(ShdzDaoImpl.class
			.getName());

	public List<Map<String, Object>> getShdzByUid(String userid) {
		String sql = " SELECT t.nid,t.yg,t.shr,t.sheng,t.shi,t.qu,t.dz,t.yb,t.dh,IF(s.nid IS NULL,0,1) AS mr FROM  tbl_shdz t LEFT JOIN tbl_qyyg s ON t.nid = s.shdz AND t.yg = s.nid  WHERE t.yg="
				+ userid + " ORDER BY rq DESC ";
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = sqldao.query(sql);
		} catch (Exception e) {
			logger.error("ShdzDaoImpl--getShdzByUid", e);
		}
		return list;
	}


}
