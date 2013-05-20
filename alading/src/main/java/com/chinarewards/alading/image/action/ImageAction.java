package com.chinarewards.alading.image.action;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;

import com.chinarewards.alading.action.BaseAction;
import com.chinarewards.alading.domain.FileItem;
import com.chinarewards.alading.image.vo.ImageList;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.service.IFileItemService;
import com.chinarewards.alading.util.CommonTools;
import com.google.inject.Inject;

/**
 * 卡图片 action
 * 
 * @author weishengshui
 * 
 */
public class ImageAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2850057898592056051L;

	@InjectLogger
	private Logger logger;
	@Inject
	private IFileItemService fileItemService;

	// 进入页面为1，提交表单为2，成功为3，失败为4，图片绑定到卡不能删除为5
	private Integer type;

	// add image
	private String description;
	private File pic;
	private String picContentType;
	private String picFileName;

	// list images
	private Integer page;
	private Integer rows;
	private ImageList imageList;

	// delete image
	private Integer id;

	// show image
	private String mimeType;

	// update image
	private FileItem image;

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public File getPic() {
		return pic;
	}

	public void setPic(File pic) {
		this.pic = pic;
	}

	public String getPicContentType() {
		return picContentType;
	}

	public void setPicContentType(String picContentType) {
		this.picContentType = picContentType;
	}

	public String getPicFileName() {
		return picFileName;
	}

	public void setPicFileName(String picFileName) {
		this.picFileName = picFileName;
	}

	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public Integer getRows() {
		return rows;
	}

	public void setRows(Integer rows) {
		this.rows = rows;
	}

	public ImageList getImageList() {
		return imageList;
	}

	public void setImageList(ImageList imageList) {
		this.imageList = imageList;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getMimeType() {
		return mimeType;
	}

	public void setMimeType(String mimeType) {
		this.mimeType = mimeType;
	}

	public FileItem getImage() {
		return image;
	}

	public void setImage(FileItem image) {
		this.image = image;
	}

	public String addImage() throws Exception {
		if (null == type || type.equals(new Integer(1)) || null == pic) {
			return "enter";
		} else {
			try {
				String contentType = picContentType;
				String originalFileName = picFileName;
				logger.info("addImage contentType={}, originalFileName={}",
						new Object[] { contentType, originalFileName });
				FileInputStream fis = new FileInputStream(pic);
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
				pic.deleteOnExit();
				type = 3; // 保存卡图片成功
			} catch (Exception e) {
				type = 4; // 保存图片失败
			}
			return SUCCESS;
		}
	}

	public String listImages() throws Exception {
		page = (page == null) ? 1 : page;
		rows = (rows == null) ? 10 : rows;
		FileItem fileItem = new FileItem();
		fileItem.setDescription(description);

		List<FileItem> list = fileItemService.searchFileItems(page, rows,
				fileItem);
		Integer count = fileItemService.countFileItems(page, rows, fileItem);
		logger.info("images list count: " + count);
		imageList = new ImageList();
		imageList.setPage(page);
		imageList.setRows((null == list) ? new ArrayList<FileItem>() : list);
		imageList.setTotal((null == count) ? 0 : count);

		return SUCCESS;

	}

	public String deleteImage() throws Exception {
		try {
			if (null == id) {
				type = 4; // id 不能为空，删除失败
			} else if (!fileItemService.checkDeleteFileItemById(id)) {
				type = 5; // 卡图片已经绑定到卡，不能删除
			} else {
				fileItemService.deleteFileItemById(id);
				type = 3; // 删除成功
			}
		} catch (Exception e) {
			type = 4;
		}

		return SUCCESS;
	}

	// 展示卡图片
	public String showImage() {
		return SUCCESS;
	}

	// 展示图片
	public InputStream getCardImage() throws Exception {

		if (null == id) {
			return null;
		}
		FileItem fileItem = fileItemService.findFileItemById(id);
		mimeType = fileItem.getMimeType();
		ByteArrayInputStream bis = new ByteArrayInputStream(
				fileItem.getContent());
		return bis;
	}

	// 更新卡图片
	public String updateImage() throws Exception {

		if (null == type || type.equals(new Integer(1))) { // prepare data
			image = fileItemService.findFileItemById(id);
			return "enter"; // 进入修改页面
		}
		try {
			String contentType = picContentType;
			String originalFileName = picFileName;
			logger.info("updateImage contentType={}, originalFileName={}", new Object[] {
					contentType, originalFileName });
			FileItem fileItem = new FileItem();
			if(null != pic){// 没有上传图片，则只更新图片描述
				FileInputStream fis = new FileInputStream(pic);
				if (null != fis && fis.available() > 0) {
					int length = fis.available();
					byte[] bbuf = new byte[length];
					for (int i = 0; i < length; i++) {
						bbuf[i] = (byte) fis.read();
					}
					fileItem.setContent(bbuf);
					fileItem.setFilesize(length);
					fileItem.setMimeType(contentType);
					fileItem.setOriginalFilename(originalFileName);

					fis.close();
					pic.deleteOnExit();
				}
			}
			fileItem.setDescription(description);
			fileItem.setId(id);
			fileItemService.updateDescContent(fileItem);
			type = 3; // 保存卡图片成功
		} catch (Exception e) {
			type = 4; // 保存卡图片失败
		}
		return SUCCESS;
	}
}
