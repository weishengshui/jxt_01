package com.wss.lsl.myapp.model;

import java.util.Date;

import org.apache.tapestry5.beaneditor.NonVisual;

public class User {

//	@NonVisual
	private long id;
	private String name;
	private String email;
	private Date birthday;
	private Role role = Role.GUEST;

	public User() {
	}

	public User(String name, String email, Date birthday) {
		this.name = name;
		this.email = email;
		this.birthday = birthday;
	}
	
	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getBirthday() {
		return birthday;
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}

	public Role getRole() {
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}

}
