package com.chinarewards.alading.reg.mapper;

import com.chinarewards.alading.domain.OrderForm;

public interface OrderFormMapper extends CommonMapper<OrderForm> {
	
	OrderForm selectByCouponNo(String couponNo);

	Integer changeStatus(OrderForm orderForm);
}
