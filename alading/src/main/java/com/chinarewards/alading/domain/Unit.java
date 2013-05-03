package com.chinarewards.alading.domain;

import java.io.Serializable;

public class Unit implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2198621676445825078L;

	private Integer pointId;
	private String pointName;
	private Integer pointRate;

	public Integer getPointId() {
		return pointId;
	}

	public void setPointId(Integer pointId) {
		this.pointId = pointId;
	}

	public String getPointName() {
		return pointName;
	}

	public void setPointName(String pointName) {
		this.pointName = pointName;
	}

	public Integer getPointRate() {
		return pointRate;
	}

	public void setPointRate(Integer pointRate) {
		this.pointRate = pointRate;
	}

}
