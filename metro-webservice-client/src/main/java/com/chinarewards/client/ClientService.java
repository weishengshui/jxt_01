package com.chinarewards.client;

import java.io.StringWriter;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Pattern;

import javax.ws.rs.core.MultivaluedMap;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

import com.chinarewards.client.exception.InvalidSignException;
import com.chinarewards.metro.models.CheckCodeResp;
import com.chinarewards.metro.models.DiscountUseCodeResp;
import com.chinarewards.metro.models.ExternalMember;
import com.chinarewards.metro.models.ExternalMemberActivate;
import com.chinarewards.metro.models.ExternalMemberLogin;
import com.chinarewards.metro.models.ExternalMemberReg;
import com.chinarewards.metro.models.IntegralAddResp;
import com.chinarewards.metro.models.IntegralConsumeResp;
import com.chinarewards.metro.models.Member;
import com.chinarewards.metro.models.common.DES3;
import com.chinarewards.metro.models.common.DateTools;
import com.chinarewards.metro.models.line.LineModel;
import com.chinarewards.metro.models.line.MetroLine;
import com.chinarewards.metro.models.line.SiteModel;
import com.chinarewards.metro.models.merchandise.CommodityVo;
import com.chinarewards.metro.models.merchandise.Merchandise;
import com.chinarewards.metro.models.merchandise.MerchandiseArray;
import com.chinarewards.metro.models.order.ExtOrderInfo;
import com.chinarewards.metro.models.order.ExtOrderInfoArray;
import com.chinarewards.metro.models.order.OrderRespArray;
import com.chinarewards.metro.models.request.CheckCodeReq;
import com.chinarewards.metro.models.request.DiscountReq;
import com.chinarewards.metro.models.request.DiscountUseCodeReq;
import com.chinarewards.metro.models.request.IntegralAddReq;
import com.chinarewards.metro.models.request.IntegralConsumeReq;
import com.chinarewards.metro.models.request.MemberActiveReq;
import com.chinarewards.metro.models.request.MemberInteractiveReq;
import com.chinarewards.metro.models.request.MemberLoginReq;
import com.chinarewards.metro.models.request.MemberModifyReq;
import com.chinarewards.metro.models.request.MemberPasswordModifyReq;
import com.chinarewards.metro.models.request.MerchandiseInfo;
import com.chinarewards.metro.models.request.MerchandiseReq;
import com.chinarewards.metro.models.request.MetroLineReq;
import com.chinarewards.metro.models.request.MetroSiteReq;
import com.chinarewards.metro.models.request.SavingAccountConsumptionReq;
import com.chinarewards.metro.models.request.ShopReq;
import com.chinarewards.metro.models.response.DiscountResp;
import com.chinarewards.metro.models.response.MemberModifyRes;
import com.chinarewards.metro.models.response.MemberPasswordModifyRes;
import com.chinarewards.metro.models.response.SavingAccountConsumptionRes;
import com.chinarewards.metro.models.response.ShopModelRes;
import com.chinarewards.metro.models.response.SiteModelRes;
import com.chinarewards.metro.util.MD5;
import com.chinarewards.metro.util.SHA1Util;
import com.sun.jersey.api.client.GenericType;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.core.util.MultivaluedMapImpl;

@SuppressWarnings("deprecation")
public class ClientService extends AbstractClient {
	public static void main(String[] args) throws InvalidSignException {
		// CheckCodeResp resp= new
		// ClientService("http://127.0.0.1:8080/metro/ws").checkCode("22",0);//参数为优惠码、类型（
		// 0--活动；1--名店）
		// System.out.println("优惠码查询确认接口----couponCode:"+resp.getCouponCode()+"   优惠码对应活动详细说明:"+resp.getCouponInfo()+"   错误原因:"+resp.getErrorReason()+
		// "   是否可用 必选  (0--不可用；1--可用):"+resp.getIsAvailable()+"   是否重复使用  （0--重复使用；1-未重复使用）:"+resp.getIsRepeat()+
		// "  使用时间:"+resp.getUseTime());
		//
		//
		// List<String> list=new ArrayList<String>();
		// list.add("ff8081813c706bbf013c707d45240000");
		// list.add("ff8081813ca32251013ca327f0550000");
		// IntegralConsumeResp resp = new
		// ClientService("http://127.0.0.1:8080/metro/ws").useIntegral("00000211",list,"POS_SALES",2500,new
		// Date(),"80","");
		// System.out.println("积分使用接口---- orderId:"+resp.getOrderId()+"   orderSource:"+resp.getOrderSource()+"   Point:"+resp.getPoint()+"   operateTime:"+
		// resp.getOperateTime()+
		// "   userId:"+resp.getUserId()+"   Description:"+resp.getDescription());

		// String requestRource= "POS_SALES" ;//请求来源
		// String money= "8GsRX3ohWis=" ;//交易金额 需要加密
		//
		// List<String> commodityIdList=new ArrayList<String>();//商品
		// commodityIdList.add("ff8081813ca32251013ca327f055000044");
		// commodityIdList.add("ff8081813ca9ssb3a1013ca9c32f350000");
		//
		// String point= "pH9f9/jWf58=" ;//积分 需要加密
		// Date operateTime=new Date();//操作日期
		// Integer userId= 80 ;//会员id
		// String description = "s顶顶顶s" ;//description
		//
		// IntegralAddResp resp = new
		// ClientService("http://127.0.0.1:8080/metro/ws").addIntegral(requestRource,money,commodityIdList,point,new
		// Date(),userId,description);
		// System.out.println("积分增加接口----   requestRource:"+resp.getRequestRource()+" Point:"+resp.getPoint()+" operateTime:"+resp.getOperateTime()+"   userId:"+
		// resp.getUserId()+
		// "  operateStatus:"+resp.getOperateStatus()+"   statusDescription:"+resp.getStatusDescription()+
		// "   ErrorInformation:"+resp.getErrorInformation());

		Pattern pattern = Pattern.compile("[0-9]*");
		System.out.println(pattern.matcher("333").matches());
	}

