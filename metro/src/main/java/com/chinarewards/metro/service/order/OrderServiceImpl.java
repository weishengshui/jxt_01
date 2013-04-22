package com.chinarewards.metro.service.order;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;

import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.domain.business.OrderInfo;

public class OrderServiceImpl implements IOrderService {

	@Autowired
	HBDaoSupport hbDaoSupport;

	@Override
	public OrderInfo signSyncInfo(OrderInfo o, boolean sync, Date syncAt) {
		o.setSync(sync);
		o.setSyncAt(syncAt);
		hbDaoSupport.update(o);
		return o;
	}

	public HBDaoSupport getHbDaoSupport() {
		return hbDaoSupport;
	}

	public void setHbDaoSupport(HBDaoSupport hbDaoSupport) {
		this.hbDaoSupport = hbDaoSupport;
	}

}
