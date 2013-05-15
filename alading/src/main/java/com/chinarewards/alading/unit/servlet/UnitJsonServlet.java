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
import com.chinarewards.alading.util.CommonTools;
import com.google.inject.Inject;
import com.google.inject.Singleton;

@Singleton
public class UnitJsonServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5029158065478669008L;

	@InjectLogger
	private Logger logger;
	@Inject
	private IUnitService unitService;

	// unit json
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		resp.setContentType("text/html; charset=utf8");
		Unit unit = unitService.findUnit();
		String res = CommonTools.toJSONString(unit);
		if (null != res) {
			if (res.startsWith("[")) {
				res = res.substring(1);
			}
			if (res.endsWith("]")) {
				res = res.substring(0, res.length() - 1);
			}
		}
		logger.info("unit json:" + res);

		resp.getWriter().write(res);
		resp.getWriter().flush();
		resp.getWriter().close();
	}
}
