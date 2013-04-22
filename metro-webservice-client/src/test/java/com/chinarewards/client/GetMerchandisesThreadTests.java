package com.chinarewards.client;

import static org.junit.Assert.assertTrue;

import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.chinarewards.metro.models.merchandise.Merchandise;

public class GetMerchandisesThreadTests extends Thread {

	// private ClientService clientService = new ClientService(
	// "http://192.168.4.235:8080/metro/ws");
	private ClientService clientService = new ClientService(
			"http://192.168.4.91:7070/metro/ws");
	private static int count = 0;

	private GetMerchandisesThreadTests() {
	}

	public void run() {
		try {
			Integer page = new Integer(1);
			Integer pageSize = new Integer(500);// 每页的大小

			// 调用后台函数，获取商品列表
			List<Merchandise> merchandises = clientService.getMerchandises(
					page, pageSize);

			assertTrue(new Integer(3).equals(merchandises.size()));
			count++;
			System.out.println("count ====>"+count);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {

		ExecutorService pool = Executors.newFixedThreadPool(200);
		for (int i = 0; i < 200; i++) {
			// 将线程放入池中进行执行
			GetMerchandisesThreadTests t = new GetMerchandisesThreadTests();
			if (!pool.isShutdown()) {
				pool.execute(t);
			}
			// System.out.println("add member====>"+(i+1));
		}
		// 关闭线程池
		pool.shutdown();
	}

	public static void ss() {

	}
}
