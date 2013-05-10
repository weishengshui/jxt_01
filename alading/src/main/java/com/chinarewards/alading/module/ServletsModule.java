package com.chinarewards.alading.module;

import com.chinarewards.alading.servlet.LoginServlet;
import com.google.inject.servlet.ServletModule;

public class ServletsModule extends ServletModule {
	
	
	@Override
	protected void configureServlets() {

		serve("/login").with(LoginServlet.class);
		
	}
}
