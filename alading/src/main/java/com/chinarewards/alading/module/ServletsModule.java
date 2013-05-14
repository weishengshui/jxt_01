package com.chinarewards.alading.module;

import com.chinarewards.alading.image.servlet.CardImageGetServlet;
import com.chinarewards.alading.image.servlet.CardImageListServlet;
import com.chinarewards.alading.image.servlet.CardImageUpdateServlet;
import com.chinarewards.alading.image.servlet.CardImageUploadServlet;
import com.chinarewards.alading.servlet.LoginServlet;
import com.chinarewards.alading.servlet.LogoutServlet;
import com.chinarewards.alading.unit.servlet.UnitServlet;
import com.google.inject.servlet.ServletModule;

public class ServletsModule extends ServletModule {
	
	
	@Override
	protected void configureServlets() {

		serve("/login").with(LoginServlet.class);
		serve("/view/logout").with(LogoutServlet.class);

		// card image
		serve("/view/cardImageUpload").with(CardImageUploadServlet.class);
		serve("/view/cardImageList").with(CardImageListServlet.class);
		serve("/view/cardImageGet/*").with(CardImageGetServlet.class);
		serve("/view/cardImageUpdate").with(CardImageUpdateServlet.class);
		serve("/view/unitShow").with(UnitServlet.class);
	}
}
