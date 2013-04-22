package com.chinarewards.client;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.junit.Test;

import com.chinarewards.client.exception.InvalidSignException;
import com.chinarewards.metro.models.merchandise.Catalog;
import com.chinarewards.metro.models.merchandise.Category;
import com.chinarewards.metro.models.merchandise.CommodityVo;
import com.chinarewards.metro.models.merchandise.Merchandise;
import com.chinarewards.metro.models.merchandise.MerchandiseFile;
import com.chinarewards.metro.models.request.MemberModifyReq;
import com.chinarewards.metro.models.request.MemberPasswordModifyReq;
import com.chinarewards.metro.models.request.SavingAccountConsumptionReq;
import com.chinarewards.metro.models.response.MemberModifyRes;
import com.chinarewards.metro.models.response.MemberPasswordModifyRes;
import com.chinarewards.metro.models.response.SavingAccountConsumptionRes;
import static org.junit.Assert.*;

public class TestClientService2 {

	private ClientService clientService = new ClientService(
			"http://localhost:8080/metro/ws");

	// 测试获取商品列表接口
	@Test
	public void testGetMerchandises() throws InvalidSignException {

		// 获取第1页的商品列表，每页500个商品
		Integer page = 1;
		Integer pageSize = new Integer(1);// 每页的大小

		// 调用后台函数，获取商品列表
		List<Merchandise> merchandises = clientService.getMerchandises(page,
				pageSize);

		System.out.println("返回商品总数:" + merchandises.size());

		System.out.println("========= 返回商品明细  ========");
		for (Merchandise m : merchandises) {
			System.out.println("----------------------------------------");
			System.out.println("商品名称: " + m.getName() + " 商品ID:"
					+ m.getCommodityId() + " 运费:" + m.getFreight() + " 品牌:"
					+ m.getBrand().getName() + "  品牌id:" + m.getBrand().getId()
					+ " 正常售卖价格：" + m.getPrice() + " 正常售卖优惠价格："
					+ m.getPreferentialPrice() + " 积分价格：" + m.getPointPrice()
					+ " 积分优惠价格：" + m.getPointPreferentialPrice() + " 售卖形式："
					+ m.getSellWay());
			List<Catalog> catalogs = m.getCatalogs();
			if (null != catalogs && catalogs.size() > 0) {
				for (Catalog c : catalogs) {
					Category cate = c.getCategory();
					String str = "是否上架：" + c.isOnsale() + " 上下架时间："
							+ c.getOnsaleTime() + " 所属类别ID：" + cate.getId()
							+ " 所属类别名称：" + cate.getName();
					while (null != cate.getParent()) {
						cate = cate.getParent();
						str += " \t\t 父类别ID: " + cate.getId() + "   父类别Name: "
								+ cate.getName();
					}
					System.out.println(str);
				}
			}
			List<MerchandiseFile> pics = m.getPics();
			if (null != pics && pics.size() > 0) {
				for (MerchandiseFile pic : pics) {
					System.out.println(" 图片url:" + pic.getUrl());
				}
			}
		}
	}

	/**
	 * 测试 储值卡消费接口
	 * 
	 * @throws InvalidSignException
	 */
	@Test
	public void testSavingAccountConsumption() throws InvalidSignException {
		// case 1: 测试订单id
		testGetMerchandises_OrderId();
		// case 2: 测试订单来源格式
		testGetMerchandises_OrderSource();
		// case 3: 测试门店
		testGetMerchandises_Shop();
		// case 4: 测试商品id
		testGetMerchandises_MerchandiseId();
		// case 5: 测试商品名称
		testGetMerchandises_MerchandiseName();
		// case 6: 测试订单中扣除的金额数量
		testGetMerchandises_point();

		// case 7: 测试会员ID
		testGetMerchandises_memberId();

		// case 8: 测试订单描述
		testGetMerchandises_orderDescription();

	}

