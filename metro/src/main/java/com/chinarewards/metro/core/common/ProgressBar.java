package com.chinarewards.metro.core.common;

public class ProgressBar {
	
	private String uuid;
	private int value;

	public ProgressBar(String uuid, int value) {
		this.uuid = uuid;
		this.value = value;
	}

	public int getValue() {
		return value;
	}

	public void setValue(int value) {
		this.value = value;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	
	

}
