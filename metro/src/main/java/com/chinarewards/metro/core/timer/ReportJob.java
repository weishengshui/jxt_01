package com.chinarewards.metro.core.timer;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.JDBCDaoSupport;
import com.chinarewards.metro.core.common.SystemTimeProvider;
import com.chinarewards.metro.domain.report.ReportTask;
import com.chinarewards.metro.domain.report.TaskName;
import com.chinarewards.metro.service.system.ISysLogService;

public class ReportJob {

	private JDBCDaoSupport jdbcDaoSupport;
	private HBDaoSupport hbDaoSupport;
	
	@Autowired
	private ISysLogService sysLogService;

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public void doIt() {

		System.out
				.println("--------------------------- entry ReportJob ---------------------------");
		// 联合会员报表任务
		brandUnionMember_report();
		
		//积分分析报表任务
		exportIntegral();
		
		member_report();
		
		discountNumber_report();
	}
	
	/**
	 * 会员分析报表
	 */
	public void member_report(){
		try{
			jdbcDaoSupport.execute("call memberOrderPrice_update()");
			sysLogService.addSysLog("系统任务","会员分析报表消费金额数据", "", "定时任务", "成功");
		}catch (Exception e) {
			sysLogService.addSysLog("系统任务","会员分析报表消费金额数据", "", "定时任务", "失败:"+e.getMessage());
		}
	}
	
	/**
	 * 优惠码分析报表
	 */
	public void discountNumber_report(){
		try{
			jdbcDaoSupport.execute("call discountNumberReport_add()");
			sysLogService.addSysLog("系统任务","优惠码分析报表数据", "", "定时任务", "成功");
		}catch (Exception e) {
			sysLogService.addSysLog("系统任务","优惠码分析报表数据", "", "定时任务", "失败:"+e.getMessage());
		}
	}

	/**
	 * 积分分析报表
	 */
	public void exportIntegral(){
		logger.trace("enter exportIntegral method... ");
		try {
			Date lastTaskDate = findLastTask(TaskName.INTEGRAL_REPORT_TASK);
			
			Date lastUpdateDateStart = null;
			Date lastUpdateDateEnd = DateTools.stringToDateD(DateTools.getToday());
			if (null != lastTaskDate) {
				lastUpdateDateStart = DateTools.stringToDateD(DateTools
						.dateToString(lastTaskDate));
			} else { // 第一次任务
				lastUpdateDateStart = null;
			}
			Date taskBeginTime = SystemTimeProvider.getCurrentTime();
			StringBuffer sqlBuf = new StringBuffer();
			List<Object> params = new ArrayList<Object>();
//			jdbcDaoSupport.execute("DROP TABLE IF EXISTS IntegralReport");
			String sql = "insert into IntegralReport select o.tx_txId as txid,o.type as integralType,o.integration as integralCount,o.usingCode as comsumePoint,concat(m.surname,m.name) as memName ,mc.cardNumber as memberCard, m.phone as phone,o.orderSource as orderSource , t.origin as origin,t.status as status,t.transactionDate as exchangeHour,t.busines as type  from OrderInfo o left join Member m on m.account=o.account_accountId left join MemberCard mc on mc.id=m.card_id left join Transaction t on t.txId=o.tx_txId where o.type != 2 and o.type != 3 " ;
			sqlBuf.append(sql);
			if (null != lastUpdateDateStart) {
				sqlBuf.append(" AND t.transactionDate >= ? ");
				params.add(lastUpdateDateStart);
			}
			sqlBuf.append(" AND t.transactionDate <= ? ");
			params.add(lastUpdateDateEnd);
			jdbcDaoSupport.execute(sqlBuf.toString(),params.toArray());
			// add report task
			ReportTask reportTask = new ReportTask();
			reportTask.setEndTime(SystemTimeProvider.getCurrentTime());
			reportTask.setStartTime(taskBeginTime);
			reportTask.setTaskName(TaskName.INTEGRAL_REPORT_TASK);
			hbDaoSupport.save(reportTask);
			sysLogService.addSysLog("系统任务","积分分析报表数据", "", "定时任务", "成功");
			logger.trace("end exportIntegral method... ");
		} catch (Exception e) {
			e.printStackTrace();
			logger.trace("enter exportIntegral Exception... ");
			sysLogService.addSysLog("系统任务","积分分析报表数据", "", "定时任务", "失败");
		}
	}
	
