package com.chinarewards.metro.models;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class GenericEntry implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6725446275496689389L;

	private String key;

	private String value;

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
}
