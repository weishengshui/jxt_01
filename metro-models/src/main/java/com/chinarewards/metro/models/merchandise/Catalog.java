package com.chinarewards.metro.models.merchandise;

import java.io.Serializable;
import java.util.Date;

import com.chinarewards.metro.models.common.DateTools;

/**
 * 商品目录
 * 
 * @author weishengshui
 * 
 */
public class Catalog implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2576686725177707292L;

	private boolean onsale;

	private Date onsaleTime;

	private Category category;

	public Catalog(boolean onsale, Date onsaleTime, Category category) {
		this.onsale = onsale;
		this.onsaleTime = onsaleTime;
		this.category = category;
	}

	public Catalog() {
	}

	public boolean isOnsale() {
		return onsale;
	}

	public void setOnsale(boolean onsale) {
		this.onsale = onsale;
	}

	public Date getOnsaleTime() {
		return onsaleTime;
	}

	public void setOnsaleTime(Date onsaleTime) {
		this.onsaleTime = onsaleTime;
	}

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}

	@Override
	public String toString() {
		return "onsale=" + onsale;
	}
}
