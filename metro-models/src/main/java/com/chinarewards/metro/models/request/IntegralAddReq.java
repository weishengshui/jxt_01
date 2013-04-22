package com.chinarewards.metro.models.request;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

import com.chinarewards.metro.models.common.DES3;

@XmlRootElement
public class IntegralAddReq implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -315676998623916252L;

	private List<MerchandiseInfo> commodityIdList;// 商品ID 必选，可传多个
	private String requestRource;// 请求来源 （web，手机、 门店id）必选
	private String money;// 交易金额 加密字符串 3des必选
	private String point;// 增加积分 加密字符串 3des必选
	private Date operateTime;// YYYYMMDDHHmmss 必选
	private Integer userId;// 用户ID 必选
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
		
		
		str.append("commodityId"+commodityId+"requestRource="
				+ requestRource + "&money=" + money + "&point=" + point
				+ "&operateTime=" + operateT + "&userId=" + userId
				+ "&description=" + description);
		return str.toString();
	}

	public List<MerchandiseInfo> getCommodityIdList() {
		return commodityIdList;
	}

	public void setCommodityIdList(List<MerchandiseInfo> commodityIdList) {
		this.commodityIdList = commodityIdList;
	}

	public String getRequestRource() {
		return requestRource;
	}

	public void setRequestRource(String requestRource) {
		this.requestRource = requestRource;
	}

	public String getMoney() {
		return money;
	}

	public void setMoney(String money) {
		this.money = money;
	}

	public String getPoint() {
		return point;
	}

	public void setPoint(String point) {
		this.point = point;
	}

	public Date getOperateTime() {
		return operateTime;
	}

	public void setOperateTime(Date operateTime) {
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
