package com.chinarewards.alading.service;

import java.util.List;

public interface ICouponService {

	/**
	 * 兑换抵用券，扣减会员积分
	 * 
	 * @param couponNo
	 *            抵用券交易号
	 * @param accountId
	 *            企业员工nid
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
	 * 
	 *         tbl_ygddzb -- elt 订单表 （9 取消订单， 3待评价商品） INSERT INTO `tbl_ygddzb`
	 *         (`nid`, `ddh`, `state`, `cjrq`, `jsrq`, `ydh`, `shrq`, `fhrq`,
	 *         `zjf`, `zje`, `jfqsl`, `fhr`, `fhrdh`, `yg`, `shdz`, `ddbz`,
	 *         `shdzxx`, `qsrq`, `gys`) VALUES (85, '20130506140650124', 9,
	 *         '2013-05-06 14:06:50', '2013-05-06 14:06:54', NULL, NULL, NULL,
	 *         10, 0.00, 0, NULL, NULL, 124, 20, '10积分换购商品', '<b>收货人：</b>windy
	 *         <b>电话号码：</b>15896521456<br />
	 *         <b>地址：</b>广东省 深圳市 南山区 高新一道，TCL,A301 581000 ', NULL, NULL);
	 * 
	 *         tbl_ygddmx -- elt 订单明细 INSERT INTO `tbl_ygddmx` (`nid`, `dd`,
	 *         `sp`, `dhfs`, `sl`, `jf`, `je`, `jfq`, `yg`, `spl`, `jssj`,
	 *         `ddh`, `state`) VALUES (99, 85, 98, NULL, 1, 10, NULL, NULL, 124,
	 *         70, '2013-05-06 14:06:54', '20130506140650124', 9);
	 * 
	 */
	public String exchange(String couponNo, int accountId, int quantity,
			String terminalId, String terminalAddress, String transactionDate);

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
	public String applyCoupon(List<String> couponNo, String terminalId,
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
	public String expireCoupon(List<String> couponNo);
}
