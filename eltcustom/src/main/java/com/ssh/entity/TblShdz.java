package com.ssh.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblShdz entity. @author MyEclipse Persistence Tools
 */
/**
 * 员工收货地址
 */
@Entity
@Table(name = "tbl_shdz")
public class TblShdz extends com.ssh.base.BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1486451713863238429L;
	

	private Integer nid;
	private Integer yg; // 员工编号
	private String shr; //收货人
	private String shi; //市
	private String qu; //区
	private String sheng; //省
	private String dz; //地址
	private String yb; // 邮编
	private String dh; //电话
	private Timestamp rq; //创建日期

	

	/** default constructor */
	public TblShdz() {
	}

	/** full constructor */
	public TblShdz(Integer yg, String shr, String shi, String qu, String sheng,
			String dz, String yb, String dh, Timestamp rq) {
		this.yg = yg;
		this.shr = shr;
		this.shi = shi;
		this.qu = qu;
		this.sheng = sheng;
		this.dz = dz;
		this.yb = yb;
		this.dh = dh;
		this.rq = rq;
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

	@Column(name = "yg")
	public Integer getYg() {
		return this.yg;
	}

	public void setYg(Integer yg) {
		this.yg = yg;
	}

	@Column(name = "shr", length = 20)
	public String getShr() {
		return this.shr;
	}

	public void setShr(String shr) {
		this.shr = shr;
	}

	@Column(name = "shi", length = 50)
	public String getShi() {
		return this.shi;
	}

	public void setShi(String shi) {
		this.shi = shi;
	}

	@Column(name = "qu", length = 50)
	public String getQu() {
		return this.qu;
	}

	public void setQu(String qu) {
		this.qu = qu;
	}

	@Column(name = "sheng", length = 20)
	public String getSheng() {
		return this.sheng;
	}

	public void setSheng(String sheng) {
		this.sheng = sheng;
	}

	@Column(name = "dz", length = 100)
	public String getDz() {
		return this.dz;
	}

	public void setDz(String dz) {
		this.dz = dz;
	}

	@Column(name = "yb", length = 10)
	public String getYb() {
		return this.yb;
	}

	public void setYb(String yb) {
		this.yb = yb;
	}

	@Column(name = "dh", length = 20)
	public String getDh() {
		return this.dh;
	}

	public void setDh(String dh) {
		this.dh = dh;
	}

	@Column(name = "rq", length = 19)
	public Timestamp getRq() {
		return this.rq;
	}

	public void setRq(Timestamp rq) {
		this.rq = rq;
	}

}