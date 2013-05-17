package com.chinarewards.alading.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.guice.transactional.Transactional;
import org.slf4j.Logger;

import com.chinarewards.alading.card.vo.CardVo;
import com.chinarewards.alading.domain.Card;
import com.chinarewards.alading.domain.Company;
import com.chinarewards.alading.domain.CompanyCard;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.reg.mapper.CompanyCardMapper;
import com.google.inject.Inject;

public class CompanyCardService implements ICompanyCardService {

	@InjectLogger
	private Logger logger;

	@Inject
	private CompanyCardMapper companyCardMapper;

	@Override
	public List<Integer> findAllPic() {
		return companyCardMapper.selectAllPic();
	}

	@Override
	public Card findDefaultCard() {

		return companyCardMapper.selectDefaultCard();
	}

	@Transactional
	@Override
	public void createOrUpdateCard(Card card, String companyId) {

		logger.info("companyId=" + companyId);
		if (card.getDefaultCard() == true) {
			companyCardMapper.updateAllCardStatus(false);
		}
		if(null == card.getId()){ // insert 
			companyCardMapper.insertCard(card);
			
			// 将卡绑定到企业
			if (null != companyId && !companyId.isEmpty()) {
				
				CompanyCard companyCard = new CompanyCard();
				Company company = new Company();
				company.setId(Integer.valueOf(companyId));
				companyCard.setCard(card);
				companyCard.setCompany(company);
				
				companyCardMapper.insert(companyCard);
			}
		} else { // update
			companyCardMapper.updateCard(card);
			
			// 更新企业与卡的关系
			// if (null != companyId && !companyId.isEmpty()) {
			//
			// CompanyCard companyCard = new CompanyCard();
			// Company company = new Company();
			// company.setId(Integer.valueOf(companyId));
			// companyCard.setCard(card);
			// companyCard.setCompany(company);
			//
			// companyCardMapper.updateCompanyCard(companyCard);
			// }
		}

	}

	@Override
	public List<Company> searchCompanys(Integer page, Integer rows,
			Company company) {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("startIndex", (page - 1) * rows);
		params.put("pageSize", rows);
		params.put("name", company.getName());
		params.put("code", company.getCode());

		return companyCardMapper.selectCompanies(params);
	}

	@Override
	public Integer countCompanys(Integer page, Integer rows, Company company) {

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("name", company.getName());
		params.put("code", company.getCode());

		return companyCardMapper.countCompanies(params);
	}

	@Override
	public List<CardVo> findCards(Integer page, Integer rows,
			CardVo cardVo) {
		
		logger.info("defaultCard="+cardVo.getDefaultCard());
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("startIndex", (page - 1) * rows);
		params.put("pageSize", rows);
		params.put("cardName", cardVo.getCardName());
		// defaultCard == null 查询默认卡 与 非默认卡
		// defaultCard == false 查询非默认卡
		// defaultCard == true 查询默认卡
		params.put("defaultCard", cardVo.getDefaultCard());

		return companyCardMapper.selectCards(params);
	}

	@Override
	public Integer countCards(Integer page, Integer rows,
			CardVo cardVo) {
		
		logger.info("defaultCard="+cardVo.getDefaultCard());
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cardName", cardVo.getCardName());
		// defaultCard == null 查询默认卡 与 非默认卡
		// defaultCard == false 查询非默认卡
		// defaultCard == true 查询默认卡
		params.put("defaultCard", cardVo.getDefaultCard());

		return companyCardMapper.countCards(params);
	}
	
	@Transactional
	@Override
	public void removeCard(Integer id) {
		
		logger.info("id="+id);
		companyCardMapper.deleteCompanyCardByCardId(id);
		companyCardMapper.deleteCard(id);
	}

	@Override
	public CardVo findCardVoByCardId(Integer cardId) {
		
		logger.info("cardId: "+cardId);
		return companyCardMapper.selectCardVo(cardId);
	}

	@Override
	public List<Card> findCardsByName(String cardName) {
		
		return companyCardMapper.selectCardsByName(cardName);
	}

}
