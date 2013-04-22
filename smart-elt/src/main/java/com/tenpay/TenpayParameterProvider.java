package com.tenpay;

public interface TenpayParameterProvider {

	public static TenpayParameterProvider getProvider = new TenpayParameterImpl();

	/**
	 * 获得收款方
	 * 
	 * @return
	 */
	public String getSPName();

	/**
	 * 获得商户号
	 * 
	 * @return
	 */
	public String getPartner();

	/**
	 * 获得密钥
	 * 
	 * @return
	 */
	public String getKey();

	/**
	 * 交易完成后跳转的URL
	 * 
	 * @return
	 */
	public String getReturnUrl();

	/**
	 * 接收财付通通知的URL
	 * 
	 * @return
	 */
	public String getNotifyUrl();

	/**
	 * 获得支付网关
	 * 
	 * @return
	 */
	public String getGW();
}
