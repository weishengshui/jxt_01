package com.ssh.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ssh.dao.ShdzDao;
import com.ssh.entity.TblShdz;
import com.ssh.service.ShdzService;
import com.ssh.util.SecurityUtil;
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class ShdzImpl implements ShdzService{
	@Resource
	private ShdzDao shdzDao;
	public List<Map<String, Object>> getShdzByUid(String userid) {
		if(SecurityUtil.sqlCheck(userid)) return null;
		return shdzDao.getShdzByUid(userid);
	};

	public TblShdz[] findByIds(Integer[] ids) {
		return shdzDao.find(ids);
	}

	public void flush() {
		shdzDao.flush();
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean remove(TblShdz shdz) {
		return shdzDao.remove(shdz);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public void remove(TblShdz[] shdzs) {
		shdzDao.remove(shdzs);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean removeById(Integer id) {
		return shdzDao.removeById(id);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public void removeByIds(Integer[] ids) {
		shdzDao.removeByIds(ids);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean save(TblShdz shdz) {
		return shdzDao.save(shdz);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean[] save(TblShdz[] shdzs) {
		return shdzDao.save(shdzs);
	}

	public List<TblShdz> findAll() {
		return shdzDao.findAll();
	}

	public TblShdz findById(Integer id) {
		return shdzDao.find(id);
	}
}
