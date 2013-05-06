package com.chinarewards.alading.service;

import com.chinarewards.alading.domain.Member;
import com.chinarewards.alading.domain.MemberInfo;

public interface IMemberService {
	
	/**
	 * 根据会员手机号查询会员卡、账户信息
	 * 
	 * @param phoneNumber
	 * @return
	 */
	MemberInfo findMemberInfoByPhone(String phoneNumber);
	
	/**
	 * 根据会员ID查询会员卡、账户信息
	 * 
	 * @param id
	 * @return
	 */
	MemberInfo findMemberInfoById(Integer id);
	
	/**
	 * 根据会员ID查询会员基本信息
	 * 
	 * @param id
	 * @return
	 */
	Member findMemberById(Integer id);
}
