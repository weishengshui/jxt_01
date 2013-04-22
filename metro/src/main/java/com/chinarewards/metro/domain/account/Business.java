package com.chinarewards.metro.domain.account;

public enum Business {

	/**
	 * POS机端获取积分
	 */
	POS_SALES,

	/**
	 * 外部订单
	 */
	EXT_ORDER,

	/**
	 * POS机端消费积分
	 */
	POS_REDEMPTION,

	/**
	 * 过期积分
	 */
	EXPIRY_POINT,

	/**
	 * 手动添加积分
	 */
	HAND_POINT,
	/**
	 * 手动处理卡充值
	 */
	HAND_MONEY,
	/**
	 * 外部接口注册时送的积分
	 */
	EXTERNAL_POINT,

	/**
	 * 储值卡消费接口扣除金额
	 */
	SAVING_ACCOUNT_CONSUMPTION,

	/**
	 *外部兑换订单 
	 */
	EXT_REDEMPTION
	
}
