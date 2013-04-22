package com.chinarewards.metro.models.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class MerchandiseInfo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4579983335019450087L;

	private String merchandiseId;
	private int count;
	
	public String getMerchandiseId() {
		return merchandiseId;
	}
	public void setMerchandiseId(String merchandiseId) {
		this.merchandiseId = merchandiseId;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}

	
	

}
