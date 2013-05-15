package com.chinarewards.alading.domain;

import java.io.Serializable;

public class Card implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4839789260676317435L;

	private Integer id;
	private String cardName;
	private FileItem picUrl;
	private boolean defaultCard; // 是否默认卡， 默认卡就一张
	private Unit unit;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getCardName() {
		return cardName;
	}

	public void setCardName(String cardName) {
		this.cardName = cardName;
	}

	public FileItem getPicUrl() {
		return picUrl;
	}

	public void setPicUrl(FileItem picUrl) {
		this.picUrl = picUrl;
	}

	public Unit getUnit() {
		return unit;
	}

	public void setUnit(Unit unit) {
		this.unit = unit;
	}

	public boolean getDefaultCard() {
		return defaultCard;
	}

	public void setDefaultCard(boolean defaultCard) {
		this.defaultCard = defaultCard;
	}

}
