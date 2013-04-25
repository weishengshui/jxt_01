package com.chinarewards.oauth.service;

import com.chinarewards.oauth.domain.User;

public interface IUserService {
	
	void createUser(User user);
	
	void updateUser(User user);
	
	User findUserById(Integer id);
	
	void deleteUser(User user);
	
	void deleteAll();
}
