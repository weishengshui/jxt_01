package com.chinarewards.alading.reg.mapper;

import com.chinarewards.alading.domain.Member;
import com.chinarewards.alading.domain.MemberInfo;

public interface MemberMapper extends CommonMapper<MemberInfo> {
	
	MemberInfo selectMemberInfoByPhone(String phoneNumber);
	
	Member selectMemberById(Integer id);
}
