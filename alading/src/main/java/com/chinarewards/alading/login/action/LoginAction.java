package com.chinarewards.alading.login.action;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;

import com.chinarewards.alading.action.BaseAction;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.ILoginService;
import com.google.inject.Inject;
import com.opensymphony.xwork2.ActionContext;

public class LoginAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3748698365503837835L;

	private String username;
	private String password;

	@InjectLogger
	private Logger logger;
	@Inject
	private ILoginService loginService;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String login() throws Exception {
		if (StringUtils.isNotEmpty(username)
				&& StringUtils.isNotEmpty(password)
				&& loginService.checkUsernamePassword(username, password)) {

			session.put("username", username);
			ActionContext.getContext().getSession();
			
			return "success";
		} else {
			return "failure";
		}
	}

}
