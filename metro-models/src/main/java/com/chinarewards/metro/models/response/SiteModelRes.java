package com.chinarewards.metro.models.response;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

import com.chinarewards.metro.models.line.SiteModel;

@XmlRootElement
public class SiteModelRes implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private List<SiteModel> siteList;
	
	private String checkStr;
	
	public String getSignValue() {
		StringBuffer sbf = new StringBuffer();
		if (null != siteList && siteList.size() > 0) {
			SiteModel s = siteList.get(0);
			sbf.append("stationId="+s.getStationId());
			sbf.append("&lineName="+s.getLineName());
			sbf.append("&position="+s.getPosition());
			sbf.append("&orderNumber="+s.getOrderNumber());
			sbf.append("&hotArea="+s.getHotArea());
			sbf.append("&smallPic="+s.getSmallPic());
		}
		return sbf.toString();
	}

	public List<SiteModel> getSiteList() {
		return siteList;
	}

	public void setSiteList(List<SiteModel> siteList) {
		this.siteList = siteList;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}
	
}
