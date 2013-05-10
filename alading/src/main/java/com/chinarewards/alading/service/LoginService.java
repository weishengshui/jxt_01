package com.chinarewards.alading.service;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;

import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.reg.mapper.MemberMapper;
import com.chinarewards.alading.util.SecurityUtil;
import com.google.inject.Inject;

public class LoginService implements ILoginService {
	
	@InjectLogger 
	private Logger logger;
	
	@Inject
	private MemberMapper memberMapper;
	
	@Override
	public boolean checkUsernamePassword(String username, String password) {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("username", username);
		params.put("password", SecurityUtil.md5(password));
		
		return memberMapper.checkUsernamePassword(params) > 0;
	}

}
