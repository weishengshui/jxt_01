package com.chinarewards.metro.models.merchandise;

/**
 * 储值卡消费中的商品VO
 * 
 * @author weishengshui
 * 
 */
public class CommodityVo {

	private String id;
	private String name;
	private Integer count;

	public CommodityVo() {
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getCount() {
		return count;
	}

	public void setCount(Integer count) {
		this.count = count;
	}
	
	@Override
	public String toString() {
		return "id="+id+"&name="+name+"&count="+count;
	}
}
