package com.chinarewards.oauth.module;

import com.chinarewards.oauth.log.Slf4jTypeListener;
import com.google.inject.AbstractModule;
import com.google.inject.matcher.Matchers;

public class LoggerModule extends AbstractModule {

	@Override
	protected void configure() {
		bindListener(Matchers.any(), new Slf4jTypeListener());
	}

}
