package com.chinarewards.alading.module;

import com.chinarewards.alading.service.AppRegisterService;
import com.chinarewards.alading.service.AppRegisterServiceImpl;
import com.chinarewards.alading.service.FileItemService;
import com.chinarewards.alading.service.IFileItemService;
import com.google.inject.Binder;
import com.google.inject.Module;
import com.google.inject.Scopes;

public class ServiceModule implements Module {

	@Override
	public void configure(Binder binder) {
		binder.bind(AppRegisterService.class).to(AppRegisterServiceImpl.class).in(Scopes.SINGLETON);
		binder.bind(IFileItemService.class).to(FileItemService.class).in(Scopes.SINGLETON);
	}

}
