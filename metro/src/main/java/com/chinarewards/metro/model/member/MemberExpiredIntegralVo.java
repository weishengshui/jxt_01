package com.chinarewards.metro.model.member;

import java.util.Date;

/**
 * 会员失效积分VO
 * 
 * @author weishengshui
 * 
 */
public class MemberExpiredIntegralVo {

	private String gainTxId;

	private String expiredTxId;

	private Date expiredDate;

	private double units;

	public MemberExpiredIntegralVo() {
	}

	public MemberExpiredIntegralVo(String gainTxId, String expiredTxId, Date expiredDate,
			double units) {
		this.gainTxId = gainTxId;
		this.expiredTxId = expiredTxId;
		this.expiredDate = expiredDate;
		this.units = units;
	}

	public double getUnits() {
		return units;
	}

	public void setUnits(double units) {
		this.units = units;
	}

	public String getGainTxId() {
		return gainTxId;
	}

	public void setGainTxId(String gainTxId) {
		this.gainTxId = gainTxId;
	}

	public String getExpiredTxId() {
		return expiredTxId;
	}

	public void setExpiredTxId(String expiredTxId) {
		this.expiredTxId = expiredTxId;
	}

	public Date getExpiredDate() {
		return expiredDate;
	}

	public void setExpiredDate(Date expiredDate) {
		this.expiredDate = expiredDate;
	}

}
