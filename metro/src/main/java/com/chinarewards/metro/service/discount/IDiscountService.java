package com.chinarewards.metro.service.discount;

import java.util.List;
import java.util.Map;

import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.member.MemberCard;
import com.chinarewards.metro.domain.pos.PosBind;
import com.chinarewards.metro.domain.shop.DiscountNumberHistory;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.model.discount.DiscountMode;
import com.chinarewards.metro.model.discount.DiscountNumberReport;
import com.chinarewards.metro.models.DiscountUseCodeResp;
import com.chinarewards.metro.models.request.DiscountUseCodeReq;
import com.chinarewards.metro.models.request.VerifyDiscountReq;

public interface IDiscountService {
	/**
	 * 根据会员信息获得对应的优惠码信息
	 * @param member   会员对象
	 * @param card   会员卡对象
	 * @param shop   门店对象
	 * @param activityInfo   门店对象
	 * @param type   0:门店ID ; 1:活动ID
	 * @return  优惠码
	 */
	public DiscountMode getDiscountCode(Member member,MemberCard card,Shop shop,ActivityInfo activityInfo,int type);
	
	/**
	 * 检测回收的优惠码在表中是否存在并未使用
	 * @param code   	优惠码
	 * @param id		门店ID、活动ID
	 * @param type		0:门店 ; 1:活动
	 * @return			true：表示存在     false：表示不存在，即可以回收
	 */
	public boolean gcCodeCheck(String code,Integer id,Integer type);
	
	/**
	 * 检测权益优惠码是否过期，如果过期返回false，否则根据权益优惠码把当前状态修改为使用中,并把该记录移入到历史记录表里
	 * @param code  优惠码
	 * @param expiredDate 过期时间
	 * @return     false--过期；true--未使用
	 */
	boolean checkDiscountCode(VerifyDiscountReq verifyDiscountReq,PosBind pb,int id,Shop shop);
	
	/**
	 * 根据优惠码，shopid/activityid,查询出现有优惠信息和历史优惠信息
	 * @param code
	 * @return
	 */
	Map selDiscountByCode(String code,int id,Integer couponType,Shop shop);
	
	/**
	 * 根据优惠码，优惠类型(0--活动，1--门店),查询出现有优惠信息和历史优惠信息
	 * @param code
	 * @return
	 */
	Map selDiscountByCode(String code,Integer codetype,String shopOrActivityId,Shop shop);
	
	/**
	 * 批量移除已过期的优惠码信息
	 */
	public void removeExpiredCodeToHistroy();
	

	
	/**根据流水号到历史表里查询，在24小时内是否存在该记录
	 * @param serialId
	 * @return
	 */
	DiscountNumberHistory getDiscountBySerialId(long serialId);
	
	
	/**
	 * 条件查询
	 * @param discountNumberHistory
	 * @param page
	 */
	List<DiscountNumberReport> findDiscountToReport(DiscountNumberHistory discountNumberHistory, Page page);
	
	
	/**
	 * 外部接口使用优惠劵
	 */
	void useDiscountNumber(DiscountUseCodeReq req,Shop shop);
	
	DiscountUseCodeResp useDiscountNumber2(DiscountUseCodeReq req);
	
	
	List<DiscountNumberReport> getDiscountReport(DiscountNumberHistory discount);
	
	
	/**根据条件获取优惠码数目
	 * @param discount
	 * @return
	 */
	int getCountDiscount(DiscountNumberHistory discount);
	
	
	
}
