package com.chinarewards.metro.model.discountcoupon;

import java.util.Date;

public class DiscountCouponVo {

	// 有效期
	private Date validDateFrom;
	private Date validDateTo;

	private Date createdAt;

	private String instruction;// 优惠说明

	public DiscountCouponVo() {
	}

	public DiscountCouponVo(Date validDateFrom, Date validDateTo, Date createdAt,
			String instruction) {
		this.validDateFrom = validDateFrom;
		this.validDateTo = validDateTo;
		this.createdAt = createdAt;
		this.instruction = instruction;
	}

	public Date getValidDateFrom() {
		return validDateFrom;
	}

	public void setValidDateFrom(Date validDateFrom) {
		this.validDateFrom = validDateFrom;
	}

	public Date getValidDateTo() {
		return validDateTo;
	}

	public void setValidDateTo(Date validDateTo) {
		this.validDateTo = validDateTo;
	}

	public String getInstruction() {
		return instruction;
	}

	public void setInstruction(String instruction) {
		this.instruction = instruction;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

}
