package com.chinarewards.metro.resources;

import java.io.StringWriter;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Pattern;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.MD5;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.crypto.SHA1Util;
import com.chinarewards.metro.domain.member.Source;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.models.ExternalMember;
import com.chinarewards.metro.models.ExternalMemberActivate;
import com.chinarewards.metro.models.ExternalMemberList;
import com.chinarewards.metro.models.ExternalMemberLogin;
import com.chinarewards.metro.models.ExternalMemberReg;
import com.chinarewards.metro.models.Member;
import com.chinarewards.metro.models.MemberSignArray;
import com.chinarewards.metro.models.RegisterResp;
import com.chinarewards.metro.models.common.DES3;
import com.chinarewards.metro.models.request.MemberActiveReq;
import com.chinarewards.metro.models.request.MemberInteractiveReq;
import com.chinarewards.metro.models.request.MemberLoginReq;
import com.chinarewards.metro.models.request.MemberModifyReq;
import com.chinarewards.metro.models.request.MemberPasswordModifyReq;
import com.chinarewards.metro.models.response.MemberModifyRes;
import com.chinarewards.metro.models.response.MemberPasswordModifyRes;
import com.chinarewards.metro.service.member.IMemberService;
import com.chinarewards.metro.service.system.ISysLogService;

@Component
@Path("/member")
public class MemberResource {

	@Autowired
	private IMemberService memberService;
	@Autowired
	private ISysLogService sysLogService;
	
	static List<Source> listSource = new ArrayList<Source>();

	@GET
	@Path("/list")
	@Consumes({ "application/xml", "application/json" })
	@Produces({ "application/xml", "application/json" })
	public MemberSignArray account() throws JAXBException {

		MemberSignArray array = new MemberSignArray();

		array.setCheckStr("hello");
		List<Member> members = new ArrayList<Member>();
		array.setList(members);

		Member member = new Member();

		member.setUserName("Kevin");
		member.setAddress("SZ");
		member.setAge(15);
		member.setGender("男");

		Member member2 = new Member();

		member2.setUserName("Helen");
		member2.setAddress("GZ");
		member2.setAge(22);
		member2.setGender("女");

		members.add(member);
		members.add(member2);

		// sign
		String ckvalue = array.getSignValue();
		array.setCheckStr(SHA1Util.SHA1Encode(ckvalue));

		JAXBContext ctx = JAXBContext.newInstance(MemberSignArray.class);
		StringWriter writer = new StringWriter();
		ctx.createMarshaller().marshal(array, writer);
		String custString = writer.toString();

		array.setCheckStr(MD5.MD5Encoder(custString));

		return array;
	}

	@POST
	@Path("/save")
	@Produces({ "application/xml", "application/json" })
	public RegisterResp saveMemeber(RegisterResp reg) {

		Date now = DateTools.dateToHour();
		com.chinarewards.metro.domain.member.Member m = new com.chinarewards.metro.domain.member.Member();

		String regEx = "^((13[0-9])|(14[0-9])|(16[0-9])|(15[0-9])|(18[0,5-9]))\\d{8}$";
		boolean flag = Pattern.compile(regEx).matcher(reg.getPhone()).find();
		if (!flag) {
			reg.setResult("1");
			reg.setTip("注册失败,请输入正确的手机号码!");
			return reg;
		}
		com.chinarewards.metro.domain.member.Member mb = memberService
				.findMemberByPhone(reg.getPhone());
		if (mb == null) {
			m.setPhone(reg.getPhone());
			m.setSource(Dictionary.MEMBER_SOURCE_POS);
			m.setPosNum(reg.getPosId());
			m.setCreateDate(now);
			m.setUpdateDate(now);
			memberService.saveT(m);
			reg.setTip("手机号码" + reg.getPhone() + "已注册,可以进行交易!");
			reg.setResult("0");
		} else {
			reg.setResult("1");
			if (reg.getResend() != null) {
				if (reg.getResend() == 1) {
					reg.setTip("手机号码" + reg.getPhone() + "已注册,可以进行交易!");
				} else {
					reg.setTip("手机号码" + reg.getPhone() + "已存在,可以进行交易!");
				}
			} else {
				reg.setTip("手机号码" + reg.getPhone() + "已存在,可以进行交易!");
			}
		}
		reg.setXactTime(now);
		return reg;
	}

