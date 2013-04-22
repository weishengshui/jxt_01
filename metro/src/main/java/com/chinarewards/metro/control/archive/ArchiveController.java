package com.chinarewards.metro.control.archive;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.imgscalr.Scalr;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.FileUtil;
import com.chinarewards.metro.core.common.SystemTimeProvider;
import com.chinarewards.metro.core.common.UUIDUtil;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.file.ImageType;
import com.chinarewards.metro.model.common.AjaxResponseCommonVo;
import com.chinarewards.metro.model.common.ImageInfo;

@Controller
@RequestMapping(value = "/archive")
public class ArchiveController {

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 获取展示图片
	 * 
	 * @param path
	 * @param fileName
	 * @param contentType
	 * @param tempPath
	 *            图片存放的临时目录
	 * @param formalPath
	 *            图片存放的正式目录
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/imageShow")
	public void shopPicShow(String fileName, String contentType,
			String tempPath, String formalPath, HttpServletResponse response)
			throws Exception {
		logger.trace("==============archive imageShow=======>  "
				+ contentType);

		tempPath = Dictionary.getPicPath(tempPath);
		formalPath = Dictionary.getPicPath(formalPath);
		String path = "";
		if ("".equals(tempPath) && "".equals(formalPath)) {
		} else {
			if (!fileName.startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)
					&& StringUtils.isNotEmpty(formalPath) ) {
				FileUtil.pathExist(formalPath);
				if(new File(formalPath, fileName).exists()){
					path = formalPath;
				}
			} else if (fileName.startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)) {
				FileUtil.pathExist(tempPath);
				FileUtil.pathExist(formalPath);
				if (new File(tempPath, fileName).exists()) {
					path = tempPath;
				} else if (new File(formalPath,
						fileName.substring(Constants.UPLOAD_TEMP_UID_PREFIX
								.length())).exists()) {
					path = formalPath;
					fileName = fileName
							.substring(Constants.UPLOAD_TEMP_UID_PREFIX
									.length());
				}
			}
		}

		if (!"".equals(path)) {
			File file = new File(path, fileName);
			response.setContentType(contentType);
			response.setContentLength((int) file.length());
			response.setHeader("Content-Disposition", "inline; filename=\""
					+ file.getName() + "\"");
			byte[] bbuf = new byte[1024];
			DataInputStream in = new DataInputStream(new FileInputStream(file));
			int bytes = 0;
			ServletOutputStream op = response.getOutputStream();
			while ((in != null) && ((bytes = in.read(bbuf)) != -1)) {
				op.write(bbuf, 0, bytes);
			}
			in.close();
			op.flush();
			op.close();
		}
	}

	/**
	 * 获取展示的缩略图
	 * 
	 * @param path
	 * @param fileName
	 * @param tempPath
	 *            图片存放的临时目录
	 * @param formalPath
	 *            图片存放的正式目录
	 * @param contentType
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/showGetthumbPic")
	public void showGetthumbPic(String fileName, String tempPath,
			String formalPath, String contentType, HttpServletResponse response)
			throws Exception {
		logger.trace("==========archive showGetthumbPic===========>  "
				+ contentType);

		tempPath = Dictionary.getPicPath(tempPath);
		formalPath = Dictionary.getPicPath(formalPath);
		String path = "";
		if ("".equals(tempPath) && "".equals(formalPath)) {
		} else {
			if (!fileName.startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)
					&& StringUtils.isNotEmpty(formalPath)) {
				FileUtil.pathExist(formalPath);
				path = formalPath;
			} else if (fileName.startsWith(Constants.UPLOAD_TEMP_UID_PREFIX)) {
				FileUtil.pathExist(tempPath);
				FileUtil.pathExist(formalPath);
				if (new File(tempPath, fileName).exists()) {
					path = tempPath;
				} else if (new File(formalPath,
						fileName.substring(Constants.UPLOAD_TEMP_UID_PREFIX
								.length())).exists()) {
					path = formalPath;
					fileName = fileName
							.substring(Constants.UPLOAD_TEMP_UID_PREFIX
									.length());
				}
			}
		}

		System.out
				.println("==========archive showGetthumbPic real path===========>  "
						+ path);

		if (!"".equals(path)) {
			File file = new File(path, fileName);
			if (file.exists()) {
				logger.trace("==========archive real path===========>  "
						+ path);
				contentType = contentType.toLowerCase();
				if (contentType.endsWith("png") || contentType.endsWith("jpeg")
						|| contentType.endsWith("gif")
						|| contentType.endsWith("jpg")
						|| contentType.endsWith("bmp")) {
					BufferedImage im = ImageIO.read(file);
					if (im != null) {
						BufferedImage thumb = Scalr.resize(im, 75);
						ByteArrayOutputStream os = new ByteArrayOutputStream();
						if (contentType.endsWith("png")) {
							ImageIO.write(thumb, "PNG", os);
						} else if (contentType.endsWith("jpeg")
								|| contentType.endsWith("jpg")) {
							ImageIO.write(thumb, "JPG", os);
						} else if (contentType.endsWith("bmp")) {
							ImageIO.write(thumb, "BMP", os);
						} else {
							ImageIO.write(thumb, "GIF", os);
						}
						response.setContentType(contentType);
						ServletOutputStream srvos = response.getOutputStream();
						response.setContentLength(os.size());
						response.setHeader("Content-Disposition",
								"inline; filename=\"" + file.getName() + "\"");
						os.writeTo(srvos);
						srvos.flush();
						srvos.close();
					}
				}
			}
		}
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/deleteImage")
	@ResponseBody
	public void deleteImage(HttpServletResponse response, HttpSession session,
			String path, String imageSessionName, String key) throws Exception {

		Map<String, FileItem> images = (Map<String, FileItem>) session
				.getAttribute(imageSessionName);
		if (null != images) {
			FileItem image = images.get(key);
			path = Dictionary.getPicPath(path);
			if (!"".equals(path)) {
				if (null != image) {
					System.out
							.println("===========archive delete Image real path=============>"
									+ path);
					if (StringUtils.isEmpty(image.getId())) {// 用户上传的临时图片，从map中去除
						new File(path, image.getUrl()).delete();
						images.remove(key);
					} else {// 说明是从数据库查询出的图片，将image标记为“可删除的”
						image.setDelete(true);
					}
				}

				response.setContentType("text/html; charset=utf-8");
				PrintWriter out = response.getWriter();
				out.write("{msg:\'删除成功\'}");
				out.flush();
			}
		}
	}

	@RequestMapping(value = "/deleteAllImage")
	@ResponseBody
	public void deleteAllImage(HttpServletResponse response,
			HttpSession session, String path, String imageSessionName)
			throws IOException {

		session.removeAttribute(imageSessionName);

		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.write("{msg:\'删除成功\'}");
		out.flush();
	}

	/**
	 * 将上传文件保存至临时文件夹
	 */
	/**
	 * 
	 * @param overview
	 * @param others
	 * @param mFile
	 * @param path
	 * @param key
	 * @param session
	 * @param imageSessionName
	 * @param response
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/imageUpload", method = RequestMethod.POST)
	@ResponseBody
	public void imageUpload(
			@RequestParam(value = "file") MultipartFile mFile,
			String path, String key, String imageType, HttpSession session,
			String imageSessionName, HttpServletResponse response) {

		logger.trace(" imageUpload path is " + path);
		path = Dictionary.getPicPath(path);
		logger.trace("real path is " + path);
		if (null == mFile) {
			return;
		}

		if (mFile.isEmpty()) {// 没有数据
			return;
		}

		if (!"".equals(path)) {
			FileUtil.pathExist(path);
			PrintWriter out = null;
			if (null == imageSessionName || imageSessionName.isEmpty()) {
				imageSessionName = UUIDUtil.generate();
			}
			if (null == key || key.isEmpty()) {
				key = "A" + UUIDUtil.generate();
			}

			try {
				response.setContentType("text/html; charset=utf-8");
				out = response.getWriter();
				String fileName = mFile.getOriginalFilename();
				String suffix = FileUtil.getSuffix(fileName);
				String fileNewName = Constants.UPLOAD_TEMP_UID_PREFIX // 临时文件前缀
						+ UUIDUtil.generate() + suffix;
				FileUtil.saveFile(mFile.getInputStream(), path, fileNewName);

				Map<String, FileItem> images = (LinkedHashMap<String, FileItem>) session
						.getAttribute(imageSessionName);
				if (null == images) {
					images = new LinkedHashMap<String, FileItem>();
				} else {
					FileItem tmpImage = images.get(key);
					if (null != tmpImage) {
						if (StringUtils.isEmpty(tmpImage.getId())) { // 说明是用户上传的临时图片，本次上传的图片将替换它，从map中移除
							new File(path, tmpImage.getUrl()).delete();
							images.remove(key);
						} else {// 说明是从数据库查询出的图片，做个删除“标记”，在提交“基本信息”表单时再从数据库中删除相应的信息，并不从map中移除
							tmpImage.setDelete(true);
							key = "" + UUIDUtil.generate();// 生成新的key
						}
					}
				}

				FileItem image = new FileItem();
				logger.trace("image is " + image);
				ImageInfo imageInfo = FileUtil.getImageInfo(path, fileNewName);
				image.setWidth(imageInfo.getWidth());
				image.setHeight(imageInfo.getHeight());
				image.setCreatedAt(SystemTimeProvider.getCurrentTime());
				image.setCreatedBy(UserContext.getUserId());
				image.setFilesize(mFile.getSize());
				image.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
				image.setLastModifiedBy(UserContext.getUserId());
				image.setMimeType(mFile.getContentType());
				image.setOriginalFilename(fileName);
				image.setUrl(fileNewName);
				if(!StringUtils.isEmpty(imageType)){
					image.setImageType(ImageType.fromString(imageType));
				}
				
				images.put(key, image);

				logger.trace("images size is " + images.size()
						+ " key is " + key + " imageSessionName is "
						+ imageSessionName);
				session.setAttribute(imageSessionName, images);

				out.write("{url:\'" + image.getUrl() + "\',width:\'"
						+ image.getWidth() + "\',height:\'" + image.getHeight()
						+ "\',imageSessionName:\'" + imageSessionName
						+ "\',contentType:\'" + image.getMimeType()
						+ "\',key:\'" + key + "\'}");
				out.flush();
			} catch (FileNotFoundException e) {
				out.write(CommonUtil.toJson(new AjaxResponseCommonVo("错误："
						+ e.getMessage())));
				out.flush();
				e.printStackTrace();
			} catch (IOException e) {
				out.write(CommonUtil.toJson(new AjaxResponseCommonVo("错误："
						+ e.getMessage())));
				out.flush();
				e.printStackTrace();
			} catch (Exception e) {
				out.write(CommonUtil.toJson(new AjaxResponseCommonVo("错误："
						+ e.getMessage())));
				out.flush();
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * ueditor获取文件
	 * 
	 * @param datetime
	 * @param fileName
	 */
	@RequestMapping("/ueditor/{datetime}/{fileName}/")
	public void ueditorGetFile(@PathVariable("datetime") String datetime, @PathVariable("fileName") String fileName, HttpServletResponse response) throws IOException{
		
		String path = Constants.UEDITOR_UPLOAD_DIR + datetime;
		List<String> fileTypes = new ArrayList<String>();
		fileTypes.add(".gif"); 
		fileTypes.add(".png");
		fileTypes.add(".jpg");
		fileTypes.add(".jpeg");
		fileTypes.add(".bmp");
		FileUtil.pathExist(path);
		if (!"".equals(path)) {
			File file = new File(path, fileName);
			String fileType = FileUtil.getSuffix(fileName);
			if(fileTypes.contains(fileType)){//图片在网页上显示
				response.setContentLength((int) file.length());
				response.setHeader("Content-Disposition", "inline; filename=\""
						+ file.getName() + "\"");
				byte[] bbuf = new byte[1024];
				DataInputStream in = new DataInputStream(new FileInputStream(file));
				int bytes = 0;
				ServletOutputStream op = response.getOutputStream();
				while ((in != null) && ((bytes = in.read(bbuf)) != -1)) {
					op.write(bbuf, 0, bytes);
				}
				in.close();
				op.flush();
				op.close();
			}else{//其它附件，则是下载
				InputStream input = FileUtils.openInputStream(file);
				byte[] data = IOUtils.toByteArray(input);
				response.reset();
				response.setHeader("Content-Disposition", "attachment; filename="
						+ new String(fileName.getBytes("gb2312"), "ISO8859-1"));
				response.addHeader("Content-Length", "" + data.length);
				response.setContentType("application/octet-stream; charset=UTF-8");
				IOUtils.write(data, response.getOutputStream());
				IOUtils.closeQuietly(input);
			}
		}
	}
}
