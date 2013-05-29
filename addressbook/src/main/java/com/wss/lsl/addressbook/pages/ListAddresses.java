package com.wss.lsl.addressbook.pages;

import java.util.List;

import org.apache.tapestry5.ioc.annotations.Inject;
import org.hibernate.Session;
import org.slf4j.Logger;

import com.wss.lsl.addressbook.entities.Address;

public class ListAddresses {

	@Inject
	private Logger logger;
	@Inject
	private Session session;
	
	@SuppressWarnings("unchecked")
	public List<Address> getAddresses(){
		logger.info("getAddresses");
		return session.createCriteria(Address.class).list();
	}

}
