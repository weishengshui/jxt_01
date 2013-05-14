package com.chinarewards.alading.resources;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;

import com.chinarewards.alading.domain.Card;
import com.chinarewards.alading.domain.CardDetail;
import com.chinarewards.alading.domain.CardList;
import com.chinarewards.alading.domain.ExchangeLog;
import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.domain.MemberInfo;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.reg.mapper.ExchangeLogMapper;
import com.chinarewards.alading.response.ImageModel;
import com.chinarewards.alading.response.PicUrlList;
import com.chinarewards.alading.service.ICompanyCardService;
import com.chinarewards.alading.service.ICouponService;
import com.chinarewards.alading.service.IFileItemService;
import com.chinarewards.alading.service.IMemberService;
import com.chinarewards.alading.util.SystemTimeProvider;
import com.google.inject.Inject;
import com.oreilly.servlet.MultipartRequest;

@Path("/")
public class EltResource {

	@InjectLogger
	private Logger logger;

	@Inject
	private IFileItemService fileItemService;
	@Inject
	private ICompanyCardService companyCardService;
	@Inject
	private IMemberService memberService;
	@Inject
	private ICouponService couponService;
	@Inject
	private ExchangeLogMapper exchangeLogMapper;

	/**
	 * 获取图片url列表
	 * 
	 * @param username
	 *            用户名
	 * @param password
	 *            密码
	 * @return
	 */
	@POST
	@Path("pic")
	@Consumes({ MediaType.APPLICATION_FORM_URLENCODED })
	@Produces({ MediaType.APPLICATION_XML })
	public PicUrlList obtainPicUrlList(@FormParam("username") String username,
			@FormParam("password") String password,
			@Context HttpServletRequest request) {

		logger.info("entrance obtainPicUrlList username={}, password={}",
				new Object[] { username, password });

		PicUrlList picUrlList = new PicUrlList();

		List<String> urlList = new ArrayList<String>();
		Card card = companyCardService.findDefaultCard();
		if (null != card) {
			FileItem fileItem = card.getPicUrl();
			if (null != fileItem && null != fileItem.getId()) {
				urlList.add("" + fileItem.getId());
			}
		}
		picUrlList.setPicUrl(urlList);

		return picUrlList;
	}

	// just for test
	@POST
	@Path("putPic")
	@Consumes({ MediaType.MULTIPART_FORM_DATA })
	@Produces({ MediaType.TEXT_HTML })
	public String putPic(@Context HttpServletRequest request)
			throws IOException {

		logger.info("entrance putPic");

		MultipartRequest mr = null;
		int maxSize = 10485760;
		mr = new MultipartRequest(request, System.getProperty("user.dir"),
				maxSize);
		File file = mr.getFile("pic");
		if (null != file) {
			String contentType = mr.getContentType("pic");
			String originalFileName = mr.getOriginalFileName("pic");
			logger.info("contentType={}, originalFileName={}", new Object[] {
					contentType, originalFileName });
			FileInputStream fis = new FileInputStream(file);
			if (null != fis && fis.available() > 0) {
				int length = fis.available();
				byte[] bbuf = new byte[length];
				for (int i = 0; i < length; i++) {
					bbuf[i] = (byte) fis.read();
				}
				FileItem fileItem = new FileItem();
				fileItem.setContent(bbuf);
				fileItem.setMimeType(contentType);
				fileItem.setOriginalFilename(originalFileName);
				fileItem.setFilesize(length);
				fileItemService.save(fileItem);
			}
			fis.close();
			file.delete();
		}
		return "success";
	}

	@GET
	@Path("getPic/{id}")
	@Produces({ MediaType.APPLICATION_XML })
	public ImageModel getPic(@PathParam("id") Integer id) {

		logger.info("entrance getPic picId={}", new Object[] { id });

		FileItem fileItem = fileItemService.findFileItemById(id);
		ImageModel imageModel = new ImageModel();
		if (null == fileItem) {
		} else {
			imageModel.setContentData(fileItem.getContent());
			imageModel.setContentType(fileItem.getMimeType());
			imageModel.setTitle("123.jpg");
			logger.info("getPic content={}",
					new Object[] { fileItem.getContent() });
		}
		return imageModel;

	}

	/**
	 * 终端机获取session
	 * 
	 * @param terminalId
	 *            终端机ID
	 * @param username
	 *            用户名
	 * @param password
	 *            密码
	 * @return
	 */
	@POST
	@Path("login")
	@Consumes({ MediaType.APPLICATION_FORM_URLENCODED })
	@Produces({ MediaType.TEXT_HTML })
	public String login(@FormParam("terminalId") String terminalId,
			@FormParam("username") String username,
			@FormParam("password") String password) {

		logger.info("entrance login terminalId={}, username={}, password={}",
				new Object[] { terminalId, username, password });

		String terminalSession = "21281728172816287162";

		if (null != username && null != password && username.equals("ishelf")
				&& password.equals("ishelf")) {

			// TODO
		} else {
			// throw Exceltion ?
		}

		return terminalSession;
	}

