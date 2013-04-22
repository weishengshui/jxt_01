package com.ssh.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblYgddmx entity. @author MyEclipse Persistence Tools
 */
/**
 * 员工订单明细表
 */
@Entity
@Table(name = "tbl_ygddmx")
public class TblYgddmx extends com.ssh.base.BaseEntity {

	

	/**
	 * 
	 */
	private static final long serialVersionUID = -6579616743173783426L;
	private Integer nid;
	private Integer dd; //订单总表编号
	private Integer sp; // 商品编号
	private Integer dhfs; // 兑换方式
	private Integer sl; // 数量
	private Integer jf; //积分
	private Double je; // 金额
	private Integer jfq; //积分券
	private Integer yg; // 员工编号
	private Integer spl; //系列编号
	private Timestamp jssj; // 时间
	private String ddh; // 订单号
	private Integer state; //状态

	

	/** default constructor */
	public TblYgddmx() {
	}

	/** full constructor */
	public TblYgddmx(Integer dd, Integer sp, Integer dhfs, Integer sl,
			Integer jf, Double je, Integer jfq, Integer yg, Integer spl,
			Timestamp jssj, String ddh, Integer state) {
		this.dd = dd;
		this.sp = sp;
		this.dhfs = dhfs;
		this.sl = sl;
		this.jf = jf;
		this.je = je;
		this.jfq = jfq;
		this.yg = yg;
		this.spl = spl;
		this.jssj = jssj;
		this.ddh = ddh;
		this.state = state;
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

	@Column(name = "dd")
	public Integer getDd() {
		return this.dd;
	}

	public void setDd(Integer dd) {
		this.dd = dd;
	}

	@Column(name = "sp")
	public Integer getSp() {
		return this.sp;
	}

	public void setSp(Integer sp) {
		this.sp = sp;
	}

	@Column(name = "dhfs")
	public Integer getDhfs() {
		return this.dhfs;
	}

	public void setDhfs(Integer dhfs) {
		this.dhfs = dhfs;
	}

	@Column(name = "sl")
	public Integer getSl() {
		return this.sl;
	}

	public void setSl(Integer sl) {
		this.sl = sl;
	}

	@Column(name = "jf")
	public Integer getJf() {
		return this.jf;
	}

	public void setJf(Integer jf) {
		this.jf = jf;
	}

	@Column(name = "je", precision = 10)
	public Double getJe() {
		return this.je;
	}

	public void setJe(Double je) {
		this.je = je;
	}

	@Column(name = "jfq")
	public Integer getJfq() {
		return this.jfq;
	}

	public void setJfq(Integer jfq) {
		this.jfq = jfq;
	}

	@Column(name = "yg")
	public Integer getYg() {
		return this.yg;
	}

	public void setYg(Integer yg) {
		this.yg = yg;
	}

	@Column(name = "spl")
	public Integer getSpl() {
		return this.spl;
	}

	public void setSpl(Integer spl) {
		this.spl = spl;
	}

	@Column(name = "jssj", length = 19)
	public Timestamp getJssj() {
		return this.jssj;
	}

	public void setJssj(Timestamp jssj) {
		this.jssj = jssj;
	}

	@Column(name = "ddh", length = 50)
	public String getDdh() {
		return this.ddh;
	}

	public void setDdh(String ddh) {
		this.ddh = ddh;
	}

	@Column(name = "state")
	public Integer getState() {
		return this.state;
	}

	public void setState(Integer state) {
		this.state = state;
	}

}