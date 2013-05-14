package com.chinarewards.alading.image.servlet;

import java.io.ByteArrayInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;

import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.IFileItemService;
import com.google.inject.Inject;
import com.google.inject.Singleton;

// 卡图片 获取servlet (浏览器显示)
@Singleton
public class CardImageGetServlet extends HttpServlet {

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

		logger.info("pathInfo=" + req.getPathInfo());
		String pathInfo = req.getPathInfo();
		if (null == pathInfo || pathInfo.equals("") || pathInfo.length() == 1) {
			return;
		}
		String[] strArray = pathInfo.substring(1).split("/");
		String fileItemId = strArray[0];
		FileItem fileItem = null;
		try {
			fileItem = fileItemService.findFileItemById(Integer
					.valueOf(fileItemId));
		} catch (Exception e) {
		}
		if (null != fileItem) {
			byte[] content = fileItem.getContent();
			if (null != content) {
				resp.setContentType(fileItem.getMimeType());
				resp.setContentLength(content.length);
				resp.setHeader("Content-Disposition", "inline; filename=\""
						+ "1112.jpg" + "\"");
				byte[] bbuf = new byte[1024];
				ByteArrayInputStream in = new ByteArrayInputStream(content);
				int bytes = 0;
				ServletOutputStream op = resp.getOutputStream();
				while ((in != null) && ((bytes = in.read(bbuf)) != -1)) {
					op.write(bbuf, 0, bytes);
				}
				in.close();
				op.flush();
				op.close();
			}
		}
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		doPost(req, resp);
	}
}