	private String url;

	public ClientService(String url) {
		this.url = url;
	}

	/**
	 * 生成优惠码
	 * 
	 * @param mid
	 *            会员ID
	 * @param couponId
	 *            门店ID或活动ID
	 * @param type
	 *            0:门店ID ; 1:活动ID
	 * @return
	 * @throws InvalidSignException
	 */
	public DiscountResp getCode(int mid, int couponId, int type)
			throws InvalidSignException, Exception {
		if (type != 0 && type != 1) {
			throw new Exception("找不到对应的类型");
		}
		DiscountReq req = new DiscountReq();
		req.setMid(mid);
		req.setCouponId(couponId);
		req.setType(type);
		try {
			// sign
			JAXBContext c = JAXBContext.newInstance(DiscountReq.class);
			req.setCheckStr(SHA1Util.SHA1Encode(req.getSignValue()));
			StringWriter r = new StringWriter();
			c.createMarshaller().marshal(req, r);
			String s = r.toString();
			String checkStr = MD5.MD5Encoder(s);
			req.setCheckStr(checkStr);

			WebResource resource = getClient().resource(url + "/discount/code");

			DiscountResp discountResp = resource.accept("application/json")
					.post(DiscountResp.class, req);

			// check sign
			String checkStr2 = discountResp.getCheckStr();
			JAXBContext ctx2 = JAXBContext.newInstance(DiscountResp.class);
			discountResp.setCheckStr(SHA1Util.SHA1Encode(discountResp
					.getSignValue()));
			StringWriter r2 = new StringWriter();
			ctx2.createMarshaller().marshal(discountResp, r2);
			String s2 = r2.toString();
			if (!MD5.MD5Encoder(s2).equals(checkStr2)) {
				throw new InvalidSignException();
			}

			return discountResp;
		} catch (UniformInterfaceException e) {
			e.printStackTrace();
			DiscountResp discountResp = new DiscountResp();
			String code = "-1";
			discountResp.setErrCode(code);
			return discountResp;
		} catch (JAXBException e) {
			throw new IllegalStateException(e);
		}
	}

	/**
	 * 优惠码查询确认接口
	 * 
	 * @param couponCode
	 * @param CouponId
	 *            0--活动；1--名店
	 * @return
	 * @throws InvalidSignException
	 */
	public CheckCodeResp checkCode(String couponCode, Integer couponId,
			String shopOrActivityId) throws InvalidSignException {
		CheckCodeReq req = new CheckCodeReq();
		req.setCouponCode(couponCode);
		req.setCouponId(couponId);
		req.setShopOrActivityId(shopOrActivityId);

		try {
			// sign
			JAXBContext c = JAXBContext.newInstance(CheckCodeReq.class);
			req.setCheckStr(SHA1Util.SHA1Encode(req.getSignValue()));
			StringWriter r = new StringWriter();
			c.createMarshaller().marshal(req, r);
			String s = r.toString();
			String checkStr = MD5.MD5Encoder(s);
			req.setCheckStr(checkStr);
		} catch (JAXBException e) {
			throw new IllegalStateException("Sign request error!", e);
		}

		WebResource resource = getClient()
				.resource(url + "/discount/checkCode");
		System.out.println("===" + resource.toString());
		try {
			CheckCodeResp checkCodeResp = resource.accept("application/json")
					.post(CheckCodeResp.class, req);

			// check sign
			String checkStr2 = checkCodeResp.getCheckStr();
			JAXBContext ctx2 = JAXBContext.newInstance(CheckCodeResp.class);
			checkCodeResp.setCheckStr(SHA1Util.SHA1Encode(checkCodeResp
					.getSignValue()));
			StringWriter r2 = new StringWriter();
			ctx2.createMarshaller().marshal(checkCodeResp, r2);
			String s2 = r2.toString();
			if (!MD5.MD5Encoder(s2).equals(checkStr2)) {
				throw new InvalidSignException();
			}

			return checkCodeResp;

		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		} catch (JAXBException e) {
			throw new IllegalStateException(e);
		}
	}

