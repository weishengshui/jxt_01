package com.ssh.service.impl;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ssh.dao.JfDao;
import com.ssh.dao.JfffmcDao;
import com.ssh.dao.QyygDao;
import com.ssh.entity.TblJfffmc;
import com.ssh.entity.TblQyyg;
import com.ssh.service.JfService;
import com.ssh.util.SecurityUtil;

@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class JfImpl implements JfService{
	@Resource
	private JfDao jfDao;
	@Resource
	private QyygDao qyygDao;
	@Resource
	private JfffmcDao jfffmcDao;
	private static Logger logger = Logger.getLogger(JfImpl.class
			.getName());
	public List<Map<String, Object>> getJfbyUid(String userid, int limit){
		if(SecurityUtil.sqlCheck(userid)) return null;
		return jfDao.getJfbyUid(userid, limit);
	};

	public List<Map<String,Object>> page(String param,String page,String rp) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return jfDao.page(jfDao.pageSql(param), page, rp, this.count(param));
	}
	
	public String count (String param) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return  jfDao.getCount(jfDao.countSql(param));
	}

	public List<Map<String,Object>> pagely(String param,String page,String rp) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return jfDao.page(jfDao.pagelySql(param), page, rp, this.countly(param));
	}
	
	public String countly (String param) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return  jfDao.getCount(jfDao.countlySql(param));
	}
	public List<Map<String, Object>> getJfLjsj(String yg) {
		if(SecurityUtil.sqlCheck(yg)) return null;
		return  jfDao.getJfLjsj(yg);
	}
	

	public TblJfffmc findById(Integer id) {
		return jfffmcDao.find(id);
	}

	public TblJfffmc[] findByIds(Integer[] ids) {
		return jfffmcDao.find(ids);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean save(TblJfffmc jfffmc) {
		return jfffmcDao.save(jfffmc);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean[] save(TblJfffmc[] jfffmc) {
		return jfffmcDao.save(jfffmc);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean lq(Integer id) {
		TblJfffmc jfffmc = jfffmcDao.find(id);
		TblQyyg qyyg = qyygDao.find(jfffmc.getHqr());
		qyyg.setJf(qyyg.getJf()+jfffmc.getFfjf());
		jfffmc.setSflq(1);
		jfffmc.setLqsj(new Timestamp(System.currentTimeMillis()));
		try{
			jfffmcDao.save(jfffmc);
			qyygDao.save(qyyg);
		}catch (Exception e){
			logger.error("JfImpl--lq", e);
			return false;
		}
		return true;
	}
}
