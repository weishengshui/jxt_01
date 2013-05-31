package com.ssh.entity;

import com.ssh.base.BaseEntity;
import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "tbl_syqyjf")
public class TblSyqyjf extends BaseEntity {
	private static final long serialVersionUID = -8982127533356030890L;
	private Integer nid;
	private Integer qy;
	private Integer yg;
	private Integer jf;
	private Timestamp zjsj;
	private Integer zjr;
	private String bz;
	private Integer sflq;
	private Timestamp lqsj;

	public TblSyqyjf() {
	}

	public TblSyqyjf(Integer qy, Integer yg, Integer jf, Timestamp zjsj,
			Integer zjr, String bz, Integer sflq) {
		this.qy = qy;
		this.yg = yg;
		this.jf = jf;
		this.zjsj = zjsj;
		this.zjr = zjr;
		this.bz = bz;
		this.sflq = sflq;
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

	@Column(name = "qy")
	public Integer getQy() {
		return this.qy;
	}

	public void setQy(Integer qy) {
		this.qy = qy;
	}

	@Column(name = "yg")
	public Integer getYg() {
		return this.yg;
	}

	public void setYg(Integer yg) {
		this.yg = yg;
	}

	@Column(name = "jf")
	public Integer getJf() {
		return this.jf;
	}

	public void setJf(Integer jf) {
		this.jf = jf;
	}

	@Column(name = "zjsj", length = 19)
	public Timestamp getZjsj() {
		return this.zjsj;
	}

	public void setZjsj(Timestamp zjsj) {
		this.zjsj = zjsj;
	}

	@Column(name = "zjr")
	public Integer getZjr() {
		return this.zjr;
	}

	public void setZjr(Integer zjr) {
		this.zjr = zjr;
	}

	@Column(name = "bz")
	public String getBz() {
		return this.bz;
	}

	public void setBz(String bz) {
		this.bz = bz;
	}

	@Column(name = "sflq")
	public Integer getSflq() {
		return this.sflq;
	}

	public void setSflq(Integer sflq) {
		this.sflq = sflq;
	}

	@Column(name = "lqsj", length = 19)
	public Timestamp getLqsj() {
		return this.lqsj;
	}

	public void setLqsj(Timestamp lqsj) {
		this.lqsj = lqsj;
	}
}