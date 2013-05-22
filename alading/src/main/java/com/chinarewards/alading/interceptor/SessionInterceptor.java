package com.chinarewards.alading.interceptor;

import java.util.Map;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.Interceptor;

public class SessionInterceptor implements Interceptor {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4773887757730729789L;

	@Override
	public void destroy() {

	}

	@Override
	public void init() {

	}

	@Override
	public String intercept(ActionInvocation invocation) throws Exception {
		
		Map<String, Object> session = invocation.getInvocationContext().getSession();
		if(session.get("username") == null){
			return  "index";
		} else {
			return invocation.invoke();
		}
	}

}
