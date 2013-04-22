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
	
	
	
	/**
	* 获取2个字符日期的天数差
	* @param p_startDate
	* @param p_endDate
	* @return 天数差
	*/
	public static long getDaysOfTowDiffDate( String p_startDate, String p_endDate ){
	  
		Date l_startDate = DateUtil.strToDate(DateUtil.yyyy_MM_dd, p_startDate);
		Date l_endDate = DateUtil.strToDate(DateUtil.yyyy_MM_dd, p_endDate);
		long l_startTime = l_startDate.getTime();
		long l_endTime = l_endDate.getTime();
		long betweenDays = (long) ( ( l_endTime - l_startTime ) / ( 1000 * 60 * 60 * 24 ) );
		return betweenDays;
	}
	

	/**
	* 获取2个Date型日期的分钟数差值
	* @param p_startDate
	* @param p_endDate
	* @return 分钟数差值
	*/
	public static long getMinutesOfTowDiffDate( Date p_startDate, Date p_endDate ){
	  
		long l_startTime = p_startDate.getTime();
		long l_endTime = p_endDate.getTime();
		long betweenMinutes = (long) ( ( l_endTime - l_startTime ) / ( 1000 * 60 ) );
		return betweenMinutes;
	}
	
	/**
	* 获取2个字符日期的天数差
	* @param p_startDate
	* @param p_endDate
	* @return 天数差
	*/
	public static long getDaysOfTowDiffDate( Date l_startDate, Date l_endDate ){
	  
		long l_startTime = l_startDate.getTime();
		long l_endTime = l_endDate.getTime();
		long betweenDays = (long) ( ( l_endTime - l_startTime ) / ( 1000 * 60 * 60 * 24 ) );
		return betweenDays;
	}
	
	
	/**
	 * 给出日期添加一段时间后的日期
	 * @param dateStr
	 * @param plus
	 * @return
	 */
	public static String getPlusDays(String format,String dateStr,long plus){
		
		Date date = DateUtil.strToDate(format, dateStr);
		
		long time = date.getTime()+ plus*24*60*60*1000;
		
		
		return DateUtil.dateToStr(format,new Date(time));
	}
	
	
	/**
	 * 给出日期添加一段时间后的日期
	 * @param dateStr
	 * @param plus
	 * @return
	 */
	public static String getPlusDays(String format,Date date,long plus){
		
		
		long time = date.getTime()+ plus*24*60*60*1000;
		
		
		return DateUtil.dateToStr(format,new Date(time));
	}
	
	 /**
     * 获取当前日期是星期几<br>
     * 
     * @param dt
     * @return 当前日期是星期几
	 * @throws ParseException 
     */
    public static String getWeekOfDate(String dt) {
        String[] weekDays = {"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"};
        Calendar cal = Calendar.getInstance();
        try
		{
			cal.setTime(new SimpleDateFormat("yyyy-MM-dd").parse(dt));
		}
		catch (ParseException e)
		{
			return "";
		}

        int w = cal.get(Calendar.DAY_OF_WEEK) - 1;
        if (w < 0)
            w = 0;

        return weekDays[w];
    }
}
