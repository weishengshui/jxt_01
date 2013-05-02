package com.chinarewards.alading.response;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

import com.chinarewards.alading.domain.CardDetail;

@XmlRootElement
public class MemberInfo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9012610712591942605L;

	private String memberSession; // 会员的session
	private List<CardDetail> cardList; // 会员卡列表

	public String getMemberSession() {
		return memberSession;
	}

	public void setMemberSession(String memberSession) {
		this.memberSession = memberSession;
	}

	public List<CardDetail> getCardList() {
		return cardList;
	}

	public void setCardList(List<CardDetail> cardList) {
		this.cardList = cardList;
	}

}
