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
import com.chinarewards.alading.service.IFileItemService;
import com.google.inject.Inject;
import com.google.inject.Singleton;

// 卡  servlet
@Singleton
public class CardServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5029158065478669008L;

	@InjectLogger
	private Logger logger;
	@Inject
	private IFileItemService fileItemService;
	@Inject
	private ICompanyCardService companyCardService;
	
	// add Card
	@Override
	protected void doPut(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		String cardName = req.getParameter("cardName");
		String picId = req.getParameter("picId");
		String unitId = req.getParameter("unitId");
		String defaultCard = req.getParameter("defaultCard");
		String companyId = req.getParameter("companyId");
		
		Card card = new Card();
		card.setCardName(cardName);
		card.setDefaultCard((null != defaultCard && !defaultCard.isEmpty())?Boolean.valueOf(defaultCard):false);
		FileItem pic = new FileItem();
		pic.setId(Integer.valueOf(picId));
		Unit unit = new Unit();
		unit.setPointId(Integer.valueOf(unitId));
		
		card.setPicUrl(pic);
		card.setUnit(unit);
		
		companyCardService.createCard(card, companyId);
	}
	
	// update card: update cardName
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse resp)
			throws ServletException, IOException {

		logger.info("entrance CardImageUploadServlet");

		resp.setContentType("text/html; charset=utf8");

	}

	// delete card
	@Override
	protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		resp.setContentType("text/html; charset=utf8");
		String id = req.getParameter("id");
		String res = "删除失败";

		resp.getWriter().write(res);
		resp.getWriter().flush();
		resp.getWriter().close();
	}
	
	// get card
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
	}
	
	
}
