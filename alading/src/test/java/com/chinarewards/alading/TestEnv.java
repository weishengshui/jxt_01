package com.chinarewards.alading;

import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;

import com.chinarewards.alading.service.AppRegisterService;
import com.google.inject.Injector;

public class TestEnv {

	private Injector injector;

	@Before
	public void setupMyBatisGuice() throws Exception {
		injector = new Application().setupMyBatisGuice();
	}

	@Test
	public void testFooService() {

		AppRegisterService appService = injector
				.getInstance(AppRegisterService.class);
		String result = appService.register("app10001", "77854120",
				"sdl2323232_we4ssf45");
		assertEquals(result, "002");
	}

}
