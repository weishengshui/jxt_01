package com.wss.lsl.addressbook.dao;

import java.util.List;

import com.wss.lsl.addressbook.model.User;

public interface UserDao {
	
	List<User> findAllUsers();
	
	User find(long id);
	
	void save(User user);
	
	void delete(User user);
	
	User findUserByName(String name);
	
}
