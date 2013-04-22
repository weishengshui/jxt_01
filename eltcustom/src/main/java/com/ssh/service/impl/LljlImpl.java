package com.ssh.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.googlecode.genericdao.search.Search;
import com.ssh.dao.LljlDao;
import com.ssh.dao.TblLljlDao;
import com.ssh.entity.TblLljl;
import com.ssh.service.LljlService;
import com.ssh.util.SecurityUtil;
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class LljlImpl implements LljlService{
	@Resource
	private LljlDao lljlDao;
	@Resource
	private TblLljlDao tbllljlDao;
	
	public List<Map<String, Object>> getLljjTitle(String yg, int limit) {
		if(SecurityUtil.sqlCheck(yg)) return null;
		return lljlDao.getLljjTitle(yg, limit);
	}
	public List<Map<String, Object>> getTszk(int yg, int qy, int limit) {
		return lljlDao.getTszk(yg, qy, limit);
	}
	
	public TblLljl findById(Integer id) {
		return tbllljlDao.find(id);
	}

	public TblLljl[] findByIds(Integer[] ids) {
		return tbllljlDao.find(ids);
	}

	public List<TblLljl> findBySpYg(Integer yg,Integer sp,Integer spl) {
		Search search = new Search(TblLljl.class);
		search.addFilterEqual("yg", yg);
		search.addFilterEqual("spl", spl);
		search.addFilterEqual("sp", sp);
		return tbllljlDao.search(search);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean save(TblLljl lljl) {
		return tbllljlDao.save(lljl);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean[] save(TblLljl[] lljl) {
		return tbllljlDao.save(lljl);
	}
}
