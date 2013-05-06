package com.chinarewards.alading.service;

public interface ICouponService {

	/**
	 * 兑换抵用券，扣减会员积分
	 * 
	 * @param couponNo
	 *            抵用券交易号
	 * @param employeeMobile
	 *            企业员工手机号
	 * @param quantity
	 *            兑换数量
	 * @param terminalId
	 *            终端Id
	 * @param terminalAddress
	 *            终端地址
	 * @param transactionDate
	 *            外部交易时间
	 * @return response code
	 *         <ul>
	 *         <li>100：交易成功</li>
	 *         <li>101：抵扣券号码已存在</li>
	 *         <li>102：会员账户余额不足</li>
	 *         <li>103：积分类型错误</li>
	 *         <li>104：超出当日使用限额</li>
	 *         <li>113：系统级异常</li>
	 *         </ul>
	 */
	public String exchange(String couponNo, String employeeMobile,
			int quantity, String terminalId, String terminalAddress,
			String transactionDate);

	/**
	 * 使用抵用券消费
	 * 
	 * @param couponNo
	 *            使用的抵用券交易号
	 * @param terminalId
	 *            终端机编号
	 * @param merchantName
	 *            终端机所属商户
	 * @param merchantAddress
	 *            终端机所属商户地址
	 * @param transactionDate
	 *            交易发生时间,日期格式为 yyyy-MM-dd hh:mm:ss
	 * @param transactionNo
	 *            外部交易号
	 * @return response code
	 *         <ul>
	 *         <li>100：交易成功</li>
	 *         <li>101：抵扣券号码不存在</li>
	 *         <li>102：抵扣券已过期</li>
	 *         <li>103: 订单状态错误</li>
	 *         <li>114: 传入的日期格式错误</li>
	 *         <li>120: 订单系统数据错误</li>
	 *         <li>113：系统级异常</li>
	 *         <li>121: 用户帐号锁定</li>
	 *         </ul>
	 */
	public String applyCoupon(String couponNo, String terminalId,
			String merchantName, String merchantAddress,
			String transactionDate, String transactionNo);

	/**
	 * 
	 * 抵用券失效接口
	 * 
	 * @param couponNo
	 *            使用的抵用券交易号
	 * @return response code
	 *         <ul>
	 *         <li>100：交易成功</li>
	 *         <li>101：抵扣券号码不存在</li>
	 *         <li>102：抵扣券已过期</li>
	 *         <li>103 : 抵用券已取消</li>
	 *         <li>104 : 订单状态错误</li>
	 *         <li>113：系统级异常</li>
	 *         <li>120:订单系统数据错误</li>
	 *         <li>121:用户被锁定</li>
	 *         </ul>
	 */
	public String expireCoupon(String couponNo);
}
