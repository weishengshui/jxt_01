package com.chinarewards.alading.reg.mapper;

import java.util.Map;

import com.chinarewards.alading.domain.OrderForm;

public interface OrderFormMapper extends CommonMapper<OrderForm> {

	OrderForm selectByCouponNo(String couponNo);

	Integer changeStatus(OrderForm orderForm);

	/**
	 * Employee exchange cash coupon by it's integrals.
	 * 
	 * @param parameters
	 *            IN _couponNo VARCHAR(50), IN _employeeMobile VARCHAR(20), IN
	 *            _quantity INT, IN _terminalId VARCHAR(50), IN _terminalAddress
	 *            VARCHAR(255), IN _transactionDate VARCHAR(50), OUT returnCode
	 *            VARCHAR(10)
	 */
	public void exchange(Map<String, Object> parameters);

	/**
	 * Employee apply consuming coupon
	 * 
	 * @param parameters
	 *            String couponNo, String terminalId, String merchantName,
	 *            String merchantAddress, String transactionDate, String
	 *            transactionNo
	 */
	public void applyCoupon(Map<String, Object> parameters);

	/**
	 * Expire employee coupons
	 * 
	 * @param parameters
	 *            String couponNo
	 */
	public void expireCoupon(Map<String, Object> parameters);

}
