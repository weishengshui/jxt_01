package com.chinarewards.oauth;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.google.inject.Injector;

public class MyGuiceServletContextListener implements ServletContextListener  {


	@Override
	public void contextInitialized(ServletContextEvent sce) {
		try {
			Injector injector = new Application().setupMyBatisGuice();
			ServiceLocator.init(injector);
		} catch (Exception e) {
			throw new IllegalStateException("Guice setup error happended!", e);
		}
		
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		// TODO Auto-generated method stub
		
	}

}
