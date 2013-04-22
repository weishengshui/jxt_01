package com.chinarewards.metro.models.order;

public class OrderRespErrorCode {
	// 成功
	public static final String SUCCESS = "0";

	// 订单号重复
	public static final String REPEART = "1";

	// 失败
	public static final String FAIL = "2";

	// 无效的优惠码
	public static final String INVALID_COUPON = "3";

	// 会员不存在
	public static final String MEMBER_NOT_EXISTS = "4";

	// 消耗积分会员必须是已激活的
	public static final String RED_ACTIVATE_REQUIRED = "9";

	// 门店不存在
	public static final String SHOP_NOT_EXISTS = "5";

	// 其他参数异常
	public static final String ILLEGAL_ARGUMENT = "6";

	// pos 终端不存在
	public static final String POS_NOT_EXISTS = "7";

	// pos 终端不是绑定到这个门店下
	public static final String INVALID_SHOP_POS = "8";
	
	// 账户余额不足 
	public static final String INVALID_BALANCE = "10";

}
