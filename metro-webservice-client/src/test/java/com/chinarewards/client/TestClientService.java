package com.chinarewards.client;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.xml.bind.JAXBException;

import junit.framework.Assert;

import org.junit.Test;

import com.chinarewards.client.exception.InvalidSignException;
import com.chinarewards.metro.models.CheckCodeResp;
import com.chinarewards.metro.models.DiscountUseCodeResp;
import com.chinarewards.metro.models.ExternalMember;
import com.chinarewards.metro.models.ExternalMemberActivate;
import com.chinarewards.metro.models.ExternalMemberList;
import com.chinarewards.metro.models.ExternalMemberLogin;
import com.chinarewards.metro.models.ExternalMemberReg;
import com.chinarewards.metro.models.IntegralAddResp;
import com.chinarewards.metro.models.IntegralConsumeResp;
import com.chinarewards.metro.models.common.DES3;
import com.chinarewards.metro.models.line.LineModel;
import com.chinarewards.metro.models.line.MetroLine;
import com.chinarewards.metro.models.line.ShopModel;
import com.chinarewards.metro.models.line.SiteModel;
import com.chinarewards.metro.models.merchandise.Catalog;
import com.chinarewards.metro.models.merchandise.Category;
import com.chinarewards.metro.models.merchandise.CommodityVo;
import com.chinarewards.metro.models.merchandise.Merchandise;
import com.chinarewards.metro.models.merchandise.MerchandiseFile;
import com.chinarewards.metro.models.order.ExtOrderInfo;
import com.chinarewards.metro.models.order.OrderResp;
import com.chinarewards.metro.models.order.OrderRespArray;
import com.chinarewards.metro.models.request.MemberModifyReq;
import com.chinarewards.metro.models.request.MemberPasswordModifyReq;
import com.chinarewards.metro.models.request.MerchandiseInfo;
import com.chinarewards.metro.models.request.SavingAccountConsumptionReq;
import com.chinarewards.metro.models.response.DiscountResp;
import com.chinarewards.metro.models.response.MemberModifyRes;
import com.chinarewards.metro.models.response.MemberPasswordModifyRes;
import com.chinarewards.metro.models.response.SavingAccountConsumptionRes;
import com.chinarewards.metro.models.response.ShopModelRes;
import com.chinarewards.metro.models.response.SiteModelRes;

public class TestClientService {

	@Test
	public void testEnv() {

		Assert.fail("run !!!");
	}

	@Test
	public void testEnv2() {

		Assert.fail("run2 !!!");
	}
	//http://localhost:8080/metro/ws    http://192.168.4.97:8080/metro/ws
	private ClientService clientService = new ClientService(
			//"http://192.168.4.18:7070/metro/ws");
	"http://localhost:8081/metro/ws");

	// 测试获取商品列表接口
		@Test
		public void testGetMerchandises() throws InvalidSignException {


			// 获取第1页的商品列表，每页500个商品
			Integer page = new Integer(1);
			Integer pageSize = new Integer(3);//每页的大小

			// 调用后台函数，获取商品列表
			List<Merchandise> merchandises = clientService.getMerchandises(page, pageSize);

			System.out.println("返回商品总数:" + merchandises.size());

			System.out.println("========= 返回商品明细  ========");
			for (Merchandise m : merchandises) {
				System.out.println("----------------------------------------");
				System.out.println("商品名称: " + m.getName() + " 商品ID:"
						+ m.getCommodityId() + " 运费:" + m.getFreight() + " 品牌:"
						+ m.getBrand().getName()+ "  品牌id:" + m.getBrand().getId()+ " 正常售卖价格："+m.getPrice()+
						" 正常售卖优惠价格："+m.getPreferentialPrice()+" 积分价格："+m.getPointPrice()+
						" 积分优惠价格："+m.getPointPreferentialPrice()+" 售卖形式："+m.getSellWay());
				List<Catalog> catalogs = m.getCatalogs();
				if(null != catalogs && catalogs.size() > 0){
					for(Catalog c : catalogs){
						Category cate = c.getCategory();
						String str = "是否上架："+c.isOnsale()+" 上下架时间："+c.getOnsaleTime()+" 所属类别ID："+cate.getId()+" 所属类别名称："+cate.getName();
						while( null != cate.getParent()){
							cate = cate.getParent();
							str += " \t\t 父类别ID: "+ cate.getId()+"   父类别Name: "+cate.getName();
						}
						System.out.println(str);	
					}
				}
				List<MerchandiseFile> pics = m.getPics();
				if(null != pics && pics.size() > 0){
					for(MerchandiseFile pic : pics){
						System.out.println(" 图片url:"+pic.getUrl());
					}
				}
			}
		}

