package com.chinarewards.client;

import static org.junit.Assert.assertTrue;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.chinarewards.metro.models.request.MemberModifyReq;
import com.chinarewards.metro.models.response.MemberModifyRes;

public class MemberBaseModifyThreadTests extends Thread {

	 private ClientService clientService = new ClientService(
	 "http://192.168.4.235:8080/metro/ws");
//	private ClientService clientService = new ClientService(
//			"http://192.168.4.91:7070/metro/ws");
	private static int count = 0;

	private int memberId;

	private String phone; // 手机。

	private String mail; // 邮箱。

	private String alivePhoneNumber; // 激活手机号

	private Date birthday; // 会员生日。

	private Integer memberStatus; // 会员状态。1 已激活 2 未激活 3注销

	private MemberBaseModifyThreadTests() {
	}

	private MemberBaseModifyThreadTests(int memberId, String phone,
			String mail, String alivePhoneNumber, Date birthday,
			Integer memberStatus) {
		this.memberId = memberId;
		this.phone = phone;
		this.mail = mail;
		this.alivePhoneNumber = alivePhoneNumber;
		this.birthday = birthday;
		this.memberStatus = memberStatus;
	}

	public void run() {
		try {
			MemberModifyReq req = new MemberModifyReq();// 模拟修改会员基本信息的请求
			req.setId(this.memberId);// 会员ID
			req.setPhone(this.phone);
			req.setMail(this.mail);
			req.setAlivePhoneNumber(this.alivePhoneNumber);
			req.setBirthday(this.birthday);
			req.setMemberStatus(this.memberStatus);
			MemberModifyRes res = clientService.modifyMember(req);
//			System.out.println(res.getFailureReasons());
			assertTrue(new Integer(1).equals(res.getUpdateStatus()));
			count++;
			System.out.println("count ====>" + count);
		} catch (Exception e) {
		}
	}

	public String generate() {

		UUID uuid = UUID.randomUUID();
		String s = uuid.toString();
		// strip off hyphens
		s = s.replaceAll("-", "");
		return s;
	}

	public static void main(String[] args) throws ParseException {
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		ExecutorService pool = Executors.newFixedThreadPool(200);
		//4.235
		/*for (int i = 0; i < 200; i++) {
			// 将线程放入池中进行执行
			MemberBaseModifyThreadTests t = new MemberBaseModifyThreadTests(
					1001 + i, 13485632021l + i + "", "657620636@qq.com",
					13495632021l + i + "", dateFormat.parse("2012-12-12 12:15:13"), 1);
			if (!pool.isShutdown()) {
				pool.execute(t);
			}
			 System.out.println("add member====>"+(i+1));
		}*/
		
		for (int i = 200; i < 400; i++) {
			// 将线程放入池中进行执行
			MemberBaseModifyThreadTests t = new MemberBaseModifyThreadTests(
					3001 + i, 13515632021l + i + "", "657620636@qq.com",
					13525632021l + i + "", dateFormat.parse("2012-12-12 12:15:13"), 1);
			if (!pool.isShutdown()) {
				pool.execute(t);
			}
			 System.out.println("add member====>"+(i+1));
		}
		
		for (int i = 400; i < 600; i++) {
			// 将线程放入池中进行执行
			MemberBaseModifyThreadTests t = new MemberBaseModifyThreadTests(
					3001 + i, 13535632021l + i + "", "657620636@qq.com",
					13545632021l + i + "", dateFormat.parse("2012-12-12 12:15:13"), 1);
			if (!pool.isShutdown()) {
				pool.execute(t);
			}
			 System.out.println("add member====>"+(i+1));
		}
		
		/*for (int i = 600; i < 800; i++) {
			// 将线程放入池中进行执行
			MemberBaseModifyThreadTests t = new MemberBaseModifyThreadTests(
					3001 + i, 13555632021l + i + "", "657620636@qq.com",
					13565632021l + i + "", dateFormat.parse("2012-12-12 12:15:13"), 3);
			if (!pool.isShutdown()) {
				pool.execute(t);
			}
			 System.out.println("add member====>"+(i+1));
		}
		
		for (int i = 800; i < 1000; i++) {
			// 将线程放入池中进行执行
			MemberBaseModifyThreadTests t = new MemberBaseModifyThreadTests(
					3001 + i, 13575632021l + i + "", "657620636@qq.com",
					13585632021l + i + "", dateFormat.parse("2012-12-12 12:15:13"), 3);
			if (!pool.isShutdown()) {
				pool.execute(t);
			}
			 System.out.println("add member====>"+(i+1));
		}*/
		
		// 4.91
		/*for (int i = 0; i < 200; i++) {
			// 将线程放入池中进行执行
			MemberBaseModifyThreadTests t = new MemberBaseModifyThreadTests(
					8575 + i, 13485632021l + i + "", "657620636@qq.com",
					13485632021l + i + "", dateFormat.parse("2012-12-12 12:15:13"), 2);
			if (!pool.isShutdown()) {
				pool.execute(t);
			}
			// System.out.println("add member====>"+(i+1));
		}*/
		// 关闭线程池
		pool.shutdown();
	}

}
