package com.chinarewards.metro.models.response;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

import com.chinarewards.metro.models.line.ShopModel;
@XmlRootElement
public class ShopModelRes implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private List<ShopModel> shopList;
	
	private String checkStr;
	
	public String getSignValue() {
		StringBuffer sbf = new StringBuffer();
		if (null != shopList && shopList.size() > 0) {
			ShopModel m = shopList.get(0);
			sbf.append("shopId="+m.getShopId());
			sbf.append("&englishName="+m.getEnglishName());
			sbf.append("&stationed="+m.getStationed());
			sbf.append("&telephone="+m.getTelephone());
			sbf.append("&brand="+m.getBrand());
			sbf.append("&type="+m.getType());
		}
		return sbf.toString();
	}
	
	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

	public List<ShopModel> getShopList() {
		return shopList;
	}

	public void setShopList(List<ShopModel> shopList) {
		this.shopList = shopList;
	}
	
}
