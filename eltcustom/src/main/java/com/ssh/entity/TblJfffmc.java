package com.ssh.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblJfffmc entity. @author MyEclipse Persistence Tools
 */
/**
 * 积分发放明细
 */
@Entity
@Table(name = "tbl_jfffmc")
public class TblJfffmc extends com.ssh.base.BaseEntity {

	
	private static final long serialVersionUID = 1321168723295757988L;
	private Integer nid; 
	private Integer qy; //企业
	private Integer jfff; // 发放表编号
	private Integer jfffxx; //发放信息表编号
	private Integer hqr; //  获奖人
	private Integer ffjf; // 发放积分
	private Timestamp ffsj; //发放时间
	private Integer sfff; //是否发放
	private Timestamp lqsj; //领取时间
	private Integer sflq;  // 是否领取
	private String ffly; //发放来源

	

	/** default constructor */
	public TblJfffmc() {
	}

	/** full constructor */
	public TblJfffmc(Integer qy, Integer jfff, Integer jfffxx, Integer hqr,
			Integer ffjf, Timestamp ffsj, Integer sfff, Timestamp lqsj,
			Integer sflq, String ffly) {
		this.qy = qy;
		this.jfff = jfff;
		this.jfffxx = jfffxx;
		this.hqr = hqr;
		this.ffjf = ffjf;
		this.ffsj = ffsj;
		this.sfff = sfff;
		this.lqsj = lqsj;
		this.sflq = sflq;
		this.ffly = ffly;
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

	@Column(name = "qy")
	public Integer getQy() {
		return this.qy;
	}

	public void setQy(Integer qy) {
		this.qy = qy;
	}

	@Column(name = "jfff")
	public Integer getJfff() {
		return this.jfff;
	}

	public void setJfff(Integer jfff) {
		this.jfff = jfff;
	}

	@Column(name = "jfffxx")
	public Integer getJfffxx() {
		return this.jfffxx;
	}

	public void setJfffxx(Integer jfffxx) {
		this.jfffxx = jfffxx;
	}

	@Column(name = "hqr")
	public Integer getHqr() {
		return this.hqr;
	}

	public void setHqr(Integer hqr) {
		this.hqr = hqr;
	}

	@Column(name = "ffjf")
	public Integer getFfjf() {
		return this.ffjf;
	}

	public void setFfjf(Integer ffjf) {
		this.ffjf = ffjf;
	}

	@Column(name = "ffsj", length = 19)
	public Timestamp getFfsj() {
		return this.ffsj;
	}

	public void setFfsj(Timestamp ffsj) {
		this.ffsj = ffsj;
	}

	@Column(name = "sfff")
	public Integer getSfff() {
		return this.sfff;
	}

	public void setSfff(Integer sfff) {
		this.sfff = sfff;
	}

	@Column(name = "lqsj", length = 19)
	public Timestamp getLqsj() {
		return this.lqsj;
	}

	public void setLqsj(Timestamp lqsj) {
		this.lqsj = lqsj;
	}

	@Column(name = "sflq")
	public Integer getSflq() {
		return this.sflq;
	}

	public void setSflq(Integer sflq) {
		this.sflq = sflq;
	}

	@Column(name = "ffly", length = 50)
	public String getFfly() {
		return this.ffly;
	}

	public void setFfly(String ffly) {
		this.ffly = ffly;
	}

}