package com.ssh.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblLljl entity. @author MyEclipse Persistence Tools
 */
/**
 * 商品浏览记录
 */
@Entity
@Table(name = "tbl_lljl")
public class TblLljl extends com.ssh.base.BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = -299979604473380269L;
	

	private Integer nid;
	private Integer spl; // 系列编号
	private Integer sp; // 商品编号
	private Integer yg; // 员工编号
	private Timestamp llsj; // 浏览时间
	private Integer qy; // 企业编号

	

	/** default constructor */
	public TblLljl() {
	}

	/** full constructor */
	public TblLljl(Integer spl, Integer sp, Integer yg, Timestamp llsj,
			Integer qy) {
		this.spl = spl;
		this.sp = sp;
		this.yg = yg;
		this.llsj = llsj;
		this.qy = qy;
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

	@Column(name = "sp")
	public Integer getSp() {
		return this.sp;
	}

	public void setSp(Integer sp) {
		this.sp = sp;
	}

	@Column(name = "yg")
	public Integer getYg() {
		return this.yg;
	}

	public void setYg(Integer yg) {
		this.yg = yg;
	}

	@Column(name = "llsj", length = 19)
	public Timestamp getLlsj() {
		return this.llsj;
	}

	public void setLlsj(Timestamp llsj) {
		this.llsj = llsj;
	}

	@Column(name = "qy")
	public Integer getQy() {
		return this.qy;
	}

	public void setQy(Integer qy) {
		this.qy = qy;
	}

}