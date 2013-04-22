package com.chinarewards.metro.core.common;

import java.util.ArrayList;
import java.util.List;

import com.chinarewards.metro.domain.account.Business;
import com.chinarewards.metro.domain.account.TxStatus;

/**
 * 字典表
 * 
 * @author huangshan
 * 
 */
public class Dictionary {

	/**
	 * DES 密钥
	 */
	public static final String SECRET_KEY = "11223344556688";

	/**
	 * 积分单位代码
	 */
	public static final String UNIT_CODE_BINKE = "BINKE"; // 缤刻
	public static final String UNIT_CODE_RMB = "RMB"; // 人民币

	/**
	 * 会员 优惠码状态
	 */
	public static final int MEMBER_DISCOUNT_NUMBER_NOT_USED = 0; // 未使用(会员领取了优惠码，但是还没使用)
	public static final int MEMBER_DISCOUNT_NUMBER_USED = 1; // 已使用
	public static final int MEMBER_DISCOUNT_NUMBER_EXPIRED = 2; // 已过期(会员领取了优惠码，但过期了)

	/**
	 * 用户状态
	 */
	public static final int USER_STATE_NORMAL = 0; // 正常
	public static final int USER_STATE_LOCKED = 1; // 锁定
	public static final int USER_STATE_DELETE = 2; // 删除

	/**
	 * 会员状态
	 */
	public static final int MEMBER_STATE_ACTIVATE = 1; // 已激活
	public static final int MEMBER_STATE_NOACTIVATE = 2; // 未激活
	public static final int MEMBER_STATE_LOGOUT = 3; // 注销 / 删除

	/**
	 * 会员性别
	 */
	public static final int MEMBER_SEX_NOLIMIT = 0; // 不限制
	public static final int MEMBER_SEX_MALE = 1; // 男
	public static final int MEMBER_SEX_FEMALE = 2; // 女

	/**
	 * 优惠码生成方式
	 */
	public static final int PROME_Code_AUTO = 0; // 系统生成
	public static final int PROME_Code_IMPORT = 1; // 文件导入

	/**
	 * 积分基本信息
	 */
	public static final String INTEGRAL_RMB_ID = "0"; // 积分--人民币ID
	public static final String INTEGRAL_BINKE_ID = "1"; // 积分--缤刻ID
	public static final int INTEGRAL_AVAILABLE_UNIT_DAY = 0; // 积分--有效期单位：天
	public static final int INTEGRAL_AVAILABLE_UNIT_MONTH = 1; // 积分--有效期单位：月
	public static final String INTEGRAL_BINKE_DEFAULT_NAME = "缤刻"; // 积分--缤刻积分默认名称：缤刻

	/**
	 * 营销任务状态
	 */
	public static final int TASK_EXECUTING = 1;// 执行中
	public static final int TASK_END = 2;// 已结束
	public static final int TASK_PAUSE = 3;// 暂停
	public static final int TASK_CANCEL = 4;// 取消
	public static final int TASK_CRATING = 5;// 创建中
	public static final int TASK_FAILURE = 6;// 失败
	public static final int TASK_NOTEXECUTE = 7;// 未执行

	/**
	 * pos获取积分，会员小票头
	 */
	public static final String V_POSSALES_MEMBER_TITLE = "possales_member_title";
	/**
	 * pos获取积分，会员小票内容
	 */
	public static final String V_POSSALES_MEMBER_CONTENT = "possales_member_content";
	/**
	 * pos获取积分，商户小票头
	 */
	public static final String V_POSSALES_MERCHANT_TITLE = "possales_merchant_title";
	/**
	 * pos获取积分，商户小票内容
	 */
	public static final String V_POSSALES_MERCHANT_CONTENT = "possales_merchant_content";

	/**
	 * 客服热线
	 */
	public static final String V_SERVICE_LINE = "service_line";

	/**
	 * 门店类型
	 */
	public static final int SHOP_TYPE_PRIVATE = 1;// 自有
	public static final int SHOP_TYPE_JOIN = 2;// 加盟

	/**
	 * 积分充值类型
	 */
	public static final int SUFFICIENT_TYPE_INTEGRAL = 1; // 积分充值
	public static final int SUFFICIENT_TYPE_STORED = 2; // 储值卡充值

	/**
	 * 返回优惠码在规则区间内已生成完的状态码
	 */
	public static final String DISCOUNT_CODE_STUTA = "errCode:408";

	/**
	 * 返回未激活会员的状态码
	 */
	public static final String MEMBER_STUTA_NOACTIVATE = "errCode:407";

	/**
	 * 返回门店信息不存在的状态码
	 */
	public static final String SHOP_NO_EXISTS = "errCode:409";

	/**
	 * 返回活动信息不存在的状态码
	 */
	public static final String ACTIVITY_NO_EXISTS = "errCode:410";

	/**
	 * 返回会员信息不存在的状态码
	 */
	public static final String MEMBER_NO_EXISTS = "errCode:411";

	/**
	 * 返回注销会员的状态码
	 */
	public static final String MEMBER_STUTA_LOGOUT = "errCode:412";

