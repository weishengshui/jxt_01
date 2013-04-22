package com.chinarewards.metro.model.discountcoupon;

import com.chinarewards.metro.core.common.Page;

/**
 * 优惠券查询条件
 * 
 * @author weishengshui
 * 
 */
public class DiscountCouponCriteria {

	private Integer shopId; // 门市ID

	private Integer shopChainId; // 连锁ID

	private Integer queryType; // 查询类型：1 表示查询所有门市；2 表示查询所有连锁

	private Page paginationDetail;

	public Integer getShopId() {
		return shopId;
	}

	public void setShopId(Integer shopId) {
		this.shopId = shopId;
	}

	public Integer getShopChainId() {
		return shopChainId;
	}

	public void setShopChainId(Integer shopChainId) {
		this.shopChainId = shopChainId;
	}

	public Integer getQueryType() {
		return queryType;
	}

	public void setQueryType(Integer queryType) {
		this.queryType = queryType;
	}

	public Page getPaginationDetail() {
		return paginationDetail;
	}

	public void setPaginationDetail(Page paginationDetail) {
		this.paginationDetail = paginationDetail;
	}

}
