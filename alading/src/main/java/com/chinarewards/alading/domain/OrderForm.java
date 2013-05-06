package com.chinarewards.alading.domain;

import java.util.Date;

public class OrderForm {

	public int id ;
	
	public String couponNo ;
	
	public String merchandiseName;
	
	public int merchandiseId;
	
	// 抵用券的售卖价格
	public Double sellPrice;
	
	// 抵用券数量
	public int quantity;
	
	// 0订单可用,1过期，2，已使用，3已取消
	public int status;
	
	public Date orderTime;
	
	public Date createdAt;
	
	// 员工Id
	public int employeeId;
	
	// 下订单的手机号码
	public String mobilePhone;
	
	public String unitCode ;
	
	public Double unitPrice;
	
	// 使用积分数量
	public Double units ;
	
	// 企业id
	public int enterpriseId;
	
	public Date lastUpdatedAt ;
	
	// 过期时间
	public Date expiredTime ;
}
