package com.ssh.service;

import com.ssh.entity.TblPay;

public interface PayService {	
	public boolean save(TblPay pay);
    public boolean[] save(TblPay[] pay);
    public TblPay findById(String id);
    public TblPay[] findByIds(String[] ids);
	
}
