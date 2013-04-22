package com.chinarewards.metro.models.request;

import java.io.Serializable;
import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class MetroLineReq implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -491045052975846976L;
	private String checkStr;
	private String table ;
	private String operateType ;
	private String description ;
	private Date operateTime ;
	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("table=" + table + "&operateType=" + operateType
				+ "&description=" + description + "&operateTime=" + operateTime);

		return str.toString();
	}
	public String getCheckStr() {
		return checkStr;
	}
	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}
	public String getTable() {
		return table;
	}
	public void setTable(String table) {
		this.table = table;
	}
	public String getOperateType() {
		return operateType;
	}
	public void setOperateType(String operateType) {
		this.operateType = operateType;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Date getOperateTime() {
		return operateTime;
	}
	public void setOperateTime(Date operateTime) {
		this.operateTime = operateTime;
	}
	
}
