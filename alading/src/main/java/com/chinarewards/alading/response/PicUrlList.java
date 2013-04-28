package com.chinarewards.alading.response;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="picUrlList")
public class PicUrlList implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -6745330957750832839L;
	
	private List<String> picUrl;

	public List<String> getPicUrl() {
		return picUrl;
	}

	public void setPicUrl(List<String> picUrl) {
		this.picUrl = picUrl;
	}
	
	
}
