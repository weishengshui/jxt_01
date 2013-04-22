package com.chinarewards.metro.domain.merchandise;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

import org.hibernate.annotations.GenericGenerator;

import com.chinarewards.metro.domain.shop.Shop;

/**
 * 商品与门店的关系维护
 * 
 * @author weishengshui
 * 
 */
@Entity
public class MerchandiseShop implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2560193135439308612L;

	@Id
	@GeneratedValue(generator = "system-uuid")
	@GenericGenerator(name = "system-uuid", strategy = "uuid")
	private String id;

	@ManyToOne
	private Merchandise merchandise;

	@ManyToOne
	private Shop shop;

	private Integer sort;// 商品在门店的排序编号

	public MerchandiseShop() {
	}

	public MerchandiseShop(Merchandise merchandise, Shop shop, Integer sort) {
		this.merchandise = merchandise;
		this.shop = shop;
		this.sort = sort;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Merchandise getMerchandise() {
		return merchandise;
	}

	public void setMerchandise(Merchandise merchandise) {
		this.merchandise = merchandise;
	}

	public Shop getShop() {
		return shop;
	}

	public void setShop(Shop shop) {
		this.shop = shop;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

}
