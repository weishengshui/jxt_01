package com.ssh.interceptor;

import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;
import com.ssh.action.CxhdjAction;
import com.ssh.action.LoginAction;
import com.ssh.action.PjjAction;
import com.ssh.action.SpAction;
import com.ssh.action.SpjAction;
import com.ssh.entity.TblQyyg;
import java.util.Map;

public class SessionInterceptor extends AbstractInterceptor {
	private static final long serialVersionUID = -6730910068175278870L;

	public String intercept(ActionInvocation invocation) throws Exception {
		ActionContext ctx = ActionContext.getContext();
		Map session = ctx.getSession();
		Action action = (Action) invocation.getAction();
		if (((action instanceof LoginAction)) || ((action instanceof SpAction))
				|| ((action instanceof SpjAction))
				|| ((action instanceof CxhdjAction))
				|| ((action instanceof PjjAction))) {
			return invocation.invoke();
		}
		TblQyyg user = (TblQyyg) session.get("user");
		if ((user != null) && (user.getNid() != null)) {
			return invocation.invoke();
		}
		if (session.get("hrqyjf") != null) {
			return invocation.invoke();
		}
		return "login";
	}
}