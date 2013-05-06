package com.chinarewards.alading.domain;

/**
 * 员工基本信息，没写全，暂时只用到这么几个属性
 * 
 * @author weishengshui
 *
 */
public class Member {

	private Integer id;
	private Integer enterpriseId;
	private String mobilePhone;
	private Integer status; 

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getEnterpriseId() {
		return enterpriseId;
	}

	public void setEnterpriseId(Integer enterpriseId) {
		this.enterpriseId = enterpriseId;
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

}
