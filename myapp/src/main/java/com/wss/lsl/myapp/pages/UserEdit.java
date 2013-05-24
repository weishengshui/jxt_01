package com.wss.lsl.myapp.pages;

import org.apache.tapestry5.annotations.Component;
import org.apache.tapestry5.corelib.components.BeanEditForm;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.slf4j.Logger;

import com.wss.lsl.myapp.dao.UserDao;
import com.wss.lsl.myapp.model.User;

public class UserEdit {
	
	@Inject
	private Logger logger;
	@Inject
	private UserDao userDao;
	private User user = null;
	private long userId;

	@Component
	private BeanEditForm form;

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public void onActivate(long id) {
		if (id > 0) {// update
			this.user = userDao.find(id);
			this.userId = id;
		} else { // insert
			this.user = new User();
			this.userId = 0;
		}
	}

	public long onPassivate() {
		return userId;
	}

	public void onValidateFromForm() {
		logger.info("user name={}", user.getName());
		User anotherUser = userDao.findUserByName(user.getName());
		if (null != anotherUser && anotherUser.getId() != user.getId()) {
			form.recordError("用户名已存在");
		}
	}

	public Object onSuccess() {
		userDao.save(user);

		return Start.class;
	}

}
