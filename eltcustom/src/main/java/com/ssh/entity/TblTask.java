package com.ssh.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblTask entity. @author MyEclipse Persistence Tools
 */
/**
 * 定时任务表
 */
@Entity
@Table(name = "tbl_task")
public class TblTask extends com.ssh.base.BaseEntity{
	

	private static final long serialVersionUID = 5247909765486242520L;
	private Integer nid;
	private String mc; //名称
	private String pl; //规则
	private String lm; //类名
	private Integer zc; //载入
	private Integer zt; //状态

	

	/** default constructor */
	public TblTask() {
	}

	/** full constructor */
	public TblTask(String mc, String pl, String lm, Integer zc, Integer zt) {
		this.mc = mc;
		this.pl = pl;
		this.lm = lm;
		this.zc = zc;
		this.zt = zt;
	}

	
	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "nid", unique = true, nullable = false)
	public Integer getNid() {
		return this.nid;
	}

	public void setNid(Integer nid) {
		this.nid = nid;
	}

	@Column(name = "mc", nullable = false, length = 20)
	public String getMc() {
		return this.mc;
	}

	public void setMc(String mc) {
		this.mc = mc;
	}

	@Column(name = "pl", nullable = false, length = 30)
	public String getPl() {
		return this.pl;
	}

	public void setPl(String pl) {
		this.pl = pl;
	}

	@Column(name = "lm", nullable = false, length = 200)
	public String getLm() {
		return this.lm;
	}

	public void setLm(String lm) {
		this.lm = lm;
	}

	@Column(name = "zc", nullable = false)
	public Integer getZc() {
		return this.zc;
	}

	public void setZc(Integer zc) {
		this.zc = zc;
	}

	@Column(name = "zt", nullable = false)
	public Integer getZt() {
		return this.zt;
	}

	public void setZt(Integer zt) {
		this.zt = zt;
	}

}