package com.chinarewards;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;

import com.chinarewards.oauth.Application;
import com.chinarewards.oauth.domain.User;
import com.chinarewards.oauth.service.AppRegisterService;
import com.chinarewards.oauth.service.IUserService;
import com.google.inject.Injector;

public class TestEnv {

	private Injector injector;
	private IUserService userService;

	@Before
	public void setupMyBatisGuice() throws Exception {
		injector = new Application().setupMyBatisGuice();
		userService = injector.getInstance(IUserService.class);
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
		
		User user = userService.findUserById(1);
		assertNotNull(user);
		assertEquals("Pocoyo", user.getName());
		
		user = new User();
		user.setId(1);
		user.setName("王思思");
		userService.updateUser(user);
		
		user = userService.findUserById(1);
		assertNotNull(user);
		assertEquals("王思思", user.getName());
		
		user = new User();
		user.setName("lsl");
		user.setValid(true);
		userService.createUser(user);
		user = userService.findUserById(user.getId());
		assertTrue(user.isValid());
		
		user = new User();
		user.setName("lsl2");
		userService.createUser(user);
		user = userService.findUserById(user.getId());
		assertFalse(user.isValid());
		
//		ExecutorService  executorService = Executors.newFixedThreadPool(200);
//		// 高并发插入数据，检测主键自增长是否线程安全
//		for(int i = 0; i < 200; i++){
//			executorService.execute(new AddUserThread(userService, "wss"+i));
//		}
//		
//		executorService.shutdown();
	}
	
	class AddUserThread extends Thread{
		
		private IUserService userService;
		private String userName;
		
		public AddUserThread() {
		}
		
		public AddUserThread(IUserService userService, String userName) {
			this.userService = userService;
			this.userName = userName;
		}
		
		@Override
		public void run() {
			
			User user = new User();
			user.setName(this.userName);
			this.userService.createUser(user);
		}
	}

}
