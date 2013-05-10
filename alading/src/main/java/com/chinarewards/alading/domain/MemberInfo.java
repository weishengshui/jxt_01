package com.chinarewards.alading.domain;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class MemberInfo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9012610712591942605L;

	private String memberSession; // 会员的session
	private CardList cardList; // 会员卡列表

	public String getMemberSession() {
		return memberSession;
	}

	public void setMemberSession(String memberSession) {
		this.memberSession = memberSession;
	}

	public CardList getCardList() {
		return cardList;
	}

	public void setCardList(CardList cardList) {
		this.cardList = cardList;
	}

}
