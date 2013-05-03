package com.chinarewards.alading.module;

import java.util.HashMap;
import java.util.Map;

import com.chinarewards.alading.resources.EltResource;
import com.google.inject.servlet.ServletModule;
import com.sun.jersey.guice.spi.container.servlet.GuiceContainer;

public class ResourcesModule extends ServletModule {
	
	@Override
	protected void configureServlets() {
		
		bind(EltResource.class);
		
		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("com.sun.jersey.config.property.packages", "com.chinarewards.alading.resources");
		serve("/ishelf/*").with(GuiceContainer.class, parameters);
	}
}
