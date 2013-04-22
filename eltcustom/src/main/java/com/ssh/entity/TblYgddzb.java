package com.ssh.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblYgddzb entity. @author MyEclipse Persistence Tools
 */
/**
 * 员工订单总表
 */
@Entity
@Table(name = "tbl_ygddzb")
public class TblYgddzb extends com.ssh.base.BaseEntity {

	

	/**
	 * 
	 */
	private static final long serialVersionUID = 5034749148211193871L;
	private Integer nid;
	private String ddh; //订单号
	private Integer state; //状态
	private Timestamp cjrq; //创建日期
	private Timestamp jsrq; //付款日期
	private String ydh; //运单号
	private Timestamp shrq; //收货日期
	private Timestamp fhrq; //发货日期
	private Integer zjf; //总积分
	private Double zje; //总金额
	private Integer jfqsl; //积分券数量
	private String fhr; //发货人
	private String fhrdh; //发货人电话
	private Integer yg; //员工编号
	private Integer shdz; //收货地址
	private String ddbz; //订单备注
	private String shdzxx; //收货地址内容
	private Timestamp qsrq; //签收日期
	private Integer gys; //供应商

	

	/** default constructor */
	public TblYgddzb() {
	}

	/** full constructor */
	public TblYgddzb(String ddh, Integer state, Timestamp cjrq, Timestamp jsrq,
			String ydh, Timestamp shrq, Timestamp fhrq, Integer zjf,
			Double zje, Integer jfqsl, String fhr, String fhrdh, Integer yg,
			Integer shdz, String ddbz, String shdzxx, Timestamp qsrq,
			Integer gys) {
		this.ddh = ddh;
		this.state = state;
		this.cjrq = cjrq;
		this.jsrq = jsrq;
		this.ydh = ydh;
		this.shrq = shrq;
		this.fhrq = fhrq;
		this.zjf = zjf;
		this.zje = zje;
		this.jfqsl = jfqsl;
		this.fhr = fhr;
		this.fhrdh = fhrdh;
		this.yg = yg;
		this.shdz = shdz;
		this.ddbz = ddbz;
		this.shdzxx = shdzxx;
		this.qsrq = qsrq;
		this.gys = gys;
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

	@Column(name = "cjrq", length = 19)
	public Timestamp getCjrq() {
		return this.cjrq;
	}

	public void setCjrq(Timestamp cjrq) {
		this.cjrq = cjrq;
	}

	@Column(name = "jsrq", length = 19)
	public Timestamp getJsrq() {
		return this.jsrq;
	}

	public void setJsrq(Timestamp jsrq) {
		this.jsrq = jsrq;
	}

	@Column(name = "ydh", length = 50)
	public String getYdh() {
		return this.ydh;
	}

	public void setYdh(String ydh) {
		this.ydh = ydh;
	}

	@Column(name = "shrq", length = 19)
	public Timestamp getShrq() {
		return this.shrq;
	}

	public void setShrq(Timestamp shrq) {
		this.shrq = shrq;
	}

	@Column(name = "fhrq", length = 19)
	public Timestamp getFhrq() {
		return this.fhrq;
	}

	public void setFhrq(Timestamp fhrq) {
		this.fhrq = fhrq;
	}

	@Column(name = "zjf")
	public Integer getZjf() {
		return this.zjf;
	}

	public void setZjf(Integer zjf) {
		this.zjf = zjf;
	}

	@Column(name = "zje", precision = 10)
	public Double getZje() {
		return this.zje;
	}

	public void setZje(Double zje) {
		this.zje = zje;
	}

	@Column(name = "jfqsl")
	public Integer getJfqsl() {
		return this.jfqsl;
	}

	public void setJfqsl(Integer jfqsl) {
		this.jfqsl = jfqsl;
	}

	@Column(name = "fhr", length = 20)
	public String getFhr() {
		return this.fhr;
	}

	public void setFhr(String fhr) {
		this.fhr = fhr;
	}

	@Column(name = "fhrdh", length = 50)
	public String getFhrdh() {
		return this.fhrdh;
	}

	public void setFhrdh(String fhrdh) {
		this.fhrdh = fhrdh;
	}

	@Column(name = "yg")
	public Integer getYg() {
		return this.yg;
	}

	public void setYg(Integer yg) {
		this.yg = yg;
	}

	@Column(name = "shdz")
	public Integer getShdz() {
		return this.shdz;
	}

	public void setShdz(Integer shdz) {
		this.shdz = shdz;
	}

	@Column(name = "ddbz", length = 200)
	public String getDdbz() {
		return this.ddbz;
	}

	public void setDdbz(String ddbz) {
		this.ddbz = ddbz;
	}

	@Column(name = "shdzxx", length = 500)
	public String getShdzxx() {
		return this.shdzxx;
	}

	public void setShdzxx(String shdzxx) {
		this.shdzxx = shdzxx;
	}

	@Column(name = "qsrq", length = 19)
	public Timestamp getQsrq() {
		return this.qsrq;
	}

	public void setQsrq(Timestamp qsrq) {
		this.qsrq = qsrq;
	}

	@Column(name = "gys")
	public Integer getGys() {
		return this.gys;
	}

	public void setGys(Integer gys) {
		this.gys = gys;
	}

}