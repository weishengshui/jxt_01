package com.chinarewards.metro.models.merchandise;

import java.io.Serializable;
import java.util.List;

import com.chinarewards.metro.models.brand.Brand;

public class Merchandise implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8916857885144771574L;

	private String commodityId;

	private String name;

	private Double freight; // 运费

	private Brand brand;

	private String speciesId; // 不是必选，暂时没用到

	private Integer sellWay; // 售卖方式：1、积分 2、人名币 3、积分+人名币

	private Double price;

	private Double PreferentialPrice;

	private Double pointPrice;

	private Double pointPreferentialPrice;

	private List<Catalog> catalogs;

	private List<MerchandiseFile> pics;// 商品图片

	public Merchandise(String id, String name, Double freight) {
		this.commodityId = id;
		this.name = name;
		this.freight = freight;
	}

	public Merchandise() {
	}

	public String getCommodityId() {
		return commodityId;
	}

	public void setCommodityId(String commodityId) {
		this.commodityId = commodityId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Double getFreight() {
		return freight;
	}

	public void setFreight(Double freight) {
		this.freight = freight;
	}

	public Brand getBrand() {
		return brand;
	}

	public void setBrand(Brand brand) {
		this.brand = brand;
	}

	public String getSpeciesId() {
		return speciesId;
	}

	public void setSpeciesId(String speciesId) {
		this.speciesId = speciesId;
	}

	public List<MerchandiseFile> getPics() {
		return pics;
	}

	public void setPic(List<MerchandiseFile> pics) {
		this.pics = pics;
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

	public Double getPointPrice() {
		return pointPrice;
	}

	public void setPointPrice(Double pointPrice) {
		this.pointPrice = pointPrice;
	}

	public Double getPointPreferentialPrice() {
		return pointPreferentialPrice;
	}

	public void setPointPreferentialPrice(Double pointPreferentialPrice) {
		this.pointPreferentialPrice = pointPreferentialPrice;
	}

	public List<Catalog> getCatalogs() {
		return catalogs;
	}

	public void setCatalogs(List<Catalog> catalogs) {
		this.catalogs = catalogs;
	}

	public void setPics(List<MerchandiseFile> pics) {
		this.pics = pics;
	}

}
