package com.ssh.entity;

import com.ssh.base.BaseEntity;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "tbl_qy")
public class TblQy extends BaseEntity {
	private static final long serialVersionUID = 2022224945872389331L;
	private Integer nid;
	private String qymc;
	private String logo;
	private Integer zt;

	public TblQy() {
	}

	public TblQy(String qymc, String logo, Integer zt) {
		this.qymc = qymc;
		this.logo = logo;
		this.zt = zt;
	}

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "nid", unique = true, nullable = false)
	public Integer getNid() {
		return this.nid;
	}

	public void setNid(Integer nid) {
		this.nid = nid;
	}

	@Column(name = "qymc", length = 300)
	public String getQymc() {
		return this.qymc;
	}

	public void setQymc(String qymc) {
		this.qymc = qymc;
	}

	@Column(name = "log", length = 100)
	public String getLogo() {
		return this.logo;
	}

	public void setLogo(String logo) {
		this.logo = logo;
	}

	@Column(name = "zt")
	public Integer getZt() {
		return this.zt;
	}

	public void setZt(Integer zt) {
		this.zt = zt;
	}
}