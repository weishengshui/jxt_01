package com.chinarewards.alading.domain;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class CardList {
	private List<CardDetail> cardDetail = new ArrayList<CardDetail>();

	public List<CardDetail> getCardDetail() {
		return cardDetail;
	}

	public void setCardDetail(List<CardDetail> cardDetail) {
		this.cardDetail = cardDetail;
	}

}
