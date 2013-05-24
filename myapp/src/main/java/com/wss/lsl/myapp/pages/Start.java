package com.wss.lsl.myapp.pages;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.tapestry5.Block;
import org.apache.tapestry5.beaneditor.BeanModel;
import org.apache.tapestry5.internal.services.MapMessages;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.services.BeanModelSource;
import org.apache.tapestry5.services.ComponentSource;

import com.wss.lsl.myapp.dao.UserDao;
import com.wss.lsl.myapp.model.User;

public class Start {
	
	@Inject
	private Block userDetails;
	
	@Inject
	private UserDao userDao;
	@Inject
	private BeanModelSource beanModelSource;

	private User user;
	private User detailUser;
	

	public User getDetailUser() {
		return detailUser;
	}

	public List<User> getUsers() {
		return userDao.findAllUsers();
	}

	public BeanModel<User> getModel() {
		
		BeanModel<User> model = beanModelSource.createDisplayModel(User.class,
				new MapMessages(Locale.CHINA, new HashMap<String, String>()));
		model.addEmpty("delete");
		model.addEmpty("view");
		return model;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public void onActionFromDelete(long id) {
		user = userDao.find(id);
		if (null != user) {
			userDao.delete(user);
		}
	}
	
	public Block onActionFromView(long id) {
		detailUser = userDao.find(id);
		return userDetails;
	}

}
