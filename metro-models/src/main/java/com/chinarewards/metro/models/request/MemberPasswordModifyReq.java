package com.chinarewards.metro.models.request;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

import org.apache.commons.codec.binary.StringUtils;

import com.chinarewards.metro.models.common.DES3;

/**
 * 会员密码修改Req
 * 
 * @author weishengshui
 * 
 */
@XmlRootElement
public class MemberPasswordModifyReq {

	private Integer id; // 会员ID

	private String phone; // 手机。可以删除这个参数

	private String alivePhoneNumber; // 激活手机号。可以删除这个参数

	private String oldPassword; // 老密码

	private String newPassword; // 新密码

	private String updateTime; // 修改时间 yyyyMMddHHmmss

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("id=" + id + "&phone=" + phone + "&alivePhoneNumber="
				+ alivePhoneNumber + "&oldPassword=" + oldPassword
				+ "&newPassword=" + newPassword + "&updateTime=" + updateTime);
		return str.toString();
	}

	public MemberPasswordModifyReq() {
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

	public void setOldPassword(String oldPassword) {
		this.oldPassword = oldPassword;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public String getOldPassword() {
		return oldPassword;
	}

	public String getNewPassword() {
		return newPassword;
	}

	/**
	 * 修改时间 yyyyMMddHHmmss，只有格式正确的才会被设定，由client端设置
	 * 
	 * @param updateTime
	 */
	public void setUpdateTime(String updateTime) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		Date updateDate = null;
		try {
			if (null != updateTime && updateTime.length() > 0) {
				updateDate = dateFormat.parse(updateTime);
			}
		} catch (ParseException e) {
		}
		if (null != updateDate) {
			this.updateTime = updateTime;
		}
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

}
