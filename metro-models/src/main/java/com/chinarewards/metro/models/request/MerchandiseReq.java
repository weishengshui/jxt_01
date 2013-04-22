package com.chinarewards.metro.models.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class MerchandiseReq implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5380905038207146642L;

	private Integer page; // 第几页
	private Integer pageSize; // 每页的商品数量
	private String checkStr;

	public String getSignValue() {
		return "page=" + page;
	}

	public MerchandiseReq() {
	}

	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

	public Integer getPageSize() {
		return pageSize;
	}

	public void setPageSize(Integer pageSize) {
		this.pageSize = pageSize;
	}

}
