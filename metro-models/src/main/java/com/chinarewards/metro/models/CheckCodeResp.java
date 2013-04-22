package com.chinarewards.metro.models;

import java.io.Serializable;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 优惠码查询确认响应vo
 * 
 * @author qingminzou
 * 
 */
@XmlRootElement
public class CheckCodeResp implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1842038330424678186L;

	/**
	 * 优惠码
	 */
	private String couponCode;

	/**
	 * 是否可用 必选 (0--不可用；1--可用)
	 */
	private Integer isAvailable;

	/**
	 * 是否重复使用 （0--不可复用；1-可复用）
	 */
	private Integer isRepeat;

	/**
	 * 使用时间
	 */
	private Date useTime;

	/**
	 * 优惠码对应活动详细说明
	 */
	private String couponInfo;

	/**
	 * 错误原因(如过期等等) 可选
	 */
	private String errorReason;

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("couponCode=" + couponCode + "&isAvailable=" + isAvailable
				+ "&isRepeat=" + isRepeat + "&useTime=" + useTime
				+ "&couponInfo=" + couponInfo + "&errorReason=" + errorReason);
		return str.toString();
	}

	public String getCouponCode() {
		return couponCode;
	}

	public void setCouponCode(String couponCode) {
		this.couponCode = couponCode;
	}

	public Integer getIsAvailable() {
		return isAvailable;
	}

	public void setIsAvailable(Integer isAvailable) {
		this.isAvailable = isAvailable;
	}

	public Integer getIsRepeat() {
		return isRepeat;
	}

	public void setIsRepeat(Integer isRepeat) {
		this.isRepeat = isRepeat;
	}

	public Date getUseTime() {
		return useTime;
	}

	public void setUseTime(Date useTime) {
		this.useTime = useTime;
	}

	public String getCouponInfo() {
		return couponInfo;
	}

	public void setCouponInfo(String couponInfo) {
		this.couponInfo = couponInfo;
	}

	public String getErrorReason() {
		return errorReason;
	}

	public void setErrorReason(String errorReason) {
		this.errorReason = errorReason;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

}