		// 测试与POS进销存系统订单交互接口
		@Test
		public void testProcessExtOrder() {

			List<ExtOrderInfo> list = new ArrayList<ExtOrderInfo>();

			// 订单一
			{
			ExtOrderInfo order1 = new ExtOrderInfo();

			// 订单中银行支付的金额
			order1.setBankPay("0");

			// 订单中使用现金支付的金额
			order1.setCash("0");

			// 必选 营业员ID
			order1.setClerkId("001");

			// 可选 优惠码ID
			order1.setCouponCode("");

			// YYYYMMDDHHmmss 发送时间必选
			order1.setDeliverTime("20130307110432");

			// 必选 订单得到的积分
			order1.setIntegration("1");

			// 订单中使用积享通支付的金额
//			order1.setMemberCard("0");
			
			// 门店ID
			order1.setShopId("111");

			// 必选 订单ID
			order1.setOrderId("0002");

			// 订单数量
//			order1.setOrderNum("2");

			// 必选, 以分为单位569 即5.69￥
			order1.setOrderPrice("1");

			// 订单来源
			order1.setOrderSource("test_pos");

			// 订单状态 1 正常 2 退单 3 冻结 4 订单修改(仅会被客服修改)
			order1.setOrderState("1");

			// 20121016122542必选 订单产生时间
			order1.setOrderTime("20130307110432");

			// 终端POS id
			order1.setPosId("REWARDS-0002");

			// 会员Id
			order1.setUserId("50");

			// 可选 此订单使用的积分
//			order1.setUsingCode("0");
			
			//订单流水号
//			order1.setSerialId("123");	
			
			// 添加订单一到集合
			list.add(order1);
			}
			
			/*
			 //订单二
			{
			ExtOrderInfo order1 = new ExtOrderInfo();

			// 订单中银行支付的金额
			order1.setBankPay("0");

			// 订单中使用现金支付的金额
			order1.setCash("0");

			// 必选 营业员ID
			order1.setClerkId("001");

			// 可选 优惠码ID
			order1.setCouponCode("");

			// YYYYMMDDHHmmss 发送时间必选
			order1.setDeliverTime("20130307110340");

			// 必选 订单得到的积分
			order1.setIntegration("1");

			// 订单中使用积享通支付的金额
			order1.setMemberCard("0");
			
			// 门店ID
			order1.setShopId("111");

			// 必选 订单ID
			order1.setOrderId("0002");

			// 订单数量
			order1.setOrderNum("2");

			// 必选, 以分为单位569 即5.69￥
			order1.setOrderPrice("1");

			// 订单来源
			order1.setOrderSource("test_pos");

			// 订单状态 1 正常 2 退单 3 冻结 4 订单修改(仅会被客服修改)
			order1.setOrderState("1");

			// 20121016122542必选 订单产生时间
			order1.setOrderTime("20130307110432");

			// 终端POS id
			order1.setPosId("REWARDS-0002");

			// 会员Id
			order1.setUserId("50");

			// 可选 此订单使用的积分
			order1.setUsingCode("0");
			
			//订单流水号
			order1.setSerialId("123");	
			
			// 添加订单一到集合
			list.add(order1);
			}
			*/	

			try {
				// 调用后台函数
				OrderRespArray resp = clientService.processExtOrder(list);

//				System.out.println("==== 是否成功 "
//						+ (resp.getResult().equals("0") ? "成功"
//								: "失败 ====" + "错误码： " + resp.getResult()));

				System.out.println("=========== 各个订单处理明细 ============");
				for (OrderResp item : resp.getList()) {
					System.out.println("*** 订单ID: " + item.getOrdered() + " 响应码："
							+ item.getResponseCode() + " 响应描述: "
							+ item.getResponseText() + " 响应时间: "
							+ item.getResponseTime() + " ***");
				}
			} catch (InvalidSignException e) {
				System.out.println("=== 请求签名失败 ===");
			}catch (Exception e) {e.printStackTrace();
				System.out.println("=== 请求签名失败 ===");
			}
		}
	/**
	 * 优惠码查询确认接口
	 * @throws InvalidSignException 
	 */
	@Test
	public void  testCheckCode() throws InvalidSignException {
		// 优惠码
	String couponCode="1";
		// 优惠码类型
	Integer CouponId=1;//类型（ 0--活动；1--门店）
		// 必选 门店id或活动id
	String shopOrActivityId="236";
		
    CheckCodeResp resp= clientService.checkCode(couponCode,CouponId,shopOrActivityId);
      
    System.out.println("优惠码查询确认接口----couponCode:"+resp.getCouponCode()+"   优惠码对应详细说明:"+resp.getCouponInfo()+"   错误原因:"+resp.getErrorReason()+
    		   "   是否可用 必选  (0--不可用；1--可用):"+resp.getIsAvailable()+"   是否可复用（ （0--不可复用；1-可复用））:"+resp.getIsRepeat()+
    		   "  使用时间:"+resp.getUseTime());		
	}
	
