package com.chinarewards.alading.image.action;

import com.chinarewards.alading.action.BaseAction;

/**
 * 卡图片 action
 * 
 * @author weishengshui
 * 
 */
public class ImageAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2850057898592056051L;
	// 进入页面为1，提交表单为2
	private Integer type;

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}
	
	
}
