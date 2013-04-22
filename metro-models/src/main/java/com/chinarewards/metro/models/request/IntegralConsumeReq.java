package com.chinarewards.metro.models.request;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class IntegralConsumeReq implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -315676998623916252L;

	private String orderId;// 订单ID 必选
	private List<MerchandiseInfo> commodityIdList;// 商品ID 必选，可传多个
	private String orderSource;// 订单来源 （网站、门店编号） 必选
	private double point;// 扣除积分 必选
	private Date operateTime;// yyyyMMddHHmmss 必选
	private String userId;// 用户ID 必选
	private String description;// 订单描述 可选

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		String format="yyyyMMddHHmmss";
		SimpleDateFormat dateFormat = new SimpleDateFormat(format);
		String operateT="";
		if(operateTime!=null){
			operateT=dateFormat.format(operateTime);
		}
		
		String commodityId="";
		if(commodityIdList!=null&&commodityIdList.size()>0){
			commodityId= commodityIdList.get(0).getMerchandiseId();
		}
		str.append("orderId=" + orderId + "&commodityId=" +commodityId
				+ "&orderSource=" + orderSource + "&point=" + point
				+ "&operateTime=" + operateT + "&userId=" + userId
				+ "&description=" + description);

		return str.toString();
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public List<MerchandiseInfo> getCommodityIdList() {
		return commodityIdList;
	}

	public void setCommodityIdList(List<MerchandiseInfo> commodityIdList) {
		this.commodityIdList = commodityIdList;
	}

	public String getOrderSource() {
		return orderSource;
	}

	public void setOrderSource(String orderSource) {
		this.orderSource = orderSource;
	}

	public double getPoint() {
		return point;
	}

	public void setPoint(double point) {
		this.point = point;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Date getOperateTime() {
		return operateTime;
	}

	public void setOperateTime(Date operateTime) {
		this.operateTime = operateTime;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getDescription() {
		return description;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

}