	/**
	 * 优惠码使用接口
	 * 
	 * @param couponCode
	 * @param CouponId
	 *            0--活动；1--名店
	 * @return
	 * @throws InvalidSignException
	 */
	public DiscountUseCodeResp useCode(String userId, String couponCode,
			String shopOrActivityId, String orderId, String description,
			Integer couponType) throws InvalidSignException {
		DiscountUseCodeReq req = new DiscountUseCodeReq();
		req.setCouponCode(couponCode);
		req.setShopOrActivityId(shopOrActivityId);
		req.setDescription(description);
		req.setOrderId(orderId);
		req.setUserId(userId);
		req.setCouponType(couponType);

		try {
			// sign
			JAXBContext c = JAXBContext.newInstance(DiscountUseCodeReq.class);
			req.setCheckStr(SHA1Util.SHA1Encode(req.getSignValue()));
			StringWriter r = new StringWriter();
			c.createMarshaller().marshal(req, r);
			String s = r.toString();
			String checkStr = MD5.MD5Encoder(s);
			req.setCheckStr(checkStr);
		} catch (JAXBException e) {
			throw new IllegalStateException("Sign request error!", e);
		}

		WebResource resource = getClient().resource(
				url + "/discount/useDiscountCode");
		System.out.println("===" + resource.toString());
		try {
			DiscountUseCodeResp resp = resource.accept("application/json")
					.post(DiscountUseCodeResp.class, req);

			// check sign
			String checkStr2 = resp.getCheckStr();
			JAXBContext ctx2 = JAXBContext
					.newInstance(DiscountUseCodeResp.class);
			resp.setCheckStr(SHA1Util.SHA1Encode(resp.getSignValue()));
			StringWriter r2 = new StringWriter();
			ctx2.createMarshaller().marshal(resp, r2);
			String s2 = r2.toString();
			if (!MD5.MD5Encoder(s2).equals(checkStr2)) {
				throw new InvalidSignException();
			}

			return resp;
		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		} catch (JAXBException e) {
			throw new IllegalStateException(e);
		}
	}

	/**
	 * 积分使用接口
	 * 
	 * @param orderId
	 * @param commodityIdList
	 * @param orderSource
	 * @param point
	 * @param operateTime
	 * @param userId
	 * @param description
	 * @return
	 * @throws InvalidSignException
	 */
	public IntegralConsumeResp useIntegral(String orderId,
			List<MerchandiseInfo> commodityIdList, String orderSource,
			double point, Date operateTime, String userId, String description)
			throws InvalidSignException {
		IntegralConsumeReq req = new IntegralConsumeReq();
		req.setCommodityIdList(commodityIdList);
		req.setDescription(description);
		req.setOperateTime(operateTime);
		req.setOrderId(orderId);
		req.setUserId(userId);
		req.setPoint(point);
		req.setOrderSource(orderSource);

		try {
			// sign
			JAXBContext c = JAXBContext.newInstance(IntegralConsumeReq.class);
			req.setCheckStr(SHA1Util.SHA1Encode(req.getSignValue()));
			StringWriter r = new StringWriter();
			c.createMarshaller().marshal(req, r);
			String s = r.toString();
			String checkStr = MD5.MD5Encoder(s);
			req.setCheckStr(checkStr);
		} catch (JAXBException e) {
			throw new IllegalStateException("Sign request error!", e);
		}

		WebResource resource = getClient().resource(
				url + "/integral/useIntegral");
		System.out.println("===" + resource.toString());
		try {
			IntegralConsumeResp integralConsumeResp = resource.accept(
					"application/json").post(IntegralConsumeResp.class, req);

			// check sign
			String checkStr2 = integralConsumeResp.getCheckStr();
			System.out.println("s2:" + checkStr2 + " s1:"
					+ integralConsumeResp.getCheckStr());
			JAXBContext ctx2 = JAXBContext
					.newInstance(IntegralConsumeResp.class);
			integralConsumeResp.setCheckStr(SHA1Util
					.SHA1Encode(integralConsumeResp.getSignValue()));
			StringWriter r2 = new StringWriter();
			ctx2.createMarshaller().marshal(integralConsumeResp, r2);
			String s2 = r2.toString();
			if (!MD5.MD5Encoder(s2).equals(checkStr2)) {
				throw new InvalidSignException();
			}

			return integralConsumeResp;

		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		} catch (JAXBException e) {
			throw new IllegalStateException(e);
		}
	}

