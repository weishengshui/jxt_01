package com.chinarewards.alading.reg.mapper;

import com.chinarewards.alading.domain.MemberInfo;

public interface MemberMapper extends CommonMapper<MemberInfo> {
	
	MemberInfo selectMemberByPhone(String phoneNumber);
}
