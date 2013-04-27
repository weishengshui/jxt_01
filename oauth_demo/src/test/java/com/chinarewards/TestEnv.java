package com.chinarewards;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;

import com.chinarewards.oauth.Application;
import com.chinarewards.oauth.domain.Author;
import com.chinarewards.oauth.domain.Blog;
import com.chinarewards.oauth.domain.User;
import com.chinarewards.oauth.service.AppRegisterService;
import com.chinarewards.oauth.service.IBlogService;
import com.chinarewards.oauth.service.IUserService;
import com.google.inject.Injector;

public class TestEnv {

	private Injector injector;
	private IUserService userService;
	private IBlogService blogService;

	@Before
	public void setupMyBatisGuice() throws Exception {
		injector = new Application().setupMyBatisGuice();
		userService = injector.getInstance(IUserService.class);
		blogService = injector.getInstance(IBlogService.class);
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
		assertNull(user.getValid());
		
		user = userService.findUserById(1);
		assertNotNull(user);
		assertEquals("王思思", user.getName());
		
		user = new User();
		user.setName("lsl");
		user.setValid(true);
		userService.createUser(user);
		user = userService.findUserById(user.getId());
		assertTrue(user.getValid());
		
		user = new User();
		user.setName("lsl2");
		user.setValid(false);
		userService.createUser(user);
		user = userService.findUserById(user.getId());
		assertFalse(user.getValid());
		
		List<User> list = userService.findAllUser();
		assertEquals(6, list.size());
		
		List<Integer> list2 = new ArrayList<Integer>();
		list2.add(1);
		list2.add(2);
		list2.add(3);
		list2.add(8);
		int count = userService.batchDelete(list2);
		assertEquals(3, count);
		
		
		Boolean boolean1 = new Boolean(null);
		assertFalse(boolean1);
		boolean1 = new Boolean(false);
		assertFalse(boolean1);
		boolean1 = new Boolean(true);
		assertTrue(boolean1);
		assertTrue(boolean1 == true);
		Boolean boolean2 = new Boolean(true);
//		assertTrue(boolean1 == boolean2);
		Integer integer = new Integer(1);
		assertTrue(integer == 1);
		
//		ExecutorService  executorService = Executors.newFixedThreadPool(200);
//		// 高并发插入数据，检测主键自增长是否线程安全
//		for(int i = 0; i < 200; i++){
//			executorService.execute(new AddUserThread(userService, "wss"+i));
//		}
//		
//		executorService.shutdown();
	}
	
	@Test
	public void testBlogService(){
		Author author = new Author();
		author.setAuthor_name("wss");
		Blog blog = new Blog();
		blog.setBlog_name("blog123");
		blog.setAuthor(author);
		
		blogService.create(blog);
		
		blog = blogService.findById(1);
		assertNotNull(blog);
		assertNull(blog.getAuthor());
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
