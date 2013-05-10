package com.chinarewards.alading.service;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.mybatis.guice.transactional.Transactional;
import org.slf4j.Logger;

import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.reg.mapper.ExchangeLogMapper;
import com.chinarewards.alading.reg.mapper.MemberMapper;
import com.chinarewards.alading.reg.mapper.OrderFormMapper;
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

	@Transactional
	@Override
	public String exchange(String couponNo, int accountId, int quantity,
			String terminalId, String terminalAddress, String transactionDate) {
		Map<String, Object> parameters = new HashMap<String, Object>();
		/*
		 * IN _couponNo VARCHAR(50), IN _employeeMobile VARCHAR(20), IN
		 * _quantity INT, IN _terminalId VARCHAR(50), IN _terminalAddress
		 * VARCHAR(255), IN _transactionDate VARCHAR(50), OUT returnCode
		 * VARCHAR(10)
		 */
		parameters.put("_couponNo", couponNo);
		parameters.put("_accountId", accountId);
		parameters.put("_quantity", quantity);
		parameters.put("_terminalId", terminalId);
		parameters.put("_terminalAddress", terminalAddress);
		parameters.put("_transactionDate", transactionDate);
		parameters.put("returnCode", "");
		orderFormMapper.exchange(parameters);
		String returnCode = (parameters.get("returnCode") != null) ? String
				.valueOf(parameters.get("returnCode")) : "";

		return returnCode;
	}

	@Transactional
	@Override
	public String applyCoupon(List<String> couponNo, String terminalId,
			String merchantName, String merchantAddress,
			String transactionDate, String transactionNo) {

		// 114 日期格式检查
		try {
			SimpleDateFormat dateFormat = new SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss");
			dateFormat.parse(transactionDate);
		} catch (Exception e) {
			return "114";
		}

		String returnCode = "";
		for (String cp : couponNo) {
			if (StringUtils.isNotEmpty(cp)) {
				Map<String, Object> parameters = new HashMap<String, Object>();
				/*
				 * IN _couponNo VARCHAR(50), IN _employeeMobile VARCHAR(20), IN
				 * _quantity INT, IN _terminalId VARCHAR(50), IN
				 * _terminalAddress VARCHAR(255), IN _transactionDate
				 * VARCHAR(50), OUT returnCode VARCHAR(10)
				 */
				parameters.put("_couponNo", cp);
				parameters.put("_terminalId", terminalId);
				parameters.put("_merchantName", merchantName);
				parameters.put("_merchantAddress", merchantAddress);
				parameters.put("_transactionDate", transactionDate);
				parameters.put("_transactionNo", transactionNo);

				parameters.put("returnCode", "");
				orderFormMapper.applyCoupon(parameters);
				returnCode = (parameters.get("returnCode") != null) ? String
						.valueOf(parameters.get("returnCode")) : "";

				// One of coupon failed rollback all
				if (!returnCode.equals("100")) {
					throw new IllegalStateException(returnCode);
				}
			}
		}
		return returnCode;
	}

	@Transactional
	@Override
	public String expireCoupon(List<String> couponNo) {

		String returnCode = "";
		for (String cn : couponNo) {
			if (StringUtils.isNotEmpty(cn)) {
				Map<String, Object> parameters = new HashMap<String, Object>();
				parameters.put("_couponNo", cn);
				parameters.put("returnCode", "");
				orderFormMapper.expireCoupon(parameters);
				returnCode = (parameters.get("returnCode") != null) ? String
						.valueOf(parameters.get("returnCode")) : "";

				// One of coupon failed rollback all
				if (!returnCode.equals("100")) {
					throw new IllegalStateException(returnCode);
				}
			}
		}
		return returnCode;
	}

}
