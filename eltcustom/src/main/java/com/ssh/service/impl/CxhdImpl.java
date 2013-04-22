package com.ssh.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ssh.dao.CxhdDao;
import com.ssh.entity.TblCxhd;
import com.ssh.service.CxhdService;
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class CxhdImpl implements CxhdService{
	@Resource
	private CxhdDao cxhdDao;
	public List<Map<String, Object>> getCxhd(int limit) {
		String param = " AND syxs = 1 ";
		return cxhdDao.getCxhd(param,limit);
	}
	public List<Map<String, Object>> getCxhdImg(int limit) {
		String param = " AND syxs = 1 AND sfgg = 1 ";
		return cxhdDao.getCxhd(param,limit);
	}
	public TblCxhd findById(Integer id) {
		return cxhdDao.find(id);
	}
}
