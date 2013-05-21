package com.chinarewards.alading.card.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;

import com.chinarewards.alading.card.vo.CardVo;
import com.chinarewards.alading.domain.Card;
import com.chinarewards.alading.domain.CompanyCard;
import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.domain.Unit;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.ICompanyCardService;
import com.chinarewards.alading.util.CommonTools;
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
	private ICompanyCardService companyCardService;

	// card list
	// 组装成 CardVo，方便页面显示
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		logger.info("card list");

		resp.setContentType("text/html; charset=UTF-8");

		String pageStr = req.getParameter("page");
		String rowsStr = req.getParameter("rows");
		String cardName = req.getParameter("cardName");
		String defaultCard = req.getParameter("defaultCard");
		Integer page = null;
		Integer rows = null;
		try {
			page = Integer.valueOf(pageStr);
			rows = Integer.valueOf(rowsStr);
		} catch (Exception e) {
		}
		page = (page == null) ? 1 : page;
		rows = (rows == null) ? 10 : rows;

		CardVo cardVo = new CardVo();
		cardVo.setCardName(cardName);
		cardVo.setDefaultCard((null != defaultCard && !defaultCard.isEmpty()) ? Boolean
				.valueOf(defaultCard) : null);
		List<CardVo> list = companyCardService.findCards(page, rows, cardVo);
		Integer count = companyCardService.countCards(page, rows, cardVo);

		Map<String, Object> resMap = new HashMap<String, Object>();
		resMap.put("page", page);
		resMap.put("total", count == null ? 0 : count);
		resMap.put("rows", list == null ? new ArrayList<CompanyCard>() : list);

		String resBody = CommonTools.toJSONString(resMap);
		if (null != resBody) {
			if (resBody.startsWith("[")) {
				resBody = resBody.substring(1);
			}
			if (resBody.endsWith("]")) {
				resBody = resBody.substring(0, resBody.length() - 1);
			}
		}
		logger.info("json array: " + resBody);
		resp.getWriter().write(resBody);
		resp.getWriter().flush();
		resp.getWriter().close();
	}

	// delete card
	@Override
	protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		resp.setContentType("text/html; charset=UTF-8");
		String id = req.getParameter("id");
		String res = "删除成功";

		try {
			companyCardService.removeCard(Integer.valueOf(id));
		} catch (Exception e) {
			res = "删除失败";
		}

		resp.getWriter().write(res);
		resp.getWriter().flush();
		resp.getWriter().close();
	}

	// get cardVo
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		resp.setContentType("text/html; charset=UTF-8");
		String cardId = req.getParameter("id");

		CardVo cardVo = null;
		try {
			cardVo = companyCardService.findCardVoByCardId(Integer
					.valueOf(cardId));
		} catch (Exception e) {
		}
		// String resBody = CommonTools.toJSONString(cardVo);
		// if (null != resBody) {
		// if (resBody.startsWith("[")) {
		// resBody = resBody.substring(1);
		// }
		// if (resBody.endsWith("]")) {
		// resBody = resBody.substring(0, resBody.length() - 1);
		// }
		// }
		// logger.info("cardVo json: " + resBody);

		req.setAttribute("card", cardVo);
		req.getRequestDispatcher("/view/cardUpdate.jsp").forward(req, resp);

		// resp.getWriter().write(resBody);
		// resp.getWriter().flush();
		// resp.getWriter().close();

	}

}
