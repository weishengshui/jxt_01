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

import com.chinarewards.alading.domain.Company;
import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.ICompanyCardService;
import com.chinarewards.alading.service.IFileItemService;
import com.chinarewards.alading.util.CommonTools;
import com.google.inject.Inject;
import com.google.inject.Singleton;

// 企业列表  servlet
@Singleton
public class CompanyListServlet extends HttpServlet {

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

	// 获取还没有卡图片的企业列表
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		logger.info("entrance CompanyListServlet");

		resp.setContentType("text/html; charset=utf8");

		String pageStr = req.getParameter("page");
		String rowsStr = req.getParameter("rows");
		String companyName = req.getParameter("companyName");
		String companyCode = req.getParameter("companyCode");
		Integer page = null;
		Integer rows = null;
		try {
			page = Integer.valueOf(pageStr);
			rows = Integer.valueOf(rowsStr);
		} catch (Exception e) {
		}

		page = (page == null) ? 1 : page;
		rows = (rows == null) ? 10 : rows;

		Company company = new Company();
		company.setCode(companyCode);
		company.setName(companyName);

		List<Company> list = companyCardService.searchCompanys(page, rows,
				company);
		Integer count = companyCardService.countCompanys(page, rows, company);

		Map<String, Object> resMap = new HashMap<String, Object>();
		resMap.put("page", page);
		resMap.put("total", count == null ? 0 : count);
		resMap.put("rows", list == null ? new ArrayList<FileItem>() : list);

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

}
