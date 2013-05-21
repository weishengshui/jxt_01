package com.chinarewards.alading.card.vo;

import java.util.List;

import com.chinarewards.alading.domain.Company;

public class CompanyList {

	private Integer page;
	private List<Company> rows;
	private Integer total;

	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public List<Company> getRows() {
		return rows;
	}

	public void setRows(List<Company> rows) {
		this.rows = rows;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

}
