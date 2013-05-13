package com.chinarewards.alading.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;

import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.ILoginService;
import com.google.inject.Inject;
import com.google.inject.Singleton;

@Singleton
public class LogoutServlet extends HttpServlet {

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

		doGet(req, resp);
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		HttpSession session = req.getSession(false);
		if(null != session){
			session.invalidate();
		}
		resp.sendRedirect(req.getContextPath() + "/login.jsp");
	}

}
