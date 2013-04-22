package com.ssh.base;

import java.io.Serializable;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import com.googlecode.genericdao.dao.hibernate.GenericDAOImpl;

@SuppressWarnings("hiding")
public class BaseDAO<BaseEntity, ID extends Serializable> extends
		GenericDAOImpl<BaseEntity, ID> {
	@Autowired
	public void setSessionFactory(SessionFactory sessionFactory) {
		super.setSessionFactory(sessionFactory);
	}

}