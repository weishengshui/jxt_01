package com.ssh.entity;

import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * TblQyyg entity. @author MyEclipse Persistence Tools
 */
/**
 * 企业员工
 */
@Entity
@Table(name = "tbl_qyyg")
public class TblQyyg extends com.ssh.base.BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4369766881183852959L;
	

	private Integer nid;
	private Integer qy; // 企业编号
	private String ygbh; // 员工编号
	private String ygxm; //  员工姓名
	private Integer xb; // 性别
	private String dx; // 不用
	private String bm; // 所属部门
	private String zsld; //不用
	private String lxdh; // 联系电话
	private String email; // 邮箱
	private Timestamp csrj; //出生日期
	private Integer zt; // 状态
	private Integer xtzt; // 系统状态
	private Timestamp rzsj; // 入职时间
	private String dlmm; // 登录密码
	private String zfmm; // 支付密码
	private Long jf; // 积分
	private Integer gly; // 是否管理员
	private String glqx; // 管理权限
	private Integer shdz; // 收货地址
	private String txtp; //不用
	private String nc; // 不用
 
	

	/** default constructor */
	public TblQyyg() {
	}

	/** full constructor */
	public TblQyyg(Integer qy, String ygbh, String ygxm, Integer xb, String dx,
			String bm, String zsld, String lxdh, String email, Timestamp csrj,
			Integer zt, Integer xtzt, Timestamp rzsj, String dlmm, String zfmm,
			Long jf, Integer gly, String glqx, Integer shdz, String txtp,
			String nc) {
		this.qy = qy;
		this.ygbh = ygbh;
		this.ygxm = ygxm;
		this.xb = xb;
		this.dx = dx;
		this.bm = bm;
		this.zsld = zsld;
		this.lxdh = lxdh;
		this.email = email;
		this.csrj = csrj;
		this.zt = zt;
		this.xtzt = xtzt;
		this.rzsj = rzsj;
		this.dlmm = dlmm;
		this.zfmm = zfmm;
		this.jf = jf;
		this.gly = gly;
		this.glqx = glqx;
		this.shdz = shdz;
		this.txtp = txtp;
		this.nc = nc;
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

	@Column(name = "qy")
	public Integer getQy() {
		return this.qy;
	}

	public void setQy(Integer qy) {
		this.qy = qy;
	}

	@Column(name = "ygbh", length = 50)
	public String getYgbh() {
		return this.ygbh;
	}

	public void setYgbh(String ygbh) {
		this.ygbh = ygbh;
	}

	@Column(name = "ygxm", length = 20)
	public String getYgxm() {
		return this.ygxm;
	}

	public void setYgxm(String ygxm) {
		this.ygxm = ygxm;
	}

	@Column(name = "xb")
	public Integer getXb() {
		return this.xb;
	}

	public void setXb(Integer xb) {
		this.xb = xb;
	}

	@Column(name = "dx", length = 100)
	public String getDx() {
		return this.dx;
	}

	public void setDx(String dx) {
		this.dx = dx;
	}

	@Column(name = "bm", length = 100)
	public String getBm() {
		return this.bm;
	}

	public void setBm(String bm) {
		this.bm = bm;
	}

	@Column(name = "zsld", length = 50)
	public String getZsld() {
		return this.zsld;
	}

	public void setZsld(String zsld) {
		this.zsld = zsld;
	}

	@Column(name = "lxdh", length = 50)
	public String getLxdh() {
		return this.lxdh;
	}

	public void setLxdh(String lxdh) {
		this.lxdh = lxdh;
	}

	@Column(name = "email", length = 100)
	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	@Column(name = "csrj", length = 19)
	public Timestamp getCsrj() {
		return this.csrj;
	}

	public void setCsrj(Timestamp csrj) {
		this.csrj = csrj;
	}

	@Column(name = "zt")
	public Integer getZt() {
		return this.zt;
	}

	public void setZt(Integer zt) {
		this.zt = zt;
	}

	@Column(name = "xtzt")
	public Integer getXtzt() {
		return this.xtzt;
	}

	public void setXtzt(Integer xtzt) {
		this.xtzt = xtzt;
	}

	@Column(name = "rzsj", length = 19)
	public Timestamp getRzsj() {
		return this.rzsj;
	}

	public void setRzsj(Timestamp rzsj) {
		this.rzsj = rzsj;
	}

	@Column(name = "dlmm", length = 50)
	public String getDlmm() {
		return this.dlmm;
	}

	public void setDlmm(String dlmm) {
		this.dlmm = dlmm;
	}

	@Column(name = "zfmm", length = 50)
	public String getZfmm() {
		return this.zfmm;
	}

	public void setZfmm(String zfmm) {
		this.zfmm = zfmm;
	}

	@Column(name = "jf")
	public Long getJf() {
		return this.jf;
	}

	public void setJf(Long jf) {
		this.jf = jf;
	}

	@Column(name = "gly")
	public Integer getGly() {
		return this.gly;
	}

	public void setGly(Integer gly) {
		this.gly = gly;
	}

	@Column(name = "glqx", length = 100)
	public String getGlqx() {
		return this.glqx;
	}

	public void setGlqx(String glqx) {
		this.glqx = glqx;
	}

	@Column(name = "shdz")
	public Integer getShdz() {
		return this.shdz;
	}

	public void setShdz(Integer shdz) {
		this.shdz = shdz;
	}

	@Column(name = "txtp", length = 150)
	public String getTxtp() {
		return this.txtp;
	}

	public void setTxtp(String txtp) {
		this.txtp = txtp;
	}

	@Column(name = "nc", length = 64)
	public String getNc() {
		return this.nc;
	}

	public void setNc(String nc) {
		this.nc = nc;
	}

}