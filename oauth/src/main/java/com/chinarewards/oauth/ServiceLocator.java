package com.chinarewards.oauth;

import com.chinarewards.oauth.service.AppRegisterService;
import com.google.inject.Injector;

public class ServiceLocator {

	private final Injector injector;

	private static ServiceLocator instance;

	private ServiceLocator(Injector injector) {
		this.injector = injector;
	}

	public static void init(Injector injector) {
		if (instance == null) {
			instance = new ServiceLocator(injector);
		}
	}
	
	public static ServiceLocator getInstance() {
		return instance;
	}

	public AppRegisterService getAppRegisterService() {
		return injector.getInstance(AppRegisterService.class);
	}
}
