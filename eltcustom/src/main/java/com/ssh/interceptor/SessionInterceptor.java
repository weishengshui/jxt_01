package com.ssh.interceptor;

import java.util.Map;

import javax.annotation.Resource;


import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import com.ssh.action.LoginAction;
import com.ssh.entity.TblQyyg;

public class SessionInterceptor extends AbstractInterceptor {

	private static final long serialVersionUID = -6730910068175278870L;

	public String intercept(ActionInvocation invocation) throws Exception {
		ActionContext ctx = ActionContext.getContext();
		Map<String, Object> session = ctx.getSession();
		Action action = (Action) invocation.getAction();
		if (action instanceof LoginAction) {
			return invocation.invoke();
		}
		TblQyyg user = (TblQyyg) session.get("user");
		if (user!=null&&user.getNid() != null) {
			return invocation.invoke();
		}
		return Action.LOGIN;
	}

}