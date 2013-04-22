package com.ssh.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblBzzx entity. @author MyEclipse Persistence Tools
 */
/**
 * 帮助中心
 */
@Entity
@Table(name = "tbl_bzzx")
public class TblBzzx extends com.ssh.base.BaseEntity {

	
	private static final long serialVersionUID = 7017046444465957736L;
	private Integer nid; //编号
	private String bt; //标题
	private Integer upid;//父类
	private String nr; //内容
	private Integer xswz;//显示位置
	private Integer sfxz;//是否显示

	

	/** default constructor */
	public TblBzzx() {
	}

	/** full constructor */
	public TblBzzx(String bt, Integer upid, String nr, Integer xswz,
			Integer sfxz) {
		this.bt = bt;
		this.upid = upid;
		this.nr = nr;
		this.xswz = xswz;
		this.sfxz = sfxz;
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

	@Column(name = "bt", length = 20)
	public String getBt() {
		return this.bt;
	}

	public void setBt(String bt) {
		this.bt = bt;
	}

	@Column(name = "upid")
	public Integer getUpid() {
		return this.upid;
	}

	public void setUpid(Integer upid) {
		this.upid = upid;
	}

	@Column(name = "nr", length = 65535)
	public String getNr() {
		return this.nr;
	}

	public void setNr(String nr) {
		this.nr = nr;
	}

	@Column(name = "xswz")
	public Integer getXswz() {
		return this.xswz;
	}

	public void setXswz(Integer xswz) {
		this.xswz = xswz;
	}

	@Column(name = "sfxz")
	public Integer getSfxz() {
		return this.sfxz;
	}

	public void setSfxz(Integer sfxz) {
		this.sfxz = sfxz;
	}

}