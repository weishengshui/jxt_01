package com.chinarewards.metro.models.request;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

import com.chinarewards.metro.models.common.DateTools;

/**
 * 会员基本资料修改Req
 * 
 * @author weishengshui
 * 
 */
@XmlRootElement
public class MemberModifyReq {

	private Integer id; // 会员ID

	private String phone; // 手机。

	private String mail; // 邮箱。

	private Date registerDate; // 注册日期。注册日期应该为会员注册时系统生成，不可修改。可以删除这个参数

	private Boolean alive; // 是否激活。是否激活应该属于会员状态的一种， 可以删除这个参数

	private String alivePhoneNumber; // 激活手机号

	private Integer grade; // 等级，当前系统未分等级。即只有一个等级。可以删除这个参数

	private Date birthday; // 会员生日。

	private Double integration; // 积分。积分为会员管理平台所有的业务，积分的增加或减少，都会有相应的交易对应。所以在修改会员资料的接口中，不应该有积分的修改项。
								// 可以删除这个参数

	private Integer memberStatus; // 会员状态。1 已激活 2 未激活 3注销

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("id=" + id + "&phone=" + phone + "&mail=" + mail
				+ "&registerDate=" + (registerDate==null?"":DateTools.dateToStrings(registerDate)) + "&alive=" + alive
				+ "&alivePhoneNumber=" + alivePhoneNumber + "&grade=" + grade
				+ "&birthday=" + (birthday==null?"":DateTools.dateToStrings(birthday)) + "&integration=" + integration
				+ "&memberStatus=" + memberStatus);

		return str.toString();
	}

	public MemberModifyReq() {
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getMail() {
		return mail;
	}

	public void setMail(String mail) {
		this.mail = mail;
	}

	public Date getRegisterDate() {
		return registerDate;
	}

	public void setRegisterDate(Date registerDate) {
		this.registerDate = registerDate;
	}

	public Boolean getAlive() {
		return alive;
	}

	public void setAlive(Boolean alive) {
		this.alive = alive;
	}

	public String getAlivePhoneNumber() {
		return alivePhoneNumber;
	}

	public void setAlivePhoneNumber(String alivePhoneNumber) {
		this.alivePhoneNumber = alivePhoneNumber;
	}

	public Integer getGrade() {
		return grade;
	}

	public void setGrade(Integer grade) {
		this.grade = grade;
	}

	public Date getBirthday() {
		return birthday;
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}

	public Double getIntegration() {
		return integration;
	}

	public void setIntegration(Double integration) {
		this.integration = integration;
	}

	public Integer getMemberStatus() {
		return memberStatus;
	}

	public void setMemberStatus(Integer memberStatus) {
		this.memberStatus = memberStatus;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

}
