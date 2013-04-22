package com.chinarewards.metro.core.timer;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.quartz.QuartzJobBean;

public class EmailReportJob extends QuartzJobBean {
	
//	private int timeout;
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public void setTimeout(int timeout) {
//		this.timeout = timeout;
	}


	@Override
	protected void executeInternal(JobExecutionContext context)
			throws JobExecutionException {
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		logger.trace("EmailReportJob executeInternal() time is "+dateFormat.format(new Date()));
	}
	
}	
