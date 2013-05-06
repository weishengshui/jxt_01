package com.chinarewards.alading.module;

import com.chinarewards.alading.service.CompanyCardService;
import com.chinarewards.alading.service.CouponService;
import com.chinarewards.alading.service.FileItemService;
import com.chinarewards.alading.service.ICompanyCardService;
import com.chinarewards.alading.service.ICouponService;
import com.chinarewards.alading.service.IFileItemService;
import com.chinarewards.alading.service.IMemberService;
import com.chinarewards.alading.service.MemberService;
import com.google.inject.Binder;
import com.google.inject.Module;
import com.google.inject.Scopes;

public class ServiceModule implements Module {

	@Override
	public void configure(Binder binder) {
		binder.bind(IFileItemService.class).to(FileItemService.class).in(Scopes.SINGLETON);
		binder.bind(ICompanyCardService.class).to(CompanyCardService.class).in(Scopes.SINGLETON);
		binder.bind(IMemberService.class).to(MemberService.class).in(Scopes.SINGLETON);
		binder.bind(ICouponService.class).to(CouponService.class).in(Scopes.SINGLETON);
	}

}