	/**
	 * 优惠码使用接口
	 * @throws InvalidSignException 
	 */
	@Test
	public void testuseCode() throws InvalidSignException{
		String userId="7"  ;//会员id
		String couponCode="32"  ;//优惠码
		String shopOrActivityId= "110" ;//门店或活动id
		String orderId="111112"  ;//订单id
		String description=""  ;//使用描述
		
		Integer couponType= 1;//优惠码类型( 0--活动；1--门店）
		
		DiscountUseCodeResp resp= clientService.useCode(userId,couponCode,shopOrActivityId,orderId,description,couponType);
		System.out.println("优惠码使用接口-----  优惠码:"+resp.getCouponCode()+"   userId:"+resp.getUserId()+"  优惠码id:"+resp.getCouponId()+"  优惠码对应的优惠信息:"+
				resp.getCouponDescription()+
				"   优惠码使用状态:"+resp.getUsedState()+"   优惠码使用描述:"+resp.getUsedDescription());
		
	}
	/**
	 * 积分使用接口
	 * @throws InvalidSignException 
	 * @throws ParseException 
	 */
	@Test
	public void testuseIntegral() throws InvalidSignException, ParseException{
		String orderId="0072w5";//订单
		List<MerchandiseInfo> list=new ArrayList<MerchandiseInfo>();//商品list
		MerchandiseInfo merInfo=new MerchandiseInfo();
		merInfo.setCount(2);
		merInfo.setMerchandiseId("ff8081813c5c00b0013c5c09e5810001");
		list.add(merInfo);
		
		
		
		
		String orderSource="sss";//订单来源
		double point=30;//积分
		//Date operateTime=new Date();//操作日期
//		String format="yyyyMMddHHmmss";
//		SimpleDateFormat dateFormat = new SimpleDateFormat(format);
//		Date operateTime=dateFormat.parse("201303083923");
		
		
		String userId="110";//会员id
		String description="测试";//description
		
		IntegralConsumeResp resp = clientService.useIntegral(orderId,list,orderSource,point,new Date(),userId,description);
		System.out.println("积分使用接口---- orderId:"+resp.getOrderId()+"   orderSource:"+resp.getOrderSource()+"   Point:"+resp.getPoint()+"   operateTime:"+
				resp.getOperateTime()+
				"   userId:"+resp.getUserId()+"   Description:"+resp.getDescription()+"    ErrorInformation:"+resp.getErrorInformation()+"  操作状态:"+resp.getOperateStatus()+"   操作状态说明:"+resp.getStatusDescription());
	}
	

	
	/**
	 * 积分增加接口
	 * @throws InvalidSignException 
	 * @throws ParseException 
	 */
	@Test
	public void testaddIntegral() throws InvalidSignException, ParseException{
		String   requestRource= "ss"  ;//请求来源
		String   money= "5cHAHSsgVfw="  ;//交易金额   需要加密

		List<MerchandiseInfo> commodityIdList=new ArrayList<MerchandiseInfo>();//商品
		MerchandiseInfo merInfo=new MerchandiseInfo();
		merInfo.setCount(2);
		merInfo.setMerchandiseId("ff8081813ca9b3a1013ca9ce3a31000c");
		commodityIdList.add(merInfo);
		
		
		
		String   point= "5cHAHSsgVfw="  ;//积分    需要加密
	//	Date operateTime=new Date();//操作日期
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String  operateT = "2010-02-12 1:1:1";
		Date operateTime = sdf.parse( operateT); 
		System.out.println(operateTime);
		
		Integer   userId= 7  ;//会员id
		String  description = "s顶顶顶s"  ;//description
		
		IntegralAddResp resp = clientService.addIntegral(requestRource,money,commodityIdList,point,new Date(),userId,description);
		System.out.println("积分增加接口----   requestRource:"+resp.getRequestRource()+" Point:"+resp.getPoint()+" operateTime:"+resp.getOperateTime()+"   userId:"+
				resp.getUserId()+
				"  operateStatus:"+resp.getOperateStatus()+"   statusDescription:"+resp.getStatusDescription()+ "   ErrorInformation:"+resp.getErrorInformation()+"  操作状态:"+resp.getOperateStatus()+"   操作状态说明:"+resp.getStatusDescription());
	}
	
