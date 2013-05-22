package com.chinarewards.alading.module;

import org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter;

import com.google.inject.Scopes;
import com.google.inject.servlet.ServletModule;

public class ServletsModule extends ServletModule {

	@Override
	protected void configureServlets() {
		
		/*// session filter 
		Map<String, String> params = new HashMap<String, String>();
		// 定义要拦截的目录，目录之间用","隔开 
		params.put("include", "view");
		filter("/*").through(SessionFilter.class, params);
		
		// login logout servlet
		serve("/login").with(LoginServlet.class);
		serve("/view/logout").with(LogoutServlet.class);*/
		
		bind(StrutsPrepareAndExecuteFilter.class).in(Scopes.SINGLETON);
		filter("*.do").through(StrutsPrepareAndExecuteFilter.class);
		filter("/").through(StrutsPrepareAndExecuteFilter.class);
	}
}
