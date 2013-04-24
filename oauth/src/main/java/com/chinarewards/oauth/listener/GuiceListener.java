package com.chinarewards.oauth.listener;

import com.chinarewards.oauth.Application;
import com.google.inject.Injector;
import com.google.inject.servlet.GuiceServletContextListener;

public class GuiceListener extends GuiceServletContextListener {
	
	@Override
	protected Injector getInjector() {
		Injector injector =null; 
		try {
			injector = new Application().setupMyBatisGuice(Application.PRODUCTION_DATABASE_PROPERTIES);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return injector;
	}

}
