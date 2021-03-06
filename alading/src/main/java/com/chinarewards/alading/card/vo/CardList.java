package com.chinarewards.alading.card.vo;

import java.util.List;

public class CardList {

	private Integer page;
	private List<CardVo> rows;
	private Integer total;

	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public List<CardVo> getRows() {
		return rows;
	}

	public void setRows(List<CardVo> rows) {
		this.rows = rows;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

}