	/**
	 * 根据手机号码获取指定会员所有有效卡类型数据
	 * 
	 * @param terminalSession
	 *            终端机session ID
	 * @param mobileNo
	 *            会员手机号
	 * @return
	 */
	@POST
	@Path("member/info")
	@Consumes({ MediaType.APPLICATION_FORM_URLENCODED })
	@Produces({ MediaType.APPLICATION_XML })
	public MemberInfo getMemberInfo(
			@FormParam("terminalSession") String terminalSession,
			@FormParam("mobileNo") String mobileNo,
			@Context HttpServletRequest request) {

		logger.info(
				"entrance memberInfo terminalSession={}, mobileNo={}, password={}",
				new Object[] { terminalSession, mobileNo });

		// String picPrefix = getPicPrefix(request);
		MemberInfo memberInfo = new MemberInfo();
		if (!StringUtils.isEmpty(mobileNo)) {
			memberInfo = memberService.findMemberInfoByPhone(mobileNo);
			if (null != memberInfo) {
				// CardList cardList = memberInfo.getCardList();
				// if (null != cardList) {
				// List<CardDetail> cardDetails = cardList.getCardDetail();
				// if (null != cardDetails && cardDetails.size() > 0) {
				// for (CardDetail detail : cardDetails) {
				// detail.setPicUrl(picPrefix + detail.getPicUrl());
				// }
				// }
				// }
			} else {
				memberInfo = new MemberInfo();
			}
		}

		return memberInfo;
	}

	/**
	 * 兑换抵用券，扣减会员积分
	 * 
	 * @param terminalSession
	 *            终端机的sessionId
	 * @param sessionId
	 *            会员的sessionId
	 * @param accountId
	 *            会员账户id
	 * @param pointId
	 *            卡积分单位id
	 * @param amount
	 *            兑换数量
	 * @param terminalId
	 *            终端机编号
	 * @param terminalAddress
	 *            终端机地址
	 * @param transactionDate
	 *            兑换发生时间，日期格式为 yyyy-MM-dd hh:mm:ss
	 * @param couponNo
	 *            抵用券交易号
	 * @return 
	 *         100：交易成功、101：抵扣券号码已存在、102：会员账户余额不足、103：积分类型错误、104：超出当日使用限额、110：用户名密码错误
	 *         、111：用户session无效、112：终端机session无效、113：系统级异常
	 */
	@POST
	@Path("redeem/apply")
	@Consumes({ MediaType.APPLICATION_FORM_URLENCODED })
	@Produces({ MediaType.TEXT_HTML })
	public String redeemApply(
			@FormParam("terminalSession") String terminalSession,
			@FormParam("sessionId") String sessionId,
			@FormParam("accountId") Integer accountId,
			@FormParam("pointId") String pointId,
			@FormParam("amount") Integer amount,
			@FormParam("terminalId") String terminalId,
			@FormParam("terminalAddress") String terminalAddress,
			@FormParam("transactionDate") String transactionDate,
			@FormParam("couponNo") String couponNo) {
		logger.trace(
				"entrance redeemApply terminalSession={}, sessionId={}, accountId={}, pointId={}, amount={}, terminalId={}, terminalAddress={}, transactionDate={}, couponNo={}",
				new Object[] { terminalSession, sessionId, accountId, pointId,
						amount, terminalId, terminalAddress, transactionDate,
						couponNo });

		String response = couponService.exchange(couponNo, accountId, amount,
				terminalId, terminalAddress, transactionDate);

		return response;
	}

