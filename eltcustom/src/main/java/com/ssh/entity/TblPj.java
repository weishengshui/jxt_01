package com.ssh.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblPj entity. @author MyEclipse Persistence Tools
 */
/**
 * 商品系列评价
 */
@Entity
@Table(name = "tbl_pj")
public class TblPj extends com.ssh.base.BaseEntity{
	
	private static final long serialVersionUID = -6554173699858098581L;
	private Integer nid;
	private Integer spl; // 系列评分
	private Integer yg; // 员工编号
	private Integer ygxb; // 员工性别
	private Double zpf; // 总评分
	private Integer fhpf; // 发货评分 
	private Integer fwpf; // 服务评分
	private Integer wlpf; // 物流评分
	private Integer pj; // 评价
	private String pjnr; // 
	private Timestamp rq; // 日期
	private Integer pjxj; //

	

	/** default constructor */
	public TblPj() {
	}

	/** full constructor */
	public TblPj(Integer spl, Integer yg, Integer ygxb, Double zpf,
			Integer fhpf, Integer fwpf, Integer wlpf, Integer pj, String pjnr,
			Timestamp rq, Integer pjxj) {
		this.spl = spl;
		this.yg = yg;
		this.ygxb = ygxb;
		this.zpf = zpf;
		this.fhpf = fhpf;
		this.fwpf = fwpf;
		this.wlpf = wlpf;
		this.pj = pj;
		this.pjnr = pjnr;
		this.rq = rq;
		this.pjxj = pjxj;
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

	@Column(name = "spl")
	public Integer getSpl() {
		return this.spl;
	}

	public void setSpl(Integer spl) {
		this.spl = spl;
	}

	@Column(name = "yg")
	public Integer getYg() {
		return this.yg;
	}

	public void setYg(Integer yg) {
		this.yg = yg;
	}

	@Column(name = "ygxb")
	public Integer getYgxb() {
		return this.ygxb;
	}

	public void setYgxb(Integer ygxb) {
		this.ygxb = ygxb;
	}

	@Column(name = "zpf", precision = 10)
	public Double getZpf() {
		return this.zpf;
	}

	public void setZpf(Double zpf) {
		this.zpf = zpf;
	}

	@Column(name = "fhpf")
	public Integer getFhpf() {
		return this.fhpf;
	}

	public void setFhpf(Integer fhpf) {
		this.fhpf = fhpf;
	}

	@Column(name = "fwpf")
	public Integer getFwpf() {
		return this.fwpf;
	}

	public void setFwpf(Integer fwpf) {
		this.fwpf = fwpf;
	}

	@Column(name = "wlpf")
	public Integer getWlpf() {
		return this.wlpf;
	}

	public void setWlpf(Integer wlpf) {
		this.wlpf = wlpf;
	}

	@Column(name = "pj")
	public Integer getPj() {
		return this.pj;
	}

	public void setPj(Integer pj) {
		this.pj = pj;
	}

	@Column(name = "pjnr", length = 150)
	public String getPjnr() {
		return this.pjnr;
	}

	public void setPjnr(String pjnr) {
		this.pjnr = pjnr;
	}

	@Column(name = "rq", length = 19)
	public Timestamp getRq() {
		return this.rq;
	}

	public void setRq(Timestamp rq) {
		this.rq = rq;
	}

	@Column(name = "pjxj")
	public Integer getPjxj() {
		return this.pjxj;
	}

	public void setPjxj(Integer pjxj) {
		this.pjxj = pjxj;
	}

}