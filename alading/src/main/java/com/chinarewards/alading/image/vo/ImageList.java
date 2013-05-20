package com.chinarewards.alading.image.vo;

import java.util.List;

import com.chinarewards.alading.domain.FileItem;

public class ImageList {

	private Integer page;
	private List<FileItem> rows;
	private Integer total;

	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public List<FileItem> getRows() {
		return rows;
	}

	public void setRows(List<FileItem> rows) {
		this.rows = rows;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

}
