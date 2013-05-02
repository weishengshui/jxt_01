package com.chinarewards.alading.resources;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
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

import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.response.MemberInfo;
import com.chinarewards.alading.response.PicUrlList;
import com.chinarewards.alading.service.AppRegisterService;
import com.chinarewards.alading.service.IFileItemService;
import com.google.inject.Inject;

@Path("/")
public class EltResource {

	@InjectLogger
	private Logger logger;

	@Inject
	private AppRegisterService appRegisterService;
	
	@Inject
	private IFileItemService fileItemService;

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
			@FormParam("password") String password) {

		logger.info("entrance obtainPicUrlList username={}, password={}",
				new Object[] { username, password });

		PicUrlList picUrlList = new PicUrlList();

		if (null != username && null != password && username.equals("admin")
				&& password.equals("password")) {

			List<String> urlList = new ArrayList<String>();
			urlList.add("http://www.baidu.com/pic1.jpg");
			urlList.add("http://www.baidu.com/pic2.jpg");
			urlList.add("http://www.baidu.com/pic3.jpg");

			// TODO

			picUrlList.setPicUrl(urlList);
		} else {
			// throw Exceltion ?
		}

		return picUrlList;
	}
	
	// just for test
	@POST
	@Path("putPic")
	@Consumes({ MediaType.MULTIPART_FORM_DATA })
	@Produces({ MediaType.TEXT_HTML })
	public String putPic(@FormParam("pic") byte[] pic) {

		logger.info("entrance putPic pic={}",
				new Object[] { pic });
		
		FileItem fileItem = new FileItem();
		fileItem.setContent(pic);
		fileItemService.save(fileItem);
			
		return "成功";
	}
	
	
	@GET
	@Path("getPic/{id}")
	@Produces({MediaType.APPLICATION_OCTET_STREAM})
	public void getPic(@PathParam("id") Integer  id, @Context HttpServletResponse response) {

		logger.info("entrance getPic picId={}",
				new Object[] { id });
		
		FileItem fileItem = fileItemService.findFileItemById(id);
		logger.info("getPic content={}",
				new Object[] { fileItem.getContent() });
		//		HttpRequest request = context.
		byte[] content = fileItem.getContent();
		if(null != content && content.length > 0){
			try {
				response.setContentType("image/jpg");
				response.setContentLength(content.length);
				response.setHeader("Content-Disposition", "inline; filename=\""
						+ "123.jpg" + "\"");
				byte[] bbuf = new byte[1024];
				ByteArrayInputStream in = new ByteArrayInputStream(content);
				int bytes = 0;
				ServletOutputStream op = response.getOutputStream();
				while ((in != null) && ((bytes = in.read(bbuf)) != -1)) {
					op.write(bbuf, 0, bytes);
				}
				in.close();
				op.flush();
				op.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
//		return "success";
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
			@FormParam("mobileNo") String mobileNo) {

		logger.info(
				"entrance memberInfo terminalSession={}, mobileNo={}, password={}",
				new Object[] { terminalSession, mobileNo });

		MemberInfo memberInfo = new MemberInfo();

		// TODO

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
			@FormParam("accountId") String accountId,
			@FormParam("pointId") String pointId,
			@FormParam("amount") Integer amount,
			@FormParam("terminalId") String terminalId,
			@FormParam("terminalAddress") String terminalAddress,
			@FormParam("transactionDate") String transactionDate,
			@FormParam("couponNo") String couponNo) {

		logger.info(
				"entrance redeemApply terminalSession={}, sessionId={}, accountId={}, pointId={}, amount={}, terminalId={}, terminalAddress={}, transactionDate={}, couponNo={}",
				new Object[] { terminalSession, sessionId, accountId, pointId,
						amount, terminalId, terminalAddress, transactionDate,
						couponNo });

		String response = "100";
		// TODO

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
			@FormParam("couponNo") String couponNo) {

		logger.info(
				"entrance redeemAccept username={}, password={}, terminalId={}, merchantName={}, merchantAddress={}, transactionDate={}, transactionNo={}, couponNo={}",
				new Object[] { username, password, terminalId, merchantName,
						merchantAddress, transactionDate, transactionNo,
						couponNo });

		String response = "100";
		// TODO

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
			@FormParam("couponNo") String couponNo) {

		logger.info("entrance redeemCancel username={}, couponNo={}",
				new Object[] { username, password, couponNo });

		String response = "100";
		if (!StringUtils.isEmpty(username) && !StringUtils.isEmpty(password)
				&& username.equals("ishelf") && password.equals("ishelf")) {
			// TODO

		} else {
			response = "110";
		}

		return response;
	}

}
