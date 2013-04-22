package com.chinarewards.metro.core.timer;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ExampleBusinessObject {
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public void doIt(){
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		logger.trace("ExampleBusinessObject doIt() time is "+dateFormat.format(new Date()));
	}
}
