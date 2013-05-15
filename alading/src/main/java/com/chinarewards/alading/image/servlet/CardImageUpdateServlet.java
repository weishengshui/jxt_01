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

// 卡图片 修改、删除servlet
@Singleton
public class CardImageUpdateServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5029158065478669008L;

	@InjectLogger
	private Logger logger;
	@Inject
	private IFileItemService fileItemService;
	
	// update image
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
		String id = mr.getParameter("id");
		
		FileItem fileItem = new FileItem();
		fileItem.setDescription(description);
		try {
			fileItem.setId(Integer.valueOf(id));
		} catch (Exception e) {
		}
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
				fileItem.setContent(bbuf);
				fileItem.setMimeType(contentType);
				fileItem.setOriginalFilename(originalFileName);
				fileItem.setFilesize(length);
			}
			fis.close();
			file.delete();
		}
		fileItemService.updateDescContent(fileItem);
		resp.getWriter().write("success");
		resp.getWriter().flush();
		resp.getWriter().close();

	}
	
	// delete image
	@Override
	protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		resp.setContentType("text/html; charset=utf8");
		String id = req.getParameter("id");
		String res = "删除失败";
		try {
			boolean check = fileItemService.checkDeleteFileItemById(Integer.valueOf(id));
			if(!check){
				res = "该图片已经绑定到卡，不能删除";
			}else {
				int count = fileItemService.deleteFileItemById(Integer.valueOf(id));
				if(count == 1){
					res = "删除成功";
				} 
			}
		} catch (Exception e) {
		}
		
		resp.getWriter().write(res);
		resp.getWriter().flush();
		resp.getWriter().close();
	}
	
	// prepare data before update
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		String id = req.getParameter("id");
		FileItem fileItem = fileItemService.findFileItemById(Integer.valueOf(id));
		req.setAttribute("image", fileItem);
		
		req.getRequestDispatcher("/view/updateCardImage.jsp").forward(req, resp);
	}
}