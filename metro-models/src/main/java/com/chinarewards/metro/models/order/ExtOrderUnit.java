package com.chinarewards.metro.models.order;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class ExtOrderUnit implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6666953615076051172L;
	

	private String checkStr;

	private List<ExtOrderInfo> list;

	private int currPage;

	private int totalPage;

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

	public List<ExtOrderInfo> getList() {
		return list;
	}

	public void setList(List<ExtOrderInfo> list) {
		this.list = list;
	}

	public int getCurrPage() {
		return currPage;
	}

	public void setCurrPage(int currPage) {
		this.currPage = currPage;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
}
