package com.chinarewards.client;

import com.chinarewards.metro.models.CheckCodeResp;
import com.chinarewards.metro.models.request.CheckCodeReq;
import com.chinarewards.metro.models.request.DiscountReq;
import com.chinarewards.metro.models.response.DiscountResp;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;

public class DiscountCodeClient extends AbstractClient  {
	private String url;

	public DiscountCodeClient(String url) {
		this.url = url;
	}
	public static void main(String[] args) {

		try {
			DiscountResp discountResp = new DiscountCodeClient("http://127.0.0.1:8080/metro/ws").getCode(7,120,0);
			System.out.println("code====="+discountResp.getCouponCode()+"    errCode is : "+discountResp.getErrCode());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
	}

	/**
	 * 生成优惠码
	 * @param mid  			会员ID
	 * @param couponId		门店ID或活动ID
	 * @param type			0:门店ID ; 1:活动ID
	 * @return
	 * @throws Exception 
	 */
	public DiscountResp getCode(int mid,int couponId,int type) throws Exception {
		if(type != 0 || type != 1){
			throw new Exception("找不到对应的类型");
		}else{
			DiscountReq req = new DiscountReq();
			req.setMid(mid);
			req.setCouponId(couponId);
			req.setType(type);
			WebResource resource = getClient().resource(url + "/discount/code");
			try {
				DiscountResp discountResp = resource.accept("application/json").post(DiscountResp.class,req);
				return discountResp;
			} catch (UniformInterfaceException e) {
				e.printStackTrace();
				DiscountResp discountResp = new DiscountResp();
				String code = "-1" ;
				discountResp.setErrCode(code);
				return discountResp  ;
			}
		}
	}
	
	/**
	 *	优惠码查询确认接口
	 * @param couponCode
	 * @param CouponId  0--活动；1--名店
	 * @return
	 */
	public CheckCodeResp checkCode(String couponCode,Integer couponId) {
		CheckCodeReq req = new CheckCodeReq();
		req.setCouponCode(couponCode);
		req.setCouponId(couponId);
		
		WebResource resource = getClient().resource(url + "/discount/checkCode");
		System.out.println("==="+resource.toString());
		try {
			CheckCodeResp checkCodeResp = resource.accept("application/json").post(CheckCodeResp.class,req);
			return checkCodeResp;
			
		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		}
	}
	
	

	/**
	 *	优惠码使用接口
	 * @param couponCode
	 * @param CouponId  0--活动；1--名店
	 * @return
	 */
	public CheckCodeResp useCode(String couponCode,Integer couponId) {
		CheckCodeReq req = new CheckCodeReq();
		req.setCouponCode(couponCode);
		req.setCouponId(couponId);
		
		WebResource resource = getClient().resource(url + "/discount/useCode");
		System.out.println("==="+resource.toString());
		try {
			CheckCodeResp checkCodeResp = resource.accept("application/json").post(CheckCodeResp.class,req);
			return checkCodeResp;
		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		}
	}
}
