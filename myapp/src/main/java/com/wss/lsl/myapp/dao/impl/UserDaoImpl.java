package com.wss.lsl.myapp.dao.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.wss.lsl.myapp.dao.UserDao;
import com.wss.lsl.myapp.model.User;

public class UserDaoImpl implements UserDao {

	private long id = 0l;
	List<User> users = new ArrayList<User>();

	public UserDaoImpl() {

		try {
			save(new User("zhangsan", "657620636@qq.com", new Date()));
			Thread.sleep(1000);
			save(new User("lisi", "71456895241@qq.com", new Date()));
			Thread.sleep(1000);
			save(new User("wangwu", "9985412451@qq.com", new Date()));
		} catch (InterruptedException e) {
		}
	}

	@Override
	public List<User> findAllUsers() {

		return users;
	}

	@Override
	public User find(long id) {

		for (User user : users) {
			if (user.getId() == id) {
				return user;
			}
		}

		return null;
	}

	@Override
	public void save(User user) {

		if (null != user) {
			user.setId(id++);
			users.add(user);
		}
	}

	@Override
	public void delete(User user) {
		users.remove(user);
	}

	@Override
	public User findUserByName(String name) {

		for (User user : users) {
			if (null != name && name.equals(user.getName())) {
				return user;
			}
		}

		return null;
	}

}
