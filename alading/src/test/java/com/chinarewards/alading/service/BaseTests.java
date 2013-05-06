package com.chinarewards.alading.service;

import com.chinarewards.alading.Application;
import com.google.inject.Injector;

public class BaseTests {

	protected Injector injector;

	public void setUp() throws Exception {
		injector = new Application().setupMyBatisGuice();
	}

	public void tearDown() throws Exception {
		injector = null;
	}

}