	/**
	 * 联合会员报表
	 */
	public void brandUnionMember_report() {
		try {
			Date lastTaskDate = findLastTask(TaskName.BRAND_UNION_MEMBER_REPORT_TASK);
			
			Date lastUpdateDateStart = null;
			Date lastUpdateDateEnd = DateTools.stringToDateD(DateTools.getToday());
			if (null != lastTaskDate) {
				lastUpdateDateStart = DateTools.stringToDateD(DateTools
						.dateToString(lastTaskDate));
			} else { // 第一次任务
				lastUpdateDateStart = null;
			}
			logger.trace("brandUnionMember_report lastUpdateDateStart ===> "
					+ lastUpdateDateStart);
			logger.trace("brandUnionMember_report lastUpdateDateEnd ===> "
					+ lastUpdateDateEnd);
			
			StringBuffer sqlBuf = new StringBuffer();
			List<Object> params = new ArrayList<Object>();
			Date taskBeginTime = SystemTimeProvider.getCurrentTime();
			
			// delete invalid record
			sqlBuf.append("DELETE FROM brandunionmember_report WHERE brandunionmember_report.id NOT IN (SELECT id FROM BrandUnionMember)");
			logger.trace("delelte invalid brandunionmember ===> "
					+ sqlBuf.toString());
			jdbcDaoSupport.execute(sqlBuf.toString(), params.toArray());
			
			// update old record
			sqlBuf.setLength(0);
			sqlBuf.append("UPDATE brandunionmember_report bumr INNER JOIN ( ");
			sqlBuf.append("SELECT CONCAT(m.surname, m.`name`) AS `name`, mc.cardNumber AS cardNumber, b.id AS brandId, m.id AS memberId ");
			sqlBuf.append("FROM BrandUnionMember bum, Brand b, Member m, MemberCard mc ");
			sqlBuf.append("WHERE m.card_id = mc.id AND bum.brand_id=b.id AND bum.member_id=m.id ");
			if (null != lastUpdateDateStart) {
				sqlBuf.append("AND m.updateDate >= ? ");
				params.add(lastUpdateDateStart);
			}
			sqlBuf.append("AND m.updateDate <= ? ");
			params.add(lastUpdateDateEnd);
			sqlBuf.append(") bum on bumr.brandId = bum.brandId AND bumr.memberId = bum.memberId ");
			sqlBuf.append("SET bumr.`name` = bum.`name`, bumr.cardNumber = bum.cardNumber");
			logger.trace("update brandunionmember ===> " + sqlBuf.toString());
			jdbcDaoSupport.execute(sqlBuf.toString(), params.toArray());
			
			// insert new record
			sqlBuf.setLength(0);
			params.clear();
			sqlBuf.append("INSERT INTO brandunionmember_report(id, `name`, cardNumber, brandId, joinedDate, memberId) ");
			sqlBuf.append("SELECT bum.id AS id, CONCAT(m.surname,m.`name`) AS `name`, mc.cardNumber AS cardNumber, ");
			sqlBuf.append("b.id AS brandId, bum.joinedDate AS joinedDate, m.id AS memberId ");
			sqlBuf.append("FROM BrandUnionMember bum, Brand b, Member m, MemberCard mc ");
			sqlBuf.append("WHERE m.card_id = mc.id AND bum.brand_id=b.id AND bum.member_id=m.id ");
			if (null != lastUpdateDateStart) {
				sqlBuf.append("AND bum.joinedDate >= ? ");
				params.add(lastUpdateDateStart);
			}
			sqlBuf.append("AND bum.joinedDate <= ? ");
			params.add(lastUpdateDateEnd);
			sqlBuf.append("AND NOT EXISTS ( SELECT * FROM brandunionmember_report bumr WHERE bumr.brandId=b.id AND bumr.memberId=m.id )");
			logger.trace("add brandunionmember ===> " + sqlBuf.toString());
			jdbcDaoSupport.execute(sqlBuf.toString(), params.toArray());
			
			// add report task
			ReportTask reportTask = new ReportTask();
			reportTask.setEndTime(SystemTimeProvider.getCurrentTime());
			reportTask.setStartTime(taskBeginTime);
			reportTask.setTaskName(TaskName.BRAND_UNION_MEMBER_REPORT_TASK);
			hbDaoSupport.save(reportTask);
			sysLogService.addSysLog("系统任务","联合会员报表数据", "", "定时任务", "成功");
		} catch (Exception e) {
			sysLogService.addSysLog("系统任务","联合会员报表数据", "", "定时任务", "失败");
			// ignore database error
		}
	}

	/**
	 * 查询上一次的任务时间
	 * 
	 * @param taskName
	 * @return
	 */
	private Date findLastTask(TaskName taskName) {

		String hql = "FROM ReportTask WHERE taskName=? ORDER BY startTime DESC";

		ReportTask reportTask = hbDaoSupport.findTByHQL(hql, taskName);
		if (null != reportTask) {
			return reportTask.getStartTime();
		}
		return null;
	}

	public void setJdbcDaoSupport(JDBCDaoSupport jdbcDaoSupport) {
		this.jdbcDaoSupport = jdbcDaoSupport;
	}

	public void setHbDaoSupport(HBDaoSupport hbDaoSupport) {
		this.hbDaoSupport = hbDaoSupport;
	}

}
