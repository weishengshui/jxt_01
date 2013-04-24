package com.chinarewards.oauth.service;

/**
 * This service has two core functions one is authenticate application whether
 * the registration,the other is Register application using MAC + regCode.
 * 
 * @author qingminzou
 * 
 */
public interface AppRegisterService {

	/**
	 * Authenticate application whether the registration
	 * 
	 * @param appId
	 * @param macAddress
	 * @return <ur> <li><code>000</code> means registered<li> <li>
	 *         <code>001</code> means not registered<li>
	 *         <ur>
	 */
	public String authenticate(String appId, String macAddress);

	/**
	 * register application using MAC + regCode.
	 * 
	 * @param appId
	 * @param regCode
	 * @param macAddress
	 * @return <ur> <li><code>000</code> success<li> 
	 * 				<li><code>001</code> The host(confirm it using mac-address) registered already<li>
	 * 				<li><code>002</code> invalid regCode<li>
	 *         <ur>
	 */
	public String register(String appId, String regCode, String macAddress);

}
