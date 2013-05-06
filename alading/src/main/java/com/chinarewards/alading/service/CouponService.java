package com.chinarewards.alading.service;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.mybatis.guice.transactional.Transactional;
import org.slf4j.Logger;

import com.chinarewards.alading.domain.ExchangeLog;
import com.chinarewards.alading.domain.Member;
import com.chinarewards.alading.domain.OrderForm;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.reg.mapper.ExchangeLogMapper;
import com.chinarewards.alading.reg.mapper.MemberMapper;
import com.chinarewards.alading.reg.mapper.OrderFormMapper;
import com.chinarewards.alading.util.SystemTimeProvider;
import com.google.inject.Inject;

public class CouponService implements ICouponService {

	@InjectLogger
	private Logger logger;

	@Inject
	private OrderFormMapper orderFormMapper;
	@Inject
	private MemberMapper memberMapper;
	@Inject
	private ExchangeLogMapper exchangeLogMapper;

	@Override
	public String exchange(String couponNo, String employeeMobile,
			int quantity, String terminalId, String terminalAddress,
			String transactionDate) {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Transactional
	@Override
	public String applyCoupon(String couponNo, String terminalId,
			String merchantName, String merchantAddress,
			String transactionDate, String transactionNo) {

		String res = "100";
		String mobilePhone = null;
		Date td = null;
		OrderForm orderForm = orderFormMapper.selectByCouponNo(couponNo);

		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		try {
			td = dateFormat.parse(transactionDate);
		} catch (Exception e) {
		}

		if (null == orderForm) {
			res = "101"; // 抵用券号码不存在
		} else {
			Integer employeeId = orderForm.employeeId;
			Member member = memberMapper.selectMemberById(employeeId);
			mobilePhone = (member != null) ? member.getMobilePhone() : null;

			if (orderForm.status == 1) {
				res = "102"; // 抵用券已过期
			} else if (orderForm.status != 0) {
				res = "103"; // 订单状态错误
			} else if (null == td) {
				res = "114"; // 传入的日期格式错误
			} else if (null == member) {
				res = "120"; // 订单数据错误
			} else if (!member.getStatus().equals(new Integer(1))) {
				res = "121"; // 用户已锁定
			} else {
				orderForm.status = 2; // 将状态改成已使用
				orderForm.lastUpdatedAt = SystemTimeProvider.getCurrentTime();
				if (orderFormMapper.changeStatus(orderForm).equals(
						new Integer(1))) {
					res = "100"; // 交易成功
				} else {
					res = "113"; // 系统级异常
				}
			}
		}

		// exchangeLog
		ExchangeLog exchangeLog = new ExchangeLog();
		exchangeLog.couponNo = couponNo;
		exchangeLog.createdAt = SystemTimeProvider.getCurrentTime();
		exchangeLog.returnCode = res;
		exchangeLog.transactionDate = td;
		exchangeLog.merchantAddress = merchantAddress;
		exchangeLog.merchantName = merchantName;
		exchangeLog.terminalId = terminalId;
		exchangeLog.operation = "使用抵扣券";
		exchangeLog.mobilePhone = mobilePhone;
		exchangeLogMapper.insert(exchangeLog);

		return res;
	}

	@Transactional
	@Override
	public String expireCoupon(String couponNo) {
		String res = "100";
		String mobilePhone = null;
		OrderForm orderForm = orderFormMapper.selectByCouponNo(couponNo);

		if (null == orderForm) {
			res = "101"; // 抵用券号码不存
		} else {
			Integer employeeId = orderForm.employeeId;
			Member member = memberMapper.selectMemberById(employeeId);
			mobilePhone = (member != null) ? member.getMobilePhone() : null;

			if (orderForm.status == 1) {
				res = "102"; // 抵用券已过期
			} else if (orderForm.status == 3) {
				res = "103"; // 抵用券已取消
			} else if (orderForm.status != 0) {
				res = "104"; // 订单状态错误
			} else {
				if (null == member) {
					res = "120"; // 订单数据错误
				} else if (!member.getStatus().equals(new Integer(1))) {
					res = "121"; // 用户已锁定
				} else {
					orderForm.status = 3; // 将状态改成已取消
					orderForm.lastUpdatedAt = SystemTimeProvider
							.getCurrentTime();
					if (orderFormMapper.changeStatus(orderForm).equals(
							new Integer(1))) {
						res = "100"; // 交易成功
					} else {
						res = "113"; // 系统级异常
					}
				}
			}
		}

		// exchangeLog
		ExchangeLog exchangeLog = new ExchangeLog();
		exchangeLog.couponNo = couponNo;
		exchangeLog.createdAt = SystemTimeProvider.getCurrentTime();
		exchangeLog.returnCode = res;
		exchangeLog.transactionDate = SystemTimeProvider.getCurrentTime();
		exchangeLog.operation = "失效抵扣券";
		exchangeLog.mobilePhone = mobilePhone;
		exchangeLogMapper.insert(exchangeLog);

		return res;
	}

}
