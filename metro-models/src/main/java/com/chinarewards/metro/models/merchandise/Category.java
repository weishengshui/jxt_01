package com.chinarewards.metro.models.merchandise;

import java.io.Serializable;

public class Category implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6641238778266009183L;

	private String id;

	private String name;

	private Category parent;

	public Category(String id, String name, Category parent) {
		this.id = id;
		this.name = name;
		this.parent = parent;
	}

	public Category() {
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Category getParent() {
		return parent;
	}

	public void setParent(Category parent) {
		this.parent = parent;
	}

}
