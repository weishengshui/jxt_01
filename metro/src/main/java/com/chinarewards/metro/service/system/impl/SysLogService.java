package com.chinarewards.metro.service.system.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.system.SysLog;
import com.chinarewards.metro.service.system.ISysLogService;


@Service
public class SysLogService implements ISysLogService {
	
	@Autowired
	private HBDaoSupport hbDaoSupport;
	
	@Override
	public SysLog addSysLog(String object, String name, String event,String other) {
		SysLog s = new SysLog();
		s.setEvent(event);
		s.setName(name);
		s.setOperator(UserContext.getUserName());
		s.setObject(object);
		s.setOther(other);
		s.setTime(DateTools.systemDateTo24Hour());
		return hbDaoSupport.save(s);
	}

	@Override
	public SysLog addSysLog(String user, String object, String name,
			String event, String other) {
		SysLog s = new SysLog();
		s.setEvent(event);
		s.setName(name);
		s.setOperator(user);
		s.setObject(object);
		s.setOther(other);
		s.setTime(DateTools.systemDateTo24Hour());
		return hbDaoSupport.save(s);
	}
	
}
