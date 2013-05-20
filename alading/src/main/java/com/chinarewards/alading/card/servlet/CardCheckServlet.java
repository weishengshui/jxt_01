package com.chinarewards.alading.card.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;

import com.chinarewards.alading.domain.Card;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.ICompanyCardService;
import com.google.inject.Inject;
import com.google.inject.Singleton;

@Singleton
public class CardCheckServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5029158065478669008L;

	@InjectLogger
	private Logger logger;
	@Inject
	private ICompanyCardService companyCardService;

	// 检查是否有默认卡，如果有默认卡就不能继续添加默认卡
	@Override
	protected void doPut(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		logger.info("check default card");
		resp.setContentType("text/html; charset=utf8");

		if (null != companyCardService.findDefaultCard()) {
			resp.getWriter().write("true");
		} else {
			resp.getWriter().write("false");
		}

		resp.getWriter().flush();
		resp.getWriter().close();
	}
	
	// 检查卡名称是否存在
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		resp.setContentType("text/html; charset=utf8");
		
		String cardName = req.getParameter("cardName");
		logger.info("check cardName={}", cardName);
		
		List<Card> list = companyCardService.findCardsByName(cardName);

		if (null != list && list.size() > 0) {
			resp.getWriter().write("true");
		} else {
			resp.getWriter().write("false");
		}

		resp.getWriter().flush();
		resp.getWriter().close();
	}

	@Override
	protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		// resp.setContentType("text/html; charset=utf8");
		// String id = req.getParameter("id");
		// String res = "删除失败";
		//
		// resp.getWriter().write(res);
		// resp.getWriter().flush();
		// resp.getWriter().close();
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

	}

}