	/**
	 * 返回未开始的活动状态码
	 */
	public static final String ACTIVITY_NO_START = "errCode:413";

	/**
	 * 返回已结束的活动状态码
	 */
	public static final String ACTIVITY_END = "errCode:414";

	/**
	 * 返回已取消的活动状态码
	 */
	public static final String ACTIVITY_CANCLE = "errCode:415";

	/**
	 * 会员注册来源
	 */
	public static final String MEMBER_SOURCE_POS = "1004";
	public static final String MEMBER_SOURCE_CRM = "1005";

	/**
	 * 系统参数表(默认值) POS机获取积分交易冻结天数
	 */
	public static final String V_POS_SALES_FROZEN_DAYS = "deferred_transaction";

	/**
	 * 缤刻 网关URL
	 */
	public static final String V_SMS_MTURL = "mturl";

	/**
	 * 网关请求命令
	 */
	public static final String V_SMS_COMMAND = "command";

	/**
	 * SPID
	 */
	public static final String V_SMS_SPID = "spid";

	/**
	 * sp 密码
	 */
	public static final String V_SMS_SPPASSWORD = "sppassword";

	/**
	 * sp 编码
	 */
	public static final String V_SMS_SPSC = "spsc";

	/**
	 * sa
	 */
	public static final String V_SMS_SA = "sa";

	/**
	 * 获取会员状态集合
	 * 
	 * @return
	 */
	public static List<BoxValue<Integer, String>> findMemberStatus() {
		List<BoxValue<Integer, String>> list = new ArrayList<BoxValue<Integer, String>>();
		list.add(new BoxValue<Integer, String>(MEMBER_STATE_ACTIVATE, "已激活"));
		list.add(new BoxValue<Integer, String>(MEMBER_STATE_NOACTIVATE, "未激活"));
		// list.add(new BoxValue<Integer, String>(MEMBER_STATE_LOGOUT, "已注销"));
		return list;
	}

	public static List<BoxValue<Integer, String>> findMemberSex() {
		List<BoxValue<Integer, String>> list = new ArrayList<BoxValue<Integer, String>>();
		list.add(new BoxValue<Integer, String>(MEMBER_SEX_NOLIMIT, "不限制"));
		list.add(new BoxValue<Integer, String>(MEMBER_SEX_MALE, "男"));
		list.add(new BoxValue<Integer, String>(MEMBER_SEX_FEMALE, "女"));
		return list;
	}

	/**
	 * 获取营销任务状态集合
	 * 
	 * @return
	 */
	public static List<BoxValue<Integer, String>> findMessageTaskStatus() {
		List<BoxValue<Integer, String>> list = new ArrayList<BoxValue<Integer, String>>();
		list.add(new BoxValue<Integer, String>(TASK_NOTEXECUTE, "未执行"));
		list.add(new BoxValue<Integer, String>(TASK_EXECUTING, "执行中"));
		list.add(new BoxValue<Integer, String>(TASK_END, "已结束"));
		list.add(new BoxValue<Integer, String>(TASK_PAUSE, "暂停"));
		list.add(new BoxValue<Integer, String>(TASK_CANCEL, "取消"));
		list.add(new BoxValue<Integer, String>(TASK_CRATING, "创建中"));
		list.add(new BoxValue<Integer, String>(TASK_FAILURE, "失败"));
		return list;
	}

	public static String getPicPath(String pathName) {
		if ("SHOP_IMG".equals(pathName)) {
			return Constants.SHOP_IMG;
		} else if ("UPLOAD_TEMP_BASE_DIR".equals(pathName)) {
			return Constants.UPLOAD_TEMP_BASE_DIR;
		} else if ("MERCHANDISE_IMAGE_DIR".equals(pathName)) {
			return Constants.MERCHANDISE_IMAGE_DIR;
		} else if ("MERCHANDISE_IMAGE_BUFFER".equals(pathName)) {
			return Constants.MERCHANDISE_IMAGE_BUFFER;
		} else if ("BRAND_IMAGE_DIR".equals(pathName)) {
			return Constants.BRAND_IMAGE_DIR;
		} else if ("BRAND_IMAGE_BUFFER".equals(pathName)) {
			return Constants.BRAND_IMAGE_BUFFER;
		} else if ("ACTIVITY_IMAGE_DIR".equals(pathName)) {
			return Constants.ACTIVITY_IMAGE_DIR;
		} else if ("ACTIVITY_IMAGE_BUFFER".equals(pathName)) {
			return Constants.ACTIVITY_IMAGE_BUFFER;
		} else if ("MERCHANT_IMAGE_DIR".equals(pathName)) {
			return Constants.MERCHANT_IMAGE_DIR;
		} else if ("LINE_BUFFEREN_IMG".equals(pathName)) {
			return Constants.LINE_BUFFEREN_IMG;
		} else if ("LINE_IMG".equals(pathName)) {
			return Constants.LINE_IMG;
		} else if ("SITE_IMG".equals(pathName)) {
			return Constants.SITE_IMG;
		} else if ("SITE_BUFFEREN_IMG".equals(pathName)) {
			return Constants.SITE_BUFFEREN_IMG;
		} else if ("SHOP_BUFFEREN_IMG".equals(pathName)) {
			return Constants.SHOP_BUFFEREN_IMG;
		} else if ("COUPON_IMAGE_BUFFER".equals(pathName)) {
			return Constants.COUPON_IMAGE_BUFFER;
		} else if ("COUPON_IMAGE_DIR".equals(pathName)) {
			return Constants.COUPON_IMAGE_DIR;
		} else {
			return "";
		}
	}

