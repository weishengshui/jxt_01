package com.ssh.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblSpl entity. @author MyEclipse Persistence Tools
 */
/**
 * 商品系列表
 */
@Entity
@Table(name = "tbl_spl")
public class TblSpl extends com.ssh.base.BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7896440051313194792L;
	

	private Integer nid;
	private Integer sp; //显示商品
	private String mc; // 名称
	private Integer lb3; // 类目3
	private Integer lb2; // 类目2
	private Integer lb1; //类目1
	private Integer ydsl; //已兑数量
	private String cpjs; //商品介绍
	private String shfw; //售后服务
	private Timestamp rq; // 日期
	private Integer zt; // 状态
	private Integer sftj; //是否推荐

	

	/** default constructor */
	public TblSpl() {
	}

	/** full constructor */
	public TblSpl(Integer sp, String mc, Integer lb3, Integer lb2, Integer lb1,
			Integer ydsl, String cpjs, String shfw, Timestamp rq, Integer zt,
			Integer sftj) {
		this.sp = sp;
		this.mc = mc;
		this.lb3 = lb3;
		this.lb2 = lb2;
		this.lb1 = lb1;
		this.ydsl = ydsl;
		this.cpjs = cpjs;
		this.shfw = shfw;
		this.rq = rq;
		this.zt = zt;
		this.sftj = sftj;
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

	@Column(name = "sp")
	public Integer getSp() {
		return this.sp;
	}

	public void setSp(Integer sp) {
		this.sp = sp;
	}

	@Column(name = "mc", length = 100)
	public String getMc() {
		return this.mc;
	}

	public void setMc(String mc) {
		this.mc = mc;
	}

	@Column(name = "lb3")
	public Integer getLb3() {
		return this.lb3;
	}

	public void setLb3(Integer lb3) {
		this.lb3 = lb3;
	}

	@Column(name = "lb2")
	public Integer getLb2() {
		return this.lb2;
	}

	public void setLb2(Integer lb2) {
		this.lb2 = lb2;
	}

	@Column(name = "lb1")
	public Integer getLb1() {
		return this.lb1;
	}

	public void setLb1(Integer lb1) {
		this.lb1 = lb1;
	}

	@Column(name = "ydsl")
	public Integer getYdsl() {
		return this.ydsl;
	}

	public void setYdsl(Integer ydsl) {
		this.ydsl = ydsl;
	}

	@Column(name = "cpjs", length = 65535)
	public String getCpjs() {
		return this.cpjs;
	}

	public void setCpjs(String cpjs) {
		this.cpjs = cpjs;
	}

	@Column(name = "shfw", length = 65535)
	public String getShfw() {
		return this.shfw;
	}

	public void setShfw(String shfw) {
		this.shfw = shfw;
	}

	@Column(name = "rq", length = 19)
	public Timestamp getRq() {
		return this.rq;
	}

	public void setRq(Timestamp rq) {
		this.rq = rq;
	}

	@Column(name = "zt")
	public Integer getZt() {
		return this.zt;
	}

	public void setZt(Integer zt) {
		this.zt = zt;
	}

	@Column(name = "sftj")
	public Integer getSftj() {
		return this.sftj;
	}

	public void setSftj(Integer sftj) {
		this.sftj = sftj;
	}

}