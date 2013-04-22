package com.chinarewards.metro.models.response;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 会员密码修改Res
 * 
 * @author weishengshui
 * 
 */
@XmlRootElement
public class MemberPasswordModifyRes {

	private Integer id; // 会员ID

	private String phone; // 手机。可以删除这个参数

	private String alivePhoneNumber; // 激活手机号。可以删除这个参数

	private Integer updateStatus; // 修改状态。1 成功 2 失败

	private String updateDesc; // 修改状态描述。可选

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("id=" + id + "&phone=" + phone + "&alivePhoneNumber="
				+ alivePhoneNumber + "&updateStatus=" + updateStatus
				+ "&updateDesc=" + updateDesc + "&updateDesc=" + updateDesc);
		return str.toString();
	}

	public MemberPasswordModifyRes() {
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

	public String getAlivePhoneNumber() {
		return alivePhoneNumber;
	}

	public void setAlivePhoneNumber(String alivePhoneNumber) {
		this.alivePhoneNumber = alivePhoneNumber;
	}

	public Integer getUpdateStatus() {
		return updateStatus;
	}

	public void setUpdateStatus(Integer updateStatus) {
		this.updateStatus = updateStatus;
	}

	public String getUpdateDesc() {
		return updateDesc;
	}

	public void setUpdateDesc(String updateDesc) {
		this.updateDesc = updateDesc;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

}
