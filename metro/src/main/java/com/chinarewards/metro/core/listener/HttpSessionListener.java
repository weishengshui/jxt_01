package com.chinarewards.metro.core.listener;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.service.system.ISysLogService;

public class HttpSessionListener implements
		javax.servlet.http.HttpSessionListener {

	@Override
	public void sessionCreated(HttpSessionEvent se) {
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {

		try {
			HttpSession session = se.getSession();

			ApplicationContext ctx = WebApplicationContextUtils
					.getRequiredWebApplicationContext(session
							.getServletContext());
			ISysLogService sysLogService = (ISysLogService) ctx
					.getBean("sysLogService");
			String username = (String) session
					.getAttribute(UserContext.USER_NAME);
			if (null != username) {
				sysLogService.addSysLog(username, "系统管理", username,
						OperationEvent.EVENT_LOGOUT.getName(), "成功");
			}
		} catch (Exception e) {
		}

	}

}
