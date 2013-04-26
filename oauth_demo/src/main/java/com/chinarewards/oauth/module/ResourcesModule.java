package com.chinarewards.oauth.module;

import java.util.HashMap;
import java.util.Map;

import com.chinarewards.oauth.resources.AppRegResource;
import com.google.inject.servlet.ServletModule;
import com.sun.jersey.guice.spi.container.servlet.GuiceContainer;

public class ResourcesModule extends ServletModule {
	
	@Override
	protected void configureServlets() {
		
		bind(AppRegResource.class);
		
		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("com.sun.jersey.config.property.packages", "com.chinarewards.oauth.resources");
		serve("/ws/*").with(GuiceContainer.class, parameters);
	}
}
