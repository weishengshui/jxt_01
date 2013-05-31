/*
 * Created on 2005-6-10
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
/********************************************************
*  Copyright (C)
*  File name:      
*  Author:         
*  Date:           
*  Description:    
*  Others:         
*  History:
*    1. Date:           
*       Author:         
*       Modification:   
********************************************************/
package com.ssh.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import javax.persistence.Entity;

/**
 * @author jason
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
@Entity
public class DateUtil {
	
	
	public final static String yyyy_MM_dd = "yyyy-MM-dd";
	public final static String yyyyMMdd = "yyyyMMdd";
	public final static String yyyyMM = "yyyyMM";
	public final static String yyyy_MM = "yyyy-MM";
	public final static String yyyy_MM_dd_HH_mm = "yyyy-MM-dd HH:mm";
	public final static String yyyyMMddHHmm = "yyyyMMddHHmm";
	public final static String yyyyMMddHHmmss = "yyyyMMddHHmmss";
	public final static String yyyy_MM_dd_HH_mm_ss = "yyyy-MM-dd HH:mm:ss";
	
	
	/**
	 * 将字符串时间改成Date类型
	 * @param format
	 * @param dateStr
	 * @return
	 */
	public  static Date strToDate(String format,String dateStr) {
		
		Date date = null;
		
		try {
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
			date = simpleDateFormat.parse(dateStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return date;
	}
	
	
	/**
	 * 将Date时间转成字符串
	 * @param format
	 * @param date
	 * @return
	 */
	public static String dateToStr(String format,Date date){
		
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
		
		return simpleDateFormat.format(date);	
	}

	public static long getDaysOfTowDiffDate(String p_startDate, String p_endDate) {
		Date l_startDate = strToDate("yyyy-MM-dd", p_startDate);
		Date l_endDate = strToDate("yyyy-MM-dd", p_endDate);
		long l_startTime = l_startDate.getTime();
		long l_endTime = l_endDate.getTime();
		long betweenDays = (l_endTime - l_startTime) / 86400000L;
		return betweenDays;
	}

	public static long getMinutesOfTowDiffDate(Date p_startDate, Date p_endDate) {
		long l_startTime = p_startDate.getTime();
		long l_endTime = p_endDate.getTime();
		long betweenMinutes = (l_endTime - l_startTime) / 60000L;
		return betweenMinutes;
	}

	public static long getDaysOfTowDiffDate(Date l_startDate, Date l_endDate) {
		long l_startTime = l_startDate.getTime();
		long l_endTime = l_endDate.getTime();
		long betweenDays = (l_endTime - l_startTime) / 86400000L;
		return betweenDays;
	}

	public static String getPlusDays(String format, String dateStr, long plus) {
		Date date = strToDate(format, dateStr);

		long time = date.getTime() + plus * 24L * 60L * 60L * 1000L;

		return dateToStr(format, new Date(time));
	}

	public static String getPlusDays(String format, Date date, long plus) {
		long time = date.getTime() + plus * 24L * 60L * 60L * 1000L;

		return dateToStr(format, new Date(time));
	}

	public static String getWeekOfDate(String dt) {
		String[] weekDays = { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" };
		Calendar cal = Calendar.getInstance();
		try {
			cal.setTime(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
		} catch (ParseException e) {
			return "";
		}

		int w = cal.get(7) - 1;
		if (w < 0) {
			w = 0;
		}
		return weekDays[w];
	}
}