	/**
	 * 与POS进销存系统会员交互
	 * 
	 * @param OperateType
	 * @param PreSyncTime
	 * @param PhoneNum
	 * @return
	 * @throws JAXBException 
	 */
	@POST
	@Path("/offExternalMember")
	@Consumes({ "application/xml", "application/json" })
	public ExternalMember offExternalMember(MemberInteractiveReq m) throws JAXBException {
		
		String checkStr = m.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(MemberInteractiveReq.class);
		m.setCheckStr(SHA1Util.SHA1Encode(m.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(m, r);
		String s = r.toString();
		if (!MD5.MD5Encoder(s).equals(checkStr)) {
			throw new IllegalArgumentException("Request Sign failed!");
		}
		
		if("SYNC".equals(m.getOperateType())){
			ExternalMember external = new ExternalMember();
			List<ExternalMemberList> externalMemberList = new ArrayList<ExternalMemberList>();
			if(m.getCurPage() !=null && m.getCurPage() > 0){
				Page page = new Page();
				page.setPage(m.getCurPage());
				List<com.chinarewards.metro.domain.member.Member> list = memberService.offExternalMember(m.getPreSyncTime(),page);
				for(com.chinarewards.metro.domain.member.Member member : list){
					ExternalMemberList externalMember = new ExternalMemberList();
					externalMember.setMemberId(member.getId());
					externalMember.setRegisterDate(DateTools.format_YYYYMMDDHHmmss(member.getCreateDate()));
					externalMember.setEmail(member.getEmail());
					externalMember.setGrade(member.getGrade());//会员等级 可选
					externalMember.setIntegral(member.getIntegral());
					externalMember.setIsActive(member.getStatus().equals(Dictionary.MEMBER_STATE_ACTIVATE) ? Dictionary.MEMBER_STATE_ACTIVATE :Dictionary.MEMBER_STATE_NOACTIVATE);
					externalMember.setPhone(member.getPhone());
					Integer ss = member.getStatus() == null ? 0 : member.getStatus();
					externalMember.setStatus((ss.equals(Dictionary.MEMBER_STATE_ACTIVATE) || ss.equals(Dictionary.MEMBER_STATE_NOACTIVATE)) ? 1 : 2);
					externalMember.setBirth(DateTools.format_YYYYMMDDHHmmss(member.getBirthDay()));
					String sss = member.getSurname()==null?"":member.getSurname();
					String n = member.getName() == null?"":member.getName();
					externalMember.setName(sss+n);
//					if(m.getPreSyncTime() == null){
//						externalMember.setTarget(1); //更新标记 1 新增 2 修改 3 其他
//					}else{
//						// 昨天 23: 59 59
//						Calendar cal = Calendar.getInstance();
//						cal.setTime(new Date());
//						cal.set(Calendar.HOUR, 23);
//						cal.set(Calendar.MINUTE, 59);
//						cal.set(Calendar.SECOND,59);
//					    cal.add(Calendar.DATE, -1);
//						// 传过来当天 00:00:01
//						Calendar cur = Calendar.getInstance();
//						cur.setTime(m.getPreSyncTime());
//						cur.set(Calendar.HOUR, 0);
//						cur.set(Calendar.MINUTE, 0);
//						cur.set(Calendar.SECOND,1);
//						
//						if(member.getCreateDate().before(cal.getTime()) && member.getCreateDate().after(cur.getTime())){
//							externalMember.setTarget(1);
//						}else{
//							externalMember.setTarget(2);
//						}
//					}
					externalMember.setUpdateTime(DateTools.format_YYYYMMDDHHmmss(member.getUpdateDate()));
					externalMember.setIntegral(member.getIntegral()==null?0:member.getIntegral());
					externalMemberList.add(externalMember);
				}
				external.setMemberList(externalMemberList);
				external.setCurPage(m.getCurPage());
				external.setTotalPage(page.getTotalRows());
				
				JAXBContext ctx = JAXBContext.newInstance(ExternalMember.class);
				StringWriter writer = new StringWriter();
				ctx.createMarshaller().marshal(external, writer);
				String custString = writer.toString();
				external.setCheckStr(MD5.MD5Encoder(custString));
				
				external.setResult("成功");
				return external;
			}else{
				external.setMemberList(externalMemberList);
				external.setResult("失败,输入的当前页有错误");
				return external;
			}
		}else if("QUERY".equals(m.getOperateType())){
			com.chinarewards.metro.domain.member.Member member = memberService.offExternalMemberByPhone(m.getPhoneNum());
			ExternalMember external = new ExternalMember();
			List<ExternalMemberList> externalMemberList = new ArrayList<ExternalMemberList>();
			if(member == null){
				ExternalMemberList externalMember = new ExternalMemberList();
				externalMember.setMemberId(-1);
				externalMemberList.add(externalMember);
			}else{
				ExternalMemberList externalMember = new ExternalMemberList();
				externalMember.setMemberId(member.getId());
				externalMember.setRegisterDate(DateTools.format_YYYYMMDDHHmmss(member.getCreateDate()));
				externalMember.setEmail(member.getEmail());
				externalMember.setGrade(member.getGrade());//会员等级 可选
				externalMember.setIntegral(member.getIntegral());
				externalMember.setIsActive(member.getStatus().equals(Dictionary.MEMBER_STATE_ACTIVATE) ? Dictionary.MEMBER_STATE_ACTIVATE : Dictionary.MEMBER_STATE_NOACTIVATE);
				externalMember.setPhone(member.getPhone());
				externalMember.setStatus(member.getStatus());
				Integer si = member.getStatus() == null ? 0 : member.getStatus();
				externalMember.setStatus((si.equals(Dictionary.MEMBER_STATE_ACTIVATE) || si.equals(Dictionary.MEMBER_STATE_NOACTIVATE)) ? 1 : 2);
				String ss = member.getSurname()==null?"":member.getSurname();
				String n = member.getName() == null?"":member.getName();
				externalMember.setName(ss+n);
//				externalMember.setTarget(3); //更新标记 1 新增 2 修改 3 其他
				externalMember.setUpdateTime(DateTools.format_YYYYMMDDHHmmss(member.getUpdateDate()));
				externalMember.setIntegral(member.getIntegral()==null?0:member.getIntegral());
				externalMember.setBirth(DateTools.format_YYYYMMDDHHmmss(member.getBirthDay()));
				externalMemberList.add(externalMember);
				external.setMemberList(externalMemberList);
				
				JAXBContext ctx = JAXBContext.newInstance(ExternalMember.class);
				StringWriter writer = new StringWriter();
				ctx.createMarshaller().marshal(external, writer);
				String custString = writer.toString();
				external.setCheckStr(MD5.MD5Encoder(custString));
			}
			return external;
		}else {
			return new ExternalMember();
		}
	}

	/**
	 * 会员基本信息修改
	 * 
	 * @param reg
	 * @return
	 * @throws JAXBException
	 */
	@PUT
	@Path("/modify")
	@Produces({ "application/xml", "application/json" })
	public MemberModifyRes modify(MemberModifyReq memberModifyReq)
			throws JAXBException {

		// check sign
		String checkStr = memberModifyReq.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(MemberModifyReq.class);
		memberModifyReq.setCheckStr(SHA1Util.SHA1Encode(memberModifyReq
				.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(memberModifyReq, r);
		String s = r.toString();
		if (!MD5.MD5Encoder(s).equals(checkStr)) {
			throw new IllegalArgumentException("Request Sign failed!");
		}
		MemberModifyRes memberModifyRes = null;
		
		try {
			memberModifyRes = memberService
						.updateMemberForClient(memberModifyReq);
		} catch (Exception e) {
			Integer id = memberModifyReq.getId();
			String phone = memberModifyReq.getPhone();
			String mail = memberModifyReq.getMail();
			String alivePhoneNumber = memberModifyReq.getAlivePhoneNumber();
			Date birthday = memberModifyReq.getBirthday();
			Integer memberStatus = memberModifyReq.getMemberStatus();

			memberModifyRes = new MemberModifyRes();
			memberModifyRes.setAlivePhoneNumber(alivePhoneNumber);
			memberModifyRes.setBirthday(birthday);
			memberModifyRes.setFailureReasons("数据库异常");
			memberModifyRes.setId(id);
			memberModifyRes.setMail(mail);
			memberModifyRes.setMemberStatus(memberStatus);
			memberModifyRes.setPhone(phone);
			memberModifyRes.setUpdateStatus(2);
			try {
				sysLogService.addSysLog("会员基本资料修改", memberModifyReq.getPhone(), OperationEvent.EVENT_UPDATE.getName(), "失败");
			} catch (Exception e1) {
			}
		}

		// sign
		String ckvalue = memberModifyRes.getSignValue();
		memberModifyRes.setCheckStr(SHA1Util.SHA1Encode(ckvalue));

		JAXBContext ctx = JAXBContext.newInstance(MemberModifyRes.class);
		StringWriter writer = new StringWriter();
		ctx.createMarshaller().marshal(memberModifyRes, writer);
		String custString = writer.toString();
		memberModifyRes.setCheckStr(MD5.MD5Encoder(custString));

		return memberModifyRes;
	}

	/**
	 * 会员密码信息修改
	 * 
	 * @param reg
	 * @return
	 * @throws JAXBException
	 */
	@POST
	@Path("/passwordModify")
	@Produces({ "application/xml", "application/json" })
	public MemberPasswordModifyRes passwordModify(
			MemberPasswordModifyReq memberPasswordModifyReq)
			throws JAXBException {

		// check sign
		String checkStr = memberPasswordModifyReq.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(MemberPasswordModifyReq.class);
		memberPasswordModifyReq.setCheckStr(SHA1Util
				.SHA1Encode(memberPasswordModifyReq.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(memberPasswordModifyReq, r);
		String s = r.toString();
		if (!MD5.MD5Encoder(s).equals(checkStr)) {
			throw new IllegalArgumentException("Request Sign failed!");
		}

		MemberPasswordModifyRes memberPasswordModifyRes = null; 
		
		com.chinarewards.metro.domain.member.Member member = memberService.findMemberById(memberPasswordModifyReq.getId());
		String name = null;
		if(null == member){
			name = "";
		}else {
			name = member.getSurname() + member.getName();
			name = (name==null)?member.getPhone():name;
		}
		try {
			memberPasswordModifyRes = memberService
					.updateMemberPasswordForClient(memberPasswordModifyReq);
			try {
				if(memberPasswordModifyRes.getUpdateStatus().equals(new Integer(1))){
					sysLogService.addSysLog("会员密码修改", name, OperationEvent.EVENT_UPDATE.getName(), "成功");
				} else {
					sysLogService.addSysLog("会员密码修改", name, OperationEvent.EVENT_UPDATE.getName(), "失败");
				}
			} catch (Exception e) {
			}
		} catch (Exception e) {
			try {
				sysLogService.addSysLog("会员密码修改", name, OperationEvent.EVENT_UPDATE.getName(), "失败");
			} catch (Exception e1) {
			}
		}

		// sign
		String ckvalue = memberPasswordModifyRes.getSignValue();
		memberPasswordModifyRes.setCheckStr(SHA1Util.SHA1Encode(ckvalue));

		JAXBContext ctx = JAXBContext
				.newInstance(MemberPasswordModifyRes.class);
		StringWriter writer = new StringWriter();
		ctx.createMarshaller().marshal(memberPasswordModifyRes, writer);
		String custString = writer.toString();
		memberPasswordModifyRes.setCheckStr(MD5.MD5Encoder(custString));

		return memberPasswordModifyRes;
	}

	/**
	 * 验证是否激活
	 * 
	 * @param memberId
	 * @param phone
	 * @param activeCode
	 * @return 状态：1 已激活 2 没激活 3 注销
	 * @throws JAXBException 
	 */

	@POST
	@Path("/offExternalMemberActive")
	@Produces({ "application/xml", "application/json" })
	public ExternalMemberActivate memberActivate(MemberActiveReq e) throws JAXBException{
		
		String checkStr = e.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(MemberActiveReq.class);
		e.setCheckStr(SHA1Util.SHA1Encode(e.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(e, r);
		String s = r.toString();
		if (!MD5.MD5Encoder(s).equals(checkStr)) {
			throw new IllegalArgumentException("Request Sign failed!");
		}
		
		com.chinarewards.metro.domain.member.Member m = memberService.findMemberById(e.getMemberId());
		ExternalMemberActivate externalMember = new ExternalMemberActivate();
		if(m != null){
			if(m.getStatus() == Dictionary.MEMBER_STATE_ACTIVATE){
				externalMember.setResult("激活失败,会员已激活");
			}else if(m.getStatus() == Dictionary.MEMBER_STATE_LOGOUT){
				externalMember.setResult("激活失败,会员已注销");
			}else{
				if(m.getValiCode() != null){
					if(m.getValiCode().equals(e.getActiveCode())){
						externalMember.setMemberId(m.getId());
						externalMember.setPhone(m.getPhone());
						externalMember.setCreateTime(m.getCreateDate());
						externalMember.setActivePhone(m.getPhone());
						externalMember.setIsActive(Dictionary.MEMBER_STATE_ACTIVATE);
						
						JAXBContext ctx = JAXBContext.newInstance(ExternalMemberActivate.class);
						StringWriter writer = new StringWriter();
						ctx.createMarshaller().marshal(externalMember, writer);
						String custString = writer.toString();
						externalMember.setCheckStr(MD5.MD5Encoder(custString));
						
						try{
							memberService.updateStatus(String.valueOf(e.getMemberId()), Dictionary.MEMBER_STATE_ACTIVATE);
							externalMember.setResult("激活成功");
							sysLogService.addSysLog("外部接口激活", e.getPhone(), OperationEvent.EVENT_SAVE.getName(), "成功");
						}catch(Exception ex){
							externalMember.setMemberId(null);
							externalMember.setResult("激活失败 " + ex);
							sysLogService.addSysLog("外部接口激活", e.getPhone(), OperationEvent.EVENT_SAVE.getName(), "失败");
						}
					}else{
						externalMember.setMemberId(m.getId());
						externalMember.setPhone(m.getPhone());
						externalMember.setCreateTime(m.getCreateDate());
						externalMember.setActivePhone(m.getPhone());
						externalMember.setIsActive(Dictionary.MEMBER_STATE_NOACTIVATE);
						
						JAXBContext ctx = JAXBContext.newInstance(ExternalMemberActivate.class);
						StringWriter writer = new StringWriter();
						ctx.createMarshaller().marshal(externalMember, writer);
						String custString = writer.toString();
						externalMember.setCheckStr(MD5.MD5Encoder(custString));
						
						externalMember.setResult("激活失败,验证码不正确");
					}
				}else{
					externalMember.setResult("激活失败,验证码不能为空");
				}
			}
		}else{
			externalMember.setResult("激活失败,会员不存在");
		}
		return externalMember;
	}

	/**
	 * 会员登录接口
	 * @param memberId
	 * @param phone
	 * @param password
	 * @return
	 * @throws JAXBException 
	 */
	@POST
	@Path("/offExternalMemberLogin")
	@Produces({ "application/xml", "application/json" })
	public ExternalMemberLogin memberLogin(MemberLoginReq login) throws JAXBException{
		
		String checkStr = login.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(MemberLoginReq.class);
		login.setCheckStr(SHA1Util.SHA1Encode(login.getSignValue()));
		StringWriter r = new StringWriter();
		c.createMarshaller().marshal(login, r);
		String s = r.toString();
		if (!MD5.MD5Encoder(s).equals(checkStr)) {
			throw new IllegalArgumentException("Request Sign failed!");
		}
		
		// 先解密,然后MD5加密明文
		String password = DES3.decryptStrMode(DES3.getKeyBytes(Dictionary.SECRET_KEY), login.getPassword());
		String mpassword = MD5.MD5Encoder(password);
		com.chinarewards.metro.domain.member.Member m = memberService.findMemberByPhonePwd(login.getPhone());
		
		ExternalMemberLogin externalMember = new ExternalMemberLogin();
		if(m != null){
			if(m.getStatus().equals(Dictionary.MEMBER_STATE_NOACTIVATE)){
				externalMember.setMemberId(login.getMemberId());
				externalMember.setPhone(login.getPhone());
				externalMember.setLoginStatus("登录失败,未激活的会员不能登录");
			}else if(!mpassword.equals(m.getPassword())){
				externalMember.setMemberId(login.getMemberId());
				externalMember.setPhone(login.getPhone());
				externalMember.setLoginStatus("登录失败,密码错误");
			}else{
				externalMember.setMemberId(m.getId());
				externalMember.setActivePhone(m.getActivePhone());
				externalMember.setBirth(m.getBirthDay());
				externalMember.setCreateTime(m.getCreateDate());
				externalMember.setEmail(m.getEmail());
				externalMember.setGrade(m.getGrade());//会员等级 可选
				externalMember.setIsActive(m.getStatus().equals(Dictionary.MEMBER_STATE_ACTIVATE) ? Dictionary.MEMBER_STATE_ACTIVATE :Dictionary.MEMBER_STATE_NOACTIVATE);
				externalMember.setPhone(m.getPhone());
				externalMember.setStatus(m.getStatus());
				externalMember.setIntegral(m.getIntegral());
				externalMember.setMoney(m.getMoney());
				
				JAXBContext ctx = JAXBContext.newInstance(ExternalMemberLogin.class);
				StringWriter writer = new StringWriter();
				ctx.createMarshaller().marshal(externalMember, writer);
				String custString = writer.toString();
				externalMember.setCheckStr(MD5.MD5Encoder(custString));
				
				externalMember.setLoginStatus("登录成功");
			}
		}else{
			externalMember.setMemberId(login.getMemberId());
			externalMember.setPhone(login.getPhone());
			externalMember.setLoginStatus("登录失败,用户不存在");
		}
		return externalMember;
	}

	/**
	 * 
	 * @param email
	 * @param phone
	 * @param createTime
	 * @param isActivate 参数没用到
	 * @param activatePhone 
	 * @param grade  暂时没用到
	 * @param birth
	 * @param integral
	 * @param status
	 * @param password
	 * @return 1 已激活  2未激活  
	 * @throws ParseException 
	 * @throws JAXBException 
	 */
	@POST
	@Path("/offExternalMemberRegister")
	@Produces({ "application/xml", "application/json" })
	public ExternalMemberReg memberRegister(ExternalMemberReg r) throws ParseException, JAXBException{
		
		String checkStr = r.getCheckStr();
		JAXBContext c = JAXBContext.newInstance(ExternalMemberReg.class);
		r.setCheckStr(SHA1Util.SHA1Encode(r.getSignValue()));
		StringWriter rr = new StringWriter();
		c.createMarshaller().marshal(r, rr);
		String s = rr.toString();
		if (!MD5.MD5Encoder(s).equals(checkStr)) {
			throw new IllegalArgumentException("Request Sign failed!");
		}
		
		// 先解密,然后MD5加密明文
		String password = null;
		if(StringUtils.isNotEmpty(r.getPassword())){
			password = DES3.decryptStrMode(DES3.getKeyBytes(Dictionary.SECRET_KEY), r.getPassword());
		}
		
		if(StringUtils.isEmpty(r.getPhone())){
			ExternalMemberReg reg = new ExternalMemberReg();
			reg.setResult("注册失败,手机号码不能为空");
			return reg;
		}else if(r.getCreateTime()==null){
			ExternalMemberReg reg = new ExternalMemberReg();
			reg.setResult("注册失败,注册时间不能为空");
			return reg;
		}else if(r.getIsActive() ==null){
			ExternalMemberReg reg = new ExternalMemberReg();
			reg.setResult("注册失败,是否激活不能为空");
			return reg;
		}else if(r.getIntegral()==null){
			ExternalMemberReg reg = new ExternalMemberReg();
			reg.setResult("注册失败,会员积分不能为空");
			return reg;
		}else if("".equals(password) || password == null){
			ExternalMemberReg reg = new ExternalMemberReg();
			reg.setResult("注册失败,会员密码不能为空");
			return reg;
		}else{
			
			if(r.getIsActive() != Dictionary.MEMBER_STATE_ACTIVATE && r.getIsActive() != Dictionary.MEMBER_STATE_NOACTIVATE){
				ExternalMemberReg reg = new ExternalMemberReg();
				reg.setResult("注册失败,是否激活值输入错误 1 激活, 2 未激活");
				return reg;
			}
			if(r.getIsActive() == Dictionary.MEMBER_STATE_ACTIVATE && StringUtils.isEmpty(r.getActivePhone())){
				ExternalMemberReg reg = new ExternalMemberReg();
				reg.setResult("注册失败,激活手机号不能为空");
				return reg;
			}
			if(r.getIntegral() != null && r.getIntegral() < 0){
				ExternalMemberReg reg = new ExternalMemberReg();
				reg.setResult("注册失败,会员积分不能小于0");
				return reg;
			}
			String regEx = "^((13[0-9])|(14[0-9])|(16[0-9])|(15[0-9])|(18[0,5-9]))\\d{8}$";
			boolean flag = Pattern.compile(regEx).matcher(r.getPhone()).find();
			if (!flag) {
				ExternalMemberReg reg = new ExternalMemberReg();
				reg.setResult("注册失败,手机号码输入不正确");
				return reg;
			}
			if(StringUtils.isNotEmpty(r.getActivePhone())){
				boolean flag1 = Pattern.compile(regEx).matcher(r.getActivePhone()).find();
				if (!flag1) {
					ExternalMemberReg reg = new ExternalMemberReg();
					reg.setResult("注册失败,激活手机号码输入不正确");
					return reg;
				}
			}
			if(StringUtils.isNotEmpty(r.getEmail())){
				if(!CommonUtil.emailFormat(r.getEmail())){
					ExternalMemberReg reg = new ExternalMemberReg();
					reg.setResult("注册失败,邮箱输入不正确");
					return reg;
				}
						
				if(memberService.findMemberByEmail(r.getEmail(), null) == 1){
					ExternalMemberReg reg = new ExternalMemberReg();
					reg.setResult("注册失败,邮箱已存在");
					return reg;
				}
			}
			if(r.getSource() == null){
				ExternalMemberReg reg = new ExternalMemberReg();
				reg.setResult("注册失败,注册来源不能为空");
				return reg;
			}else{
				if(listSource.size() == 0){
					listSource = memberService.findSources();
				}
				boolean f = true;
				for(Source so : listSource){
					if(so.getNum().equals(r.getSource())){
						f = false;break;
					}
				}
				if(f){
					ExternalMemberReg reg = new ExternalMemberReg();
					reg.setResult("注册失败,注册来源错误");
					return reg;
				}
			}
			com.chinarewards.metro.domain.member.Member m1 = memberService.findMemberByPhone(r.getPhone());
			if(m1 == null){
				com.chinarewards.metro.domain.member.Member m = new com.chinarewards.metro.domain.member.Member();
				m.setEmail(r.getEmail());
				m.setPhone(r.getPhone());
				m.setCreateDate(r.getCreateTime());
				if(Dictionary.MEMBER_STATE_ACTIVATE == r.getIsActive()){
					m.setActivePhone(r.getActivePhone());
				}
				m.setBirthDay(r.getBirth());
				m.setStatus(r.getIsActive());
				
				m.setPassword(MD5.MD5Encoder(password));
				m.setIntegral(r.getIntegral());
				m.setSource(r.getSource());
				m.setGrade(r.getGrade());
				
				ExternalMemberReg reg = new ExternalMemberReg();
				reg.setActivePhone(r.getActivePhone());
				reg.setIsActive(r.getIsActive());
				reg.setMemberId(m.getId());
				reg.setEmail(r.getEmail());
				reg.setPhone(r.getPhone());
				reg.setCreateTime(r.getCreateTime());
				
				JAXBContext ctx = JAXBContext.newInstance(ExternalMemberReg.class);
				StringWriter writer = new StringWriter();
				ctx.createMarshaller().marshal(reg, writer);
				String custString = writer.toString();
				reg.setCheckStr(MD5.MD5Encoder(custString));
				
				try{
					try{
						memberService.externalSaveMember(m);
						sysLogService.addSysLog("会员信息注册", r.getPhone() + "  外部接口注册", OperationEvent.EVENT_SAVE.getName(), "成功");
					}catch(Exception e){
						sysLogService.addSysLog("会员信息注册", r.getPhone() + "  外部接口注册", OperationEvent.EVENT_SAVE.getName(), "失败");
						throw new RuntimeException(e);
					}
					
					reg.setMemberId(m.getId());
					reg.setResult("注册成功");
				}catch(Exception e){
					reg = new ExternalMemberReg();
					reg.setResult("注册失败:"+e);
				}
				return reg;
			}else{
				if(Dictionary.MEMBER_SOURCE_POS.equals(m1.getSource()) && m1.getPassword() == null){
					ExternalMemberReg reg = new ExternalMemberReg();
					m1.setActivePhone(r.getActivePhone());
					m1.setBirthDay(r.getBirth());
					m1.setEmail(r.getEmail());
					m1.setGrade(r.getGrade());
					m1.setPassword(MD5.MD5Encoder(password));
					m1.setStatus(r.getIsActive());
					m1.setIntegral(r.getIntegral());
					memberService.externalSaveMember2(m1);
					reg.setMemberId(m1.getId());
					reg.setResult("注册成功");
					return reg;
				}else{
					ExternalMemberReg reg = new ExternalMemberReg();
					reg.setResult("注册失败,手机号码已存在");
					return reg;
				}
			}
		}
	}
	
}
