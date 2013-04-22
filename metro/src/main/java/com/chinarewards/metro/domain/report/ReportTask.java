package com.chinarewards.metro.domain.report;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class ReportTask implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4096033565952939018L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;

	@Enumerated(EnumType.STRING)
	@Column(nullable = false)
	private TaskName taskName; // 任务名称，不同的任务有不同的名称

	@Column(nullable = false)
	private Date startTime;

	@Column(nullable = false)
	private Date endTime;

	@Column(length = 2000)
	private String descrition; // 任务描述

	public ReportTask() {
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public TaskName getTaskName() {
		return taskName;
	}

	public void setTaskName(TaskName taskName) {
		this.taskName = taskName;
	}

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public String getDescrition() {
		return descrition;
	}

	public void setDescrition(String descrition) {
		this.descrition = descrition;
	}

}
