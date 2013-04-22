package com.chinarewards.metro.core.common;

/**
 * result 0：成功,3：无效的终端编号, 其他：待定
 * @author qingminzou
 *
 */
public abstract class ObtainConsumeTypeCode {

	/**
	 * 成功
	 */
	public final static String SUCCESS = "0";

	/**
	 * 失败
	 */
	public final static String FAIL = "1";

	/**
	 * pos 终端不存在
	 */
	public final static String INVALID_POS = "3";

	/**
	 * 其他未知异常
	 */
	public final static String OTHERS = "4";
}
