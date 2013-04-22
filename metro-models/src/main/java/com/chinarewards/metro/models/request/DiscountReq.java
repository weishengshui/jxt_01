package com.chinarewards.metro.models.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class DiscountReq implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4579983335019450087L;

	private int m_id; // 会员ID
	private int couponId; // 门店ID or 活动ID
	private int type; // 0:门店ID ; 1:活动ID

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("m_id=" + m_id + "&couponId=" + couponId + "&type=" + type);
		return str.toString();
	}

	public int getMid() {
		return m_id;
	}

	public void setMid(int m_id) {
		this.m_id = m_id;
	}

	public int getCouponId() {
		return couponId;
	}

	public void setCouponId(int couponId) {
		this.couponId = couponId;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

}
