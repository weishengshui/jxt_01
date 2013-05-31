package com.ssh.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ssh.dao.JfqDao;
import com.ssh.dao.JfqmcDao;
import com.ssh.dao.SyqyjfqDao;
import com.ssh.entity.TblJfqmc;
import com.ssh.entity.TblSyqyjfq;
import com.ssh.service.JfqService;
import com.ssh.util.SecurityUtil;
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class JfqImpl implements JfqService{
	@Resource
	private JfqDao jfqDao;
	@Resource
	private JfqmcDao jfqmcDao;

	@Resource
	private SyqyjfqDao syqyjfqDao;

	public List<Map<String, Object>> getJfqbyUid(String userid, int limit) {
		if (SecurityUtil.sqlCheck(userid))
			return null;
		return this.jfqDao.getJfqbyUid(userid, limit);
	}

	public List<Map<String, Object>> page(String param, String page, String rp) {
		if (SecurityUtil.sqlCheck(param))
			return null;
		return this.jfqDao.page(this.jfqDao.pageSql(param), page, rp,
				count(param));
	}
	
	public String count (String param) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return  jfqDao.getCount(jfqDao.countSql(param));
	}

	public List<Map<String,Object>> pagely(String param,String page,String rp) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return jfqDao.page(jfqDao.pagelySql(param), page, rp, this.countly(param));
	}
	
	public String countly (String param) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return  jfqDao.getCount(jfqDao.countlySql(param));
	}
	
	public List<Map<String, Object>> getJfqLjsj(String yg) {
		if(SecurityUtil.sqlCheck(yg)) return null;
		return  jfqDao.getJfqLjsj(yg);
	}

	public TblJfqmc findById(Integer id) {
		return jfqmcDao.find(id);
	}

	public TblJfqmc[] findByIds(Integer[] ids) {
		return jfqmcDao.find(ids);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean save(TblJfqmc jfqmc) {
		return jfqmcDao.save(jfqmc);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean[] save(TblJfqmc[] jfqmc) {
		return jfqmcDao.save(jfqmc);
	}

	public List<Map<String, Object>> getDetail(String nid) {
		if(SecurityUtil.sqlCheck(nid)) return null;
		return  jfqDao.getDetail(nid);
	}

	public List<Map<String, Object>> getSpJfqCount(String sp) {
		if(SecurityUtil.sqlCheck(sp)) return null;
		String param = " AND t.sp = " +sp;
		return  jfqDao.getSpJfqCount(param);
	}

	public List<Map<String, Object>> getSpsJfqCount(String sps) {
		if(SecurityUtil.sqlCheck(sps)) return null;
		String param = " AND t.sp in (" + sps +")";
		return  jfqDao.getSpJfqCount(param);
	}

	public List<Map<String, Object>> getSpJfq(String sps) {
		if(SecurityUtil.sqlCheck(sps)) return null;
		String param = " AND t.sp in (" + sps +")";
		return  jfqDao.getSpJfq(param);
	}

	public List<Map<String, Object>> getJfqs(int yg) {
		String param = " AND t.qyyg = " + yg ;
		return  jfqDao.getJfqs(param);
	}

	public List<Map<String, Object>> getylqmrjfq(String uid) {
		return this.syqyjfqDao.getylqmrjfq(uid);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean syqylqjfq(TblSyqyjfq syqyjfq) {
		return this.syqyjfqDao.save(syqyjfq);
	}
	
}
