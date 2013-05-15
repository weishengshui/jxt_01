package com.chinarewards.alading.domain;

import java.io.Serializable;

public class CompanyCard implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7847445083732764999L;

	private Integer id;
	private Card card;
	private Company company;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Card getCard() {
		return card;
	}

	public void setCard(Card card) {
		this.card = card;
	}

	public Company getCompany() {
		return company;
	}

	public void setCompany(Company company) {
		this.company = company;
	}

}
