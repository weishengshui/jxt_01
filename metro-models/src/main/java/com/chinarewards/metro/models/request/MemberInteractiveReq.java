package com.chinarewards.metro.models.request;

import java.io.Serializable;
import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class MemberInteractiveReq implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String operateType;
	
	private String preSyncTime;
	
	private String phoneNum;

	private Integer curPage;
	
	private String checkStr;
	
	public String getSignValue() {
		StringBuffer sbf = new StringBuffer();
		sbf.append("operateType="+operateType);
		sbf.append("&phoneNum="+phoneNum);
		sbf.append("&curPage="+curPage);
		sbf.append("&preSyncTime="+preSyncTime);
		return sbf.toString();
	}
	
	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

	public Integer getCurPage() {
		return curPage;
	}

	public void setCurPage(Integer curPage) {
		this.curPage = curPage;
	}

	public String getOperateType() {
		return operateType;
	}

	public void setOperateType(String operateType) {
		this.operateType = operateType;
	}

	public String getPreSyncTime() {
		return preSyncTime;
	}

	public void setPreSyncTime(String preSyncTime) {
		this.preSyncTime = preSyncTime;
	}

	public String getPhoneNum() {
		return phoneNum;
	}

	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}

}
