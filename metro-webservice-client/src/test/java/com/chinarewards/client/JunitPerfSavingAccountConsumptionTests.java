package com.chinarewards.client;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import com.chinarewards.client.exception.InvalidSignException;
import com.chinarewards.metro.models.merchandise.CommodityVo;
import com.chinarewards.metro.models.request.SavingAccountConsumptionReq;
import com.chinarewards.metro.models.response.SavingAccountConsumptionRes;
import com.clarkware.junitperf.ConstantTimer;
import com.clarkware.junitperf.LoadTest;
import com.clarkware.junitperf.TimedTest;
import com.clarkware.junitperf.Timer;

public class JunitPerfSavingAccountConsumptionTests extends TestCase{
	
	private ClientService clientService = new ClientService(
			"http://localhost:8080/metro/ws");
	private int userId;
	
	public JunitPerfSavingAccountConsumptionTests(String name, int userId) {
		super(name);
		this.userId = userId;
	}
	
	public void setUp() throws Exception {
		super.setUp();
	}

	public void tearDown() throws Exception {
		super.tearDown();
	}

	protected static Test testSavingAccountConsumption(int userId) {
		/*int users = 10;
		Test factory = new TestMethodFactory(JunitPerfSavingAccountConsumptionTests.class,
				"testSavingAccountConsumption_concurrent");
		Test loadTest = new LoadTest(factory, users, 1 );
		return loadTest;*/
		
		int users = 100;
		int iterations = 1;
		Timer timer = new ConstantTimer(0);

		Test testCase = new JunitPerfSavingAccountConsumptionTests("testSavingAccountConsumption_concurrent", userId);

		Test loadTest = new LoadTest(testCase, users, iterations);
//		Test timedTest = new TimedTest(loadTest, maxElapsedTimeInMillis);

		return loadTest;
	}
	
	public static Test suite() {
		TestSuite suite = new TestSuite();
		for(int i = 7975; i <= 7975 /*8174*/; i++){
			suite.addTest(testSavingAccountConsumption(i));
		}
		return suite;
	}
	
	public static void main(String[] args) {
		junit.textui.TestRunner.run(suite());
	}
	
	
	
	public void test_() throws InvalidSignException {
		for (int i = 0; i < 200; i++) {
			testSavingAccountConsumption_concurrent();
		}
	}

	public void testSavingAccountConsumption_concurrent()
			throws InvalidSignException {
		// case 2: 测试订单ID格式
		List<CommodityVo> commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		CommodityVo commodity = new CommodityVo();
		commodity.setId("ff8081813db418ac013dc48278b20012");
		commodity.setName("bsk");
		commodity.setCount(1);
		CommodityVo commodity2 = new CommodityVo();
		commodity2.setId("ff8081813db418ac013dc4b0162c001c");
		commodity2.setName("金钱豹自助午餐");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		SavingAccountConsumptionReq req = new SavingAccountConsumptionReq();

		req.setOrderId(generate());// 订单ID
		req.setOrderSource("123");// 订单来源
		req.setPoint(0.1); // 扣除金额
		req.setUserId(this.userId);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		SavingAccountConsumptionRes res = clientService
				.savingAccountConsumption(req);
		assertTrue(new Integer(1).equals(res.getOperateStatus()));
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

	}
	
	public String generate() {

		UUID uuid = UUID.randomUUID();
		String s = uuid.toString();
		// strip off hyphens
		s = s.replaceAll("-", "");
		return s;

	}

}
