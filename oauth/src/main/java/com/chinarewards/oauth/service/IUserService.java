package com.chinarewards.oauth.service;

import com.chinarewards.oauth.domain.User;

public interface IUserService {
	
	User createUser(User user);
	
	User updateUser(User user);
	
	User findUserById(String id);
	
	void deleteUser(User user);
}
