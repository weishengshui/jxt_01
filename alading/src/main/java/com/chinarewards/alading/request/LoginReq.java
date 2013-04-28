package com.chinarewards.alading.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class LoginReq implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1385952778623758423L;

	private String terminalId; // 终端机ID
	private String username; // 用户名
	private String password; // 密码

	public String getTerminalId() {
		return terminalId;
	}

	public void setTerminalId(String terminalId) {
		this.terminalId = terminalId;
	}

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
