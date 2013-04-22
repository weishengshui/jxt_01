package com.ssh.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblSp entity. @author MyEclipse Persistence Tools
 */
/**
 * 商品表
 */
@Entity
@Table(name = "tbl_sp")
public class TblSp extends com.ssh.base.BaseEntity{
	
	private static final long serialVersionUID = 5232406245191259354L;
	// Fields

	private Integer nid;
	private Integer zstp; //展示图片
	private Integer spl; //系列
	private Integer qbjf; // 全额积分
	private Integer cxjf; //促销积分
	private Integer yf; //运费
	private Integer kcsl; //库存数量
	private Integer wcdsl; //未出单数量
	private Integer xsl; //销售数量
	private Double scj; // 市场价
	private Timestamp rq; //创建日期
	private Integer zt; //状态
	private String spmc; // 商品名称
	private String spbh; // 商品编号
	private Integer zsdhfs; //展示兑换方式
	private Integer jfqsl; //积分券数量
	private String spnr; //商品内容
	private Integer kcyj; //库存预警

	// Constructors

	/** default constructor */
	public TblSp() {
	}

	/** full constructor */
	public TblSp(Integer zstp, Integer spl, Integer qbjf, Integer cxjf,
			Integer yf, Integer kcsl, Integer wcdsl, Integer xsl, Double scj,
			Timestamp rq, Integer zt, String spmc, String spbh, Integer zsdhfs,
			Integer jfqsl, String spnr, Integer kcyj) {
		this.zstp = zstp;
		this.spl = spl;
		this.qbjf = qbjf;
		this.cxjf = cxjf;
		this.yf = yf;
		this.kcsl = kcsl;
		this.wcdsl = wcdsl;
		this.xsl = xsl;
		this.scj = scj;
		this.rq = rq;
		this.zt = zt;
		this.spmc = spmc;
		this.spbh = spbh;
		this.zsdhfs = zsdhfs;
		this.jfqsl = jfqsl;
		this.spnr = spnr;
		this.kcyj = kcyj;
	}

	// Property accessors
	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "nid", unique = true, nullable = false)
	public Integer getNid() {
		return this.nid;
	}

	public void setNid(Integer nid) {
		this.nid = nid;
	}

	@Column(name = "zstp")
	public Integer getZstp() {
		return this.zstp;
	}

	public void setZstp(Integer zstp) {
		this.zstp = zstp;
	}

	@Column(name = "spl")
	public Integer getSpl() {
		return this.spl;
	}

	public void setSpl(Integer spl) {
		this.spl = spl;
	}

	@Column(name = "qbjf")
	public Integer getQbjf() {
		return this.qbjf;
	}

	public void setQbjf(Integer qbjf) {
		this.qbjf = qbjf;
	}

	@Column(name = "cxjf")
	public Integer getCxjf() {
		return this.cxjf;
	}

	public void setCxjf(Integer cxjf) {
		this.cxjf = cxjf;
	}

	@Column(name = "yf")
	public Integer getYf() {
		return this.yf;
	}

	public void setYf(Integer yf) {
		this.yf = yf;
	}

	@Column(name = "kcsl")
	public Integer getKcsl() {
		return this.kcsl;
	}

	public void setKcsl(Integer kcsl) {
		this.kcsl = kcsl;
	}

	@Column(name = "wcdsl")
	public Integer getWcdsl() {
		return this.wcdsl;
	}

	public void setWcdsl(Integer wcdsl) {
		this.wcdsl = wcdsl;
	}

	@Column(name = "xsl")
	public Integer getXsl() {
		return this.xsl;
	}

	public void setXsl(Integer xsl) {
		this.xsl = xsl;
	}

	@Column(name = "scj", precision = 10)
	public Double getScj() {
		return this.scj;
	}

	public void setScj(Double scj) {
		this.scj = scj;
	}

	@Column(name = "rq", length = 19)
	public Timestamp getRq() {
		return this.rq;
	}

	public void setRq(Timestamp rq) {
		this.rq = rq;
	}

	@Column(name = "zt")
	public Integer getZt() {
		return this.zt;
	}

	public void setZt(Integer zt) {
		this.zt = zt;
	}

	@Column(name = "spmc", length = 100)
	public String getSpmc() {
		return this.spmc;
	}

	public void setSpmc(String spmc) {
		this.spmc = spmc;
	}

	@Column(name = "spbh", length = 30)
	public String getSpbh() {
		return this.spbh;
	}

	public void setSpbh(String spbh) {
		this.spbh = spbh;
	}

	@Column(name = "zsdhfs")
	public Integer getZsdhfs() {
		return this.zsdhfs;
	}

	public void setZsdhfs(Integer zsdhfs) {
		this.zsdhfs = zsdhfs;
	}

	@Column(name = "jfqsl")
	public Integer getJfqsl() {
		return this.jfqsl;
	}

	public void setJfqsl(Integer jfqsl) {
		this.jfqsl = jfqsl;
	}

	@Column(name = "spnr", length = 65535)
	public String getSpnr() {
		return this.spnr;
	}

	public void setSpnr(String spnr) {
		this.spnr = spnr;
	}

	@Column(name = "kcyj")
	public Integer getKcyj() {
		return this.kcyj;
	}

	public void setKcyj(Integer kcyj) {
		this.kcyj = kcyj;
	}

}