	//测试生成优惠码的接口
	@Test
	public void testGetDiscountCode() throws Exception {
		int mid = 7 ;  			//会员ID
		int couponId = 116;		//门店ID或活动ID
		int type = 0 ;			//0:门店ID ; 1:活动ID
		//输入你需要的参数值获取优惠码对象信息
//		for(int i=0;i<9;i++){
		DiscountResp discountResp = clientService.getCode(mid,couponId,type);
		System.out.println("discountcode is  "+discountResp.getCouponCode()+
				"   couponName is "+discountResp.getCouponName()+
				"   userId is "+discountResp.getUserId()+
				"   description is "+discountResp.getCouponDescription()+
				"   CouponId() is "+discountResp.getCouponId()+
				"	IsRepeat is"+discountResp.getIsRepeat()+
				"    errCode is : "+discountResp.getErrCode());
//		}
	}
	
	//测试获得地铁线路的接口
	@Test
	public void testGetLineDataList() {
		String table = "" ;				//操作类型
		String operateType = "" ;		//需要的表数据类型
		String description = "" ;		//描述
		Date operateTime = null ;		//操作时间
		//获得线路的所要信息       参数暂时没有用上
		MetroLine metroLine = clientService.getLineDataList(table, operateType, description, operateTime);
		List<LineModel> models = metroLine.getModels();
		System.out.println("获得线路的总数： "+models.size());
		for(LineModel m : models){
			System.out.println("线路ID:"+m.getLineId()+" 线路名称："+m.getLineName()+" 图片："+m.getPic()+" 站点小图："+m.getSmallPic()+" 排序号:"+m.getLineNum());
		}
	}

	
	/**
	 * 测试 与POS进销存系统会员交互
	 * @throws ParseException 
	 * @throws JAXBException 
	 */
	@Test
	public void testOffExternalMember() throws ParseException, JAXBException{
		String OperateType = "SYNC"; 					//操作类型  必选(QUERY | SYNC) 如果为QUERY,则返回PhoneNum所代表的用户的信息  如果为SYNC, 则传更新的用户的信息。即:更新时间大于 PreSyncTime
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String births = "20130301023636";
		//Date PreSyncTime = sdf.parse(births); 		//上次更新截止时间  OperateType 为SYNC 则必选
		String PhoneNum = "15220060657";				//手机号码 OperateType 为QUERY 则必选
		Integer curPage = 1 ;//  第一页
		ExternalMember e = clientService.offExternalMember(OperateType, births, PhoneNum,curPage);
		System.out.println("当前页:"+e.getCurPage());
		System.out.println("总页数:"+e.getTotalPage());
		if(e.getMemberList() != null){
			System.out.println("总记录:"+e.getMemberList().size());
			for(ExternalMemberList m : e.getMemberList()){
				System.out.print("  会员Name：" + m.getName());
				System.out.print("  会员ID：" + m.getMemberId());
				System.out.print("  邮箱：" + m.getEmail());
				System.out.print("  手机号码：" + m.getPhone());
				System.out.print("  注册日期：" + m.getRegisterDate());
				System.out.print("  是否激活：" + m.getIsActive());	//1:已激活   2:未激活
				System.out.print("  等级：" + m.getGrade());	//CRM没有没有等级
				System.out.print("  积分：" + m.getIntegral());
				System.out.print("  会员状态：" + m.getStatus()); //1:已激活  2：未激活  3注销/删除
//				System.out.print("  更新标记：" + m.getTarget()); //暂时得不到
				System.out.print("  更新时间：" + m.getUpdateTime()+"\n"); 
			}
		}
		
	}
	
	
	/**
	 * 测试 验证激活
	 * @throws JAXBException 
	 */
	@Test
	public void testOffExternalMemberActive() throws JAXBException{
		Integer memberId = 80;			//会员ID
		String phone = "15245487545";	//手机号
		String activeCode = "54545";	//激活码
		
		ExternalMemberActivate m = clientService.offExternalMemberActive(memberId,phone,activeCode);
		
		System.out.print("  会员ID：" + m.getMemberId());
		System.out.print("  手机号码：" + m.getPhone());
		System.out.print("  注册日期：" + m.getCreateTime());
		System.out.print("  是否激活：" + m.getIsActive());	//1:已激活   2:未激活
		System.out.print("  激活手机号：" + m.getActivePhone());

	}
	
