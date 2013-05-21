package com.chinarewards.alading.card.action;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;

import com.chinarewards.alading.action.BaseAction;
import com.chinarewards.alading.card.vo.CardList;
import com.chinarewards.alading.card.vo.CardVo;
import com.chinarewards.alading.card.vo.CompanyList;
import com.chinarewards.alading.domain.Card;
import com.chinarewards.alading.domain.Company;
import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.domain.Unit;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.ICompanyCardService;
import com.google.inject.Inject;

/**
 * 卡 action
 * 
 * @author weishengshui
 * 
 */
public class CardAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = -967185105538028790L;
	@InjectLogger
	private Logger logger;
	@Inject
	private ICompanyCardService companyCardService;

	// 进入页面为1，提交表单为2，成功为3，失败为4, 默认卡已经存在为5(不存在为0)，卡已经绑定到企业为6，卡名称已经存在为7(不存在为0)
	private Integer type;

	// card id
	private Integer id;
	private String cardName;
	// picture id
	private Integer picId;
	private Integer unitId;
	private Boolean defaultCard;
	private String companyId;

	// list cards
	private Integer page;
	private Integer rows;
	private CardList cardList;

	private CardVo card;

	// company list
	private String companyCode;
	private String companyName;
	private CompanyList companyList;

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

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

	public Integer getPicId() {
		return picId;
	}

	public void setPicId(Integer picId) {
		this.picId = picId;
	}

	public Integer getUnitId() {
		return unitId;
	}

	public void setUnitId(Integer unitId) {
		this.unitId = unitId;
	}

	public Boolean getDefaultCard() {
		return defaultCard;
	}

	public void setDefaultCard(Boolean defaultCard) {
		this.defaultCard = defaultCard;
	}

	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}

	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public Integer getRows() {
		return rows;
	}

	public void setRows(Integer rows) {
		this.rows = rows;
	}

	public CardList getCardList() {
		return cardList;
	}

	public void setCardList(CardList cardList) {
		this.cardList = cardList;
	}

	public CardVo getCard() {
		return card;
	}

	public void setCard(CardVo card) {
		this.card = card;
	}

	public String getCompanyCode() {
		return companyCode;
	}

	public void setCompanyCode(String companyCode) {
		this.companyCode = companyCode;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public CompanyList getCompanyList() {
		return companyList;
	}

	public void setCompanyList(CompanyList companyList) {
		this.companyList = companyList;
	}

	// create or update card
	public String addCard() throws Exception {

		logger.info(
				"add card: id={}, cardName={}, defaultCard={}, picId={}, unitId={}",
				new Object[] { id, cardName, defaultCard, picId, unitId });

		if (null == type || type.equals(new Integer(1))) { // 进入页面
			return "enter";
		}

		try {
			Card card = new Card();
			card.setId(id);
			card.setCardName(cardName);
			card.setDefaultCard(defaultCard == null ? false : defaultCard);
			FileItem pic = new FileItem();
			pic.setId(picId);
			Unit unit = new Unit();
			unit.setPointId(unitId);

			card.setPicUrl(pic);
			card.setUnit(unit);

			companyCardService.createOrUpdateCard(card, companyId);
			type = 3; // success
		} catch (Exception e) {
			type = 4; // failure
		}

		return SUCCESS;
	}

	// card list
	// 组装成 CardVo，方便页面显示
	public String listCards() throws Exception {

		page = (page == null) ? 1 : page;
		rows = (rows == null) ? 10 : rows;

		logger.info(
				"list cards: page={}, rows={}, cardName={}, defaultCard={}",
				new Object[] { page, rows, cardName, defaultCard });

		CardVo cardVo = new CardVo();
		cardVo.setCardName(cardName);
		cardVo.setDefaultCard(defaultCard);

		List<CardVo> list = companyCardService.findCards(page, rows, cardVo);
		Integer count = companyCardService.countCards(page, rows, cardVo);

		cardList = new CardList();
		cardList.setPage(page);
		cardList.setTotal(count == null ? 0 : count);
		cardList.setRows(list == null ? new ArrayList<CardVo>() : list);

		return SUCCESS;
	}

	public String deleteCard() throws Exception {

		logger.info("delete card: id={}", id);

		try {
			companyCardService.removeCard(id);
			type = 3; // delete success
		} catch (Exception e) {
			type = 4; // delete failure
		}

		return SUCCESS;
	}

	// prepare data for update
	public String showCard() throws Exception {

		logger.info("get card: id={}", id);

		// prepare data for update
		card = companyCardService.findCardVoByCardId(id);

		return SUCCESS;
	}

	// 检查是否已经有默认卡
	public String checkDefaultCard() throws Exception {

		if (null != companyCardService.findDefaultCard()) {
			type = 5; // 默认卡已存在
		} else {
			type = 0; // 不存在
		}

		return SUCCESS;
	}

	// 检查卡名称是否存在
	public String checkCardName() throws Exception {

		logger.info("checkCardName: cardName={}", cardName);

		List<Card> list = companyCardService.findCardsByName(cardName);

		if (null != list && list.size() > 0) {
			type = 7; // 卡名称存在
		} else {
			type = 0; // 卡名称不存在
		}

		return SUCCESS;
	}

	// 查询企业列表
	public String listCompanies() throws Exception {

		page = (page == null) ? 1 : page;
		rows = (rows == null) ? 10 : rows;

		logger.info(
				"list Companies: page={}, rows={}, companyCode={}, companyName={}",
				new Object[] { page, rows, companyCode, companyName });

		Company company = new Company();
		company.setCode(companyCode);
		company.setName(companyName);

		List<Company> list = companyCardService.searchCompanys(page, rows,
				company);
		Integer count = companyCardService.countCompanys(page, rows, company);

		companyList = new CompanyList();
		companyList.setPage(page);
		companyList.setTotal(count == null ? 0 : count);
		companyList.setRows(list == null ? new ArrayList<Company>() : list);

		return SUCCESS;
	}
}
