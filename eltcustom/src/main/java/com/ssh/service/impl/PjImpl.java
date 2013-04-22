package com.ssh.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ssh.dao.PjDao;
import com.ssh.dao.TblPjDao;
import com.ssh.entity.TblPj;
import com.ssh.service.PjService;
import com.ssh.util.SecurityUtil;
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class PjImpl implements PjService{
	@Resource
	private PjDao pjDao;
	@Resource
	private TblPjDao tpjDao;

	private static Logger logger = Logger.getLogger(PjImpl.class
			.getName());

	public List<Map<String, Object>> getSumPf(String spl) {
		if(SecurityUtil.sqlCheck(spl)) return null;
		String param = " AND t.spl = "+spl;
		return pjDao.getSumPf(param);
	}
	public List<Map<String, Object>> getPjxj(String spl) {
		if(SecurityUtil.sqlCheck(spl)) return null;
		String param = " AND t.spl = "+spl;
		return pjDao.getPjxj(param);
	}
	public List<Map<String, Object>> getPjlx(String spl) {
		if(SecurityUtil.sqlCheck(spl)) return null;
		String param = " AND t.spl = "+spl;
		return pjDao.getPjlx(param);
	}
	public List<Map<String,Object>> page(String param,String page,String rp) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return pjDao.page(pjDao.pageSql(param), page, rp, this.count(param));
	}
	
	public String count (String param) {
		if(SecurityUtil.sqlCheck(param)) return null;
		return  pjDao.getCount(pjDao.countSql(param));
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean save(TblPj pj) {
		return tpjDao.save(pj);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
    public boolean[] save(TblPj[] pjs) {
		return tpjDao.save(pjs);
	}
    public TblPj findById(Integer id) {
		return tpjDao.find(id);
	}
    public TblPj[] findByIds(Integer[] ids) {
		return tpjDao.find(ids);
	}
}
