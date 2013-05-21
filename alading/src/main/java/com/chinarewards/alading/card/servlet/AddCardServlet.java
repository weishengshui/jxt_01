package com.chinarewards.alading.card.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;

import com.chinarewards.alading.domain.Card;
import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.domain.Unit;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.ICompanyCardService;
import com.google.inject.Inject;
import com.google.inject.Singleton;

// 卡  servlet
@Singleton
public class AddCardServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5029158065478669008L;

	@InjectLogger
	private Logger logger;
	@Inject
	private ICompanyCardService companyCardService;

	// create or update Card
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		logger.info("add card");
		resp.setContentType("text/html; charset=UTF-8");

		String cardId = req.getParameter("id");
		String cardName = req.getParameter("cardName");
		String picId = req.getParameter("picId");
		String unitId = req.getParameter("unitId");
		String defaultCard = req.getParameter("defaultCard");
		String companyId = req.getParameter("companyId");
		logger.trace(
				"cardId={}, cardName={}, picId={}, unitId={}, defaultCard={}, companyId={}",
				new Object[] { cardId, cardName, picId, unitId, defaultCard,
						companyId });
		Card card = new Card();
		if (null != cardId && !cardId.isEmpty()) {
			card.setId(Integer.valueOf(cardId));
		}
		card.setCardName(cardName);
		card.setDefaultCard((null != defaultCard && !defaultCard.isEmpty()) ? Boolean
				.valueOf(defaultCard) : false);
		FileItem pic = new FileItem();
		pic.setId(Integer.valueOf(picId));
		Unit unit = new Unit();
		unit.setPointId(Integer.valueOf(unitId));

		card.setPicUrl(pic);
		card.setUnit(unit);

		companyCardService.createOrUpdateCard(card, companyId);

		resp.getWriter().write("保存成功");
		resp.getWriter().flush();
		resp.getWriter().close();
	}

}
