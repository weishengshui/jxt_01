package com.chinarewards.metro.domain.system;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

import org.hibernate.validator.constraints.Length;

@Entity
public class SYSVariable implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7011430834901381294L;

	@Id
	@Column(name = "s_key")
	private String key;

	@Length(max = 2000)
	@Column(name = "s_value")
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
