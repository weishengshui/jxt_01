package com.chinarewards.metro.models.merchandise;

import java.io.Serializable;

/**
 * 商品的售卖形式
 * 
 * @author weishengshui
 * 
 */
public class Saleform implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5841183109020543791L;

	private Integer sellWay; // 1表示人民币售卖、2表示积分售卖

	private Double price;

	private Double PreferentialPrice;

	public Saleform(Integer sellWay, Double price, Double PreferentialPrice) {
		this.sellWay = sellWay;
		this.price = price;
		this.PreferentialPrice = PreferentialPrice;
	}

	public Saleform() {
	}

	public Integer getSellWay() {
		return sellWay;
	}

	public void setSellWay(Integer sellWay) {
		this.sellWay = sellWay;
	}

	public Double getPrice() {
		return price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public Double getPreferentialPrice() {
		return PreferentialPrice;
	}

	public void setPreferentialPrice(Double preferentialPrice) {
		PreferentialPrice = preferentialPrice;
	}

}
