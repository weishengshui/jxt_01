package com.chinarewards.alading.service;

import java.util.List;

import com.chinarewards.alading.domain.Card;
import com.chinarewards.alading.domain.Company;
import com.chinarewards.alading.domain.CompanyCard;

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
	
	/**
	 * 查询还没有卡的企业
	 * 
	 * @param page
	 * @param rows
	 * @param company
	 * @return
	 */
	List<Company> searchCompanys(Integer page, Integer rows, Company company);
	
	/**
	 * 计算没有卡的企业的数量
	 * 
	 * @param page
	 * @param rows
	 * @param company
	 * @return
	 */
	Integer countCompanys(Integer page, Integer rows, Company company);
	
	/**
	 * 查询卡
	 * 
	 * @param page
	 * @param rows
	 * @param companyCard
	 * @param defaultCard 
	 * @return
	 */
	List<CompanyCard> findCards(Integer page, Integer rows,
			CompanyCard companyCard, Boolean defaultCard);
	
	/**
	 * 计算卡数量
	 * 
	 * @param page
	 * @param rows
	 * @param companyCard
	 * @param defaultCard 
	 * @return
	 */
	Integer countCards(Integer page, Integer rows, CompanyCard companyCard, Boolean defaultCard);

}
