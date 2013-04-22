package com.ssh.service.impl;


import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ssh.dao.TblPayDao;
import com.ssh.entity.TblPay;
import com.ssh.service.PayService;
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class PayImpl implements PayService{
	@Resource
	private TblPayDao payDao;

	public TblPay findById(String id) {
		return payDao.find(id);
	}

	public TblPay[] findByIds(String[] ids) {
		return payDao.find(ids);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean save(TblPay pay) {
		return payDao.save(pay);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public boolean[] save(TblPay[] pay) {
		return payDao.save(pay);
	}
}
