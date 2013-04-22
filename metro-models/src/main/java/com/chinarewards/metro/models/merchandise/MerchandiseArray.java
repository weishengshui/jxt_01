package com.chinarewards.metro.models.merchandise;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class MerchandiseArray implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8414455774891531437L;

	private String checkStr;

	private List<Merchandise> list = new ArrayList<Merchandise>();

	// default success
	private String result;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		if (list != null && list.size() > 0) {
			Merchandise m = list.get(0);
			str.append("commodityId=" + m.getCommodityId() + "&name="
					+ m.getName() + "&freight=" + m.getFreight() + "&sellWay="
					+ m.getSellWay() + "&price=" + m.getPrice()
					+ "&PreferentialPrice=" + m.getPreferentialPrice()
					+ "&pointPrice=" + m.getPointPrice()
					+ "&pointPreferentialPrice="
					+ m.getPointPreferentialPrice() + "&catalogs="
					+ m.getCatalogs());
		}
		return str.toString();
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

	public List<Merchandise> getList() {
		return list;
	}

	public void setList(List<Merchandise> list) {
		this.list = list;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

}
