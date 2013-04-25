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
	private UserMapper mapper;
	
	@Override
	public void createUser(User user) {
		
		mapper.createUser(user);
	}

	@Override
	public void updateUser(User user) {
		
		mapper.updateUser(user);
	}

	@Transactional
	@Override
	public User findUserById(Integer id) {
		logger.info("id={}", id);
		return mapper.getUser(id);
	}

	@Override
	public void deleteUser(User user) {
		
	}

	@Override
	public void deleteAll() {
		mapper.deleteAll();
	}

}
