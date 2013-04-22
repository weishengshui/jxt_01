package com.chinarewards.metro.domain.business;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;

import com.chinarewards.metro.domain.account.Account;
import com.chinarewards.metro.domain.account.Transaction;
import com.chinarewards.metro.domain.shop.Shop;

/**
 * 外部订单（获取积分，消耗积分）都会以订单的形式推送过来<br>
 * 内部的订单也会适用此表
 * 
 * @author qingminzou
 * 
 */
@Entity
public class OrderInfo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 436028318450006505L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int id;

	// 外部交易订单号
	private String orderNo;

	@ManyToOne
	private Shop shop;

	// 会员账号
	@ManyToOne
	private Account account;

	// 交易终端
	// @ManyToOne
	// private PosBind posBind;

	// 交易终端编号
	private String posCode;

	// 终端操作人ID
	private String clerkId;

	// 交易
	@OneToOne
	private Transaction tx;

	// 终端请求流水号，验证是否同一个请求; 注意判断是否同一个请求
	private String serialId;

	private Date orderTime;

	// 订单交易金额
	private BigDecimal orderPrice;

	// 終端发送时间必选
	private Date deliverTime;

	// 优惠码ID
	private String couponCode;

	// 获取积分总数
	@Column(precision = 19, scale = 2)
	private BigDecimal integration;

	// 此订单使用的积分
	private BigDecimal usingCode;

	// 此订单使用的储值卡现金
	private BigDecimal usingCash;

	// 订单来源
	private String orderSource;

	// 订单中银行支付的金额
	private BigDecimal bankPay;

	// 会员卡号
	private String memberCard;

	// 订单中使用现金支付的金额
	private BigDecimal cash;

	// 兑换的时候有商品名称
	// @ManyToOne
	// private Merchandise merchandise;

	// 兑换礼品总量
	private Integer redemptionQuantity;

	// 匹配的积分规则
	private String matchedRules;

	// 交易前积分账户余额
	private BigDecimal beforeUnits;

	// 交易前储值卡余额
	private BigDecimal beforeCash;

	// 0 表示获取积分； 1 表示消耗积分 ；2表示储蓄账户充值；3表示储蓄账户使用。4表示复合交易类型，储蓄账户 归类交易大类，给查询适用
	private int type;

	// 是否同步到业务管理后台管理
	private Boolean sync;

	// 同步到业务管理后台管理时间
	private Date syncAt;

	// 外部订单信息，仅保存回传
	private String orderState;
	private String memberId;
	//充值说明
	private String chargeDesc;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public Shop getShop() {
		return shop;
	}

	public void setShop(Shop shop) {
		this.shop = shop;
	}

	public String getClerkId() {
		return clerkId;
	}

	public void setClerkId(String clerkId) {
		this.clerkId = clerkId;
	}

	public Transaction getTx() {
		return tx;
	}

	public void setTx(Transaction tx) {
		this.tx = tx;
	}


	public Date getOrderTime() {
		return orderTime;
	}

	public void setOrderTime(Date orderTime) {
		this.orderTime = orderTime;
	}

	public BigDecimal getOrderPrice() {
		return orderPrice;
	}

	public void setOrderPrice(BigDecimal orderPrice) {
		this.orderPrice = orderPrice;
	}

	public Date getDeliverTime() {
		return deliverTime;
	}

	public void setDeliverTime(Date deliverTime) {
		this.deliverTime = deliverTime;
	}

	public String getCouponCode() {
		return couponCode;
	}

	public void setCouponCode(String couponCode) {
		this.couponCode = couponCode;
	}

	public BigDecimal getIntegration() {
		return integration;
	}

	public void setIntegration(BigDecimal integration) {
		this.integration = integration;
	}

	public BigDecimal getUsingCode() {
		return usingCode;
	}

	public void setUsingCode(BigDecimal usingCode) {
		this.usingCode = usingCode;
	}

	public String getOrderSource() {
		return orderSource;
	}

	public void setOrderSource(String orderSource) {
		this.orderSource = orderSource;
	}

	public BigDecimal getBankPay() {
		return bankPay;
	}

	public void setBankPay(BigDecimal bankPay) {
		this.bankPay = bankPay;
	}

	public String getMemberCard() {
		return memberCard;
	}

	public void setMemberCard(String memberCard) {
		this.memberCard = memberCard;
	}

	public BigDecimal getCash() {
		return cash;
	}

	public void setCash(BigDecimal cash) {
		this.cash = cash;
	}

	public String getMatchedRules() {
		return matchedRules;
	}

	public void setMatchedRules(String matchedRules) {
		this.matchedRules = matchedRules;
	}

	public Integer getRedemptionQuantity() {
		return redemptionQuantity;
	}

	public void setRedemptionQuantity(Integer redemptionQuantity) {
		this.redemptionQuantity = redemptionQuantity;
	}

	public BigDecimal getBeforeUnits() {
		return beforeUnits;
	}

	public void setBeforeUnits(BigDecimal beforeUnits) {
		this.beforeUnits = beforeUnits;
	}

	public BigDecimal getBeforeCash() {
		return beforeCash;
	}

	public void setBeforeCash(BigDecimal beforeCash) {
		this.beforeCash = beforeCash;
	}

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getPosCode() {
		return posCode;
	}

	public void setPosCode(String posCode) {
		this.posCode = posCode;
	}

	public BigDecimal getUsingCash() {
		return usingCash;
	}

	public void setUsingCash(BigDecimal usingCash) {
		this.usingCash = usingCash;
	}

	public Boolean getSync() {
		return sync;
	}

	public void setSync(Boolean sync) {
		this.sync = sync;
	}

	public Date getSyncAt() {
		return syncAt;
	}

	public void setSyncAt(Date syncAt) {
		this.syncAt = syncAt;
	}

	public String getOrderState() {
		return orderState;
	}

	public void setOrderState(String orderState) {
		this.orderState = orderState;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getChargeDesc() {
		return chargeDesc;
	}

	public void setChargeDesc(String chargeDesc) {
		this.chargeDesc = chargeDesc;
	}

	public String getSerialId() {
		return serialId;
	}

	public void setSerialId(String serialId) {
		this.serialId = serialId;
	}
	
}