	/**
	 * 积分增加接口
	 * 
	 * @param orderId
	 * @param commodityIdList
	 * @param orderSource
	 * @param point
	 * @param operateTime
	 * @param userId
	 * @param description
	 * @return
	 * @throws InvalidSignException
	 */
	public IntegralAddResp addIntegral(String requestRource, String money,
			List<MerchandiseInfo> commodityIdList, String point,
			Date operateTime, Integer userId, String description)
			throws InvalidSignException {
		IntegralAddReq req = new IntegralAddReq();
		req.setCommodityIdList(commodityIdList);

		req.setDescription(description);
		req.setMoney(money);
		req.setOperateTime(operateTime);
		req.setUserId(userId);
		req.setRequestRource(requestRource);
		req.setPoint(point);

		try {
			// sign
			JAXBContext c = JAXBContext.newInstance(IntegralAddReq.class);
			req.setCheckStr(SHA1Util.SHA1Encode(req.getSignValue()));
			StringWriter r = new StringWriter();
			c.createMarshaller().marshal(req, r);
			String s = r.toString();
			String checkStr = MD5.MD5Encoder(s);
			req.setCheckStr(checkStr);
		} catch (JAXBException e) {
			throw new IllegalStateException("Sign request error!", e);
		}

		WebResource resource = getClient().resource(
				url + "/integral/addIntegral");
		System.out.println("===" + resource.toString());
		try {
			IntegralAddResp resop = resource.accept("application/json").post(
					IntegralAddResp.class, req);

			// check sign
			String checkStr2 = resop.getCheckStr();
			System.out.println("checkStr2:" + checkStr2 + "  get:"
					+ resop.getCheckStr());
			JAXBContext ctx2 = JAXBContext.newInstance(IntegralAddResp.class);
			resop.setCheckStr(SHA1Util.SHA1Encode(resop.getSignValue()));
			StringWriter r2 = new StringWriter();
			ctx2.createMarshaller().marshal(resop, r2);
			String s2 = r2.toString();
			if (!MD5.MD5Encoder(s2).equals(checkStr2)) {
				throw new InvalidSignException();
			}

			return resop;

		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		} catch (JAXBException e) {
			throw new IllegalStateException(e);
		}
	}

	public List<Member> getMembers(String name) {
		MultivaluedMap<String, String> params = new MultivaluedMapImpl();
		params.add("name", name);
		WebResource r = getClient().resource(url + "/member/list").queryParams(
				params);
		try {
			List<Member> m = r.accept("application/json").get(
					new GenericType<List<Member>>() {
					});
			return m;
		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		}
	}

	/**
	 * 修改会员基本信息
	 * 
	 * @param memberModifyReq
	 * @return
	 * @throws InvalidSignException
	 */
	public MemberModifyRes modifyMember(MemberModifyReq memberModifyReq)
			throws InvalidSignException {

		if (null == memberModifyReq) {
			throw new NullPointerException();
		}

		Integer id = memberModifyReq.getId();
		String phone = memberModifyReq.getPhone();
		String mail = memberModifyReq.getMail();
		String alivePhoneNumber = memberModifyReq.getAlivePhoneNumber();
		Date birthday = memberModifyReq.getBirthday();
		Integer memberStatus = memberModifyReq.getMemberStatus();

		MemberModifyRes memberModifyRes = new MemberModifyRes();
		memberModifyRes.setUpdateStatus(2);

		String phoneRegEx = "[1]{1}[3,5,8,6,4]{1}[0-9]{9}";
		String mailRegEx = "\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";

		if (null == id) {
			memberModifyRes.setFailureReasons("会员id为空");
			return memberModifyRes;
		} else if (null == phone || phone.length() == 0) {
			memberModifyRes.setFailureReasons("手机为空");
			return memberModifyRes;
		} else if (phone.length() != 11) {
			memberModifyRes.setFailureReasons("手机长度必须为11位");
			return memberModifyRes;
		} else if (!Pattern.compile(phoneRegEx).matcher(phone).find()) {
			memberModifyRes.setFailureReasons("手机号码格式不正确");
			return memberModifyRes;
		} else if (null == memberStatus) {
			memberModifyRes.setFailureReasons("会员状态为空");
			return memberModifyRes;
		} else if (!memberStatus.equals(1) && !memberStatus.equals(3)
				&& !memberStatus.equals(2)) {
			memberModifyRes.setFailureReasons("会员状态不存在");
			return memberModifyRes;
		} else if (null != mail && mail.length() > 0
				&& !Pattern.compile(mailRegEx).matcher(mail).find()) {
			memberModifyRes.setFailureReasons("邮箱格式不正确");
			return memberModifyRes;
		} else if (null != birthday && birthday.after(DateTools.dateToHour24())) {
			memberModifyRes.setFailureReasons("会员生日大于当前时间，不合法");
			return memberModifyRes;
		} else if (memberStatus.equals(1)
				&& (null == alivePhoneNumber || alivePhoneNumber.length() == 0)) {
			memberModifyRes.setFailureReasons("激活手机号为空");
			return memberModifyRes;
		} else if (memberStatus.equals(1)
				&& (null != alivePhoneNumber && alivePhoneNumber.length() != 11)) {
			memberModifyRes.setFailureReasons("激活手机号长度必须为11位");
			return memberModifyRes;
		} else if (memberStatus.equals(1)
				&& !Pattern.compile(phoneRegEx).matcher(alivePhoneNumber)
						.find()) {
			memberModifyRes.setFailureReasons("激活手机号格式不正确");
			return memberModifyRes;
		} else {
			try {
				// sign
				JAXBContext c = JAXBContext.newInstance(MemberModifyReq.class);
				memberModifyReq.setCheckStr(SHA1Util.SHA1Encode(memberModifyReq
						.getSignValue()));
				StringWriter r = new StringWriter();
				c.createMarshaller().marshal(memberModifyReq, r);
				String s = r.toString();
				String checkStr = MD5.MD5Encoder(s);
				memberModifyReq.setCheckStr(checkStr);
			} catch (JAXBException e) {
				throw new IllegalStateException("Sign request error!", e);
			}

			WebResource resource = getClient().resource(url + "/member/modify");
			System.out.println("===" + resource.toString());
			try {
				memberModifyRes = resource.accept("application/json").put(
						MemberModifyRes.class, memberModifyReq);

				// check sign
				String checkStr2 = memberModifyRes.getCheckStr();
				JAXBContext ctx2 = JAXBContext
						.newInstance(MemberModifyRes.class);
				memberModifyRes.setCheckStr(SHA1Util.SHA1Encode(memberModifyRes
						.getSignValue()));
				StringWriter r2 = new StringWriter();
				ctx2.createMarshaller().marshal(memberModifyRes, r2);
				String s2 = r2.toString();
				if (!MD5.MD5Encoder(s2).equals(checkStr2)) {
					throw new InvalidSignException();
				}
				return memberModifyRes;
			} catch (UniformInterfaceException e) {
				System.err.println("Status: "
						+ e.getResponse().getResponseStatus());
				throw new IllegalStateException(e);
			} catch (JAXBException e) {
				throw new IllegalStateException(e);
			}
		}

	}

