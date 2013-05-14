package com.chinarewards.alading.service;

import java.util.List;

import org.slf4j.Logger;

import com.chinarewards.alading.domain.Card;
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

	@Override
	public void createCard(Card card, String companyId) {
		
		logger.info("companyId="+companyId);
		
		companyCardMapper.insertCard(card);
	}

}
