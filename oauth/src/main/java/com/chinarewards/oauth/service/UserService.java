package com.chinarewards.oauth.service;

import org.mybatis.guice.transactional.Transactional;
import org.slf4j.Logger;

import com.chinarewards.oauth.domain.User;
import com.chinarewards.oauth.log.InjectLogger;
import com.chinarewards.oauth.reg.mapper.UserMapper;
import com.google.inject.Inject;

public class UserService implements IUserService {
	
	@InjectLogger
	private Logger logger;
	
	@Inject
	private UserMapper userManager;
	
	@Override
	public User createUser(User user) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public User updateUser(User user) {
		// TODO Auto-generated method stub
		return null;
	}

	@Transactional
	@Override
	public User findUserById(String id) {
		logger.info("id={}", id);
		return userManager.getUser(id);
	}

	@Override
	public void deleteUser(User user) {
		// TODO Auto-generated method stub

	}

}
