package com.chinarewards.metro.models.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class ExtOrderInfoArray implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5492136665747708960L;

	private String checkStr;

	private List<ExtOrderInfo> list = new ArrayList<ExtOrderInfo>();

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		if (list != null && list.size() > 0) {
			ExtOrderInfo o = list.get(0);
			str.append("bankPay=" + o.getBankPay() + "&cash=" + o.getCash()
					+ "&clerkId=" + o.getClerkId() + "&couponCode="
					+ o.getCouponCode() + "&deliveryTime=" + o.getDeliverTime()
					+ "&integration=" + o.getIntegration() + "&orderId="
					+ o.getOrderId() + "&orderPrice=" + o.getOrderPrice()
					+ "&orderSource=" + o.getOrderSource() + "&orderState="
					+ o.getOrderState() + "&orderTime=" + o.getOrderTime()
					+ "&posId=" + o.getPosId() + "&shopId=" + o.getShopId()
					+ "&userId=" + o.getUserId());
		}
		return str.toString();
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

	public List<ExtOrderInfo> getList() {
		return list;
	}

	public void setList(List<ExtOrderInfo> list) {
		this.list = list;
	}
}
