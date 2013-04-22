package com.chinarewards.metro.service.activity;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.service.discount.IDiscountService;
import com.chinarewards.metro.service.line.ILineService;
import com.chinarewards.metro.service.member.IMemberService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
@TransactionConfiguration
@Transactional
public class TestActivityService {

	@Autowired IDiscountService discountService ;
	
	@Autowired IMemberService memberService ;
	
	@Autowired ILineService lineService ;
	
	@Autowired IActivityService activityService ;

	@Test
	public void test() {
//		Member member = memberService.findMemberById(7);
//		System.out.println("member = "+member.getName());
//		Shop shop = lineService.findShopById(110);
//		ActivityInfo activityInfo = activityService.findActivityById("1");
//		String code = discountService.getDiscountCode(member, member.getCard(), shop, activityInfo,1);
//		System.out.println("code is ====> " + code);
	}
}
