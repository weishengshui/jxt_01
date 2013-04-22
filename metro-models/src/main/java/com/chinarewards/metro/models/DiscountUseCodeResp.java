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
public class DiscountUseCodeResp implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1842038330424678186L;

	/**
	 * 优惠码
	 */
	private String couponCode;

	/**
	 * 会员id
	 */
	private String userId;

	/**
	 * 优惠码id
	 */
	private String couponId;
	
	
	/**
	 * 是否重复使用 （0--不可复用；1-可复用）
	 */
	private Integer isRepeat;

	/**
	 * 优惠码对应的优惠信息
	 */
	private String couponDescription;
	/**
	 * 优惠码使用状态( 0: 优惠码不存在,1:成功  , 2,暂无优惠活动,3：无效的终端编号,4:优惠码已使用,5:优惠码已过期,6:
	 *	 该活动已结束！，7:该活动已取消 ;8:该活动未开始; 9：用户不存在；10：会员id不能为空；11：该会员无法使用；other:非业务类错误)
	 */
	private String usedState;
	/**
	 * 优惠码使用描述
	 */
	private String usedDescription;

	/**
	 * 错误信息
	 */
	private String errorDescription;

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("couponCode=" + couponCode + "&userId=" + userId
				+ "&couponId=" + couponId + "&couponDescription="
				+ couponDescription + "&usedState=" + usedState
				+ "&usedDescription=" + usedDescription + "&errorDescription="
				+ errorDescription);
		return str.toString();
	}

	public String getErrorDescription() {
		return errorDescription;
	}

	public void setErrorDescription(String errorDescription) {
		this.errorDescription = errorDescription;
	}

	
	public Integer getIsRepeat() {
		return isRepeat;
	}

	public void setIsRepeat(Integer isRepeat) {
		this.isRepeat = isRepeat;
	}

	public String getCouponCode() {
		return couponCode;
	}

	public void setCouponCode(String couponCode) {
		this.couponCode = couponCode;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getCouponId() {
		return couponId;
	}

	public void setCouponId(String couponId) {
		this.couponId = couponId;
	}

	public String getCouponDescription() {
		return couponDescription;
	}

	public void setCouponDescription(String couponDescription) {
		this.couponDescription = couponDescription;
	}

	public String getUsedState() {
		return usedState;
	}

	public void setUsedState(String usedState) {
		this.usedState = usedState;
	}

	public String getUsedDescription() {
		return usedDescription;
	}

	public void setUsedDescription(String usedDescription) {
		this.usedDescription = usedDescription;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}
}
