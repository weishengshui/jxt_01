package com.wss.lsl.addressbook.entities;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import org.apache.tapestry5.beaneditor.NonVisual;
import org.apache.tapestry5.beaneditor.Validate;

import com.wss.lsl.addressbook.model.Honorific;

@Entity
public class Address {
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@NonVisual
	public Long id;
	
	@Enumerated(EnumType.STRING)
	public Honorific honorific;
	@Validate("required, minLength=5, maxLength=10")
	public String firstName;

	public String lastName;

	public String street1;

	public String street2;

	public String city;

	public String state;
	@Validate("regexp")
	public String zip;

	public String email;

	public String phone;
}