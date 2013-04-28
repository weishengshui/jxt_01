package com.chinarewards.alading.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class ObtainPicListReq implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7758859785579890531L;

	private String username; // 用户名
	private String password; // 密码

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

}
