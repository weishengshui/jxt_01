package com.chinarewards.metro.models.order;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class OrderRespArray {

	// public final static String SUCCESS = "0";

	// public final static String SIGN_FAILURE = "1";

	private String checkStr;

	private List<OrderResp> list = new ArrayList<OrderResp>();

	// default success
	private String result;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		if (list != null && list.size() > 0) {
			OrderResp r = list.get(0);
			str.append("ordered=" + r.getOrdered() + "&responseCode="
					+ r.getResponseCode() + "&responseText="
					+ r.getResponseText() + "&responseTime="
					+ r.getResponseTime());
		}
		return str.toString();
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

	public List<OrderResp> getList() {
		return list;
	}

	public void setList(List<OrderResp> list) {
		this.list = list;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}
}
