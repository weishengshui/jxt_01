package com.ssh.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ssh.dao.BzzxDao;
import com.ssh.entity.TblBzzx;
import com.ssh.service.BzzxService;
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class BzzxImpl implements BzzxService{
	@Resource
	private BzzxDao bzzxDao;
	public List<Map<String, Object>> getBz() {
		return bzzxDao.getBz();
	}

    public TblBzzx findById(Integer id) {
		return bzzxDao.find(id);
	}
}
