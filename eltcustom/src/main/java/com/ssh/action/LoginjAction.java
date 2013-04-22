package com.ssh.action;

import org.springframework.stereotype.Controller;

@Controller
public class LoginjAction extends JsonAction {
	private static final long serialVersionUID = -7819310705806215032L;

	public String logout(){
		this.session.clear();
		setResult(null);
		return SUCCESS;
	}
}