	/**
	 * 使用抵用券消费
	 * 
	 * @param username
	 *            用户名
	 * @param password
	 *            密码
	 * @param terminalId
	 *            终端机编号
	 * @param merchantName
	 *            终端机所属商户
	 * @param merchantAddress
	 *            终端机所属商户地址
	 * @param transactionDate
	 *            兑换发生时间，日期格式为 yyyy-MM-dd hh:mm:ss
	 * @param transactionNo
	 *            交易号
	 * @param couponNo
	 *            使用的抵用券交易号
	 * @return 100：交易成功 、101：抵扣券号码不存在、102：抵扣券已过期、103:
	 *         订单状态错误、110：用户名密码错误、111：用户session无效、112：终端机session无效、114:
	 *         传入的日期格式错误、120: 订单系统数据错误、113：系统级异常、121: 用户帐号锁定
	 */
	@POST
	@Path("redeem/accept")
	@Consumes({ MediaType.APPLICATION_FORM_URLENCODED })
	@Produces({ MediaType.TEXT_HTML })
	public String redeemAccept(@FormParam("username") String username,
			@FormParam("password") String password,
			@FormParam("terminalId") String terminalId,
			@FormParam("merchantName") String merchantName,
			@FormParam("merchantAddress") String merchantAddress,
			@FormParam("transactionDate") String transactionDate,
			@FormParam("transactionNo") String transactionNo,
			@FormParam("couponNo") List<String> couponNo) {

		logger.info(
				"entrance redeemAccept username={}, password={}, terminalId={}, merchantName={}, merchantAddress={}, transactionDate={}, transactionNo={}, couponNo={}",
				new Object[] { username, password, terminalId, merchantName,
						merchantAddress, transactionDate, transactionNo,
						couponNo });
		// exchangeLog
		ExchangeLog exchangeLog = new ExchangeLog();
		exchangeLog.createdAt = SystemTimeProvider.getCurrentTime();
		exchangeLog.transactionDate = SystemTimeProvider.getCurrentTime();
		exchangeLog.merchantAddress = merchantAddress;
		exchangeLog.merchantName = merchantName;
		exchangeLog.terminalId = terminalId;
		exchangeLog.operation = "apply";

		String response = "100";
		try {
			response = couponService.applyCoupon(couponNo, terminalId,
					merchantName, merchantAddress, transactionDate,
					transactionNo);
		} catch (IllegalStateException e1) {
			response = e1.getMessage();
			exchangeLog.returnCode = response;
			logExchange(exchangeLog, couponNo);
		} catch (Exception e) {
			response = "113";
			exchangeLog.returnCode = response;
			logExchange(exchangeLog, couponNo);
		}
		return response;
	}

	/**
	 * 抵用券失效接口
	 * 
	 * @param username
	 *            用户名
	 * @param password
	 *            密码
	 * @param couponNo
	 *            使用的抵用券交易号
	 * @return 100：交易成功、101：抵扣券号码不存在、102：抵扣券已过期、103 : 抵用券已取消、104 :
	 *         订单状态错误、110：用户名密码错误
	 *         、111：用户session无效、112：终端机session无效、113：系统级异常、120:
	 *         订单系统数据错误、121:用户被锁定
	 */
	@POST
	@Path("redeem/cancel")
	@Consumes({ MediaType.APPLICATION_FORM_URLENCODED })
	@Produces({ MediaType.TEXT_HTML })
	public String redeemCancel(@FormParam("username") String username,
			@FormParam("password") String password,
			@FormParam("couponNo") List<String> couponNumbers) {

		logger.info(
				"entrance redeemCancel username={}, password={}, couponNo={}",
				new Object[] { username, password, couponNumbers });

		// exchangeLog
		ExchangeLog exchangeLog = new ExchangeLog();
		exchangeLog.createdAt = SystemTimeProvider.getCurrentTime();
		exchangeLog.operation = "expire";

		String response = "100";
		try {
			response = couponService.expireCoupon(couponNumbers);
		} catch (IllegalStateException e1) {
			response = e1.getMessage();
			exchangeLog.returnCode = response;
			logExchange(exchangeLog, couponNumbers);
		} catch (Exception e) {
			response = "113";
			exchangeLog.returnCode = response;
			logExchange(exchangeLog, couponNumbers);
		}
		return response;
	}

	public String getRequestURL(HttpServletRequest req) {
		StringBuffer url = new StringBuffer();
		String scheme = req.getScheme();
		int port = req.getServerPort();
		String urlPath = req.getRequestURI();

		url.append(scheme); // http, https
		url.append("://");
		url.append(req.getServerName());
		if ((scheme.equals("http") && port != 80)
				|| (scheme.equals("https") && port != 443)) {
			url.append(':');
			url.append(req.getServerPort());
		}

		url.append(urlPath);
		return url.toString();
	}

	private String getPicPrefix(HttpServletRequest request) {
		StringBuffer url = new StringBuffer();
		String scheme = request.getScheme();
		int port = request.getServerPort();
		String urlPath = request.getRequestURI();

		url.append(scheme); // http, https
		url.append("://");
		url.append(request.getServerName());
		if ((scheme.equals("http") && port != 80)
				|| (scheme.equals("https") && port != 443)) {
			url.append(':');
			url.append(request.getServerPort());
		}
		logger.info(urlPath);
		url.append(urlPath.substring(0, urlPath.indexOf('/', 1))).append(
				"/ishelf/getPic/");

		return url.toString();
	}

	protected void logExchange(ExchangeLog log, List<String> coupon) {
		for (String cp : coupon) {
			if (StringUtils.isNotEmpty(cp)) {
				log.couponNo = cp;
				exchangeLogMapper.insert(log);
			}
		}
	}
}
