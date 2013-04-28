package com.chinarewards.alading.response;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class LoginRes implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8857625712188992384L;

	private String terminalSession; // 终端session ID

	public String getTerminalSession() {
		return terminalSession;
	}

	public void setTerminalSession(String terminalSession) {
		this.terminalSession = terminalSession;
	}

}
