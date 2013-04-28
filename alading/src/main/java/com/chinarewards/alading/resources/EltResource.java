package com.chinarewards.alading.resources;

import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.slf4j.Logger;

import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.response.LoginRes;
import com.chinarewards.alading.response.MemberInfo;
import com.chinarewards.alading.response.PicUrlList;
import com.chinarewards.alading.service.AppRegisterService;
import com.google.inject.Inject;

@Path("/")
public class EltResource {

	@InjectLogger
	private Logger logger;

	@Inject
	private AppRegisterService appRegisterService;

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
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
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
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	public LoginRes login(@FormParam("terminalId") String terminalId,
			@FormParam("username") String username,
			@FormParam("password") String password) {

		logger.info("entrance login terminalId={}, username={}, password={}",
				new Object[] { terminalId, username, password });

		LoginRes loginRes = new LoginRes();

		if (null != username && null != password && username.equals("iShelf")
				&& password.equals("iShelf")) {

			// TODO
		} else {
			// throw Exceltion ?
		}

		return loginRes;
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
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
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

}