	/**
	 * 测试 修改会员基本信息接口
	 * 
	 * @throws InvalidSignException
	 */
	@Test
	public void testModifyMember() throws InvalidSignException {
		MemberModifyReq req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("13189755317");// 激活手机号
		req.setPhone("13189755315");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		MemberModifyRes res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());
	}

	// 会员资料修改 测试手机号格式
	@Test
	public void testModifyMember_phone() throws InvalidSignException {

		System.out.println("\n\n---------------- 手机号为空null ----------------");
		MemberModifyReq req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("13189755317");// 激活手机号
		req.setPhone(null);// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		MemberModifyRes res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out.println("\n\n---------------- 手机号为空\"\" ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("13189755317");// 激活手机号
		req.setPhone("");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 手机号为空长度 < 11 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("13189755317");// 激活手机号
		req.setPhone("131");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 手机号为空长度 > 11 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("13189755317");// 激活手机号
		req.setPhone("131897553101");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 手机号为空长度 == 11(格式不正确，纯数字) ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("13189755317");// 激活手机号
		req.setPhone("11189755310");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 手机号为空长度 == 11(格式不正确，任意字符) ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("13189755317");// 激活手机号
		req.setPhone("搜索@#￥%……&*（");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 手机号为空长度 == 11(正确的手机号) ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("13189755317");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());
	}

	// 会员资料修改 测试激活手机号格式(只有在修改会员状态为激活时才校验激活手机号)
	@Test
	public void testModifyMember_alivePhone() throws InvalidSignException {

		System.out
				.println("\n\n---------------- 未激活，激活手机号为空null（不校验） ----------------");
		MemberModifyReq req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber(null);// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(2); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		MemberModifyRes res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 未激活，激活手机号为空\"\"（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(2); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 未激活，激活手机号长度 < 11（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("131");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(2); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 未激活，激活手机号长度 > 11（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("131897553101");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(2); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 未激活，激活手机号长度 == 11(无效号码，11位纯数字)（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("11189755310");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(2); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 未激活，激活手机号长度 == 11(无效号码，任意特殊字符)（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("！@#￥%……&*（）");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(2); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 未激活，激活手机号长度 == 11(正确的手机号)（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("13189755310");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(2); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已注销，激活手机号为空null（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber(null);// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(3); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已注销，激活手机号为空\"\"（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(3); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已注销，激活手机号长度 < 11（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("131");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(3); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已注销，激活手机号长度 > 11（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("131897553101");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(3); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已注销，激活手机号长度 == 11(无效号码，11位纯数字)（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("11189755310");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(3); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已注销，激活手机号长度 == 11(无效号码，任意特殊字符)（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("！@#￥%……&*（）");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(3); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已注销，激活手机号长度 == 11(正确的手机号)（不校验） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("13189755310");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(3); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已激活，激活手机号为空null ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber(null);// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已激活，激活手机号为空\"\" ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已激活，激活手机号长度 < 11 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("131");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已激活，激活手机号长度 > 11 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("131897553101");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已激活，激活手机号长度 == 11(无效号码，11位纯数字) ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("11189755310");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已激活，激活手机号长度 == 11(无效号码，任意特殊字符) ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("！@#￥%……&*（）");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已激活，激活手机号长度 == 11(正确的手机号) ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(72);// 会员ID
		req.setAlivePhoneNumber("13189755310");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 未激活，修改激活手机号无效 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(82);// 会员ID
		req.setAlivePhoneNumber("13189755310");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(2); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已注销，修改激活手机号无效 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(83);// 会员ID
		req.setAlivePhoneNumber("13189755310");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(3); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

	}

	// 会员资料修改 激活手机号业务检查
	@Test
	public void testModifyMember_alivePhone2() throws InvalidSignException {

		System.out
				.println("\n\n---------------- 未激活，修改激活手机号无效 ----------------");
		MemberModifyReq req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(82);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(2); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		MemberModifyRes res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已注销，修改激活手机号无效 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(83);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(3); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 未激活改成已激活，修改激活手机号 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(93);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("14189755310");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 已激活改成已激活，修改激活手机号 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(94);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("15189755310");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());
	}

	// 会员资料修改 测试会员ID
	@Test
	public void testModifyMember_memberId() throws InvalidSignException {

		System.out.println("\n\n---------------- 会员ID为空null ----------------");
		MemberModifyReq req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(null);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(2); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		MemberModifyRes res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out.println("\n\n---------------- 会员ID为空不存在 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(-1);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(3); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

	}

	// 测试会员资料修改接口的签名
	@Test
	public void testModifyMember_checkStr() throws InvalidSignException {

		System.out.println("\n\n---------------- 会员ID为空null ----------------");
		MemberModifyReq req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(65);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("13189755310");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		MemberModifyRes res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());
		System.out.println("checkStr： " + res.getCheckStr());

	}

	// 会员资料修改 测试邮箱
	@Test
	public void testModifyMember_mail() throws InvalidSignException {

		System.out
				.println("\n\n---------------- 邮箱为空null（不修改） ----------------");
		MemberModifyReq req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(92);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("13189755210");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail(null);// 邮箱
		MemberModifyRes res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out.println("\n\n---------------- 邮箱为\"\"（修改） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(91);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("13189766210");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 邮箱为657620636@qq.com（正确邮箱，修改） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(90);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("15876767676");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 邮箱为657620636@m（非邮箱） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(90);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("15876767676");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 邮箱为65762063612345@qq.com（过长的邮箱，超过20位） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(90);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("15876767676");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("65762063612345@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out
				.println("\n\n---------------- 邮箱为6576206361234@qq.com（邮箱长度 == 20） ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(90);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("15876767676");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("6576206361234@qq.com");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

	}

	// 会员资料修改 会员状态修改
	@Test
	public void testModifyMember_memberStatus() throws InvalidSignException {

		// 将89改成未激活
		// 将88改成未激活
		// 将87的状态改成已激活
		System.out.println("\n\n---------------- 未激活改成激活 ----------------");
		MemberModifyReq req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(89);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("15865478968");// 手机号
		req.setMemberStatus(1); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail(null);// 邮箱
		MemberModifyRes res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out.println("\n\n---------------- 未激活改成已注销 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(88);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("15847896325");// 手机号
		req.setMemberStatus(3); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out.println("\n\n---------------- 已激活改成未激活 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(89);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("15865478968");// 手机号
		req.setMemberStatus(2); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

		System.out.println("\n\n---------------- 已激活改成已注销 ----------------");
		req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(87);// 会员ID
		req.setAlivePhoneNumber("13189755311");// 激活手机号
		req.setPhone("13547852695");// 手机号
		req.setMemberStatus(3); // 会员状态。1 已激活 2 未激活 3注销
		req.setMail("");// 邮箱
		res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());

	}

	/**
	 * 测试 修改会员密码信息接口
	 * 
	 * @throws InvalidSignException
	 */
	@Test
	public void testModifyMemberPassword() throws InvalidSignException {
		System.out.println("\n\n---------------- 旧密码为null ----------------");
		MemberPasswordModifyReq req = new MemberPasswordModifyReq();// 模拟修改会员密码的请求
		req.setId(85);// 会员ID
		req.setOldPassword(null);// 旧密码
		req.setNewPassword("admin");// 新密码
		MemberPasswordModifyRes res = clientService.modifyMemberPassword(req);
		System.out.println("修改状态（1 成功 2 失败）： " + res.getUpdateStatus());
		System.out.println("修改状态描述： " + res.getUpdateDesc());

		System.out.println("\n\n---------------- 旧密码为\"\" ----------------");
		req = new MemberPasswordModifyReq();// 模拟修改会员密码的请求
		req.setId(85);// 会员ID
		req.setOldPassword("");// 旧密码
		req.setNewPassword("admin");// 新密码
		res = clientService.modifyMemberPassword(req);
		System.out.println("修改状态（1 成功 2 失败）： " + res.getUpdateStatus());
		System.out.println("修改状态描述： " + res.getUpdateDesc());

		System.out.println("\n\n---------------- 新密码为null ----------------");
		req = new MemberPasswordModifyReq();// 模拟修改会员密码的请求
		req.setId(85);// 会员ID
		req.setOldPassword("admin");// 旧密码
		req.setNewPassword(null);// 新密码
		res = clientService.modifyMemberPassword(req);
		System.out.println("修改状态（1 成功 2 失败）： " + res.getUpdateStatus());
		System.out.println("修改状态描述： " + res.getUpdateDesc());

		System.out.println("\n\n---------------- 新密码为\"\" ----------------");
		req = new MemberPasswordModifyReq();// 模拟修改会员密码的请求
		req.setId(85);// 会员ID
		req.setOldPassword("admin");// 旧密码
		req.setNewPassword("");// 新密码
		res = clientService.modifyMemberPassword(req);
		System.out.println("修改状态（1 成功 2 失败）： " + res.getUpdateStatus());
		System.out.println("修改状态描述： " + res.getUpdateDesc());

		System.out.println("\n\n---------------- 会员ID为null ----------------");
		req = new MemberPasswordModifyReq();// 模拟修改会员密码的请求
		req.setId(null);// 会员ID
		req.setOldPassword("admin");// 旧密码
		req.setNewPassword("admin");// 新密码
		res = clientService.modifyMemberPassword(req);
		System.out.println("修改状态（1 成功 2 失败）： " + res.getUpdateStatus());
		System.out.println("修改状态描述： " + res.getUpdateDesc());

		System.out.println("\n\n---------------- 会员ID不存在 ----------------");
		req = new MemberPasswordModifyReq();// 模拟修改会员密码的请求
		req.setId(-1);// 会员ID
		req.setOldPassword("admin");// 旧密码
		req.setNewPassword("admin");// 新密码
		res = clientService.modifyMemberPassword(req);
		System.out.println("修改状态（1 成功 2 失败）： " + res.getUpdateStatus());
		System.out.println("修改状态描述： " + res.getUpdateDesc());

		System.out
				.println("\n\n---------------- 未激活的会员（不可修改） ----------------");
		req = new MemberPasswordModifyReq();// 模拟修改会员密码的请求
		req.setId(86);// 会员ID
		req.setOldPassword("admin");// 旧密码
		req.setNewPassword("admin");// 新密码
		res = clientService.modifyMemberPassword(req);
		System.out.println("修改状态（1 成功 2 失败）： " + res.getUpdateStatus());
		System.out.println("修改状态描述： " + res.getUpdateDesc());

		System.out
				.println("\n\n---------------- 已注销的会员（不可修改） ----------------");
		req = new MemberPasswordModifyReq();// 模拟修改会员密码的请求
		req.setId(84);// 会员ID
		req.setOldPassword("admin");// 旧密码
		req.setNewPassword("admin");// 新密码
		res = clientService.modifyMemberPassword(req);
		System.out.println("修改状态（1 成功 2 失败）： " + res.getUpdateStatus());
		System.out.println("修改状态描述： " + res.getUpdateDesc());

		System.out
				.println("\n\n---------------- 已激活的会员（老密码不正确，修改失败） ----------------");
		req = new MemberPasswordModifyReq();// 模拟修改会员密码的请求
		req.setId(85);// 会员ID
		req.setOldPassword("434343");// 旧密码
		req.setNewPassword("admin");// 新密码
		res = clientService.modifyMemberPassword(req);
		System.out.println("修改状态（1 成功 2 失败）： " + res.getUpdateStatus());
		System.out.println("修改状态描述： " + res.getUpdateDesc());

		System.out
				.println("\n\n---------------- 已激活的会员（修改成功） ----------------");
		req = new MemberPasswordModifyReq();// 模拟修改会员密码的请求
		req.setId(85);// 会员ID
		req.setOldPassword("admin");// 旧密码
		req.setNewPassword("123456");// 新密码
		res = clientService.modifyMemberPassword(req);
		System.out.println("修改状态（1 成功 2 失败）： " + res.getUpdateStatus());
		System.out.println("修改状态描述： " + res.getUpdateDesc());

		System.out
				.println("\n\n---------------- 已激活的会员（修改成功） ----------------");
		req = new MemberPasswordModifyReq();// 模拟修改会员密码的请求
		req.setId(85);// 会员ID
		req.setOldPassword("123456");// 旧密码
		req.setNewPassword("admin");// 新密码
		res = clientService.modifyMemberPassword(req);
		System.out.println("修改状态（1 成功 2 失败）： " + res.getUpdateStatus());
		System.out.println("修改状态描述： " + res.getUpdateDesc());
	}

	@Test
	public void testGetMerchandises_MerchandiseName()
			throws InvalidSignException {
		System.out.println("\n\n---------------- 商品名称不正确----------------");
		List<CommodityVo> commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		CommodityVo commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试1");
		commodity.setCount(3);
		commodities.add(commodity);

		SavingAccountConsumptionReq req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(119);
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		SavingAccountConsumptionRes res = clientService
				.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n\n---------------- 商品名称为空----------------");
		commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("");
		commodity.setCount(3);
		commodities.add(commodity);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(119);
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n\n---------------- 商品名称为空----------------");
		commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName(null);
		commodity.setCount(3);
		commodities.add(commodity);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(119);
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n\n---------------- 商品名称正确----------------");
		commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(119);
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n\n---------------- 商品名称过长（大于20）----------------");
		commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("123456789012345678901");
		commodity.setCount(3);
		commodities.add(commodity);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(119);
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());
	}

	@Test
	public void testGetMerchandises_orderDescription()
			throws InvalidSignException {
		System.out.println("\n\n---------------- 订单描述长度大于200 ----------------");
		List<CommodityVo> commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		CommodityVo commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		SavingAccountConsumptionReq req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(119);
		req.setUserId(70);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品
		req.setDescription("ssa撒撒打法速度撒撒撒撒撒1234567890-=]wedrfghjkl./3ertyuiop;sdfvbnm,.23er4tyuiop;234567890-=sdfghjk,l.wsdfghnjm,.wedrfghjklwsdfghjmk,wsdfghjklwsdfgh2134567@#$%^&*()_@#$%^&*()@#$%^&*()_ssa撒撒打法速度撒撒撒撒撒12345678902212134567i");

		SavingAccountConsumptionRes res = clientService
				.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());
	}

	@Test
	public void testGetMerchandises_memberId() throws InvalidSignException {
		System.out.println("\n\n---------------- 会员ID不存在 ----------------");
		List<CommodityVo> commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		CommodityVo commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		SavingAccountConsumptionReq req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(119);
		req.setUserId(-1);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		SavingAccountConsumptionRes res = clientService
				.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n\n---------------- 会员ID为空 ----------------");
		commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(119);
		req.setUserId(null);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n\n---------------- 会员ID存在，余额不足 ----------------");
		commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(119);
		req.setUserId(70);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());
	}

	@Test
	public void testGetMerchandises_point() throws InvalidSignException {
		System.out
				.println("\n\n---------------- 会员ID不存在11111111 ----------------");
		List<CommodityVo> commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		CommodityVo commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		SavingAccountConsumptionReq req = new SavingAccountConsumptionReq();

		req.setOrderId("1234554545");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.0); // 扣除金额
		req.setShopId(119);
		req.setUserId(-1);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		SavingAccountConsumptionRes res = clientService
				.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n\n---------------- 会员ID为空 ----------------");
		commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(119);
		req.setUserId(null);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n\n---------------- 会员ID存在，余额不足 ----------------");
		commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(119);
		req.setUserId(70);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());
	}

	@Test
	public void testSavingAccountConsumption_point()
			throws InvalidSignException {
		System.out.println("\n\n---------------- 扣除金额为空----------------");
		List<CommodityVo> commodities = new ArrayList<CommodityVo>();
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		CommodityVo commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		SavingAccountConsumptionReq req = new SavingAccountConsumptionReq();

		req.setOrderId("3232fsdfsfssddsdf");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(0.020); // 扣除金额
		req.setShopId(119);
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		SavingAccountConsumptionRes res = clientService
				.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

	}

	@Test
	public void testGetMerchandises_Shop() throws InvalidSignException {
		System.out.println("\n\n---------------- 门店不存在 ----------------");
		List<CommodityVo> commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		CommodityVo commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		SavingAccountConsumptionReq req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(-1);
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		SavingAccountConsumptionRes res = clientService
				.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n\n---------------- 门店存在 ----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(109);
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

	}

	@Test
	public void testGetMerchandises_OrderSource() throws InvalidSignException {
		System.out.println("\n\n---------------- 订单来源为空 ----------------");
		List<CommodityVo> commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		CommodityVo commodity = new CommodityVo();
		commodity.setId("12345678901234567890123456789011");
		commodity.setName("12");
		commodity.setCount(3);
		CommodityVo commodity2 = new CommodityVo();
		commodity2.setId("12345678901234567890123456789012");
		commodity2.setName("222");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		SavingAccountConsumptionReq req = new SavingAccountConsumptionReq();

		req.setOrderId("11111");// 订单ID
		req.setOrderSource("");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		SavingAccountConsumptionRes res = clientService
				.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n---------------- 订单来源为空 ----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("12345678901234567890123456789011");
		commodity.setName("12");
		commodity.setCount(3);
		commodity2 = new CommodityVo();
		commodity2.setId("12345678901234567890123456789012");
		commodity2.setName("222");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("11111");// 订单ID
		req.setOrderSource(null);// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n---------------- 订单来源长度小于4 ----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("12345678901234567890123456789011");
		commodity.setName("12");
		commodity.setCount(3);
		commodity2 = new CommodityVo();
		commodity2.setId("12345678901234567890123456789012");
		commodity2.setName("222");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("11111");// 订单ID
		req.setOrderSource("12");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n---------------- 订单来源长度==4 ----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("12345678901234567890123456789011");
		commodity.setName("12");
		commodity.setCount(3);
		commodity2 = new CommodityVo();
		commodity2.setId("12345678901234567890123456789012");
		commodity2.setName("222");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("11111");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n---------------- 订单来源长度>4 ----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("12345678901234567890123456789011");
		commodity.setName("12");
		commodity.setCount(3);
		commodity2 = new CommodityVo();
		commodity2.setId("12345678901234567890123456789012");
		commodity2.setName("222");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("11111");// 订单ID
		req.setOrderSource("12345");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

	}

	@Test
	public void testGetMerchandises_OrderId() throws InvalidSignException {
		// case 2: 测试订单ID格式
		System.out.println("\n\n---------------- 订单ID为空 ----------------");
		List<CommodityVo> commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		CommodityVo commodity = new CommodityVo();
		commodity.setId("12345678901234567890123456789011");
		commodity.setName("12");
		commodity.setCount(3);
		CommodityVo commodity2 = new CommodityVo();
		commodity2.setId("12345678901234567890123456789012");
		commodity2.setName("222");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		SavingAccountConsumptionReq req = new SavingAccountConsumptionReq();

		req.setOrderId("");// 订单ID
		req.setOrderSource("123");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		SavingAccountConsumptionRes res = clientService
				.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n---------------- 订单ID为空 ----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("12345678901234567890123456789011");
		commodity.setName("12");
		commodity.setCount(3);
		commodity2 = new CommodityVo();
		commodity2.setId("12345678901234567890123456789012");
		commodity2.setName("222");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		req = new SavingAccountConsumptionReq();

		req.setOrderId(null);// 订单ID
		req.setOrderSource("123");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n---------------- 订单ID长度>20 ----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("12345678901234567890123456789011");
		commodity.setName("12");
		commodity.setCount(3);
		commodity2 = new CommodityVo();
		commodity2.setId("12345678901234567890123456789012");
		commodity2.setName("222");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("123456789012345678901");// 订单ID
		req.setOrderSource("123");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n---------------- 订单ID长度==20 ----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("12345678901234567890123456789011");
		commodity.setName("12");
		commodity.setCount(3);
		commodity2 = new CommodityVo();
		commodity2.setId("12345678901234567890123456789012");
		commodity2.setName("222");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("12345678901234567890");// 订单ID
		req.setOrderSource("123");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

	}

	@Test
	public void test_() throws InvalidSignException {
		for (int i = 0; i < 200; i++) {
			testSavingAccountConsumption_concurrent();
		}
	}

	@Test
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
		req.setUserId(7974);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		SavingAccountConsumptionRes res = clientService
				.savingAccountConsumption(req);
		assertTrue(new Integer(1).equals(res.getOperateStatus()));
		// System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		// System.out.println("操作状态描述：" + res.getStatusDescription());

	}

	@Test
	public void testGetMerchandises_MerchandiseId() throws InvalidSignException {
		System.out.println("\n---------------- 商品id为空 ----------------");
		List<CommodityVo> commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		CommodityVo commodity = new CommodityVo();
		commodity.setId(null);
		commodity.setName("");
		commodity.setCount(3);
		CommodityVo commodity2 = new CommodityVo();
		commodity2.setId("");
		commodity2.setName("");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		SavingAccountConsumptionReq req = new SavingAccountConsumptionReq();

		req.setOrderId("123");// 订单ID
		req.setOrderSource("123");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		SavingAccountConsumptionRes res = clientService
				.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		// case 1.2: 商品ID长度小于32
		System.out.println("\n---------------- 商品ID长度小于32 ----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("1");
		commodity.setName("");
		commodity.setCount(3);
		commodity2 = new CommodityVo();
		commodity2.setId("2");
		commodity2.setName("");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("123");// 订单ID
		req.setOrderSource("123");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		// case 1.3: 商品ID长度大于32
		System.out.println("\n---------------- 商品ID长度大于32 ----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("123456789012345678901234567890123");
		commodity.setName("12");
		commodity.setCount(3);
		commodity2 = new CommodityVo();
		commodity2.setId("123456789012345678901234567890124");
		commodity2.setName("2223");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("123");// 订单ID
		req.setOrderSource("123");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		// case 1.4: 商品ID长度等于32
		System.out.println("\n---------------- 商品ID长度等于32 ----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("12345678901234567890123456789012");
		commodity.setName("12");
		commodity.setCount(3);
		commodity2 = new CommodityVo();
		commodity2.setId("12345678901234567890123456789012");
		commodity2.setName("2223");
		commodity2.setCount(3);
		commodities.add(commodity);
		commodities.add(commodity2);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("123");// 订单ID
		req.setOrderSource("123");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out
				.println("\n\n---------------- 门店存在,商品不属于门市 ----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(109);
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）：" + res.getOperateStatus());
		System.out.println("操作状态描述：" + res.getStatusDescription());

		System.out.println("\n\n----------------门店存在,商品属于门市----------------");
		commodities = new ArrayList<CommodityVo>();// 准备订单中的商品数据
		commodity = new CommodityVo();
		commodity.setId("ff8081813d1e5c86013d1ee5e14f0002");
		commodity.setName("用于接口测试");
		commodity.setCount(3);
		commodities.add(commodity);

		req = new SavingAccountConsumptionReq();

		req.setOrderId("1234");// 订单ID
		req.setOrderSource("1234");// 订单来源
		req.setPoint(1.1); // 扣除金额
		req.setShopId(119);
		req.setUserId(7);// 会员ID
		req.setCommodities(commodities);// 设置订单中的商品

		res = clientService.savingAccountConsumption(req);
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
