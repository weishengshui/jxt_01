package com.chinarewards.metro.service.member;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.domain.business.OrderInfo;
import com.chinarewards.metro.domain.member.AccountrPay;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.member.Source;
import com.chinarewards.metro.domain.rules.IntegralRule;
import com.chinarewards.metro.model.member.DiscountNumberRecordCriteria;
import com.chinarewards.metro.model.member.IntegralRecordCriteria;
import com.chinarewards.metro.model.member.MemberAttendCriteria;
import com.chinarewards.metro.model.member.MemberBrandVo;
import com.chinarewards.metro.model.member.MemberDiscountNumberVo;
import com.chinarewards.metro.model.member.MemberExpiredIntegralVo;
import com.chinarewards.metro.model.member.MemberReport;
import com.chinarewards.metro.model.member.MemberSMSOutboxHistoryCriteria;
import com.chinarewards.metro.model.member.MemberSMSOutboxHistoryVo;
import com.chinarewards.metro.model.member.SavingsAccountRecordCriteria;
import com.chinarewards.metro.models.request.MemberModifyReq;
import com.chinarewards.metro.models.request.MemberPasswordModifyReq;
import com.chinarewards.metro.models.request.SavingAccountConsumptionReq;
import com.chinarewards.metro.models.response.MemberModifyRes;
import com.chinarewards.metro.models.response.MemberPasswordModifyRes;
import com.chinarewards.metro.models.response.SavingAccountConsumptionRes;

public interface IMemberService {

	/**
	 * 保存会员信息
	 * 
	 * @param member
	 */
	public Member saveMember(Member member);
	
	public Member saveT(Member member);
	/**
	 * 外部接口保存
	 * @param 
	 * @return
	 */
	public Member externalSaveMember(Member m);
	/**
	 * 外部接口保存(如果手机号存在,且来源是POS注册，则合并)
	 * @param 
	 * @return
	 */
	public Member externalSaveMember2(Member m);
	/**
	 * 修改会员信息
	 * 
	 * @param member
	 */
	public void updateMember(Member member);

	/**
	 * 查询会员信息
	 * 
	 * @param member
	 * @param page
	 * @return
	 */
	public List<Member> findMembers(Member member, Page page);

	/**
	 * 根据ID查询会员信息
	 * 
	 * @param id
	 * @return
	 */
	public Member findMemberById(Integer id);
	
	/**
	 *报表中，查询会员信息
	 * 
	 * @param id
	 * @return
	 */
	public  List<MemberReport> findMembersToReport(Member member, Page page);

	/**
	 * 修改状态
	 * 
	 * @param id
	 * @param statusCode
	 */
	public void updateStatus(String ids, Integer statusCode);

	public void delMember(String ids);
	/**
	 * 重置密码
	 * 
	 * @param ids
	 */
	public void resetPassword(String ids);

	/**
	 * 判断手机号是否存在
	 * 
	 * @param phone
	 * @return
	 */
	public Member findMemberByPhone(String phone);

	/**
	 * 判断卡号是否存在
	 * 
	 * @param phone
	 * @return
	 */
	public Member findMemberByCardNo(String cardNo);

	/**
	 * 根据账户查找会员
	 * 
	 * @param accountId
	 * @return
	 */
	public Member findMemberByAccountId(String accountId);

	/**
	 * 根据条件查询会员的优惠码记录
	 * 
	 * @param criteria
	 * @return
	 */
	public List<MemberDiscountNumberVo> searchDiscountNumberRecords(
			DiscountNumberRecordCriteria criteria);

	/**
	 * 根据条件查询会员的优惠码记录总数
	 * 
	 * @param criteria
	 * @return
	 */
	public Long countDiscountNumberRecords(DiscountNumberRecordCriteria criteria);

	/**
	 * 发送激活码
	 */
	public void sendActivationCode(Integer memeberId, String phone);

	/**
	 * 根据条件查询会员 短信发送历史记录
	 * 
	 * @param criteria
	 * @return
	 */
	public List<MemberSMSOutboxHistoryVo> searchMemberSMSOutboxHistory(
			MemberSMSOutboxHistoryCriteria criteria);

	/**
	 * 根据条件查询会员 短信发送历史记录总数
	 * 
	 * @param criteria
	 * @return
	 */
	public Long countMemberSMSOutboxHistory(
			MemberSMSOutboxHistoryCriteria criteria);

	/**
	 * 根据条件查询等待发送的短信记录
	 * 
	 * @param criteria
	 * @return
	 */
	public List<MemberSMSOutboxHistoryVo> searchMemberSMSOutboxWait(
			MemberSMSOutboxHistoryCriteria criteria);

	/**
	 * 根据条件查询等待发送的短信记录总数
	 * 
	 * @param criteria
	 * @return
	 */
	public Long countMemberSMSOutboxWait(MemberSMSOutboxHistoryCriteria criteria);

	/**
	 * 查询会员参加的品牌记录
	 * 
	 * @param member
	 * @return
	 */
	public List<MemberBrandVo> searchAttendBrands(MemberAttendCriteria criteria);

