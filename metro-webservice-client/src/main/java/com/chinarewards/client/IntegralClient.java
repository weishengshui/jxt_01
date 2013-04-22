package com.chinarewards.client;



import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Random;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

import com.chinarewards.client.exception.InvalidSignException;
import com.chinarewards.metro.models.CheckCodeResp;
import com.chinarewards.metro.models.IntegralAddResp;
import com.chinarewards.metro.models.IntegralConsumeResp;
import com.chinarewards.metro.models.VerifyDiscountResp;
import com.chinarewards.metro.models.request.CheckCodeReq;
import com.chinarewards.metro.models.request.IntegralAddReq;
import com.chinarewards.metro.models.request.IntegralConsumeReq;
import com.chinarewards.metro.util.MD5;
import com.chinarewards.metro.util.SHA1Util;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;

public class IntegralClient extends AbstractClient{
	
	private String url;

	public IntegralClient(String url) {
		this.url = url;
	}
	public static void main(String[] args) throws InvalidSignException {

//		CheckCodeResp code = new IntegralClient("http://127.0.0.1:8080/metro/ws").checkCode("2222",0);
//		System.out.println("&&&&&&&&&&&&====="+code.getCouponInfo());
		List list=new ArrayList<String>();
		list.add("ff80818135c5beccf013c5bfefbf40002");
		
		IntegralConsumeResp code = new IntegralClient("http://127.0.0.1:8080/metro/ws").useIntegral("00000211",list,"POS_SALES",2500,new Date(),"80","");
	    System.out.println(11);
//		IntegralAddResp code = new IntegralClient("http://127.0.0.1:8080/metro/ws").addIntegral("POS_SALES","8GsRX3ohWis=","ff8081813ca32251013ca327f0550000","ueditor","pH9f9/jWf58=",new Date(),80,"");
//	    System.out.println(11);
		
		
		}

/**
 * 积分使用接口
 * @param orderId
 * @param commodityId
 * @param orderSource
 * @param point
 * @param operateTime
 * @param userId
 * @param description
 * @return
 */
	public IntegralConsumeResp useIntegral(String orderId,
			List<String> commodityIdList, String orderSource, double point,
			Date operateTime, String userId, String description)
			throws InvalidSignException {
//		IntegralConsumeReq req = new IntegralConsumeReq();
//		req.setCommodityIdList(commodityIdList);
//		req.setDescription(description);
//		req.setOperateTime(operateTime);
//		req.setOrderId(orderId);
//		req.setUserId(userId);
//		req.setPoint(point);
//		req.setOrderSource(orderSource);
//
//		try {
//			// sign
//			JAXBContext c = JAXBContext.newInstance(IntegralConsumeReq.class);
//			req.setCheckStr(SHA1Util.SHA1Encode(req.getSignValue()));
//			StringWriter r = new StringWriter();
//			c.createMarshaller().marshal(req, r);
//			String s = r.toString();
//			String checkStr = MD5.MD5Encoder(s);
//			req.setCheckStr(checkStr);
//		} catch (JAXBException e) {
//			throw new IllegalStateException("Sign request error!", e);
//		}
//
//		WebResource resource = getClient().resource(
//				url + "/integral/useIntegral");
//		System.out.println("===" + resource.toString());
//		try {
//			IntegralConsumeResp integralConsumeResp = resource.accept(
//					"application/json").post(IntegralConsumeResp.class, req);
//
//			// check sign
//			String checkStr2 = integralConsumeResp.getCheckStr();
//			JAXBContext ctx2 = JAXBContext
//					.newInstance(IntegralConsumeResp.class);
//			integralConsumeResp.setCheckStr(SHA1Util
//					.SHA1Encode(integralConsumeResp.getSignValue()));
//			StringWriter r2 = new StringWriter();
//			ctx2.createMarshaller().marshal(integralConsumeResp, r2);
//			String s2 = r2.toString();
//			if (!MD5.MD5Encoder(s2).equals(checkStr2)) {
//				throw new InvalidSignException();
//			}
//
//			return integralConsumeResp;
//
//		} catch (UniformInterfaceException e) {
//			System.err
//					.println("Status: " + e.getResponse().getResponseStatus());
//			throw new IllegalStateException(e);
//		} catch (JAXBException e) {
//			throw new IllegalStateException(e);
//		}
		return null;
	}




/**
 * 积分增加接口
 * @param orderId
 * @param commodityId
 * @param orderSource
 * @param point
 * @param operateTime
 * @param userId
 * @param description
 * @return
 */
public IntegralAddResp addIntegral(String requestRource,String money,List<String> commodityIdList,String commodityName,String point,Date operateTime,Integer userId,String description){
//	IntegralAddReq req=new IntegralAddReq();
//	req.setCommodityIdList(commodityIdList);
//	req.setDescription(description);
//	req.setMoney(money);
//	req.setOperateTime(operateTime);
//	req.setUserId(userId);
//	req.setRequestRource(requestRource);
//	req.setPoint(point);
//	
//	WebResource resource = getClient().resource(url + "/integral/addIntegral");
//	System.out.println("==="+resource.toString());
//	try {
//		IntegralAddResp resop = resource.accept("application/json").post(IntegralAddResp.class,req);
//		return resop;
//		
//	} catch (UniformInterfaceException e) {
//		System.err
//				.println("Status: " + e.getResponse().getResponseStatus());
//		throw new IllegalStateException(e);
//	}
return null;
}

}
