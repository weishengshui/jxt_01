package com.chinarewards.metro.models.request;

import java.math.BigDecimal;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

import com.chinarewards.metro.models.merchandise.CommodityVo;

/**
 * 储值卡消费req
 * 
 * @author weishengshui
 * 
 */
@XmlRootElement
public class SavingAccountConsumptionReq {

	private String orderId;

	private String orderSource;

	private Integer shopId; // 可选

	private List<CommodityVo> commodities; // 订单中的商品类表

	private Double point; // 扣除金额。

	private String operateTime; // 操作时间。格式yyyyMMddHHmmss

	private Integer userId; // 会员Id

	private String description; // 订单描述。可选

	private String checkStr;

	public String getSignValue() {
		StringBuffer str = new StringBuffer();
		str.append("orderId=" + orderId + "&orderSource=" + orderSource
				+ "&shopId=" + shopId + "&commodities=" + commodities
				+ "&point=" + point + "&operateTime=" + operateTime
				+ "&userId=" + userId + "&description=" + description);
		return str.toString();
	}

	public SavingAccountConsumptionReq() {
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getOrderSource() {
		return orderSource;
	}

	public void setOrderSource(String orderSource) {
		this.orderSource = orderSource;
	}

	public Integer getShopId() {
		return shopId;
	}

	public void setShopId(Integer shopId) {
		this.shopId = shopId;
	}

	public List<CommodityVo> getCommodities() {
		return commodities;
	}

	public void setCommodities(List<CommodityVo> commodities) {
		this.commodities = commodities;
	}

	public Double getPoint() {
		return point;
	}

	public void setPoint(Double point) {
		this.point = point;
	}

	public String getOperateTime() {
		return operateTime;
	}

	public void setOperateTime(String operateTime) {
		this.operateTime = operateTime;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getCheckStr() {
		return checkStr;
	}

	public void setCheckStr(String checkStr) {
		this.checkStr = checkStr;
	}

}
