package com.chinarewards.metro.core.common;

public abstract class POSSalesCode {

	/**
	 * 获取积分成功
	 */
	public final static String SUCCESS = "0";

	/**
	 * 获取积分失败
	 */
	public final static String FAIL = "1";

	/**
	 * 会员不存在
	 */
	public final static String MEMBER_NOT_EXISTS = "2";

	/**
	 * pos 终端不存在
	 */
	public final static String INVALID_POS = "3";

	/**
	 * 其他未知异常
	 */
	public final static String OTHERS = "4";
}