	/**
	 * 修改会员密码信息
	 * 
	 * @param memberModifyReq
	 * @return
	 * @throws InvalidSignException
	 */
	public MemberPasswordModifyRes modifyMemberPassword(
			MemberPasswordModifyReq memberPasswordModifyReq)
			throws InvalidSignException {

		if (null == memberPasswordModifyReq) {
			throw new NullPointerException();
		}

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		String updateTime = dateFormat.format(new Date());
		memberPasswordModifyReq.setUpdateTime(updateTime);

		Integer id = memberPasswordModifyReq.getId();
		String oldPassword = memberPasswordModifyReq.getOldPassword();
		String newPassword = memberPasswordModifyReq.getNewPassword();

		MemberPasswordModifyRes memberPasswordModifyRes = new MemberPasswordModifyRes();
		memberPasswordModifyRes.setUpdateStatus(2);

		if (null == id) {
			memberPasswordModifyRes.setUpdateDesc("会员id为空，修改失败");
			return memberPasswordModifyRes;
		} else if (null == oldPassword || oldPassword.length() == 0) {
			memberPasswordModifyRes.setUpdateDesc("老密码为空，修改失败");
			return memberPasswordModifyRes;
		} else if (null == newPassword || newPassword.length() == 0) {
			memberPasswordModifyRes.setUpdateDesc("新密码为空，修改失败");
			return memberPasswordModifyRes;
		} else {
			// 设定密码，并用3DES加密

			oldPassword = DES3.encryptStrMode(DES3.getKeyBytes(updateTime),
					memberPasswordModifyReq.getOldPassword());
			newPassword = DES3.encryptStrMode(DES3.getKeyBytes(updateTime),
					memberPasswordModifyReq.getNewPassword());
			memberPasswordModifyReq.setOldPassword(oldPassword);
			memberPasswordModifyReq.setNewPassword(newPassword);

			try {
				// sign
				JAXBContext c = JAXBContext
						.newInstance(MemberPasswordModifyReq.class);
				memberPasswordModifyReq.setCheckStr(SHA1Util
						.SHA1Encode(memberPasswordModifyReq.getSignValue()));
				StringWriter r = new StringWriter();
				c.createMarshaller().marshal(memberPasswordModifyReq, r);
				String s = r.toString();
				String checkStr = MD5.MD5Encoder(s);
				memberPasswordModifyReq.setCheckStr(checkStr);
			} catch (JAXBException e) {
				throw new IllegalStateException("Sign request error!", e);
			}

			WebResource resource = getClient().resource(
					url + "/member/passwordModify");
			System.out.println("===" + resource.toString());
			try {
				memberPasswordModifyRes = resource.accept("application/json")
						.post(MemberPasswordModifyRes.class,
								memberPasswordModifyReq);

				// check sign
				String checkStr2 = memberPasswordModifyRes.getCheckStr();
				JAXBContext ctx2 = JAXBContext
						.newInstance(MemberPasswordModifyRes.class);
				memberPasswordModifyRes.setCheckStr(SHA1Util
						.SHA1Encode(memberPasswordModifyRes.getSignValue()));
				StringWriter r2 = new StringWriter();
				ctx2.createMarshaller().marshal(memberPasswordModifyRes, r2);
				String s2 = r2.toString();
				if (!MD5.MD5Encoder(s2).equals(checkStr2)) {
					throw new InvalidSignException();
				}

				return memberPasswordModifyRes;
			} catch (UniformInterfaceException e) {
				System.err.println("Status: "
						+ e.getResponse().getResponseStatus());
				throw new IllegalStateException(e);
			} catch (JAXBException e) {
				throw new IllegalStateException(e);
			}
		}
	}

