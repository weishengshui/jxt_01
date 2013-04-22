package com.chinarewards.metro.core.common;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * easyui使用的tree模型
 * huang shan
 */

public class TreeNodes implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String id;
	
	private String text;// 树节点名称
	
	private Boolean checked = false;// 是否勾选状态
	
	private Map<String, Object> attributes;// 其他参数
	
	private List<TreeNodes> children;// 子节点
	
	private String state = "open";// 是否展开(open,closed)

	private Integer seq;
	
	public Integer getSeq() {
		return seq;
	}

	public void setSeq(Integer seq) {
		this.seq = seq;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public Boolean getChecked() {
		return checked;
	}

	public void setChecked(Boolean checked) {
		this.checked = checked;
	}

	public Map<String, Object> getAttributes() {
		return attributes;
	}

	public void setAttributes(Map<String, Object> attributes) {
		this.attributes = attributes;
	}

	public List<TreeNodes> getChildren() {
		return children;
	}

	public void setChildren(List<TreeNodes> children) {
		this.children = children;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}
	
}
