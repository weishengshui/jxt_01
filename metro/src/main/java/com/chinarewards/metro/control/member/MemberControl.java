package com.chinarewards.metro.control.member;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.domain.account.Account;
import com.chinarewards.metro.domain.business.OrderInfo;
import com.chinarewards.metro.domain.member.AccountrPay;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.rules.IntegralRule;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.common.AjaxResponseCommonVo;
import com.chinarewards.metro.model.member.DiscountNumberRecordCriteria;
import com.chinarewards.metro.model.member.IntegralRecordCriteria;
import com.chinarewards.metro.model.member.MemberAttendCriteria;
import com.chinarewards.metro.model.member.MemberBrandVo;
import com.chinarewards.metro.model.member.MemberDiscountNumberVo;
import com.chinarewards.metro.model.member.MemberExpiredIntegralVo;
import com.chinarewards.metro.model.member.MemberSMSOutboxHistoryCriteria;
import com.chinarewards.metro.model.member.MemberSMSOutboxHistoryVo;
import com.chinarewards.metro.model.member.SavingsAccountRecordCriteria;
import com.chinarewards.metro.model.member.SoonExpireAccountBalanceVo;
import com.chinarewards.metro.service.account.IAccountService;
import com.chinarewards.metro.service.member.IMemberService;
import com.chinarewards.metro.service.system.ISysLogService;

@Controller
@RequestMapping("/member")
public class MemberControl {

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private IMemberService memberService;
	@Autowired
	private IAccountService accountService;
	@Autowired
	private ISysLogService sysLogService;

	@RequestMapping("/memberIndex")
	public String memberIndex(Model model) throws Exception {
		model.addAttribute("status", Dictionary.findMemberStatus());
		model.addAttribute("statusJson",
				CommonUtil.toJson(Dictionary.findMemberStatus()));
		model.addAttribute("sourceJson",CommonUtil.toJson(memberService.findSources()));
		return "member/memberList";
	}

	@RequestMapping("/memberRegist")
	public String memberRegist(Model model) throws Exception {
		model.addAttribute("status", Dictionary.findMemberStatus());
		model.addAttribute("statusJson",
				CommonUtil.toJson(Dictionary.findMemberStatus()));
		return "member/memberRegist";
	}

	@RequestMapping("/memberPage")
	public String memberPage(Model model) throws Exception {
		model.addAttribute("female", Dictionary.MEMBER_SEX_FEMALE);
		return "member/member";
	}

