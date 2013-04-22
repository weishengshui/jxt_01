package com.ssh.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblCxhd entity. @author MyEclipse Persistence Tools
 */
/**
 * 商品促销活动
 */
@Entity
@Table(name = "tbl_cxhd")
public class TblCxhd extends com.ssh.base.BaseEntity{

	private static final long serialVersionUID = -3987754533163334400L;
	

	private Integer nid; //编号
	private String bt; //标题
	private String tplj; // 图片
	private Integer sp; //单品编号
	private Integer syxs; //是否显示
	private Timestamp ksrq; //开始日期
	private Timestamp jsrq; //结束日期
	private Integer xswz; //显示位置
	private Integer sfgg; //是否广告
	private String hdnr; //多品内容 (活动内容)

	

	/** default constructor */
	public TblCxhd() {
	}

	/** full constructor */
	public TblCxhd(String bt, String tplj, Integer sp, Integer syxs,
			Timestamp ksrq, Timestamp jsrq, Integer xswz, Integer sfgg,
			String hdnr) {
		this.bt = bt;
		this.tplj = tplj;
		this.sp = sp;
		this.syxs = syxs;
		this.ksrq = ksrq;
		this.jsrq = jsrq;
		this.xswz = xswz;
		this.sfgg = sfgg;
		this.hdnr = hdnr;
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

	@Column(name = "bt", length = 50)
	public String getBt() {
		return this.bt;
	}

	public void setBt(String bt) {
		this.bt = bt;
	}

	@Column(name = "tplj", length = 100)
	public String getTplj() {
		return this.tplj;
	}

	public void setTplj(String tplj) {
		this.tplj = tplj;
	}

	@Column(name = "sp")
	public Integer getSp() {
		return this.sp;
	}

	public void setSp(Integer sp) {
		this.sp = sp;
	}

	@Column(name = "syxs")
	public Integer getSyxs() {
		return this.syxs;
	}

	public void setSyxs(Integer syxs) {
		this.syxs = syxs;
	}

	@Column(name = "ksrq", length = 19)
	public Timestamp getKsrq() {
		return this.ksrq;
	}

	public void setKsrq(Timestamp ksrq) {
		this.ksrq = ksrq;
	}

	@Column(name = "jsrq", length = 19)
	public Timestamp getJsrq() {
		return this.jsrq;
	}

	public void setJsrq(Timestamp jsrq) {
		this.jsrq = jsrq;
	}

	@Column(name = "xswz")
	public Integer getXswz() {
		return this.xswz;
	}

	public void setXswz(Integer xswz) {
		this.xswz = xswz;
	}

	@Column(name = "sfgg")
	public Integer getSfgg() {
		return this.sfgg;
	}

	public void setSfgg(Integer sfgg) {
		this.sfgg = sfgg;
	}

	@Column(name = "hdnr", length = 65535)
	public String getHdnr() {
		return this.hdnr;
	}

	public void setHdnr(String hdnr) {
		this.hdnr = hdnr;
	}

}