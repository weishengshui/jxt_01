package com.chinarewards.metro.core.common;

import java.io.File;

public abstract class Constants {

	public static String sp = File.separator;
	/**
	 * 分页参数的大小
	 */
	public static final int PERPAGE_SIZE = 20;

	/**
	 * 商品类别根节点
	 */
	public static final String CATEGORY_ROOT_ID = "0";

	/**
	 * 商品类别根节点名称
	 */
	public static String MERCHANDISE_CATEGORY_ROOT = "根节点";

	public static final String UPLOAD_TEMP_UID_PREFIX = "tmp@";
	
	/**
	 * 上传文件存储在SESSION中的属性名
	 */
	public static final String UPLOADED_ARCHIVES = "uploaded_archives";
	
	/**
	 * 重置密码 (初始化密码)
	 */
	public static final String RESET_PASSWORD = "123456";

	/**
	 * 短信营销发送优先级
	 */
	public static final int TASK_PRIORITY = 2;

	/**
	 * 上传的临时目录根路径
	 */
	public static final String UPLOAD_TEMP_BASE_DIR = getArchiveTempRootDir()
			+ "/metro/archive";

	/**
	 * 商品图片存放正式目录
	 */
	public static final String MERCHANDISE_IMAGE_DIR = getArchiveRootDir()
			+ "/merchandise/images/";

	/**
	 * 商品图片缓存目录
	 */
	public static final String MERCHANDISE_IMAGE_BUFFER = getArchiveTempRootDir()
			+ "/merchandise/images/";

	/**
	 * 品牌logo存放正式目录
	 */
	public static final String BRAND_IMAGE_DIR = getArchiveRootDir()
			+ "/brand/images/";

	/**
	 * 品牌logo缓存目录
	 */
	public static final String BRAND_IMAGE_BUFFER = getArchiveTempRootDir()
			+ "/brand/images/";

	/**
	 * 活动图片存放正式目录
	 */
	public static final String ACTIVITY_IMAGE_DIR = getArchiveRootDir()
			+ "/activity/images/";

	/**
	 * 活动图片缓存目录
	 */
	public static final String ACTIVITY_IMAGE_BUFFER = getArchiveTempRootDir()
			+ "/activity/images/";

	/**
	 * 营销号码文件存放目录
	 */
	public static final String MESSAGETASK_CSV_DIR = getArchiveRootDir()
			+ "/message/csv/";

	/**
	 * 导出联合会员EXCEL的目录
	 * 
	 */
	public static final String EXPORT_UNIONMEMBER_DIR = getArchiveRootDir()
			+ "/metro/export/unionmember";

	/**
	 * 商户图片存放正式目录
	 */
	public static final String MERCHANT_IMAGE_DIR = getArchiveRootDir()
			+ "/metro/archive/merchant/images";
	/**
	 * 门店图片
	 */
	public static final String SHOP_IMG = getArchiveRootDir() + sp + "shop"
			+ sp + "images" + sp;
	/**
	 * 门店临时图片
	 */
	public static final String SHOP_BUFFEREN_IMG = getArchiveTempRootDir() + sp
			+ "shop" + sp + "images" + sp;
	/**
	 * 线路图片
	 */
	public static final String LINE_IMG = getArchiveRootDir() + sp + "line"
			+ sp + "images" + sp;
	/**
	 * 线路临时图片
	 */
	public static final String LINE_BUFFEREN_IMG = getArchiveTempRootDir() + sp
			+ "line" + sp + "images" + sp;
	/**
	 * 站台图片
	 */
	public static final String SITE_IMG = getArchiveRootDir() + sp + "site"
			+ sp + "images" + sp;
	/**
	 * 线路临时图片
	 */
	public static final String SITE_BUFFEREN_IMG = getArchiveTempRootDir() + sp
			+ "site" + sp + "images" + sp;
	/**
	 * UEditor文件上传目录
	 */
	public static final String UEDITOR_UPLOAD_DIR = getArchiveRootDir()
			+ "/ueditor/upload/";

	/**
	 * 优惠券图片存放正式目录
	 */
	public static final String COUPON_IMAGE_DIR = getArchiveRootDir()
			+ "/coupon/images/";

	/**
	 * 优惠券图片缓存目录
	 */
	public static final String COUPON_IMAGE_BUFFER = getArchiveTempRootDir()
			+ "/coupon/images/";

	
	private static String getArchiveTempRootDir() {
		String dir = "";
		String env = Config.getProperty("environment");
		if (!env.equals("production")) {
			dir = System.getProperty("user.home");
		} else {
			dir = Config.getProperty("archive_root");
		}
		return dir;
	}

	private static String getArchiveRootDir() {
		String dir = "";
		String env = Config.getProperty("environment");
		if (!env.equals("production")) {
			dir = System.getProperty("user.dir");
		} else {
			dir = Config.getProperty("tmp_archive_root");
		}
		return dir;
	}
}