	/**
	 * 查询会员参加的品牌记录总数
	 * 
	 * @param member
	 * @return
	 */
	public Long countAttendBrands(MemberAttendCriteria criteria);

	/**
	 * 根据条件查询会员的积分获取记录
	 * 
	 * @param criteria
	 * @return
	 */
	public List<OrderInfo> searchIntegralGetRecords(
			IntegralRecordCriteria criteria);

	/**
	 * 根据条件查询会员的积分获取记录总数
	 * 
	 * @param criteria
	 * @return
	 */
	public Long countIntegralGetRecords(IntegralRecordCriteria criteria);

	/**
	 * 根据条件查询会员的积分使用记录
	 * 
	 * @param criteria
	 * @return
	 */
	public List<OrderInfo> searchIntegralUseRecords(
			IntegralRecordCriteria criteria);

	/**
	 * 根据条件查询会员的积分使用记录总数
	 * 
	 * @param criteria
	 * @return
	 */
	public Long countIntegralUseRecords(IntegralRecordCriteria criteria);

	/**
	 * 根据条件查询会员的储蓄账户充值记录
	 * 
	 * @param criteria
	 * @return
	 */
	public List<OrderInfo> searchSavingsAccountGetRecords(
			SavingsAccountRecordCriteria criteria);

	/**
	 * 根据条件查询会员的储蓄账户充值记录总数
	 * 
	 * @param criteria
	 * @return
	 */
	public Long countSavingsAccountGetRecords(
			SavingsAccountRecordCriteria criteria);

	/**
	 * 根据条件查询会员的储蓄账户使用记录
	 * 
	 * @param criteria
	 * @return
	 */
	public List<OrderInfo> searchSavingsAccountUseRecords(
			SavingsAccountRecordCriteria criteria);

	/**
	 * 根据条件查询会员的储蓄账户使用记录总数
	 * 
	 * @param criteria
	 * @return
	 */
	public Long countSavingsAccountUseRecords(
			SavingsAccountRecordCriteria criteria);

	/**
	 * 查询会员的过期积分明细
	 * 
	 * @param member
	 * @param unitCodeBinke
	 * @return
	 */
	public List<MemberExpiredIntegralVo> findExpiredIntegralsByMember(
			Member member, Date fromDate, Date toDate, String unitCodeBinke,
			Page page);
	
	public void saveAccountPay(AccountrPay accountPay);
	/**
	 * 更新激活手机号
	 * @param id
	 * @param phone
	 */
	public void updateActivePhone(Integer id,String phone);
	
	public List<Member> offExternalMember(String PreSyncTime,Page page);
	
	public Member offExternalMemberByPhone(String phone);
	
	/**根据条件查询当前所有用户数
	 * @param member
	 * @return
	 */
	List<MemberReport> getTotleMembers(Member member);
	
	
	/**
	 * 判断卡号是否存在
	 * @param cardNo
	 * @param id
	 */
	public Integer findMemberByCard(String cardNo, Integer id);
	
	public Integer findMemberByEmail(String email, Integer id);
	
	public Integer findMemberByWeixin(String weixin, Integer id);
	
	public Integer findMemberByQq(String qq, Integer id);
	
	public Integer findMemberByIdentityCard(String idCard, Integer id);
	
	/**
	 * 根据webserver-client传过来的修改会员基本信息的请求更新会员基本信息
	 * 
	 * @param memberModifyReq
	 * @return
	 */
	public MemberModifyRes updateMemberForClient(MemberModifyReq memberModifyReq);
	
	/**
	 * 根据webserver-client传过来的修改会员密码信息的请求更新会员密码信息
	 * 
	 * @param memberPasswordModifyReq
	 * @return
	 */
	public MemberPasswordModifyRes updateMemberPasswordForClient(
			MemberPasswordModifyReq memberPasswordModifyReq);
	
	/**
	 * 外部接口登录
	 * @param memberId
	 * @param phone
	 * @param password
	 * @return
	 */
	public Member findMemberByPhonePwd(String phone);
	
	/**
	 * 储值卡消费接口
	 * 
	 * @param savingAccountConsumptionReq
	 * @return
	 */
	public SavingAccountConsumptionRes savingAccountConsumptionForClient(
			SavingAccountConsumptionReq savingAccountConsumptionReq);

	/**
	 * 获取规则
	 * @param ruleIds Sample: 1,2,3,4
	 * @return
	 */
	public List<IntegralRule> getRules(String ruleIds);
	
	/**
	 * 根据根据会员账号查询消费金额
	 * 
	 * @param criteria
	 * @return
	 */
	public BigDecimal getOrderPriceSum(String account_accountId);
	
	/**
	 * check the orderNO is repeated
	 * @param orderNO
	 * @return
	 */
	public boolean chechOrderNo(String orderNO);
	
	/**
	 * 根据条件获取会员数目
	 * @param member
	 * @return
	 */
	int getCountMembers(Member member);
	/**
	 * 注册来源
	 * @return
	 */
	public List<Source> findSources();
	
	/**根据num获取注册来源
	 * @param num
	 * @return
	 */
	public Source findByNum(String num);
	
	
}
