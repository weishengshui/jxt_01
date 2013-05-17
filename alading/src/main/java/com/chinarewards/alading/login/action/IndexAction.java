package com.chinarewards.alading.login.action;

import org.slf4j.Logger;

import com.chinarewards.alading.action.BaseAction;
import com.chinarewards.alading.log.InjectLogger;

public class IndexAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3542172091359969304L;

	private String error;

	@InjectLogger
	private Logger logger;

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	@Override
	public String execute() throws Exception {

		logger.trace("error={}", error);

		return SUCCESS;
	}
}
