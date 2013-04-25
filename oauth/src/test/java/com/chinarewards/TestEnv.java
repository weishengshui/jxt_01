package com.chinarewards;

import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;

import com.chinarewards.oauth.Application;
import com.chinarewards.oauth.domain.User;
import com.chinarewards.oauth.service.AppRegisterService;
import com.chinarewards.oauth.service.IUserService;
import com.chinarewards.oauth.service.UserService;
import com.google.inject.Injector;

public class TestEnv {

	private Injector injector;

	@Before
	public void setupMyBatisGuice() throws Exception {
		injector = new Application().setupMyBatisGuice(Application.TEST_DATABASE_PROPERTIES);
	}
	
	
	@Test
	public void testFooService() {

		AppRegisterService appService = injector
				.getInstance(AppRegisterService.class);
		String result = appService.register("app10001", "77854120",
				"sdl2323232_we4ssf45");
		assertEquals(result, "002");
	}
	
	@Test
	public void testUserService(){
		
		IUserService userService = injector.getInstance(IUserService.class);
		User user = userService.findUserById(1);
		assertNotNull(user);
		assertEquals("Pocoyo", user.getName());
		
		user = new User();
		user.setId(1);
		user.setName("wss");
		userService.updateUser(user);
		
		user = userService.findUserById(1);
		assertNotNull(user);
		assertEquals("wss", user.getName());
		
		user = new User();
		user.setName("lsl");
		userService.createUser(user);
		
		user = new User();
		user.setName("lsl2");
		userService.createUser(user);
		
	}

}