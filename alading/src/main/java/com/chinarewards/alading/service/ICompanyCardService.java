package com.chinarewards.alading.service;

import java.util.List;

import com.chinarewards.alading.domain.Card;

public interface ICompanyCardService {

	List<Integer> findAllPic();

	Card findDefaultCard();

	/**
	 * 创建卡，如果companyId不为空，将卡绑定到companyId指定的企业
	 * 
	 * @param card
	 * @param companyId
	 */
	void createCard(Card card, String companyId);

}
