package com.chinarewards.alading.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;

import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.ILoginService;
import com.google.inject.Inject;
import com.google.inject.Singleton;

@Singleton
public class LoginServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7499199565024373345L;

	@InjectLogger
	private Logger logger;
	@Inject
	private ILoginService loginService;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) resp;

		String username = request.getParameter("username");
		String password = request.getParameter("password");
		if (StringUtils.isNotEmpty(username)
				&& StringUtils.isNotEmpty(password)
				&& loginService.checkUsernamePassword(username, password)) {
			request.getSession().setAttribute("username", username);
			response.sendRedirect(request.getContextPath() + "/view/index.jsp");
		} else {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
		}
	}

}
