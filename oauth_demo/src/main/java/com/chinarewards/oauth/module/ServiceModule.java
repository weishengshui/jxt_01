package com.chinarewards.oauth.module;

import com.chinarewards.oauth.service.AppRegisterService;
import com.chinarewards.oauth.service.AppRegisterServiceImpl;
import com.chinarewards.oauth.service.IUserService;
import com.chinarewards.oauth.service.UserService;
import com.google.inject.Binder;
import com.google.inject.Module;
import com.google.inject.Singleton;

public class ServiceModule implements Module {

	@Override
	public void configure(Binder binder) {
		binder.bind(IUserService.class).to(UserService.class).in(Singleton.class);
		binder.bind(AppRegisterService.class).to(AppRegisterServiceImpl.class).in(Singleton.class);
	}

}
