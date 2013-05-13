package com.chinarewards.alading.image.servlet;

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

import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.IFileItemService;
import com.chinarewards.alading.util.CommonTools;
import com.google.inject.Inject;
import com.google.inject.Singleton;

// 卡图片 上传servlet
@Singleton
public class CardImageListServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5029158065478669008L;

	@InjectLogger
	private Logger logger;
	@Inject
	private IFileItemService fileItemService;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		logger.info("entrance CardImageListServlet");

		resp.setContentType("text/html; charset=utf8");

		String pageStr = req.getParameter("page");
		String rowsStr = req.getParameter("rows");
		String description = req.getParameter("description");
		Integer page = null;
		Integer rows = null;
		try {
			page = Integer.valueOf(pageStr);
			rows = Integer.valueOf(rowsStr);
		} catch (Exception e) {
		}

		page = (page == null) ? 1 : page;
		rows = (rows == null) ? 10 : rows;
		FileItem fileItem = new FileItem();
		fileItem.setDescription(description);

		List<FileItem> list = fileItemService.searchFileItems(page, rows,
				fileItem);
		Integer count = fileItemService.countFileItems(page, rows, fileItem);

		Map<String, Object> resMap = new HashMap<String, Object>();
		resMap.put("page", page);
		resMap.put("total", count == null ? 0 : count);
		resMap.put("rows", list == null ? new ArrayList<FileItem>() : list);

		String resBody = CommonTools.toJSONString(resMap);
		logger.info("json array: " + resBody);
		resp.getWriter().write(resBody);
		resp.getWriter().flush();
		resp.getWriter().close();
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		doPost(req, resp);
	}
}
