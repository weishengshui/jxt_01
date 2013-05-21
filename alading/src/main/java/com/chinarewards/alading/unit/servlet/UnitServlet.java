package com.chinarewards.alading.unit.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;

import com.chinarewards.alading.domain.Unit;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.IUnitService;
import com.google.inject.Inject;
import com.google.inject.Singleton;

@Singleton
public class UnitServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5029158065478669008L;

	@InjectLogger
	private Logger logger;
	@Inject
	private IUnitService unitService;

	// 创建或更新积分单位
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		logger.info("pathInfo=" + req.getPathInfo());
		resp.setContentType("text/html; charset=UTF-8");

		String pointId = req.getParameter("pointId");
		String pointName = req.getParameter("pointName");
		String pointRate = req.getParameter("pointRate");
		logger.trace("pointName={}", pointName);

		Unit unit = new Unit();
		unit.setPointId((pointId != null && !pointId.isEmpty()) ? Integer
				.valueOf(pointId) : null);
		unit.setPointName(pointName);
		unit.setPointRate((pointRate != null && !pointRate.isEmpty()) ? Integer
				.valueOf(pointRate) : null);

		unitService.createOrUpdateUnit(unit);

		resp.getWriter().write("保存成功");
		resp.getWriter().flush();
		resp.getWriter().close();

	}

	// 获取积分单位
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		Unit unit = unitService.findUnit();
		req.setAttribute("unit", unit);

		req.getRequestDispatcher("/view/unitShow.jsp").forward(req, resp);
	}
}
