package com.chinarewards.metro.domain.shop;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.member.Member;

@Entity
public class DiscountNumber implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -860012743274921786L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private int id;

	private String discountNum;

	private Date generatedDate;

	private Date expiredDate;
	@Transient
	private long serialId;

	// 哪个会员生成通过客户端生成的优惠码
	@ManyToOne
	private Member member;

	// 生成此优惠码的时候，此门店的所发布的优惠(一个门店只能发布一个优惠)
	private String title;

	//1:表示使用，0：表示未使用
	private Integer state ;
	
	@Lob
	private String descr;
	
	@Lob
	private String posDescr;

	@ManyToOne
	private ActivityInfo activityInfo;
	
	@ManyToOne
	private Shop shop;
	
	private int codeType ;		//优惠码是属于导入还是随机生成的     0：随机；1：导入

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Date getGeneratedDate() {
		return generatedDate;
	}

	public void setGeneratedDate(Date generatedDate) {
		this.generatedDate = generatedDate;
	}

	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	public Shop getShop() {
		return shop;
	}

	public void setShop(Shop shop) {
		this.shop = shop;
	}

	public String getDiscountNum() {
		return discountNum;
	}

	public void setDiscountNum(String discountNum) {
		this.discountNum = discountNum;
	}

	public Date getExpiredDate() {
		return expiredDate;
	}

	public void setExpiredDate(Date expiredDate) {
		this.expiredDate = expiredDate;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescr() {
		return descr;
	}

	public void setDescr(String descr) {
		this.descr = descr;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public ActivityInfo getActivityInfo() {
		return activityInfo;
	}

	public void setActivityInfo(ActivityInfo activityInfo) {
		this.activityInfo = activityInfo;
	}

	public Integer getState() {
		return state;
	}

	public void setState(Integer state) {
		this.state = state;
	}

	public String getPosDescr() {
		return posDescr;
	}

	public void setPosDescr(String posDescr) {
		this.posDescr = posDescr;
	}

	public long getSerialId() {
		return serialId;
	}

	public void setSerialId(long serialId) {
		this.serialId = serialId;
	}

	public int getCodeType() {
		return codeType;
	}

	public void setCodeType(int codeType) {
		this.codeType = codeType;
	}
}
