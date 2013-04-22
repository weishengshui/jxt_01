package com.chinarewards.client;

import static org.junit.Assert.assertTrue;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.chinarewards.metro.models.request.MemberPasswordModifyReq;
import com.chinarewards.metro.models.response.MemberPasswordModifyRes;

public class MemberPasswordModifyThreadTests extends Thread {

	// private ClientService clientService = new ClientService(
	// "http://192.168.4.235:8080/metro/ws");
	private ClientService clientService = new ClientService(
			"http://192.168.4.91:7070/metro/ws");
	public static int count;
	private Integer memberId;
	private String oldPassword;
	private String newPassword;

	private MemberPasswordModifyThreadTests(Integer memberId,
			String oldPassword, String newPassword) {
		this.memberId = memberId;
		this.oldPassword = oldPassword;
		this.newPassword = newPassword;
	}

	public void run() {

		try {
			MemberPasswordModifyReq req = new MemberPasswordModifyReq();// 模拟修改会员密码的请求
			req.setId(this.memberId);// 会员ID
			req.setOldPassword(this.oldPassword);// 旧密码
			req.setNewPassword(this.newPassword);// 新密码
			MemberPasswordModifyRes res = clientService
					.modifyMemberPassword(req);

			// System.out.println("修改状态（1 成功 2 失败）： " + res.getUpdateStatus());
			// System.out.println("修改状态描述： " + res.getUpdateDesc());
			assertTrue(new Integer(1).equals(res.getUpdateStatus()));
			count++;
			System.out.println("count ====>" + count);
		} catch (Exception e) {
		}
	}

	public static void main(String[] args) {

		s1();
//		s2();
	}

	public static void s1() {
		ExecutorService pool = Executors.newFixedThreadPool(200);
		
		for (int i = 0; i < 200; i++) {
			// 将线程放入池中进行执行
			MemberPasswordModifyThreadTests t = new MemberPasswordModifyThreadTests(
					8175 + i, "123456", "654321");
			if (!pool.isShutdown()) {
				pool.execute(t);
			}
			// System.out.println("add member====>"+(i+1));
		}
		// 关闭线程池
		pool.shutdown();
	}

	public static void s2() {
		ExecutorService pool = Executors.newFixedThreadPool(200);
		for (int i = 0; i < 200; i++) {
			// 将线程放入池中进行执行
			MemberPasswordModifyThreadTests t = new MemberPasswordModifyThreadTests(
					8175 + i, "654321", "123456");
			if (!pool.isShutdown()) {
				pool.execute(t);
			}
			// System.out.println("add member====>"+(i+1));
		}
		// 关闭线程池
		pool.shutdown();
	}

}
