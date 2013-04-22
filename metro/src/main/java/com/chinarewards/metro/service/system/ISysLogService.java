package com.chinarewards.metro.service.system;

import com.chinarewards.metro.domain.system.SysLog;

public interface ISysLogService {
	
	
	/**
	 * description：添加系统日志。
	 * 				由于此操作事物要与业务操作原事物分离，建议在Control中调用
	 * 
	 * @param object	-	操作对象， 如：任务新增     商品基本信息	优惠券维护
	 * @param name		-	操作的具体数据名称，  如：活动A   活动B   门店A
	 * @param event		-	如：增加  删除 修改  导出... 	等等
	 * @param other		-	其他扩展内容
	 * @return
	 * @time 2013-4-3   下午02:54:51
	 */
	public SysLog addSysLog(String object, String name, String event, String other);
	
	/**
	 * description：添加系统日志。
	 * 				由于此操作事物要与业务操作原事物分离，建议在Control中调用
	 * @param user 		-	用户名
	 * @param object	-	操作对象， 如：任务新增     商品基本信息	优惠券维护
	 * @param name		-	操作的具体数据名称，  如：活动A   活动B   门店A
	 * @param event		-	如：增加  删除 修改  导出... 	等等
	 * @param other		-	其他扩展内容
	 * @return
	 * @time 2013-4-3   下午02:54:51
	 */
	public SysLog addSysLog(String user, String object, String name, String event, String other);
	
}