	/**
	 * 测试 会员登录接口
	 * @throws JAXBException 
	 */
	@Test
	public void testOffExternalMemberLogin() throws JAXBException{
		Integer memberId = 123134354;				//会员ID
		String phone = "15915328531";		//手机号码
		String pwd = DES3.encryptStrMode(DES3.getKeyBytes("11223344556688"), "123456");		//123456 密码     11223344556688密钥(不可改)
		
		ExternalMemberLogin m = clientService.memberLogin(memberId,phone,pwd);
		
		System.out.print("  会员ID：" + m.getMemberId());
		System.out.print("  邮箱：" + m.getEmail());
		System.out.print("  手机号码：" + m.getPhone());
		System.out.print("  注册日期：" + m.getCreateTime());
		System.out.print("  是否激活：" + m.getIsActive());	//1:已激活   2:未激活
		System.out.print("  激活手机号：" + m.getActivePhone());
		System.out.print("  等级：" + m.getGrade());	//CRM没有没有等级
		System.out.print("  积分：" + m.getIntegral());
		System.out.print("  会员状态：" + m.getStatus()); //1:已激活  2：未激活  3注销/删除
		System.out.print("  登录状态：" + m.getLoginStatus());
		System.out.println(" 储值卡余额："+m.getMoney()+"\n");
	}
	
	
	/**
	 * 测试 注册会员接口
	 * @throws ParseException 
	 * @throws JAXBException 
	 */
	@Test
	public void testMemberRegister() throws ParseException, JAXBException{
		/*case1:必填项正常传参
		String email = "";
		String phone = "15915312345"; //手机（必选）
		String createTime = "2013-02-22 12:2:2"; //日期（必选）
		Integer isActivate = 2; //是否激活（必选）
		String activatePhone = "15915312345"; //激活手机号（必选）
		String grade = "";	//等级
		String birth = "";  
		Integer integral = 10; //积分（必选）
		Integer status = 2;  // 会员状态（必选）1:已激活  2：未激活  3删除
		String password = DES3.encryptStrMode(DES3.getKeyBytes("11223344556688"), "123456");		//123456 密码     11223344556688密钥(不可改)
		*/	
		String email = "aaa@qq.com";
		String phone = "15987653334";
		Date createTime = new Date(); //创建时间
		Integer isActive = 2;		  //是否激活 // 1:已激活  2：未激活
		String activePhone = "15221606545";
		String grade = "";	//等级
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String births = "2010-02-12";
		Date birth = sdf.parse(births); 		//生日
		String source = "123";	//注册来源
		Integer integral = 10; //积分
		Integer status = 2;  // 1:已激活  2：未激活  3删除  暂时没用到,状态根据是否激活判断
		String password = DES3.encryptStrMode(DES3.getKeyBytes("11223344556688"), "123456");		//123456 密码     11223344556688密钥(不可改)
		
		ExternalMemberReg r = new ExternalMemberReg();
		r.setSource(source);
		r.setEmail(email);
		r.setPhone(phone);
		r.setCreateTime(createTime);
		r.setIsActive(isActive);
		r.setActivePhone(activePhone);
		r.setGrade(grade);
		r.setBirth(birth);
		r.setIntegral(integral);
		r.setStatus(status);
		r.setPassword(password);
		
		ExternalMemberReg m = clientService.memberRegister(r);
		
		System.out.print("  会员ID：" + m.getMemberId());
		System.out.print("  邮箱：" + m.getEmail());
		System.out.print("  手机号码：" + m.getPhone());
		System.out.print("  注册日期：" + m.getCreateTime());
		System.out.print("  是否激活：" + m.getIsActive());	// 1:已激活  2：未激活
		System.out.print("  激活手机号：" + m.getActivePhone());
		System.out.print(" 结果:"+m.getResult()+"\n");
	}
	
