package com.chinarewards.metro.model.merchandise;

import com.chinarewards.common.models.PageSorting.SortingDetail;
import com.chinarewards.metro.core.common.Page;

/**
 * 商品查询条件
 * 
 * @author weishengshui
 * 
 */
public class MerchandiseCriteria {

	private String id;
	private String code;
	private String name;
	private String model;
	private String unitId; // 根据unitId确定售卖形式
	private String categoryId; // 商品目录所属的类别id
	private Integer brandId;
	private Double rmbPrcieFrom;
	private Double rmbPrcieTo;
	private Double rmbPreferentialPrcieFrom;
	private Double rmbPreferentialPrcieTo;
	private Double binkePrcieFrom;
	private Double binkePrcieTo;
	private Double binkePreferentialPrcieFrom;
	private Double binkePreferentialPrcieTo;

	private Page paginationDetail;
	private SortingDetail sortingDetail;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUnitId() {
		return unitId;
	}

	public void setUnitId(String unitId) {
		this.unitId = unitId;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getModel() {
		return model;
	}

	public void setModel(String model) {
		this.model = model;
	}

	public Page getPaginationDetail() {
		return paginationDetail;
	}

	public void setPaginationDetail(Page paginationDetail) {
		this.paginationDetail = paginationDetail;
	}

	public SortingDetail getSortingDetail() {
		return sortingDetail;
	}

	public void setSortingDetail(SortingDetail sortingDetail) {
		this.sortingDetail = sortingDetail;
	}

	public String getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(String categoryId) {
		this.categoryId = categoryId;
	}

	public Integer getBrandId() {
		return brandId;
	}

	public void setBrandId(Integer brandId) {
		this.brandId = brandId;
	}

	public Double getRmbPrcieFrom() {
		return rmbPrcieFrom;
	}

	public void setRmbPrcieFrom(Double rmbPrcieFrom) {
		this.rmbPrcieFrom = rmbPrcieFrom;
	}

	public Double getRmbPrcieTo() {
		return rmbPrcieTo;
	}

	public void setRmbPrcieTo(Double rmbPrcieTo) {
		this.rmbPrcieTo = rmbPrcieTo;
	}

	public Double getRmbPreferentialPrcieFrom() {
		return rmbPreferentialPrcieFrom;
	}

	public void setRmbPreferentialPrcieFrom(Double rmbPreferentialPrcieFrom) {
		this.rmbPreferentialPrcieFrom = rmbPreferentialPrcieFrom;
	}

	public Double getRmbPreferentialPrcieTo() {
		return rmbPreferentialPrcieTo;
	}

	public void setRmbPreferentialPrcieTo(Double rmbPreferentialPrcieTo) {
		this.rmbPreferentialPrcieTo = rmbPreferentialPrcieTo;
	}

	public Double getBinkePrcieFrom() {
		return binkePrcieFrom;
	}

	public void setBinkePrcieFrom(Double binkePrcieFrom) {
		this.binkePrcieFrom = binkePrcieFrom;
	}

	public Double getBinkePrcieTo() {
		return binkePrcieTo;
	}

	public void setBinkePrcieTo(Double binkePrcieTo) {
		this.binkePrcieTo = binkePrcieTo;
	}

	public Double getBinkePreferentialPrcieFrom() {
		return binkePreferentialPrcieFrom;
	}

	public void setBinkePreferentialPrcieFrom(Double binkePreferentialPrcieFrom) {
		this.binkePreferentialPrcieFrom = binkePreferentialPrcieFrom;
	}

	public Double getBinkePreferentialPrcieTo() {
		return binkePreferentialPrcieTo;
	}

	public void setBinkePreferentialPrcieTo(Double binkePreferentialPrcieTo) {
		this.binkePreferentialPrcieTo = binkePreferentialPrcieTo;
	}
	
}
