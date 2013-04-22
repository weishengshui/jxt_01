package com.chinarewards.metro.domain.shop;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.member.Member;

@Entity
public class DiscountNumberHistory implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1061030034312465888L;

	@Id
	private int id;

	private String discountNum;

	private Date generatedDate;

	private Date usedDate;
	
	// 优惠码状态: 0未使用、1已使用
	private Integer status;

	private Date expiredDate;

	// 哪个会员生成通过客户端生成的优惠码
	@ManyToOne
	private Member member;

	// 生成此优惠码的时候，此门店的所发布的优惠(一个门店只能发布一个优惠)
	private String title;

	@Lob
	private String description;
	
	@Lob
	private String posDescr;

	@ManyToOne
	private ActivityInfo activityInfo;
	
	@ManyToOne
	private Shop shop;
	
	private long serialId;
	
	private double money;

	private String transactionNO;
	
	@Transient	
	private Integer source;//门店1，活动2
	@Transient
	private String shopActivityName;
	@Transient
	private String shopName;
	@Transient
	private String activityName;

	@Transient
	private String memberName;
	@Transient
	private String memberCard;
	
	
	private String orderId;
	
	private int codeType ;		//优惠码是属于导入还是随机生成的     0：随机；1：导入
	
	@Transient
	private Page paginationDetail;;

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

	public Date getUsedDate() {
		return usedDate;
	}

	public void setUsedDate(Date usedDate) {
		this.usedDate = usedDate;
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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getPosDescr() {
		return posDescr;
	}

	public void setPosDescr(String posDescr) {
		this.posDescr = posDescr;
	}

	public ActivityInfo getActivityInfo() {
		return activityInfo;
	}

	public void setActivityInfo(ActivityInfo activityInfo) {
		this.activityInfo = activityInfo;
	}

	public long getSerialId() {
		return serialId;
	}

	public void setSerialId(long serialId) {
		this.serialId = serialId;
	}

	public double getMoney() {
		return money;
	}

	public void setMoney(double money) {
		this.money = money;
	}

	public String getTransactionNO() {
		return transactionNO;
	}

	public void setTransactionNO(String transactionNO) {
		this.transactionNO = transactionNO;
	}

	

	public Integer getSource() {
		return source;
	}

	public void setSource(Integer source) {
		this.source = source;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public int getCodeType() {
		return codeType;
	}

	public void setCodeType(int codeType) {
		this.codeType = codeType;
	}

	public String getShopActivityName() {
		return shopActivityName;
	}

	public void setShopActivityName(String shopActivityName) {
		this.shopActivityName = shopActivityName;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getMemberCard() {
		return memberCard;
	}

	public void setMemberCard(String memberCard) {
		this.memberCard = memberCard;
	}

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	public String getActivityName() {
		return activityName;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}

	public Page getPaginationDetail() {
		return paginationDetail;
	}

	public void setPaginationDetail(Page paginationDetail) {
		this.paginationDetail = paginationDetail;
	}
	
}
