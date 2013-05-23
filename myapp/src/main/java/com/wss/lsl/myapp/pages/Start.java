package com.wss.lsl.myapp.pages;

import java.util.List;

import org.apache.tapestry5.beaneditor.BeanModel;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.services.BeanModelSource;
import org.apache.tapestry5.services.ComponentSource;

import com.wss.lsl.myapp.dao.UserDao;
import com.wss.lsl.myapp.model.User;

public class Start {

	@Inject
	private UserDao userDao;
	@Inject
	private BeanModelSource beanModelSource;
	@Inject 
	private ComponentSource componentSource;
	
	private User user;

	public List<User> getUsers() {
		return userDao.findAllUsers();
	}
	
	public BeanModel<User> getModel(){
		BeanModel<User> model = beanModelSource.createDisplayModel(User.class, null);
		model.add("delete", null);
		
		return model;
	}
	
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

}
