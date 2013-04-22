package com.chinarewards.metro.domain.business;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity
public class RedemptionDetail implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5972161708122871288L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int id;

	@ManyToOne
	private OrderInfo orderInfo;

	private String merchandiseId;

	private String merchandiseName;

	// 商品采购价格(人民币)
	private double purchasePrice;

	// 售出单价
	private double sellUnits;

	// 售出使用单位
	private String sellUnitCode;

	// 数量
	private int quantity;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public OrderInfo getOrderInfo() {
		return orderInfo;
	}

	public void setOrderInfo(OrderInfo orderInfo) {
		this.orderInfo = orderInfo;
	}

	public String getMerchandiseId() {
		return merchandiseId;
	}

	public void setMerchandiseId(String merchandiseId) {
		this.merchandiseId = merchandiseId;
	}

	public String getMerchandiseName() {
		return merchandiseName;
	}

	public void setMerchandiseName(String merchandiseName) {
		this.merchandiseName = merchandiseName;
	}

	public double getPurchasePrice() {
		return purchasePrice;
	}

	public void setPurchasePrice(double purchasePrice) {
		this.purchasePrice = purchasePrice;
	}

	public double getSellUnits() {
		return sellUnits;
	}

	public void setSellUnits(double sellUnits) {
		this.sellUnits = sellUnits;
	}

	public String getSellUnitCode() {
		return sellUnitCode;
	}

	public void setSellUnitCode(String sellUnitCode) {
		this.sellUnitCode = sellUnitCode;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

}