	/**
	 * 测试 门店接口
	 * @throws JAXBException 
	 */
	@Test
	public void testShopList() throws JAXBException{
		String table = "" ;				//操作类型
		String operateType = "" ;		//需要的表数据类型
		String description = "" ;		//描述
		Date operateTime = new Date();		//操作时间  //四个参数都没用到
		
		ShopModelRes s = clientService.getShopModel(table, operateType, description, operateTime);
		System.out.println("总记录数:" + s.getShopList().size());
		for(ShopModel m : s.getShopList()){
			System.out.print("  门店ID：" + m.getShopId());
			System.out.print("  中文名称：" + m.getChineseName());
			System.out.print("  英文名称：" + m.getEnglishName());
			System.out.print("  站点ID：" + m.getStationed());
			System.out.print("  地址：" + m.getAddress());
			System.out.print("  经纬度：" + m.getPosition());
			System.out.print("  电话：" + m.getTelephone());
			System.out.print("  所属品牌：" + m.getBrand());
			System.out.print("  类型：" + m.getType()+"\n");
		}
	}
	
	/**
	 * 测试 站点接口
	 * @throws JAXBException 
	 */
	@Test
	public void testSiteList() throws JAXBException{
		String table = "" ;				//操作类型
		String operateType = "" ;		//需要的表数据类型
		String description = "" ;		//描述
		Date operateTime = new Date();		//操作时间  //四个参数都没用到
		SiteModelRes s =  clientService.getSiteModel(table, operateType, description, operateTime);
		System.out.println("总记录数:" + s.getSiteList().size());
		for(SiteModel m : s.getSiteList()){
			System.out.print("  站点ID：" + m.getStationId());
			System.out.print("  站点名称：" + m.getName());
			System.out.print("  线路：" + m.getLineName());
			System.out.print("  描述：" + m.getDescription());
			System.out.print("  图片：" + m.getPic());
			System.out.print("  排序号：" + m.getOrderNumber());
			System.out.print("  热点区域：" + m.getHotArea());
			System.out.print("  站点小图：" + m.getSmallPic()+"\n");
		}
	}
	
	/**
	 * 测试 储值卡消费接口
	 * @throws InvalidSignException 
	 */
	@Test
	public void testSavingAccountConsumption() throws InvalidSignException{
		List<CommodityVo> commodities = new ArrayList<CommodityVo>();//准备订单中的商品数据
		CommodityVo commodity = new CommodityVo();
		commodity.setId("ff8081813c8f7c3d013c8f7ef0650000");
		commodity.setName("");
		commodity.setCount(3);
		commodities.add(commodity);
		
		SavingAccountConsumptionReq req = new SavingAccountConsumptionReq();
		
		req.setOrderId("123");//订单ID
		req.setOrderSource("123");//订单来源
		req.setPoint(52.22); //扣除金额
		req.setUserId(7);//会员ID
		req.setCommodities(commodities);//设置订单中的商品
		
		SavingAccountConsumptionRes res = clientService.savingAccountConsumption(req);
		System.out.println("操作状态（1 成功 2失败）："+res.getOperateStatus());
		System.out.println("操作状态描述："+res.getStatusDescription());
	}
	
	/**
	 * 测试 修改会员基本信息接口
	 * @throws InvalidSignException 
	 */
	@Test
	public void testModifyMember() throws InvalidSignException{
		MemberModifyReq req = new MemberModifyReq();// 模拟修改会员基本信息的请求
		req.setId(1);//会员ID
		req.setAlivePhoneNumber("13189755310");//激活手机号
		req.setPhone("13189755314");//手机号
		req.setMemberStatus(1); //会员状态。1 已激活 2 未激活 3注销
		req.setMail("657620636@qq.com");//邮箱
		MemberModifyRes res = clientService.modifyMember(req);
		System.out.println("修改状态（1 修改成功 2 修改失败）： " + res.getUpdateStatus());
		System.out.println("失败原因（null表示修改成功）： " + res.getFailureReasons());
	}
	
	/**
	 * 测试 修改会员密码信息接口
	 * @throws InvalidSignException 
	 */
	@Test
	public void testModifyMemberPassword() throws InvalidSignException{
		MemberPasswordModifyReq req2 = new MemberPasswordModifyReq();//模拟修改会员密码的请求
		req2.setId(7);//会员ID
		req2.setOldPassword("12345@#$%^&*()6lll");//旧密码
		req2.setNewPassword("123456");//新密码
		MemberPasswordModifyRes res2 = clientService.modifyMemberPassword(req2);
		System.out.println("修改状态（1 成功 2 失败）： " + res2.getUpdateStatus());
		System.out.println("修改状态描述： " + res2.getUpdateDesc());
	}
}
