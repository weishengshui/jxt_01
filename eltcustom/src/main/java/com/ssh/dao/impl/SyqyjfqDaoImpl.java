package com.ssh.dao.impl;

import com.ssh.base.BaseDAO;
import com.ssh.base.SqlDao;
import com.ssh.dao.SyqyjfqDao;
import com.ssh.entity.TblSyqyjfq;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

@Repository
public class SyqyjfqDaoImpl extends BaseDAO<TblSyqyjfq, Integer> implements
		SyqyjfqDao {

	@Resource
	private SqlDao sqldao;
	private static Logger logger = Logger.getLogger(JfqDaoImpl.class.getName());

	public List<Map<String, Object>> getylqmrjfq(String uid) {
		String sql = "SELECT distinct t.yg, t.jfq FROM tbl_syqyjfqlq t WHERE t.yg = "
				+ uid;
		List list = new ArrayList();
		try {
			list = this.sqldao.query(sql);
		} catch (Exception e) {
			logger.error("JfqDaoImpl--getylqmrjfq", e);
		}
		return list;
	}
}