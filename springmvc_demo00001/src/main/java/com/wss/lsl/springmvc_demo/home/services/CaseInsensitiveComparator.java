package com.wss.lsl.springmvc_demo.home.services;

import java.util.Comparator;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class CaseInsensitiveComparator implements Comparator<String> {
	
	private Logger logger = LoggerFactory.getLogger(getClass()); 
	
	@Override
	public int compare(String o1, String o2) {
		logger.info("compare o1={} o2={}",new Object[]{o1,o2});
		assert o1!=null && o2 != null;
		return String.CASE_INSENSITIVE_ORDER.compare(o1, o2);
	}

}
