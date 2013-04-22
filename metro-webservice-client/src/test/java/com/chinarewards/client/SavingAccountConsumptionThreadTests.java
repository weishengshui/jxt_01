package com.chinarewards.client;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.chinarewards.client.exception.InvalidSignException;
import com.chinarewards.metro.models.merchandise.CommodityVo;
import com.chinarewards.metro.models.request.SavingAccountConsumptionReq;
import com.chinarewards.metro.models.response.SavingAccountConsumptionRes;

import static org.junit.Assert.*;

public class SavingAccountConsumptionThreadTests extends Thread {

	private int memberId;
//	private ClientService clientService = new ClientService(
//			"http://192.168.4.235:8080/metro/ws");
	private ClientService clientService = new ClientService(
			"http://192.168.4.91:7070/metro/ws");
	private static int count = 0;

	private SavingAccountConsumptionThreadTests() {
	}

	private SavingAccountConsumptionThreadTests(int memberId) {
		this.memberId = memberId;
	}

	public void run() {
		// case 2: 测试订单ID格式
//		List<CommodityVo> commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
//		CommodityVo commodity = new CommodityVo();
//		commodity.setId("4028846b3dfc7418013dfcdc61d6001a");
//		commodity.setName("11");
//		commodity.setCount(1);
//		CommodityVo commodity2 = new CommodityVo();
//		commodity2.setId("4028846b3e10c1ab013e10d206c30000");
//		commodity2.setName("储值卡接口测试");
//		commodity2.setCount(3);
//		commodities.add(commodity);
//		commodities.add(commodity2);
		
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
		req.setUserId(this.memberId);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		SavingAccountConsumptionRes res;
		try {
			res = clientService.savingAccountConsumption(req);
			assertTrue(new Integer(1).equals(res.getOperateStatus()));
			count++;
			System.out.println("count ====>"+count);
//			System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		} catch (InvalidSignException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// assertTrue(new Integer(1).equals(res.getOperateStatus()));
		// System.out.println("操作状态描述：" + res.getStatusDescription());
	}

	public String generate() {

		UUID uuid = UUID.randomUUID();
		String s = uuid.toString();
		// strip off hyphens
		s = s.replaceAll("-", "");
		return s;
	}

	public static void main(String[] args) {
		
		ExecutorService pool = Executors.newFixedThreadPool(200);
		for (int i = 0; i < 200; i++) {
			// 将线程放入池中进行执行
			SavingAccountConsumptionThreadTests t = new SavingAccountConsumptionThreadTests(
					7175 + i);
			if (!pool.isShutdown()) {
				pool.execute(t);
			}
//			System.out.println("add member====>"+(i+1));
		}
		// 关闭线程池
		pool.shutdown();
	}
	
	public static void ss(){
		
	}
}
