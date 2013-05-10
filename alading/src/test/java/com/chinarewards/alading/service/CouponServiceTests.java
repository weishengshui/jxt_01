package com.chinarewards.alading.service;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class CouponServiceTests extends BaseTests {

	private ICouponService couponService;

	@Before
	public void setUp() throws Exception {
		super.setUp();
		couponService = injector.getInstance(ICouponService.class);
	}

	@After
	public void tearDown() throws Exception {
		couponService = null;
		super.tearDown();
	}

	/**
	 * 失效抵扣券测试
	 * 
	 * <ul>
	 * <li>100：交易成功</li>
	 * <li>101：抵扣券号码不存在</li>
	 * <li>102：抵扣券已过期</li>
	 * <li>103 : 抵用券已取消</li>
	 * <li>104 : 订单状态错误</li>
	 * <li>113：系统级异常</li>
	 * <li>120:订单系统数据错误</li>
	 * <li>121:用户被锁定</li>
	 * </ul>
	 */
	@Test
	public void test_expireCoupon() {

		assertNotNull(couponService);
		// 抵用券不存在
		List<String> couponNos = new ArrayList<String>();
		couponNos.add("22222011");
		assertEquals("101", couponService.expireCoupon(couponNos));

		String couponNo = "001"; // 抵用券可用
		couponNos.set(0, couponNo);
		assertEquals("100", couponService.expireCoupon(couponNos));
		assertEquals("103", couponService.expireCoupon(couponNos));

		couponNo = "002"; // 抵用券已过期
		couponNos.set(0, couponNo);
		assertEquals("102", couponService.expireCoupon(couponNos));

		couponNo = "003"; // 抵用券已使用
		couponNos.set(0, couponNo);
		assertEquals("104", couponService.expireCoupon(couponNos));

		couponNo = "004"; // 抵用券已取消
		couponNos.set(0, couponNo);
		assertEquals("103", couponService.expireCoupon(couponNos));

		couponNo = "005"; // 抵用券错误状态
		couponNos.set(0, couponNo);
		assertEquals("104", couponService.expireCoupon(couponNos));

		couponNo = "006"; // 用户已锁定
		couponNos.set(0, couponNo);
		assertEquals("121", couponService.expireCoupon(couponNos));

	}

	/**
	 * 使用抵扣券测试
	 * 
	 * <ul>
	 * <li>100：交易成功</li>
	 * <li>101：抵扣券号码不存在</li>
	 * <li>102：抵扣券已过期</li>
	 * <li>103: 订单状态错误</li>
	 * <li>114: 传入的日期格式错误</li>
	 * <li>120: 订单系统数据错误</li>
	 * <li>113：系统级异常</li>
	 * <li>121: 用户帐号锁定</li>
	 * </ul>
	 */
	@Test
	public void test_applyCoupon() {

		assertNotNull(couponService);
		// 抵用券不存在
		assertEquals("101", couponService.applyCoupon(Arrays.asList(new String[]{"11211"}), "ter", "merchantName", "merchantAddress", "2012-05-06 14:12:25", "transationNo"));
		// 传入的日期格式错误
		assertEquals("114", couponService.applyCoupon(Arrays.asList(new String[]{"001"}), "ter", "merchantName", "merchantAddress", "2012-05-06 14:12:", "transationNo"));

		String couponNo = "001"; // 抵用券可用
		assertEquals("100", couponService.applyCoupon(Arrays.asList(new String[]{couponNo}), "ter", "merchantName", "merchantAddress", "2012-05-06 14:12:25", "transationNo"));
		assertEquals("103", couponService.applyCoupon(Arrays.asList(new String[]{couponNo}), "ter", "merchantName", "merchantAddress", "2012-05-06 14:12:25", "transationNo"));

		couponNo = "002"; // 抵用券已过期
		assertEquals("102", couponService.applyCoupon(Arrays.asList(new String[]{couponNo}), "ter", "merchantName", "merchantAddress", "2012-05-06 14:12:25", "transationNo"));

		couponNo = "003"; // 抵用券已使用
		assertEquals("103", couponService.applyCoupon(Arrays.asList(new String[]{couponNo}), "ter", "merchantName", "merchantAddress", "2012-05-06 14:12:25", "transationNo"));

		couponNo = "004"; // 抵用券已取消
		assertEquals("103", couponService.applyCoupon(Arrays.asList(new String[]{couponNo}), "ter", "merchantName", "merchantAddress", "2012-05-06 14:12:25", "transationNo"));

		couponNo = "005"; // 抵用券错误状态
		assertEquals("103", couponService.applyCoupon(Arrays.asList(new String[]{couponNo}), "ter", "merchantName", "merchantAddress", "2012-05-06 14:12:25", "transationNo"));

		couponNo = "006"; // 用户已锁定
		assertEquals("121", couponService.applyCoupon(Arrays.asList(new String[]{couponNo}), "ter", "merchantName", "merchantAddress", "2012-05-06 14:12:25", "transationNo"));

	}

}
