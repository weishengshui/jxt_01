package com.chinarewards.metro.service.discount.impl;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.domain.shop.DiscountNumber;
import com.chinarewards.metro.domain.shop.DiscountNumberHistory;

public class ThreadPoolTask implements Runnable {
	private HBDaoSupport hbDaoSupport;
	private DiscountNumber number;   

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
    public ThreadPoolTask(DiscountNumber tasks,HBDaoSupport hbDaoSupport) {   
        this.number = tasks;
        this.hbDaoSupport = hbDaoSupport;
    }
	@Override
	public void run() {
		logger.trace("===========>"+number.getDiscountNum()+"========"+hbDaoSupport);
		Date now_date = new Date();
		Date expiredDate = number.getExpiredDate();
		boolean flag = now_date.after(expiredDate);
		if(flag){
			
			DiscountNumberHistory history = new DiscountNumberHistory();
			
			history.setDescription(number.getDescr());
			history.setDiscountNum(number.getDiscountNum());
			history.setExpiredDate(expiredDate);
			history.setGeneratedDate(number.getGeneratedDate());
			history.setMember(number.getMember());
			history.setShop(number.getShop());
			history.setStatus(-1);
			history.setTitle(number.getTitle());
			history.setUsedDate(null);
			try {
				hbDaoSupport.save(history);
				
				String hql = "delete from DiscountNumber where id = ?" ;
				hbDaoSupport.executeHQL(hql, number.getId());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}
