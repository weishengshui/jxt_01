package com.chinarewards.metro.models.merchandise;

import java.io.Serializable;

public class MerchandiseFile implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4133787650851100596L;

	private String id;

	private String mimeType;

	private String url;

	private Integer width;

	private Integer height;

	private String imageType; // OVERVIEW表示基本图，IMAGE1表示图片1，IMAGE2表示图片2.。。。

	public MerchandiseFile() {
	}

	public MerchandiseFile(String id, String mimeTye, String url,
			Integer width, Integer height, String imageType) {
		this.id = id;
		this.mimeType = mimeTye;
		this.url = url;
		this.width = width;
		this.height = height;
		this.imageType = imageType;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getMimeType() {
		return mimeType;
	}

	public void setMimeType(String mimeType) {
		this.mimeType = mimeType;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Integer getWidth() {
		return width;
	}

	public void setWidth(Integer width) {
		this.width = width;
	}

	public Integer getHeight() {
		return height;
	}

	public void setHeight(Integer height) {
		this.height = height;
	}

	public String getImageType() {
		return imageType;
	}

	public void setImageType(String imageType) {
		this.imageType = imageType;
	}

	@Override
	public String toString() {
		return "id=" + id + "&mimeType=" + mimeType + "&url=" + url + "&width="
				+ width + "&height=" + height + "&imageType=" + imageType;
	}
}