	@RequestMapping("/saveMember")
	@ResponseBody
	public Member saveMember(Member member) throws Exception {
		try{
			Member m = memberService.saveMember(member);
			sysLogService.addSysLog("会员信息注册", member.getSurname()+member.getName(), OperationEvent.EVENT_SAVE.getName(), "成功");
			return m;
		}catch(Exception e){
			sysLogService.addSysLog("会员信息注册", member.getSurname()+member.getName(), OperationEvent.EVENT_SAVE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}

	@RequestMapping("/updateMember")
	@ResponseBody
	public void updateMember(HttpServletResponse response, Member member)
			throws Exception {
		int i = 0;
		try{
			i = memberService.updateMember(member);
			sysLogService.addSysLog("会员信息维护", member.getSurname()+member.getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
		}catch(Exception e){
			sysLogService.addSysLog("会员信息维护", member.getSurname()+member.getName(), OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		if(i==1){
			out.println(CommonUtil.toJson(new AjaxResponseCommonVo("1")));
		}else{
			out.println(CommonUtil.toJson(new AjaxResponseCommonVo("保存成功")));
		}
		out.flush();
	}

	@RequestMapping("/findMemebers")
	public Map<String, Object> findMemebers(Member member, Page page)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("rows", memberService.findMembers(member, page));
		map.put("total", page.getTotalRows());
		return map;
	}

	@RequestMapping("/findMemberById")
	public String findMemberById(Integer id, Model model) throws Exception {
		model.addAttribute("member", memberService.findMemberById(id));
		model.addAttribute("female", Dictionary.MEMBER_SEX_FEMALE);
		return "member/member";
	}

	/**
	 * 发送激活码
	 */
	@RequestMapping(value = "/sendActivationCode")
	@ResponseBody
	public void sendActivationCode(Member member) {
		String n = member.getSurname();
		if(n == null){
			n = member.getPhone();
		}else{
			n = member.getSurname()+member.getName();
		}
		try{
			memberService.sendActivationCode(member.getId(), member.getPhone());
//			"  发送激活码
			sysLogService.addSysLog("会员信息维护", n, OperationEvent.EVENT_UPDATE.getName(), "成功");
		}catch(Exception e){
			sysLogService.addSysLog("会员信息维护", n, OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}

	/**
	 * 手动激活会员
	 */
	@ExceptionHandler(RuntimeException.class)
	@RequestMapping("/activationMember")
	@ResponseBody
	public void activationMember(String ids,String phone,String name) throws Exception {
		try{
			memberService.updateStatus(ids, Dictionary.MEMBER_STATE_ACTIVATE);
//			+ "  手动激活会员
			sysLogService.addSysLog("会员信息维护", name, OperationEvent.EVENT_UPDATE.getName(), "成功");
		}catch(Exception e){
			sysLogService.addSysLog("会员信息维护", name, OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}

	/**
	 * 注销会员
	 */
	@ResponseBody
	@RequestMapping("/logoutMember")
	public void logoutMember(String ids,String names) throws Exception {
		try{
			memberService.delMember(ids);
			for(String s : names.split(",")){
				sysLogService.addSysLog("会员信息维护", s, OperationEvent.EVENT_LOGOUT.getName(), "成功");
			}
		}catch(Exception e){
			for(String s : names.split(",")){
				sysLogService.addSysLog("会员信息维护", s, OperationEvent.EVENT_LOGOUT.getName(), "失败"+e.getMessage());
			}
			throw new RuntimeException(e);
		}
	}

	/**
	 * 重置密码
	 */
	@ResponseBody
	@RequestMapping("/resetPassword")
	public void resetPassword(String ids,String name) throws Exception {
		try {
			memberService.resetPassword(ids);
			// "  重置密码"
			sysLogService.addSysLog("会员信息维护", name, OperationEvent.EVENT_UPDATE.getName(), "成功");
		} catch (Exception e) {
			sysLogService.addSysLog("会员信息维护", name, OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}

	/**
	 * 查询手机号是否存在
	 * 
	 * @param phone
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/findMemberByPhone")
	public String findMemberByPhone(String phone, Integer id) throws Exception {
		Member m = memberService.findMemberByPhone(phone);
		if (m == null)
			return "0";
		else {
			if (m.getId().equals(id)) { // 用==判断不一定正确，注意是两个对象
				return "0";
			} else {
				return "1";
			}
		}
	}
	
	/**
	 * 查询卡号是否存在
	 * 
	 * @param phone
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/findMemberByCard")
	public Integer findMemberByCard(String cardNo, Integer id) throws Exception {
		return memberService.findMemberByCard(cardNo, id);
	}

	@ResponseBody
	@RequestMapping("/findMemberByEmail")
	public Integer findMemberByEmail(String email, Integer id) throws Exception {
		return memberService.findMemberByEmail(email, id);
	}
	
	@ResponseBody
	@RequestMapping("/findMemberByWeixin")
	public Integer findMemberByWeixin(String weixin, Integer id) throws Exception {
		return memberService.findMemberByWeixin(weixin, id);
	}
	
	@ResponseBody
	@RequestMapping("/findMemberByQq")
	public Integer findMemberByQq(String qq, Integer id) throws Exception {
		return memberService.findMemberByQq(qq, id);
	}
	
	@ResponseBody
	@RequestMapping("/findMemberByIdentityCard")
	public Integer findMemberByIdentityCard(String idCard, Integer id) throws Exception {
		return memberService.findMemberByIdentityCard(idCard, id);
	}
	/**
	 * 修改页面
	 * 
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping("/updateMemberPage")
	public String updateMemberPage(Model model, Integer id) {
		model.addAttribute("member", memberService.findMemberById(id));
		model.addAttribute("male", Dictionary.MEMBER_SEX_MALE);
		model.addAttribute("female", Dictionary.MEMBER_SEX_FEMALE);
		model.addAttribute("member_state_logout",
				Dictionary.MEMBER_STATE_LOGOUT);
		model.addAttribute("member_state_noactive",
				Dictionary.MEMBER_STATE_NOACTIVATE);
		model.addAttribute("member_state_active",
				Dictionary.MEMBER_STATE_ACTIVATE);
		return "member/memberUpdate";
	}

	@RequestMapping("/accountPayList")
	public String accountPayList(Model model){
		model.addAttribute("status", Dictionary.findMemberStatus());
		model.addAttribute("statusJson",CommonUtil.toJson(Dictionary.findMemberStatus()));
		model.addAttribute("sourceJson",CommonUtil.toJson(memberService.findSources()));
		return  "member/accountPayList";
	}
	
	/**
	 * 会员账户充值
	 * @param model
	 * @param id
	 * @return
	 */
	@RequestMapping("/accountPay")
	public String accountPay(Model model,Integer id){
		model.addAttribute("member", memberService.findMemberById(id));
		return  "member/accountPay";
	}
	
	@RequestMapping("/saveAccountPay")
	@ResponseBody
	public void  saveAccountPay(AccountrPay accountrPay){
		//String type = accountrPay.getSource().equals(Dictionary.SUFFICIENT_TYPE_INTEGRAL) ? "积分" : "金额";
		try{
			memberService.saveAccountPay(accountrPay);
			//type+"充值: "+accountrPay.getMemberName()
			sysLogService.addSysLog("会员账户充值", accountrPay.getMemberName(), OperationEvent.EVENT_SAVE.getName(), "成功");
		}catch(Exception e){
			sysLogService.addSysLog("会员账户充值", accountrPay.getMemberName(), OperationEvent.EVENT_SAVE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
		
	}
	
	
	/**
	 * 账户信息
	 */
	@RequestMapping("/accountInfo")
	public String accountInfo(Model model, Integer id) {

		Member member = memberService.findMemberById(id);
		Account account = accountService.findAccountByMember(member);

		double avalableJiFen = accountService.getAccountBalance(account,
				Dictionary.UNIT_CODE_BINKE);
		double froznJiFen = accountService.getFrozenAccountBalance(account,
				Dictionary.UNIT_CODE_BINKE);
		double rmbBalance = accountService.getAccountBalance(account,
				Dictionary.UNIT_CODE_RMB);
		DecimalFormat df = new DecimalFormat();
		df.setMinimumFractionDigits(0);
		df.setMaximumFractionDigits(2);
		String rmbstr = df.format(rmbBalance);
		String avalableJiFenSssstr = df.format(avalableJiFen);
		String froznJiFenStr = df.format(froznJiFen);
		model.addAttribute("avalableJiFen", avalableJiFenSssstr.replaceAll(",", ""));
		model.addAttribute("froznJiFen", froznJiFenStr.replaceAll(",", ""));
		model.addAttribute("rmbBalance", rmbstr.replaceAll(",", ""));
		model.addAttribute("id", id);

		return "member/accountInfo";
	}

	// 获取即将过期的积分
	@RequestMapping("/soonExpire")
	public String soonExpire(Model model, Integer id) {
		List<SoonExpireAccountBalanceVo> soonExpire = null;

		if (null == id) {
			soonExpire = new ArrayList<SoonExpireAccountBalanceVo>();
		} else {
			// prepare data
			Member member = memberService.findMemberById(id);

			soonExpire = accountService.soonExpireAccountBalanceByMember(
					member, Dictionary.UNIT_CODE_BINKE);
		}

		model.addAttribute("id", id);
		model.addAttribute("rows", soonExpire);
		model.addAttribute("total", soonExpire.size());

		return "member/accountInfo";
	}

	// 获取会员的过期积分明细
	@RequestMapping(value = "/expiredIntegralGet", method = RequestMethod.GET)
	public String expiredIntegral(Model model, Integer id) {

		model.addAttribute("id", id);

		return "member/expiredIntegral";
	}

	@RequestMapping(value = "/expiredIntegral")
	public String expiredIntegral(Integer page, Integer rows, Model model,
			Integer id, Date fromDate, Date toDate) {
		
		Page paginationDetail = new Page();
		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);
		
		List<MemberExpiredIntegralVo> list = null;

		if (null == id) {
			list = new ArrayList<MemberExpiredIntegralVo>();
		} else {
			// prepare data
			Member member = memberService.findMemberById(id);

			list = memberService.findExpiredIntegralsByMember(member, fromDate,
					toDate, Dictionary.UNIT_CODE_BINKE, paginationDetail);
		}

		model.addAttribute("id", id);
		model.addAttribute("rows", list);
		model.addAttribute("total", paginationDetail.getTotalRows());
		model.addAttribute("page", page);

		return "member/expiredIntegral";
	}

	/**
	 * 积分获取记录页面
	 * 
	 * @return
	 */
	@RequestMapping("/integralGetRecord")
	public String integralGetRecord(
			@ModelAttribute IntegralRecordCriteria criteria, Integer page,
			Integer rows, Model model) {

		model.addAttribute("id", criteria.getId());
		Page paginationDetail = new Page();
		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);
		criteria.setPaginationDetail(paginationDetail);

		List<OrderInfo> list = memberService.searchIntegralGetRecords(criteria);
		Long count = memberService.countIntegralGetRecords(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());

		logger.trace("integralGetRecord list size is " + list.size());

		model.addAttribute("total", count);
		model.addAttribute("page", page);
		model.addAttribute("rows", list);
		model.addAttribute("txTypesJson", CommonUtil.toJson(Dictionary.findTxTypes()));
		model.addAttribute("txStatusesJson", CommonUtil.toJson(Dictionary.findTxSatuses()));
		return "member/integralGetRecord";
	}

	/**
	 * 积分使用记录页面
	 * 
	 * @return
	 */
	@RequestMapping("/integralUseRecord")
	public String integralUseRecord(
			@ModelAttribute IntegralRecordCriteria criteria, Integer page,
			Integer rows, Model model) {

		model.addAttribute("id", criteria.getId());
		Page paginationDetail = new Page();
		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);
		criteria.setPaginationDetail(paginationDetail);

		List<OrderInfo> list = memberService.searchIntegralUseRecords(criteria);
		Long count = memberService.countIntegralUseRecords(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());

		model.addAttribute("total", count);
		model.addAttribute("page", page);
		model.addAttribute("rows", list);
		model.addAttribute("txTypesJson", CommonUtil.toJson(Dictionary.findTxTypes()));
		model.addAttribute("txStatusesJson", CommonUtil.toJson(Dictionary.findTxSatuses()));

		return "member/integralUseRecord";
	}

	/**
	 * 储蓄账户充值记录页面
	 * 
	 * @param criteria
	 * @param page
	 * @param rows
	 * @param model
	 * @return
	 */
	@RequestMapping("/savingsAccountGetRecord")
	public String savingsAccountGetRecord(
			@ModelAttribute SavingsAccountRecordCriteria criteria,
			Integer page, Integer rows, Model model) {

		model.addAttribute("id", criteria.getId());
		Page paginationDetail = new Page();
		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);
		criteria.setPaginationDetail(paginationDetail);

		List<OrderInfo> list = memberService
				.searchSavingsAccountGetRecords(criteria);
		Long count = memberService.countSavingsAccountGetRecords(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());

		model.addAttribute("total", count);
		model.addAttribute("page", page);
		model.addAttribute("rows", list);
		model.addAttribute("txStatusesJson", CommonUtil.toJson(Dictionary.findTxSatuses()));

		return "member/savingsAccountGetRecord";
	}

	/**
	 * 储蓄账户使用记录页面
	 * 
	 * @param criteria
	 * @param page
	 * @param rows
	 * @param model
	 * @return
	 */
	@RequestMapping("/savingsAccountUseRecord")
	public String savingsAccountUseRecord(
			@ModelAttribute SavingsAccountRecordCriteria criteria,
			Integer page, Integer rows, Model model) {

		model.addAttribute("id", criteria.getId());
		Page paginationDetail = new Page();
		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);
		criteria.setPaginationDetail(paginationDetail);

		List<OrderInfo> list = memberService
				.searchSavingsAccountUseRecords(criteria);
		Long count = memberService.countSavingsAccountUseRecords(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());

		model.addAttribute("total", count);
		model.addAttribute("page", page);
		model.addAttribute("rows", list);
		model.addAttribute("txStatusesJson", CommonUtil.toJson(Dictionary.findTxSatuses()));

		return "member/savingsAccountUseRecord";
	}

	/**
	 * 优惠码记录页面
	 * 
	 * @param criteria
	 * @param page
	 * @param rows
	 * @param model
	 * @return
	 */
	@RequestMapping("/discountNumberRecord")
	public String discountNumberRecord(
			@ModelAttribute DiscountNumberRecordCriteria criteria,
			Integer page, Integer rows, Model model) {

		model.addAttribute("id", criteria.getId());
		Page paginationDetail = new Page();
		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);
		criteria.setPaginationDetail(paginationDetail);

		List<MemberDiscountNumberVo> list = memberService
				.searchDiscountNumberRecords(criteria);
		Long count = memberService.countDiscountNumberRecords(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());

		model.addAttribute("total", count);
		model.addAttribute("page", page);
		model.addAttribute("rows", list);
		model.addAttribute("discountNumberSatusesJson", CommonUtil.toJson(Dictionary.findMemberDiscountNumberSatuses()));
		
		return "member/discountNumberRecord";
	}

	/**
	 * 短信发送历史记录页面 短信发送历史记录
	 * 
	 * @param criteria
	 * @param page
	 * @param rows
	 * @param model
	 * @return
	 */
	@RequestMapping("/memberSMSOutboxHistory")
	public String memberSMSOutboxHistory(
			@ModelAttribute MemberSMSOutboxHistoryCriteria criteria,
			Integer page, Integer rows, Model model) {

		model.addAttribute("id", criteria.getId());
		Page paginationDetail = new Page();
		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);
		criteria.setPaginationDetail(paginationDetail);

		List<MemberSMSOutboxHistoryVo> list = memberService
				.searchMemberSMSOutboxHistory(criteria);
		Long count = memberService.countMemberSMSOutboxHistory(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());
		// just for test
		// list.add(new MemberSMSOutboxHistoryVo("13189755310", "你好，现在有以下优惠",
		// new Date(), SMSSendStatus.ERROR));
		// list.add(new MemberSMSOutboxHistoryVo("13189755310", "你好，现在有以下优惠",
		// new Date(), SMSSendStatus.SENT));

		model.addAttribute("total", count);
		model.addAttribute("page", page);
		model.addAttribute("rows", list);

		return "member/memberSMSOutboxHistory";
	}

	/**
	 * 短信发送历史记录页面 等待发送的短信的记录
	 * 
	 * @param criteria
	 * @param page
	 * @param rows
	 * @param model
	 * @return
	 */
	@RequestMapping("/memberSMSOutboxWait")
	public String memberSMSOutboxWait(
			@ModelAttribute MemberSMSOutboxHistoryCriteria criteria,
			Integer page, Integer rows, Model model) {

		model.addAttribute("id", criteria.getId());
		Page paginationDetail = new Page();
		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);
		criteria.setPaginationDetail(paginationDetail);

		List<MemberSMSOutboxHistoryVo> list = memberService
				.searchMemberSMSOutboxWait(criteria);
		Long count = memberService.countMemberSMSOutboxWait(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());

		model.addAttribute("total", count);
		model.addAttribute("page", page);
		model.addAttribute("rows", list);

		return "member/memberSMSOutboxHistory";
	}

	/**
	 * 会员维护中的联合会员页面 ------ 显示会员是哪些品牌的联合会员
	 * 
	 * @param criteria
	 * @param page
	 * @param rows
	 * @param model
	 * @return
	 */
	@RequestMapping("/attendBrands")
	public String attendBrands(@ModelAttribute MemberAttendCriteria criteria,
			Integer page, Integer rows, Model model) {

		model.addAttribute("id", criteria.getId());
		Page paginationDetail = new Page();
		rows = (rows == null) ? Constants.PERPAGE_SIZE : rows;
		page = page == null ? 1 : page;
		paginationDetail.setPage(page);
		paginationDetail.setRows(rows);
		criteria.setPaginationDetail(paginationDetail);

		List<MemberBrandVo> list = memberService.searchAttendBrands(criteria);
		Long count = memberService.countAttendBrands(criteria);
		paginationDetail.setTotalRows(count==null?0:count.intValue());

		model.addAttribute("total", count);
		model.addAttribute("page", page);
		model.addAttribute("rows", list);

		return "member/attendBrands";
	}

	@RequestMapping("rules")
	public String showMatchedRules(String ruleIds, Model model) {

		List<IntegralRule> rules = memberService.getRules(ruleIds);
		model.addAttribute("rows", rules);

		if (!StringUtils.isEmpty(ruleIds) && !ruleIds.endsWith(",")) {
			int flag = ruleIds.lastIndexOf(",");
			if (flag == -1) {
				flag = 0;
			}else{
				flag ++ ;
			}
			String bithdayRate = ruleIds.substring(flag);
			try {
				if(bithdayRate != null ){
					model.addAttribute("birthdayRate",
							"生日奖励" + Double.parseDouble(bithdayRate) + " 倍积分");
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return "member/integralGetRecord";
	}
	
	@RequestMapping(value = "/checkDetails")
	public void checkPosBand(String ruleIds, HttpServletResponse response) {
		response.setContentType("text/html; charset=utf-8");
		try {
			int count = 0 ;
			PrintWriter out = response.getWriter();
			List<IntegralRule> rules = memberService.getRules(ruleIds);
			if(rules != null){
				count = rules.size() ;
			}
			out.print(CommonUtil.toJson(count));
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
