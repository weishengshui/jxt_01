package com.ssh.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ssh.dao.GbDao;
import com.ssh.service.GbService;
import com.ssh.util.SecurityUtil;
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class GbImpl implements GbService{
	@Resource
	private GbDao gbDao;

	private static Logger logger = Logger.getLogger(GbImpl.class
			.getName());
	
	public List<Map<String, Object>> getGbbyQy(int qy,int yg, int limit) {
		String param = " AND t.qy = "+qy+" AND m.yg = "+ yg;
		if(SecurityUtil.sqlCheck(param)) return null;
		return gbDao.getGbbyQy(param, limit);
	}

	public List<Map<String,Object>> page(String param,String page,String rp) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return gbDao.page(gbDao.pageSql(param), page, rp, this.count(param));
	}
	
	public String count (String param) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return  gbDao.getCount(gbDao.countSql(param));
	}

	public Long getYgGbwd(int yg,int qy) {
		String param = " AND t.qy = "+qy+" AND m.yg = "+ yg;
		List<Map<String,Object>> l = gbDao.getYgGbwd(param);
		Long count = (Long)l.get(0).get("count");
		return count;
	}
	
	public int setYgGbyd(String param) {
		return gbDao.setYgGbyd(param);
	}
}