	/**
	 * 按页获取商品列表，每页500个商品
	 * 
	 * @param req
	 * @return
	 * @throws InvalidSignException
	 */
	public List<Merchandise> getMerchandises(Integer page, Integer pageSize)
			throws InvalidSignException {
		MerchandiseReq req = new MerchandiseReq();
		req.setPage(page);
		req.setPageSize(pageSize);

		try {
			// sign
			JAXBContext c = JAXBContext.newInstance(MerchandiseReq.class);
			req.setCheckStr(SHA1Util.SHA1Encode(req.getSignValue()));
			StringWriter r = new StringWriter();
			c.createMarshaller().marshal(req, r);
			String s = r.toString();
			String checkStr = MD5.MD5Encoder(s);
			req.setCheckStr(checkStr);

			WebResource resource = getClient().resource(
					url + "/merchandise/list");

			MerchandiseArray resp = resource.accept("application/json").post(
					MerchandiseArray.class, req);

			// check sign
			String checkStr2 = resp.getCheckStr();
			String signValue = resp.getSignValue();
			resp.setCheckStr(SHA1Util.SHA1Encode(signValue));
			JAXBContext ctx2 = JAXBContext.newInstance(MerchandiseArray.class);
			StringWriter r2 = new StringWriter();
			ctx2.createMarshaller().marshal(resp, r2);
			String s2 = MD5.MD5Encoder(r2.toString());
			System.out.println("s1:" + s2 + " c:" + checkStr2);
			if (!s2.equals(checkStr2)) {
				throw new InvalidSignException();
			}
			return resp.getList();
		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		} catch (JAXBException e) {
			throw new IllegalStateException(e);
		}

	}

