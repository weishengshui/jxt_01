package com.ssh.action;

import java.security.NoSuchAlgorithmException;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

import com.ssh.util.SecurityUtil;
import com.ssh.base.BaseAction;
import com.ssh.entity.TblQyyg;
import com.ssh.service.QyygService;

@Controller
@Results( { @Result(name = "success", location = "/jsp/base/index.jsp"),
		@Result(name = "failed", location = "/index.jsp") })
public class LoginAction extends BaseAction {
	private static final long serialVersionUID = 7091212937558144242L;
	private static Logger logger = Logger
			.getLogger(LoginAction.class.getName());
	
	@Resource
	private QyygService qyygService;
	
	private String userId;
	private String password;
	private String failedinfo;
	private TblQyyg user;
	

	public String getUserId() {
		return userId;
	}

	public void setUser(TblQyyg user) {
		this.user = user;
	}

	public TblQyyg getUser() {
		return user;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getPassword() {
		return password;
	}

	public void setFailedinfo(String failedinfo) {
		this.failedinfo = failedinfo;
	}

	public String getFailedinfo() {
		return failedinfo;
	}
	
	public String list() {
		TblQyyg tyg = (TblQyyg) session.get("user");
		setUser(tyg);
		return SUCCESS;
	}
	
	public String execute() {
		if (userId == null || userId.equals("")) {
			return "failed";
		}
		
		TblQyyg user = qyygService.findByEmail(userId);
		if (user == null) {
			this.setFailedinfo("登录失败");
			return "failed";
		}
		String md5pwd = "";
		try {
			md5pwd = SecurityUtil.md5(password);
		} catch (NoSuchAlgorithmException e) {
			logger.error("LoginAction:", e);
		}
		if (user.getDlmm()!=null&&user.getDlmm().equals(md5pwd)) {
			this.session.put("user", user);
			this.setUser(user);
			return SUCCESS;
		}
		this.setFailedinfo("登录失败");
		return "failed";
	}
}
