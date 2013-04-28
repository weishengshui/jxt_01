package com.chinarewards.alading.module;

import com.chinarewards.alading.service.AppRegisterService;
import com.chinarewards.alading.service.AppRegisterServiceImpl;
import com.google.inject.Binder;
import com.google.inject.Module;
import com.google.inject.Singleton;

public class ServiceModule implements Module {

	@Override
	public void configure(Binder binder) {
		binder.bind(AppRegisterService.class).to(AppRegisterServiceImpl.class).in(Singleton.class);
	}

}
