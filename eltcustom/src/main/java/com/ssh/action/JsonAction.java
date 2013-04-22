package com.ssh.action;

import net.sf.json.JSON;
import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;

import com.ssh.base.BaseAction;


@ParentPackage("ajax")
@Result(type = "json", params = { "root", "result" })
public abstract class JsonAction extends BaseAction {
	private static final long serialVersionUID = -220338922043627899L;
	private transient JSON result;
	private String param;
	private static Logger logger = Logger.getLogger(JsonAction.class
			.getName());

	public void setResult(JSON json) {
		this.result = json;
	}

	public JSON getResult() {
		return result;
	}

	public void setParam(String param) {
		this.param = param;
	}

	public String getParam() {
		return param;
	}

}
