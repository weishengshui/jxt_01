package com.chinarewards.metro.client;

import java.util.HashMap;
import java.util.Map;

import com.chinarewards.metro.models.ObtainConsumeTypeResp;
import com.chinarewards.metro.models.RegisterResp;
import com.chinarewards.metro.models.SalesResp;
import com.chinarewards.metro.models.VerifyDiscountResp;
import com.chinarewards.metro.models.request.SalesReq;
import com.chinarewards.metro.models.request.VerifyDiscountReq;
import com.sun.jersey.api.client.WebResource;

public class ClientService extends AbstractClient {

	// http://xxx/metro/ws
	private String url;

	public ClientService(String url) {
		this.url = url;
	}

	public static void main(String[] args) {
		ClientService service = new ClientService(
				"http://localhost:8080/metro/ws");

//		 ObtainConsumeTypeResp result = service.getConsumeTypes("REWARDS-0003", "0");
//		
//		 System.out.println("Result:" + result.getResult());
		 
		

		 String posId = "REWARDS-0004";
		 String identify = "13456789765";
		 long serialId = 1000012;
		
		 Map<Long, Double> consumeInfo = new HashMap<Long, Double>();
		 consumeInfo.put(1l, 1d);
		 consumeInfo.put(2l, 2d);
		
		 SalesResp resp = service.sale(posId, identify, serialId, consumeInfo,
		 false);
		
		 System.out.println("Result: " + resp.getResult());
		 ObtainConsumeTypeResp result = service.getConsumeTypes("10001", "0");
		
		 System.out.println("Result:" + result.getResult());

		// String posId = "10001";
		// String identify = "15818727773";
		// long serialId = 1000006;
		//
		// Map<Long, Double> consumeInfo = new HashMap<Long, Double>();
		// consumeInfo.put(1l, 120d);
		// consumeInfo.put(2l, 205d);
		//
		// SalesResp resp = service.sale(posId, identify, serialId, consumeInfo,
		// false);
		//
		// System.out.println("Result: " + resp.getResult());
//		VerifyDiscountResp vdr = service.verifyDiscountCode("REWARDS-0003", "42675", 1311, 122.1,true);
//		System.out.println(111);
	}

	/**
	 * 获取消费类型列表请求
	 * 
	 * @param posId
	 */
	public ObtainConsumeTypeResp getConsumeTypes(String posId, String token) {
		
		return getClient().resource(url + "/pos").path(posId).path("/dl")
				.get(ObtainConsumeTypeResp.class);
	}



	/**
	 * 手机注册
	 * 
	 * @param mobilePhone
	 * @param posId
	 * @param resend
	 */
	public RegisterResp register(String posId, String mobilePhone,
			boolean resend) {
		try {
			RegisterResp rr = new RegisterResp();
			rr.setPhone(mobilePhone);
			rr.setPosId(posId);
			return getClient().resource(url + "/member/save").post(
					RegisterResp.class, rr);
		} catch (UnsupportedOperationException e) {
			throw new UnsupportedOperationException();
		}
	}

	/**
	 * 获取积分
	 * 
	 * @param posId
	 * @param identify
	 *            卡号或手机号
	 * @param consumeInfo
	 *            各个消费类型的明细;例如：key->餐饮,value->500;key->娱乐,value->200;...
	 */
	public SalesResp sale(String posId, String identify, long serialId,
			Map<Long, Double> consumeInfo, boolean resend) {

		SalesReq params = new SalesReq();
		params.setPosId(posId);
		params.setIdentify(identify);
		params.setSerialId(serialId);
		params.setToken("0");
		params.setConsumeDetails(consumeInfo);
		params.setResend(resend);
		
		WebResource resource = getClient().resource(url).path("/trans/sale");
		SalesResp result = resource.accept("application/json").post(
				SalesResp.class, params);

		return result;
	}
	
	
	/**
	 * 验证使用优惠码
	 * 
	 * @param posId
	 * @param discountCode
	 * @param resend
	 * @param serialId
	 * @return
	 */
	public VerifyDiscountResp verifyDiscountCode(String posId,
			String discountCode, long serialId,double money, boolean resend) {
		try {
			VerifyDiscountReq vd = new VerifyDiscountReq();
		    vd.setPosId(posId);
		    vd.setDiscountCode(discountCode);
		    vd.setMoney(money);
		    if(resend){
		    	  vd.setResend(1);
		    }else{
		    	  vd.setResend(0);
		    }
		  
		    vd.setSerialId(serialId);
		    WebResource resource = getClient().resource(url).path("/discount/useCode");
		    VerifyDiscountResp vdr= resource.accept("application/json").post(
					VerifyDiscountResp.class, vd);
		    return vdr;
		} catch (UnsupportedOperationException e) {
			throw new IllegalStateException(e);
		}
	}

}