	public MetroLine getLineDataList(String table, String operateType,
			String description, Date operateTime) {
		// List<LineModel> models = new ArrayList<LineModel>();
		MetroLineReq req = new MetroLineReq();
		req.setDescription(description);
		req.setOperateTime(operateTime);
		req.setOperateType(operateType);
		req.setTable(table);
		MetroLine lm = null ;
		try {
			JAXBContext c = JAXBContext.newInstance(MetroLineReq.class);
			req.setCheckStr(SHA1Util.SHA1Encode(req.getSignValue()));
			StringWriter r = new StringWriter();
			c.createMarshaller().marshal(req, r);
			String s = r.toString();
			String checkStr = MD5.MD5Encoder(s);
			req.setCheckStr(checkStr);
			WebResource resource = getClient().resource(
					url + "/line/lineDataList");
			lm = resource.accept("application/json").post(
					new GenericType<MetroLine>() {
					}, req);
		} catch (UniformInterfaceException e) {
			e.printStackTrace();
		} catch (JAXBException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return lm;
	}

	public List<SiteModel> getSiteModel() {
		MultivaluedMap<String, String> params = new MultivaluedMapImpl();
		// params.add("table", "table");
		// params.add("operateType", "operateType");
		// params.add("description", "description");
		// params.add("operateTime", "");
		WebResource resource = getClient().resource(url + "/line/site/list")
				.queryParams(params);
		return resource.accept("application/json").get(
				new GenericType<List<SiteModel>>() {
				});

	}

	/**
	 * 储值卡消费
	 * 
	 * @param req
	 * @return
	 * @throws InvalidSignException
	 */
	public SavingAccountConsumptionRes savingAccountConsumption(
			SavingAccountConsumptionReq req) throws InvalidSignException {

		if (null == req) {
			throw new NullPointerException();
		}
		req.setOperateTime(DateTools.date_To_yyyyMMddHHmmss(new Date()));
		String orderId = req.getOrderId();
		String orderSource = req.getOrderSource();
		Integer shopId = req.getShopId(); // 可选
		List<CommodityVo> commodities = req.getCommodities(); // 订单中的商品类表
		Double point = req.getPoint(); // 扣除金额。
		String operateTime = req.getOperateTime(); // 操作时间。格式yyyyMMddHHmmss
		Integer userId = req.getUserId(); // 会员Id
		String description = req.getDescription(); // 订单描述。可选

		SavingAccountConsumptionRes res = new SavingAccountConsumptionRes();
		res.setDescription(description);
		res.setOperateStatus(2);// failure
		res.setOrderId(orderId);
		res.setOrderSource(orderSource);
		res.setPoint(point);
		res.setOperateTime(operateTime);
		res.setUserId(userId);

		boolean commodityAvailable = true;
		if (null != commodities && commodities.size() > 0) {
			for (CommodityVo commodity : commodities) {
				String id = commodity.getId();
				Integer count = commodity.getCount();
				String name = commodity.getName();
				if (null == id || id.length() == 0) {
					res.setStatusDescription("商品id不能为空");
					commodityAvailable = false;
					break;
				} else if (null == count || count <= 0) {
					res.setStatusDescription("商品id\"" + id + "\"对应的商品数量无效");
					commodityAvailable = false;
					break;
				} else if (null == name || name.length() == 0) {
					res.setStatusDescription("商品id\"" + id + "\"对应的商品名称无效");
					commodityAvailable = false;
					break;
				}
			}
		} else {
			res.setStatusDescription("商品列表不能为空");
			commodityAvailable = false;
		}
		int pointLength = 1;
		if (null != point) {
			DecimalFormat format = new DecimalFormat("#.##");
			double tempPoint = Double
					.valueOf(format.format(point.doubleValue()));
			if (tempPoint < point.doubleValue()) {
				pointLength = 3;
			}
		}
		if (!commodityAvailable) {

		} else if (null == orderId || orderId.length() == 0) {
			res.setStatusDescription("订单id不能为空");
		} else if (null == orderSource || orderSource.length() == 0) {
			res.setStatusDescription("订单来源不能为空");
		} else if (null == commodities || commodities.size() == 0) {
			res.setStatusDescription("商品列表不能为空");
		} else if (null == point) {
			res.setStatusDescription("扣除金额不能为空");
		} else if (point.doubleValue() <= 0) {
			res.setStatusDescription("扣除金额必须大于0");
		} else if (pointLength > 2) {
			res.setStatusDescription("扣除金额精确到小数点后两位即可");
		} else if (null == operateTime || operateTime.length() == 0) {
			res.setStatusDescription("操作时间不能为空");
		} else if (null == userId) {
			res.setStatusDescription("会员id不能为空");
		} else {

			try {
				// sign
				JAXBContext c = JAXBContext
						.newInstance(SavingAccountConsumptionReq.class);
				req.setCheckStr(SHA1Util.SHA1Encode(req.getSignValue()));
				StringWriter r = new StringWriter();
				c.createMarshaller().marshal(req, r);
				String s = r.toString();
				String checkStr = MD5.MD5Encoder(s);
				req.setCheckStr(checkStr);
			} catch (JAXBException e) {
				throw new IllegalStateException("Sign request error!", e);
			}

			WebResource resource = getClient().resource(
					url + "/savingAccount/consumption");
			System.out.println("===" + resource.toString());
			try {
				res = resource.accept("application/json").post(
						SavingAccountConsumptionRes.class, req);

				// check sign
				String checkStr2 = res.getCheckStr();
				JAXBContext ctx2 = JAXBContext
						.newInstance(SavingAccountConsumptionRes.class);
				res.setCheckStr(SHA1Util.SHA1Encode(res.getSignValue()));
				StringWriter r2 = new StringWriter();
				ctx2.createMarshaller().marshal(res, r2);
				String s2 = r2.toString();
				if (!MD5.MD5Encoder(s2).equals(checkStr2)) {
					throw new InvalidSignException();
				}

			} catch (UniformInterfaceException e) {
				System.err.println("Status: "
						+ e.getResponse().getResponseStatus());
				throw new IllegalStateException(e);
			} catch (JAXBException e) {
				throw new IllegalStateException(e);
			}
		}
		return res;

	}

	/**
	 * 与POS进销存系统会员交互
	 * 
	 * @throws JAXBException
	 */
	public ExternalMember offExternalMember(String OperateType,
			String PreSyncTime, String PhoneNum, Integer curPage)
			throws JAXBException {

		MemberInteractiveReq m = new MemberInteractiveReq();
		m.setOperateType(OperateType);
		m.setPhoneNum(PhoneNum);
		m.setPreSyncTime(PreSyncTime);
		m.setCurPage(curPage);

		JAXBContext c = JAXBContext.newInstance(MemberInteractiveReq.class);
		m.setCheckStr(SHA1Util.SHA1Encode(m.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(m, r);
		String s = r.toString();
		String checkStr = MD5.MD5Encoder(s);
		m.setCheckStr(checkStr);

		WebResource resource = getClient().resource(
				url + "/member/offExternalMember");
		return resource.accept("application/json").post(
				new GenericType<ExternalMember>() {
				}, m);
	}

	/**
	 * 验证是否激活
	 * 
	 * @param memberId
	 * @param phone
	 * @param activeCode
	 * @return 状态：1 已激活 2 没激活 3 注销/删除
	 * @throws JAXBException
	 */

	public ExternalMemberActivate offExternalMemberActive(Integer memberId,
			String phone, String activeCode) throws JAXBException {
		MemberActiveReq m = new MemberActiveReq();
		m.setMemberId(memberId);
		m.setPhone(phone);
		m.setActiveCode(activeCode);

		JAXBContext c = JAXBContext.newInstance(MemberActiveReq.class);
		m.setCheckStr(SHA1Util.SHA1Encode(m.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(m, r);
		String s = r.toString();
		String checkStr = MD5.MD5Encoder(s);
		m.setCheckStr(checkStr);

		WebResource resource = getClient().resource(
				url + "/member/offExternalMemberActive");
		return resource.accept("application/json").post(
				new GenericType<ExternalMemberActivate>() {
				}, m);
	}

	/**
	 * 会员登录接口
	 * 
	 * @param memberId
	 * @param phone
	 * @param password
	 * @return
	 * @throws JAXBException
	 */
	public ExternalMemberLogin memberLogin(Integer memberId, String phone,
			String password) throws JAXBException {
		MemberLoginReq m = new MemberLoginReq();
		m.setMemberId(memberId);
		m.setPhone(phone);
		m.setPassword(password);

		JAXBContext c = JAXBContext.newInstance(MemberLoginReq.class);
		m.setCheckStr(SHA1Util.SHA1Encode(m.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(m, r);
		String s = r.toString();
		String checkStr = MD5.MD5Encoder(s);
		m.setCheckStr(checkStr);

		WebResource resource = getClient().resource(
				url + "/member/offExternalMemberLogin");
		return resource.accept("application/json").post(
				new GenericType<ExternalMemberLogin>() {
				}, m);
	}

	/**
	 * 注册会员
	 * 
	 * @param email
	 * @param phone
	 * @param createTime
	 * @param isActivate
	 * @param activatePhone
	 * @param grade
	 * @param birth
	 * @param integral
	 * @param status
	 * @param password
	 * @return
	 * @throws JAXBException
	 */
	public ExternalMemberReg memberRegister(ExternalMemberReg m)
			throws JAXBException {
		JAXBContext c = JAXBContext.newInstance(ExternalMemberReg.class);
		m.setCheckStr(SHA1Util.SHA1Encode(m.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(m, r);
		String s = r.toString();
		String checkStr = MD5.MD5Encoder(s);
		m.setCheckStr(checkStr);
		WebResource resource = getClient().resource(
				url + "/member/offExternalMemberRegister");
		return resource.accept("application/json").post(
				ExternalMemberReg.class, m);
	}

	/**
	 * 门店接口
	 * 
	 * @param table
	 * @param operateType
	 * @param description
	 * @param operateTime
	 * @return
	 * @throws JAXBException
	 */
	public ShopModelRes getShopModel(String table, String operateType,
			String description, Date operateTime) throws JAXBException {
		ShopReq m = new ShopReq();
		m.setDescription(description);
		m.setTable(table);
		m.setOperateTime(operateTime);
		m.setOperateType(operateType);

		JAXBContext c = JAXBContext.newInstance(ShopReq.class);
		m.setCheckStr(SHA1Util.SHA1Encode(m.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(m, r);
		String s = r.toString();
		String checkStr = MD5.MD5Encoder(s);
		m.setCheckStr(checkStr);

		WebResource resource = getClient().resource(url + "/line/shop/list");
		return resource.accept("application/json").post(
				new GenericType<ShopModelRes>() {
				}, m);
	}

	/**
	 * 站点接口
	 * 
	 * @return
	 * @throws JAXBException
	 */
	public SiteModelRes getSiteModel(String table, String operateType,
			String description, Date operateTime) throws JAXBException {
		MetroSiteReq m = new MetroSiteReq();
		m.setTable(table);
		m.setOperateTime(operateTime);
		m.setOperateType(operateType);
		m.setDescription(description);

		JAXBContext c = JAXBContext.newInstance(MetroSiteReq.class);
		m.setCheckStr(SHA1Util.SHA1Encode(m.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(m, r);
		String s = r.toString();
		String checkStr = MD5.MD5Encoder(s);
		m.setCheckStr(checkStr);

		WebResource resource = getClient().resource(url + "/line/site/list");
		return resource.accept("application/json").post(
				new GenericType<SiteModelRes>() {
				}, m);
	}

	/**
	 * 与POS进销存系统订单交互接口
	 * 
	 * @param list
	 * @return
	 * @throws InvalidSignException
	 */
	public OrderRespArray processExtOrder(List<ExtOrderInfo> list)
			throws InvalidSignException {

		if (null == list || list.size() < 1) {
			throw new IllegalArgumentException("Order could't be null!");
		}

		try {
			ExtOrderInfoArray arrays = new ExtOrderInfoArray();
			arrays.setList(list);

			// sign
			JAXBContext c = JAXBContext.newInstance(ExtOrderInfoArray.class);
			arrays.setCheckStr(SHA1Util.SHA1Encode(arrays.getSignValue()));
			StringWriter r = new StringWriter();
			c.createMarshaller().marshal(arrays, r);
			String s = r.toString();
			String checkStr = MD5.MD5Encoder(s);
			arrays.setCheckStr(checkStr);

			WebResource resource = getClient().resource(
					url + "/trans/push/order");

			OrderRespArray resp = resource.accept("application/json").post(
					OrderRespArray.class, arrays);

			// check sign
			String checkStr2 = resp.getCheckStr();
			JAXBContext ctx2 = JAXBContext.newInstance(OrderRespArray.class);
			resp.setCheckStr(SHA1Util.SHA1Encode(resp.getSignValue()));
			StringWriter r2 = new StringWriter();
			ctx2.createMarshaller().marshal(resp, r2);
			String s2 = r2.toString();
			if (!MD5.MD5Encoder(s2).equals(checkStr2)) {
				throw new InvalidSignException();
			}
			return resp;
		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		} catch (JAXBException e) {
			throw new IllegalStateException(e);
		}
	}
}
