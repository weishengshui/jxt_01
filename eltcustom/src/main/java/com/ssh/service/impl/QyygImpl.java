package com.ssh.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.annotation.Propagation;

import com.googlecode.genericdao.search.Search;
import com.ssh.dao.QyygDao;
import com.ssh.entity.TblQyyg;
import com.ssh.service.QyygService;

@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class QyygImpl implements QyygService {
	@Resource
	private QyygDao qyygDao;
	
	public List<TblQyyg> findAll() {
		return qyygDao.findAll();
	}

	public TblQyyg findById(Integer id) {
		return qyygDao.find(id);
	}

	public TblQyyg findByEmail(String email) {
		Search search = new Search(TblQyyg.class);
		search.setDistinct(true);
		search.addFilterEqual("email", email);
		return qyygDao.searchUnique(search);
	}
	
	public TblQyyg[] findByIds(Integer[] ids) {
		return qyygDao.find(ids);
	}

	public void flush() {
		qyygDao.flush();
	}
	public List<Map<String, Object>> getQyinfo(int qy) {
		return qyygDao.getQyinfo(qy);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean remove(TblQyyg qyyg) {
		return qyygDao.remove(qyyg);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public void remove(TblQyyg[] qyygs) {
		qyygDao.remove(qyygs);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean removeById(Integer id) {
		return qyygDao.removeById(id);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public void removeByIds(Integer[] ids) {
		qyygDao.removeByIds(ids);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean save(TblQyyg qyyg) {
		return qyygDao.save(qyyg);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean[] save(TblQyyg[] qyygs) {
		return qyygDao.save(qyygs);
	}
}
