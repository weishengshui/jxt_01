package com.chinarewards.alading.reg.mapper;

import java.util.List;
import java.util.Map;

import com.chinarewards.alading.card.vo.CardVo;
import com.chinarewards.alading.domain.Card;
import com.chinarewards.alading.domain.Company;
import com.chinarewards.alading.domain.CompanyCard;

public interface CompanyCardMapper extends CommonMapper<CompanyCard> {
	
	List<Integer> selectAllPic();

	Card selectDefaultCard();

	void insertCard(Card card);
	
	List<Company> selectCompanies(Map<String, Object> params);

	Integer countCompanies(Map<String, Object> params);

	Integer updateAllCardStatus(boolean b);

	List<CardVo> selectCards(Map<String, Object> params);

	Integer countCards(Map<String, Object> params);

	void deleteCompanyCardByCardId(Integer id);

	void deleteCard(Integer id);

	CardVo selectCardVo(Integer cardId);

	void updateCard(Card card);

	List<Card> selectCardsByName(String cardName);
}
