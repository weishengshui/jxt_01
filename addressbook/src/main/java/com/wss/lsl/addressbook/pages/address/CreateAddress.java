package com.wss.lsl.addressbook.pages.address;

import org.apache.tapestry5.annotations.InjectPage;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.hibernate.annotations.CommitAfter;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.hibernate.Session;

import com.wss.lsl.addressbook.entities.Address;
import com.wss.lsl.addressbook.pages.ListAddresses;

public class CreateAddress {
	
	@Property
	private Address address;
	
	@Inject
	private Session session;
	
	@InjectPage
	private ListAddresses index;
	
	@CommitAfter
	public Object onSuccess(){
		
		session.persist(address);
		
		return index;
	}
}
