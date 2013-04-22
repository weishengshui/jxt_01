package com.chinarewards.metro.model.integral;

/**
 * 积分分析报表查询VO
 * 
 * @author gaojinxing
 * 
 */
public class IntegralQueryConditionVo {
	private String type; // 类型1:获得积分 2:使用积分

	private String origin; // 来源

	private String status; // 状态

	private String startDate; // 开始日期

	private String endDate; // 结束日期

	private String memName; // 会员名称

	private String memberCard; // 会员卡号

	private String phone; // 会员手机号

	private String orderSource; // 来源
	
	private Integer integralType ;

	public IntegralQueryConditionVo() {
	}

	public IntegralQueryConditionVo(String type, String origin, String status,
			String startDate, String endDate, String memName,Integer integralType,
			String memberCard, String phone, String orderSource) {
		super();
		this.type = type;
		this.origin = origin;
		this.status = status;
		this.startDate = startDate;
		this.endDate = endDate;
		this.memName = memName;
		this.integralType = integralType;
		this.memberCard = memberCard;
		this.phone = phone;
		this.orderSource = orderSource;
	}

	public Integer getIntegralType() {
		return integralType;
	}

	public void setIntegralType(Integer integralType) {
		this.integralType = integralType;
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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
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

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
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
}
