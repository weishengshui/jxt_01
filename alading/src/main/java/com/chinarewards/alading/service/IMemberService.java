package com.chinarewards.alading.service;

import com.chinarewards.alading.domain.MemberInfo;

public interface IMemberService {
	
	MemberInfo findMemberInfoByPhone(String phoneNumber);
	
	MemberInfo findMemberInfoById(Integer id);
}
