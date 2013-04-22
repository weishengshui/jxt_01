package com.ssh.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblJfqmc entity. @author MyEclipse Persistence Tools
 */
/**
 * 积分券明细
 */
@Entity
@Table(name = "tbl_jfqmc")
public class TblJfqmc extends com.ssh.base.BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8011083976279298214L;
	

	private Integer nid;
	private Integer jfq; //积分券表编号
	private String jfqh;// 积分券前缀
	private Integer qy;//企业
	private Integer qyyg; //使用员工编号
	private Integer zt; // 状态
	private Timestamp yxq; //有效期
	private Timestamp ffsj;// 发放时间
	private Timestamp sysj; //使用时间
	private Integer jfqdd; //订单编号
	private Integer jfqffmc; //发放明细编号
	private Integer ffzt; // 发放状态
	private Timestamp lqsj; // 领取时间
	private Integer sflq; //是否领取
	private String ffly; //发放来源
	private String ddh; // 员工订单号
	private String ffyy; //发放理由

	

	/** default constructor */
	public TblJfqmc() {
	}

	/** full constructor */
	public TblJfqmc(Integer jfq, String jfqh, Integer qy, Integer qyyg,
			Integer zt, Timestamp yxq, Timestamp ffsj, Timestamp sysj,
			Integer jfqdd, Integer jfqffmc, Integer ffzt, Timestamp lqsj,
			Integer sflq, String ffly, String ddh, String ffyy) {
		this.jfq = jfq;
		this.jfqh = jfqh;
		this.qy = qy;
		this.qyyg = qyyg;
		this.zt = zt;
		this.yxq = yxq;
		this.ffsj = ffsj;
		this.sysj = sysj;
		this.jfqdd = jfqdd;
		this.jfqffmc = jfqffmc;
		this.ffzt = ffzt;
		this.lqsj = lqsj;
		this.sflq = sflq;
		this.ffly = ffly;
		this.ddh = ddh;
		this.ffyy = ffyy;
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

	@Column(name = "jfq")
	public Integer getJfq() {
		return this.jfq;
	}

	public void setJfq(Integer jfq) {
		this.jfq = jfq;
	}

	@Column(name = "jfqh", length = 50)
	public String getJfqh() {
		return this.jfqh;
	}

	public void setJfqh(String jfqh) {
		this.jfqh = jfqh;
	}

	@Column(name = "qy")
	public Integer getQy() {
		return this.qy;
	}

	public void setQy(Integer qy) {
		this.qy = qy;
	}

	@Column(name = "qyyg")
	public Integer getQyyg() {
		return this.qyyg;
	}

	public void setQyyg(Integer qyyg) {
		this.qyyg = qyyg;
	}

	@Column(name = "zt")
	public Integer getZt() {
		return this.zt;
	}

	public void setZt(Integer zt) {
		this.zt = zt;
	}

	@Column(name = "yxq", length = 19)
	public Timestamp getYxq() {
		return this.yxq;
	}

	public void setYxq(Timestamp yxq) {
		this.yxq = yxq;
	}

	@Column(name = "ffsj", length = 19)
	public Timestamp getFfsj() {
		return this.ffsj;
	}

	public void setFfsj(Timestamp ffsj) {
		this.ffsj = ffsj;
	}

	@Column(name = "sysj", length = 19)
	public Timestamp getSysj() {
		return this.sysj;
	}

	public void setSysj(Timestamp sysj) {
		this.sysj = sysj;
	}

	@Column(name = "jfqdd")
	public Integer getJfqdd() {
		return this.jfqdd;
	}

	public void setJfqdd(Integer jfqdd) {
		this.jfqdd = jfqdd;
	}

	@Column(name = "jfqffmc")
	public Integer getJfqffmc() {
		return this.jfqffmc;
	}

	public void setJfqffmc(Integer jfqffmc) {
		this.jfqffmc = jfqffmc;
	}

	@Column(name = "ffzt")
	public Integer getFfzt() {
		return this.ffzt;
	}

	public void setFfzt(Integer ffzt) {
		this.ffzt = ffzt;
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

	@Column(name = "ddh", length = 50)
	public String getDdh() {
		return this.ddh;
	}

	public void setDdh(String ddh) {
		this.ddh = ddh;
	}

	@Column(name = "ffyy", length = 50)
	public String getFfyy() {
		return this.ffyy;
	}

	public void setFfyy(String ffyy) {
		this.ffyy = ffyy;
	}

}