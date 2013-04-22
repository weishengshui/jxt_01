package com.chinarewards.metro.model.merchandise;

import com.chinarewards.metro.domain.merchandise.MerchandiseShop;
import com.chinarewards.metro.domain.shop.Shop;

public class MerchandiseShopVo {

	private Integer shopId;
	private String merchandiseId;
	private Integer merShopSort; // 商品在门店的排序
	private String region;
	private String shopName;
	private String shopEnName;

	public MerchandiseShopVo(Integer shopId, String merchandiseId,
			Integer merShopSort) {
		this.shopId = shopId;
		this.merchandiseId = merchandiseId;
		this.merShopSort = merShopSort;
	}

	public MerchandiseShopVo() {
	}

	public MerchandiseShopVo(MerchandiseShop merchandiseShop) {
		Shop shop = merchandiseShop.getShop();
		this.shopId = shop.getId();
		this.merShopSort = merchandiseShop.getSort();
		this.region = shop.getProvince() == null ? "" : shop.getProvince();
		this.region += shop.getCity() == null ? "" : shop.getCity();
		this.region += shop.getRegion() == null ? "" : shop.getRegion();
		this.shopName = shop.getName() == null ? "" : shop.getName();
		this.shopEnName = shop.getEnName() == null ? "" : shop.getEnName();
	}

	public Integer getShopId() {
		return shopId;
	}

	public void setShopId(Integer shopId) {
		this.shopId = shopId;
	}

	public String getMerchandiseId() {
		return merchandiseId;
	}

	public void setMerchandiseId(String merchandiseId) {
		this.merchandiseId = merchandiseId;
	}

	public Integer getMerShopSort() {
		return merShopSort;
	}

	public void setMerShopSort(Integer merShopSort) {
		this.merShopSort = merShopSort;
	}

	public String getRegion() {
		return region;
	}

	public void setRegion(String region) {
		this.region = region;
	}

	public String getShopName() {
		return shopName;
	}

	public void setShopName(String shopName) {
		this.shopName = shopName;
	}

	public String getShopEnName() {
		return shopEnName;
	}

	public void setShopEnName(String shopEnName) {
		this.shopEnName = shopEnName;
	}

}