	/**
	 * 获取门店类型集合
	 * 
	 * @return
	 */
	public static List<BoxValue<Integer, String>> findShopType() {
		List<BoxValue<Integer, String>> list = new ArrayList<BoxValue<Integer, String>>();
		list.add(new BoxValue<Integer, String>(SHOP_TYPE_PRIVATE, "自有"));
		list.add(new BoxValue<Integer, String>(SHOP_TYPE_JOIN, "加盟"));
		return list;
	}

	/**
	 * 获取交易类型集合
	 * 
	 * @return
	 */
	public static List<BoxValue<Business, String>> findTxTypes() {
		List<BoxValue<Business, String>> list = new ArrayList<BoxValue<Business, String>>();
		list.add(new BoxValue<Business, String>(Business.EXPIRY_POINT, "过期积分"));
		list.add(new BoxValue<Business, String>(Business.HAND_MONEY, "手动储值卡充值"));
		list.add(new BoxValue<Business, String>(Business.HAND_POINT, "手动添加积分"));
		list.add(new BoxValue<Business, String>(Business.POS_REDEMPTION,
				"POS机端消费积分"));
		list.add(new BoxValue<Business, String>(Business.POS_SALES, "POS机端获取积分"));
		list.add(new BoxValue<Business, String>(Business.EXTERNAL_POINT,
				"外部接口注册时送的积分"));
		list.add(new BoxValue<Business, String>(
				Business.SAVING_ACCOUNT_CONSUMPTION, "储值卡消费接口扣除金额"));
		list.add(new BoxValue<Business, String>(Business.EXT_REDEMPTION,
				"外部兑换订单"));
		list.add(new BoxValue<Business, String>(Business.EXT_ORDER,
				"外部订单"));
		return list;
	}

	/**
	 * 获取交易状态集合
	 * 
	 * @return
	 */
	public static List<BoxValue<TxStatus, String>> findTxSatuses() {
		List<BoxValue<TxStatus, String>> list = new ArrayList<BoxValue<TxStatus, String>>();
		list.add(new BoxValue<TxStatus, String>(TxStatus.COMPLETED, "完成"));
		list.add(new BoxValue<TxStatus, String>(TxStatus.FROZEN, "冻结"));
		list.add(new BoxValue<TxStatus, String>(TxStatus.RETURNED, "撤销"));
		list.add(new BoxValue<TxStatus, String>(TxStatus.DISABLED, "失效"));
		return list;
	}

	/**
	 * 获取会员使用优惠码状态集合
	 * 
	 * @return
	 */
	public static List<BoxValue<Integer, String>> findMemberDiscountNumberSatuses() {
		List<BoxValue<Integer, String>> list = new ArrayList<BoxValue<Integer, String>>();
		list.add(new BoxValue<Integer, String>(MEMBER_DISCOUNT_NUMBER_NOT_USED,
				"未使用"));
		list.add(new BoxValue<Integer, String>(MEMBER_DISCOUNT_NUMBER_USED,
				"已使用"));
		list.add(new BoxValue<Integer, String>(MEMBER_DISCOUNT_NUMBER_EXPIRED,
				"已过期"));
		return list;
	}

	/**
	 * 获取系统参数名称集合
	 * 
	 * @return
	 */
	public static List<BoxValue<String, String>> findSystemParamNames() {
		List<BoxValue<String, String>> list = new ArrayList<BoxValue<String, String>>();
		list.add(new BoxValue<String, String>("img_host", "(通过外部接口查询站台/线路时)提供给接口图片访问的URL,如IP/域名发生变化需要总这里改变"));
		//优惠码规则
		list.add(new BoxValue<String, String>("expresion", "优惠码范围区间(比如: 1~1000)"));
		//优惠码过期时间
		list.add(new BoxValue<String, String>("expirTime", "优惠码过期时间(小时)"));
		
		list.add(new BoxValue<String, String>("mturl", "缤刻短信网关 mturl"));
		list.add(new BoxValue<String, String>("command", "缤刻短信网关 command"));
		list.add(new BoxValue<String, String>("spid", "缤刻短信网关 spid"));
		list.add(new BoxValue<String, String>("sppassword", "缤刻短信网关 sppassword"));
		list.add(new BoxValue<String, String>("spsc", "缤刻短信网关 spsc"));
		list.add(new BoxValue<String, String>("sa", "缤刻短信网关 sa"));
		list.add(new BoxValue<String, String>("deferred_transaction", "POS机获取积分交易冻结天数"));
		
		return list;
	}
}
