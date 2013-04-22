package com.chinarewards.metro.service.order;

import java.util.Date;

import com.chinarewards.metro.domain.business.OrderInfo;

public interface IOrderService {

	/**
	 * 更新订单同步到业务管理后台系统状态
	 * 
	 * @param o
	 * @return
	 */
	public OrderInfo signSyncInfo(OrderInfo o,boolean sync,Date syncAt);
}
