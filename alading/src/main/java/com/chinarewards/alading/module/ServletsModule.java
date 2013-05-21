package com.chinarewards.alading.module;

import java.util.HashMap;
import java.util.Map;

import org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter;

import com.chinarewards.alading.card.servlet.CardCheckServlet;
import com.chinarewards.alading.card.servlet.CardServlet;
import com.chinarewards.alading.card.servlet.CompanyListServlet;
import com.chinarewards.alading.filter.SessionFilter;
import com.chinarewards.alading.image.servlet.CardImageGetServlet;
import com.chinarewards.alading.image.servlet.CardImageListServlet;
import com.chinarewards.alading.image.servlet.CardImageUpdateServlet;
import com.chinarewards.alading.image.servlet.CardImageUploadServlet;
import com.chinarewards.alading.servlet.LoginServlet;
import com.chinarewards.alading.servlet.LogoutServlet;
import com.chinarewards.alading.unit.servlet.UnitJsonServlet;
import com.chinarewards.alading.unit.servlet.UnitServlet;
import com.google.inject.Scopes;
import com.google.inject.servlet.ServletModule;

public class ServletsModule extends ServletModule {

	@Override
	protected void configureServlets() {
		
		// session filter 
		Map<String, String> params = new HashMap<String, String>();
		// 定义要拦截的目录，目录之间用","隔开 
		params.put("include", "view");
		filter("/*").through(SessionFilter.class, params);
		
		// login logout servlet
		serve("/login").with(LoginServlet.class);
		serve("/view/logout").with(LogoutServlet.class);
		
		bind(StrutsPrepareAndExecuteFilter.class).in(Scopes.SINGLETON);
		filter("*.do").through(StrutsPrepareAndExecuteFilter.class);
		filter("/").through(StrutsPrepareAndExecuteFilter.class);

		// card image servlet
//		serve("/view/cardImageUpload").with(CardImageUploadServlet.class);
//		serve("/view/cardImageList").with(CardImageListServlet.class);
//		serve("/view/cardImageGet/*").with(CardImageGetServlet.class);
//		serve("/view/cardImageUpdate").with(CardImageUpdateServlet.class);
		// unit servlet
//		serve("/view/unitShow").with(UnitServlet.class);
//		serve("/view/unitJson").with(UnitJsonServlet.class);
		// card servlet
//		serve("/view/card").with(CardServlet.class);
//		serve("/view/companyList").with(CompanyListServlet.class);
//		serve("/view/cardCheck").with(CardCheckServlet.class);
	}
}
