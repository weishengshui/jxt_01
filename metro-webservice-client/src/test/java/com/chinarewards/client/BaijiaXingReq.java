package com.chinarewards.client;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class BaijiaXingReq {

	private String select = "biaoti";
	private String keyword;

	public String getSelect() {
		return select;
	}

	public void setSelect(String select) {
		this.select = select;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

}
