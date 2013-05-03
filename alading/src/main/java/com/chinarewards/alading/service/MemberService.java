package com.chinarewards.alading.service;

import org.slf4j.Logger;

import com.chinarewards.alading.domain.MemberInfo;
import com.chinarewards.alading.log.InjectLogger;
import com.chinarewards.alading.reg.mapper.MemberMapper;
import com.google.inject.Inject;

public class MemberService implements IMemberService {
	
	@InjectLogger
	private Logger logger;
	
	@Inject
	private MemberMapper memberMapper;
	
	@Override
	public MemberInfo findMemberInfoByPhone(String phoneNumber) {
		return memberMapper.selectMemberByPhone(phoneNumber);
	}

	@Override
	public MemberInfo findMemberInfoById(Integer id) {
		return memberMapper.select(id);
	}

}
