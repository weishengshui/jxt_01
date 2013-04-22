package com.chinarewards.metro.domain.system;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Transient;

@Entity
public class SysLog implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7011430834901381294L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO )
	private Integer id;
	
	/**
	 * 操作员， 如：admin
	 */
	private String operator;
	
	/**
	 * 操作时间
	 */
	private String time;
	
	/**
	 * 操作对象， 如：任务新增     商品基本信息	优惠券维护
	 */
	private String object;
	
	/**
	 * 操作的具体数据名称，  如：活动A   活动B   门店A
	 */
	private String name;
	
	/**
	 * 如：增加  删除 修改  导出... 	等等
	 */
	private String event;
	
	/**
	 * 其他内容， 可选择性填入
	 */
	private String other;

	@Transient
	private String startTime;
	
	@Transient
	private String endTime;
	
	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getOperator() {
		return operator;
	}

	public void setOperator(String operator) {
		this.operator = operator;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getObject() {
		return object;
	}

	public void setObject(String object) {
		this.object = object;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEvent() {
		return event;
	}

	public void setEvent(String event) {
		this.event = event;
	}

	public String getOther() {
		return other;
	}

	public void setOther(String other) {
		this.other = other;
	}
	
}
