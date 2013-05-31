package com.ssh.entity;

import com.ssh.base.BaseEntity;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "tbl_syqyjfqlq")
public class TblSyqyjfq extends BaseEntity {
	private static final long serialVersionUID = 1L;
	private Integer nid;
	private Integer qyyg;
	private Integer jfqId;

	public TblSyqyjfq() {
	}

	public TblSyqyjfq(Integer qyyg, Integer jfqId) {
		this.qyyg = qyyg;
		this.jfqId = jfqId;
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

	@Column(name = "yg", nullable = false)
	public Integer getQyyg() {
		return this.qyyg;
	}

	public void setQyyg(Integer qyyg) {
		this.qyyg = qyyg;
	}

	@Column(name = "jfq", nullable = false)
	public Integer getJfqId() {
		return this.jfqId;
	}

	public void setJfqId(Integer jfqId) {
		this.jfqId = jfqId;
	}
}