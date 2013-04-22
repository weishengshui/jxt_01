package com.chinarewards.metro.model.integral;

import java.io.Serializable;
import java.util.Date;

public class IntegralReport implements Serializable {
	
	private static final long serialVersionUID = -3249234043721822957L;

	private String memName;				//会员名称

	private String memberCard;			//会员卡号

	private String type;				//类型

	private long integralCount;			//获取积分数
	
	private long usedIntegral;	 		//使用积分数

	private String origin;				//来源

	private String status;				//状态

	private Date exchangeHour;			//交易时间
	
	private String phone; 				// 会员手机号
	
	private String orderSource; 		// 来源

	public IntegralReport() {
	}


	public IntegralReport(String memName, String memberCard, String type,
			long integralCount, long usedIntegral, String origin,
			String status, Date exchangeHour, String phone, String orderSource) {
		super();
		this.memName = memName;
		this.memberCard = memberCard;
		this.type = type;
		this.integralCount = integralCount;
		this.usedIntegral = usedIntegral;
		this.origin = origin;
		this.status = status;
		this.exchangeHour = exchangeHour;
		this.phone = phone;
		this.orderSource = orderSource;
	}


	public String getPhone() {
		return phone;
	}


	public void setPhone(String phone) {
		this.phone = phone;
	}


	public String getOrderSource() {
		return orderSource;
	}


	public void setOrderSource(String orderSource) {
		this.orderSource = orderSource;
	}


	public void setIntegralCount(long integralCount) {
		this.integralCount = integralCount;
	}


	public String getMemName() {
		return memName;
	}

	public void setMemName(String memName) {
		this.memName = memName;
	}

	public String getMemberCard() {
		return memberCard;
	}

	public void setMemberCard(String memberCard) {
		this.memberCard = memberCard;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public long getIntegralCount() {
		return integralCount;
	}

	public void setIntegralCount(Long integralCount) {
		this.integralCount = integralCount;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getExchangeHour() {
		return exchangeHour;
	}

	public void setExchangeHour(Date exchangeHour) {
		this.exchangeHour = exchangeHour;
	}

	public long getUsedIntegral() {
		return usedIntegral;
	}

	public void setUsedIntegral(long usedIntegral) {
		this.usedIntegral = usedIntegral;
	}

}
