package com.chinarewards.metro.models.request;

import java.io.Serializable;
import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;
@XmlRootElement
public class MetroSiteReq implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -491045052975846976L;
	private String table ;
	private String operateType ;
	private String description ;
	private Date operateTime ;
	private String checkStr;
	
	public String getSignValue() {
		StringBuffer sbf = new StringBuffer();
		sbf.append("&table="+table);
		sbf.append("&operateType="+operateType);
		sbf.append("&operateTime="+operateTime);
		return sbf.toString();
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
