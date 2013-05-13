package com.chinarewards.alading.image.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;

import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.IFileItemService;
import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.oreilly.servlet.MultipartRequest;

// 卡图片 上传servlet
@Singleton
public class CardImageUploadServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5029158065478669008L;

	@InjectLogger
	private Logger logger;
	@Inject
	private IFileItemService fileItemService;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse resp)
			throws ServletException, IOException {

		logger.info("entrance CardImageUploadServlet");

		resp.setContentType("text/html; charset=utf8");

		MultipartRequest mr = null;
		int maxSize = 10485760;
		mr = new MultipartRequest(request, System.getProperty("user.dir"),
				maxSize, "UTF-8");
		File file = mr.getFile("pic");
		String description = mr.getParameter("description");
		if (null != file) {
			String contentType = mr.getContentType("pic");
			String originalFileName = mr.getOriginalFileName("pic");
			logger.info("contentType={}, originalFileName={}", new Object[] {
					contentType, originalFileName });
			FileInputStream fis = new FileInputStream(file);
			if (null != fis && fis.available() > 0) {
				int length = fis.available();
				byte[] bbuf = new byte[length];
				for (int i = 0; i < length; i++) {
					bbuf[i] = (byte) fis.read();
				}
				FileItem fileItem = new FileItem();
				fileItem.setContent(bbuf);
				fileItem.setMimeType(contentType);
				fileItem.setOriginalFilename(originalFileName);
				fileItem.setFilesize(length);
				fileItem.setDescription(description);
				fileItemService.save(fileItem);
			}
			fis.close();
			file.delete();
		}
		resp.getWriter().write("success");
		resp.getWriter().flush();
		resp.getWriter().close();

	}
}
