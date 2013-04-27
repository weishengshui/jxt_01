package com.chinarewards.oauth.service;

import java.util.List;

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
	private UserMapper userMapper;
	
	@Override
	public void createUser(User user) {
		
		userMapper.insert(user);
	}

	@Override
	public void updateUser(User user) {
		
		userMapper.update(user);
	}

	@Transactional
	@Override
	public User findUserById(Integer id) {
		logger.info("id={}", id);
		return userMapper.select(id);
	}

	@Override
	public void deleteUser(User user) {
		
	}

	@Override
	public void deleteAll() {
		userMapper.deleteAll();
	}

	@Override
	public List<User> findAllUser() {
		
		return userMapper.selectAll();
	}

	@Override
	public Integer batchDelete(List<Integer> list) {
		
		return userMapper.batchDelete(list);
	}

}
