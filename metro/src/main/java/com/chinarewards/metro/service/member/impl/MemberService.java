package com.chinarewards.metro.service.member.impl;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.JDBCDaoSupport;
import com.chinarewards.metro.core.common.MD5;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.SystemTimeProvider;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.account.Account;
import com.chinarewards.metro.domain.account.Business;
import com.chinarewards.metro.domain.account.QueueStatus;
import com.chinarewards.metro.domain.account.Transaction;
import com.chinarewards.metro.domain.account.Unit;
import com.chinarewards.metro.domain.activity.ActivityInfo;
import com.chinarewards.metro.domain.business.OrderInfo;
import com.chinarewards.metro.domain.business.RedemptionDetail;
import com.chinarewards.metro.domain.member.AccountrPay;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.member.Source;
import com.chinarewards.metro.domain.merchandise.Merchandise;
import com.chinarewards.metro.domain.merchandise.MerchandiseSaleform;
import com.chinarewards.metro.domain.merchandise.MerchandiseShop;
import com.chinarewards.metro.domain.rules.IntegralRule;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.domain.sms.SMSSendStatus;
import com.chinarewards.metro.domain.user.OperationEvent;
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
import com.chinarewards.metro.models.common.DES3;
import com.chinarewards.metro.models.merchandise.CommodityVo;
import com.chinarewards.metro.models.request.MemberModifyReq;
import com.chinarewards.metro.models.request.MemberPasswordModifyReq;
import com.chinarewards.metro.models.request.SavingAccountConsumptionReq;
import com.chinarewards.metro.models.response.MemberModifyRes;
import com.chinarewards.metro.models.response.MemberPasswordModifyRes;
import com.chinarewards.metro.models.response.SavingAccountConsumptionRes;
import com.chinarewards.metro.resources.MemberResource;
import com.chinarewards.metro.service.account.IAccountService;
import com.chinarewards.metro.service.member.IMemberService;
import com.chinarewards.metro.service.merchandise.IMerchandiseService;
import com.chinarewards.metro.service.system.ISysLogService;
import com.chinarewards.metro.sms.ICommunicationService;

@Service
public class MemberService implements IMemberService {
	@Autowired
	private HBDaoSupport hbDaoSupport;
	@Autowired
	private JDBCDaoSupport jdbcDaoSupport;
	@Autowired
	private IAccountService accountService;
	@Autowired
	ICommunicationService communicationService;
	@Autowired
	private IMerchandiseService merchandiseService;
	@Autowired
	private ISysLogService sysLogService;

	Logger logger = Logger.getLogger(this.getClass());
	
	@Override
	public Member saveMember(Member member) {
		Date date = new Date();
		member.setCreateDate(date);
		member.setCreateUser(UserContext.getUserName());
		member.setUpdateDate(date);
		Account account = accountService.createAccount(member.getName());
		member.setAccount(account != null ? account.getAccountId() : "");
		member.setStatus(Dictionary.MEMBER_STATE_NOACTIVATE);
		member.setSource(Dictionary.MEMBER_SOURCE_CRM);
		hbDaoSupport.save(member);
		if ("on".equals(member.getValiCode())) {// 勾选了发送验证码 调用短信接口发送短信
			sendActivationCode(member.getId(), member.getPhone());
		}
		return member;
	}

	@Override
	public Member saveT(Member member) {
		Account account = accountService.createAccount("");
		member.setAccount(account != null ? account.getAccountId() : "");
		member.setStatus(Dictionary.MEMBER_STATE_NOACTIVATE);
		hbDaoSupport.save(member);
		//sendActivationCode(member.getId(), member.getPhone());
		String c = "您的手机号已经注册成功，可以消费获得积分。请登录www.blinq.cn完善您的个人信息。";
		communicationService.queueSMS(null, member.getId().toString(), member.getPhone(), c, 5,null);
		return member;
	}

	@Override
	public Member externalSaveMember(Member member) {
		Date now = new Date();
		Account account = accountService.createAccount("");
		member.setAccount(account != null ? account.getAccountId() : "");
		if(member.getIntegral() > 0){
			Transaction tx = accountService.createTransaction("", Business.EXTERNAL_POINT, now);
			String strUnit = Dictionary.UNIT_CODE_BINKE;
			Unit unit = hbDaoSupport.findTByHQL("FROM Unit where unitCode = ?",strUnit);
			OrderInfo orderInfo = new OrderInfo();
			orderInfo.setType(0);
			tx.setBusines(Business.EXTERNAL_POINT);
			orderInfo.setAccount(account);
			orderInfo.setClerkId("");
			orderInfo.setTx(tx);
			
			String source = "";
			for(Source so : findSources()){
				if(so.getNum().equals(member.getSource())){
					source = so.getName();break;
				}
			}
			
			orderInfo.setOrderSource(source);
			orderInfo.setOrderNo(tx.getTxId());
			orderInfo.setIntegration(BigDecimal.valueOf(member.getIntegral()));
			orderInfo.setOrderTime(now);
			accountService.deposit("", account, unit,member.getIntegral(), tx);
			hbDaoSupport.save(orderInfo);
		}
		member.setCreateDate(now);
		member.setUpdateDate(now);
		Member m = hbDaoSupport.save(member);
		if(Dictionary.MEMBER_STATE_NOACTIVATE == member.getStatus()){
			sendActivationCode(m.getId(), m.getPhone());
		}
		return m;
	}
	
	@Override
	public Member externalSaveMember2(Member member) {
		Date now = new Date();
		Account account = accountService.findAccountById(member.getAccount());
		if(member.getIntegral() > 0){
			Transaction tx = accountService.createTransaction("", Business.EXTERNAL_POINT, now);
			String strUnit = Dictionary.UNIT_CODE_BINKE;
			Unit unit = hbDaoSupport.findTByHQL("FROM Unit where unitCode = ?",strUnit);
			OrderInfo orderInfo = new OrderInfo();
			orderInfo.setType(0);
			tx.setBusines(Business.EXTERNAL_POINT);
			orderInfo.setAccount(account);
			orderInfo.setClerkId("");
			orderInfo.setTx(tx);
			String source = "";
			for(Source so : findSources()){
				if(so.getNum().equals(member.getSource())){
					source = so.getName();break;
				}
			}
			orderInfo.setOrderSource(source);
			orderInfo.setOrderNo(tx.getTxId());
			orderInfo.setIntegration(BigDecimal.valueOf(member.getIntegral()));
			orderInfo.setOrderTime(now);
			accountService.deposit("", account, unit,member.getIntegral(), tx);
			hbDaoSupport.save(orderInfo);
		}
		member.setUpdateDate(now);
		hbDaoSupport.update(member);
		String sql = "update Member set password = ?, status = ? where id = ?";
		jdbcDaoSupport.execute(sql, member.getPassword(),member.getStatus(),member.getId());
		if(Dictionary.MEMBER_STATE_NOACTIVATE == member.getStatus()){
			sendActivationCode(member.getId(), member.getPhone());
		}
		return member;
	}
	
	@Override
	public void sendActivationCode(Integer memeberId, String phone) {
		Long l = Math.round(Math.random() * 899999 + 190000);
		String c = "激活码: " + l.toString() ;
		communicationService.queueSMS(null, memeberId.toString(), phone, c, 5,
				null);
		// 修改验证码
		String hql = "UPDATE Member SET valiCode = ? WHERE id = ?";
		hbDaoSupport.executeHQL(hql, l.toString(), memeberId);
	}

	@Override
	public void updateMember(Member member) {
		member.setUpdateDate(new Date());
		member.setUpdateUser(UserContext.getUserName());
		hbDaoSupport.update(member);
	}

	@Override
	public List<Member> findMembers(Member member, Page page) {
		Map<String, Object> map = new HashMap<String, Object>();
		StringBuffer hql = new StringBuffer();
		hql.append("from Member where status <> " + Dictionary.MEMBER_STATE_LOGOUT);
		if (StringUtils.isNotEmpty(member.getName())) {
			hql.append(" and CONCAT(surname,name) like :name");
			// CONCAT(surname,name) like '%罗小美%'
			map.put("name", "%" + member.getName() + "%");
		}
		if (member.getStatus() != null && !"".equals(member.getStatus())) {
			hql.append(" and status = :status");
			map.put("status", member.getStatus());
		}
		if (StringUtils.isNotEmpty(member.getProvince())) {
			hql.append(" and province = :province");
			map.put("province", member.getProvince());
		}
		if (StringUtils.isNotEmpty(member.getCity())) {
			hql.append(" and city = :city");
			map.put("city", member.getCity());
		}
		if (StringUtils.isNotEmpty(member.getArea())) {
			hql.append(" and area = :area");
			map.put("area", member.getArea());
		}
		if (StringUtils.isNotEmpty(member.getPhone())) {
			hql.append(" and phone like :phone");
			map.put("phone", "%" + member.getPhone() + "%");
		}
		if (member.getCard() != null) {
			if (StringUtils.isNotEmpty(member.getCard().getCardNumber())) {
				hql.append(" and card.cardNumber like :cardnumber");
				map.put("cardnumber", "%" + member.getCard().getCardNumber()
						+ "%");
			}
		}
		if (StringUtils.isNotEmpty(member.getEmail())) {
			hql.append(" and email like :email");
			map.put("email", "%" + member.getEmail() + "%");
		}
		if(StringUtils.isNotEmpty(member.getQq())){
			hql.append(" and qq like :qq");
			map.put("qq", "%" + member.getQq() + "%");
		}
		if(StringUtils.isNotEmpty(member.getWeixin())){
			hql.append(" and weixin like :weixin");
			map.put("weixin", "%" + member.getWeixin() + "%");
		}
		hql.append(" order by id desc");
		return hbDaoSupport.findTsByHQLPage(hql.toString(), map, page);
	}

	@Override
	public List<MemberReport> findMembersToReport(Member member, Page page) {
		List<MemberReport> mlist=new ArrayList<MemberReport>();
	
		List<Object> args = new ArrayList<Object>();
		List<Object> argsCount = new ArrayList<Object>();
		StringBuffer sqlCount = new StringBuffer();
		StringBuffer sql = new StringBuffer();
//		sql.append("select  m.`id`,m.`account`,m.`phone`,m.`surname`,m.`name` ,m.`card_id`,m.`address`,m.`createDate`,m.`birthDay`,m.`sex`,m.`email`,mc.cardNumber,"+
//				" m.`province`,m.`city`,m.`area`,m.`status`,m.`source`,sum(o.`orderPrice`) as orderPriceSum   from Member m  "+
//                " left JOIN  `OrderInfo` o     "+
//                 " on  m.`account`=o.`account_accountId` and (o.type=3 or o.type=0 or o.type=4) left join MemberCard mc on m.card_id=mc.id  where m.status <> " + Dictionary.MEMBER_STATE_LOGOUT);
		sql.append("select  m.`id`,m.`account`,m.`phone`,m.`surname`,m.`name` ,m.`card_id`,m.`address`,m.`createDate`,m.`birthDay`,m.`sex`,m.`email`,mc.cardNumber,"+
				" m.`province`,m.`city`,m.`area`,m.`status`,m.`source`,m.orderPriceSum   from Member m  "+
                 "  left join MemberCard mc on m.card_id=mc.id  where m.status <> " + Dictionary.MEMBER_STATE_LOGOUT);
		sqlCount.append("select count(p.id) from (select m.id   from Member m  "+
                  "    where  m.status <> " + Dictionary.MEMBER_STATE_LOGOUT);
		if (StringUtils.isNotEmpty(member.getName())) {
			sql.append(" and CONCAT(m.surname,m.name) like ?");
			sqlCount.append(" and CONCAT(m.surname,m.name) like ?");
			args.add(  "%" +member.getName()+ "%"  );
			argsCount.add("%" +member.getName()+ "%" );
		}
		if (member.getStatus() != null && !"".equals(member.getStatus())) {
			
			sql.append(" and m.status = ?");
			sqlCount.append(" and m.status = ?");
			args.add( member.getStatus());
			argsCount.add(member.getStatus());
		}
		if (StringUtils.isNotEmpty(member.getProvince())) {
			sql.append(" and m.province = ?");
			sqlCount.append(" and m.province = ?");
			args.add( member.getProvince());
			argsCount.add(member.getProvince());
		}
		if (StringUtils.isNotEmpty(member.getCity())) {
			sql.append(" and m.city = ?");
			sqlCount.append(" and m.city = ?");
			args.add( member.getCity());
			argsCount.add(member.getCity());
		}
		if (StringUtils.isNotEmpty(member.getArea())) {
			
			sql.append(" and m.area = ?");
			sqlCount.append(" and m.area = ?");
			args.add( member.getArea());
			argsCount.add(member.getArea());
		}
		if (StringUtils.isNotEmpty(member.getPhone())) {
			
			sql.append(" and m.phone = ?");
			sqlCount.append(" and m.phone = ?");
			args.add( member.getPhone());
			argsCount.add(member.getPhone());
		}
		if (member.getCard() != null) {
			if (StringUtils.isNotEmpty(member.getCard().getCardNumber())) {
				
				sql.append(" and m.card.cardNumber like ?");
				sqlCount.append(" m.card.cardNumber like ?" );
				args.add("%" + member.getCard().getCardNumber()+"%" );
				argsCount.add("%" + member.getCard().getCardNumber()+"%" );
			}
		}
		if (StringUtils.isNotEmpty(member.getEmail())) {
			sql.append(" and m.email like ?");
			sqlCount.append(" and m.email like ?");
			args.add( "%" + member.getEmail() + "%");
			argsCount.add("%" + member.getEmail() + "%");
		}
		
		
		if(member.getCreateStart()!=null){
			sql.append(" and m.createDate  >= ? ");
			sqlCount.append(" and m.createDate >= ? ");
			args.add( member.getCreateStart());
			argsCount.add( member.getCreateStart());
		}
		if(member.getCreateEnd()!=null){
			sql.append(" and m.createDate <=? ");
			sqlCount.append(" and m.createDate <= ? ");
			args.add( member.getCreateEnd());
			argsCount.add( member.getCreateEnd());
		}
		int year=DateTools.getYear();
		
		if(member.getAgeStart()!=null&&member.getAgeEnd()==null){
			
				sql.append(" and (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(m.birthday)), '%Y')+0) >=? ");
				sqlCount.append(" and (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(m.birthday)), '%Y')+0)  >= ? ");
				args.add( member.getAgeStart());
				argsCount.add(member.getAgeStart());
			
		}
		
		if(member.getAgeEnd()!= null&&member.getAgeStart()==null ){
				sql.append(" and (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(m.birthday)), '%Y')+0)  <= ? ");
				sqlCount.append(" and (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(m.birthday)), '%Y')+0)  <=  ? ");
				args.add( member.getAgeEnd());
				argsCount.add(member.getAgeEnd());
		}
		if(member.getAgeStart()!=null&&member.getAgeEnd()!=null&& member.getAgeStart()<member.getAgeEnd()){
				sql.append(" and (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(m.birthday)), '%Y')+0)  between ? and  ? ");
				sqlCount.append(" and (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(m.birthday)), '%Y')+0)  between ? and  ? ");
				args.add( member.getAgeStart());
				argsCount.add(member.getAgeStart());
				args.add( member.getAgeEnd());
				argsCount.add(member.getAgeEnd());
		}
		logger.trace("member.getSource()====="+member.getSource());
		if(StringUtils.isNotEmpty(member.getSource())&&!"0".equals(member.getSource())){
			sql.append(" and m.source =?");
			sqlCount.append(" and m.source =?");
			args.add( member.getSource());
			argsCount.add(member.getSource());
		}
		
		
		if(member.getSex()!=null&&member.getSex()!=0){
			sql.append(" and m.sex =?");
			sqlCount.append(" and m.sex =?");
			args.add( member.getSex());
			argsCount.add(member.getSex());
		}
		
		
	//	sql.append(" group by m.`id` ");
	//	sqlCount.append("  group by m.`id`  ");
	
        if(member.getExpenseStart()!=null||member.getExpenseEnd()!=null){
//        	 sql.append("  having  ");
//        	 sqlCount.append(" having ");
        	 
    		 if(member.getExpenseStart()!=null){
    			// sql.append(" sum(o.`orderPrice`)>=?  ");
    			 sql.append(" and m.orderPriceSum>=?  ");
    			 args.add(member.getExpenseStart());
    			
    			 sqlCount.append(" and  m.orderPriceSum>=?  ");
    			 argsCount.add(member.getExpenseStart());
    		 }
    		
    		 if(member.getExpenseEnd()!=null){
    			 sql.append(" and m.orderPriceSum<=?  ");
    			 args.add(member.getExpenseEnd());
    			 
    			 sqlCount.append(" and m.orderPriceSum<=?  ");
       			 argsCount.add(member.getExpenseEnd());
    		 }
    		 if(member.getExpenseEnd()!=null&&member.getExpenseStart()==null){
    			 sql.append(" or      m.orderPriceSum is null ");
    			 sqlCount.append(" or      m.orderPriceSum is null  ");
    		 }
    	
		}
		
        sqlCount.append(" )p");
		sql.append("  order by m.createDate desc");
		sql.append("   LIMIT ?,?");
		args.add(page.getStart());
		args.add(page.getRows());
		logger.trace(sqlCount.toString());
		 if(argsCount.size()>0){
				page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString(),argsCount.toArray()));
			}else{
				page.setTotalRows(jdbcDaoSupport.findCount(sqlCount.toString()));
			}
	
		logger.trace(sql);
		RowMapper rowMapper = getRowMemberMapper();
		mlist = jdbcDaoSupport.findTsBySQL(rowMapper, sql.toString(),args.toArray());

		
      return mlist;
	}
	
	
	private RowMapper getRowMemberMapper() {
		RowMapper rowMapper = new RowMapper<MemberReport>() {
			@Override
			public MemberReport mapRow(ResultSet rs, int arg1)
					throws SQLException {
				MemberReport report = new MemberReport();
				report.setId(rs.getInt("id"));
				report.setAccount(rs.getString("account"));
				report.setPhone(rs.getString("phone"));
				report.setSurname(rs.getString("surname"));
				report.setName(rs.getString("name"));
				report.setCardNumber(rs.getString("cardNumber"));
				report.setAddress(rs.getString("address"));
				report.setCreateDate(rs.getDate("createDate"));
				report.setBirthDay(rs.getDate("birthDay"));
				report.setSex(rs.getInt("sex"));
				report.setEmail(rs.getString("email"));
				report.setProvince(rs.getString("province"));
				report.setCity(rs.getString("city"));
				report.setArea(rs.getString("area"));
				report.setStatus(rs.getInt("status"));
				report.setSource(rs.getString("source"));
				report.setOrderPriceSum(rs.getBigDecimal("orderPriceSum"));
				
				return report;
			}
		};
		return rowMapper;
	}
	@Override
	public Member findMemberById(Integer id) {
		return hbDaoSupport.findTById(Member.class, id);
	}

	@Override
	public void updateStatus(String ids, Integer statusCode) {
		String hql = "update Member set status = :status where id = :ids";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", statusCode);
		map.put("ids", Integer.parseInt(ids));
		hbDaoSupport.executeHQL(hql, map);
		if(statusCode == Dictionary.MEMBER_STATE_ACTIVATE){
			Member m = hbDaoSupport.findTById(Member.class, Integer.parseInt(ids));
			if(StringUtils.isEmpty(m.getPassword())){
				Long l = Math.round(Math.random() * 899999 + 190000);
				String c = "初始密码: " +  l.toString() ;
				communicationService.queueSMS(null, m.getId().toString(), m.getPhone(), c, 5,null);
				String hql1 = "UPDATE Member SET password = ? WHERE id = ?";
				hbDaoSupport.executeHQL(hql1, MD5.MD5Encoder(l.toString()), m.getId());
				updateActivePhone(Integer.parseInt(ids),m.getPhone());
			}
		}
	}

	@Override
	public void delMember(String ids) {
		String hql = "update Member set status = :status where id in(:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", Dictionary.MEMBER_STATE_LOGOUT);
		map.put("ids", CommonUtil.getIntegers(ids));
		for(Integer id : CommonUtil.getIntegers(ids)){
			Member m = findMemberById(id);
			m.setPhone(m.getPhone()+"_"+id);
			saveMember(m);
		}
		hbDaoSupport.executeHQL(hql, map);
	}
	
	@Override
	public void resetPassword(String ids) {
		String hql = "update Member set password = :password where id in(:id)";
		Map<String, Object> map = new HashMap<String, Object>();
		Long l = Math.round(Math.random() * 899999 + 190000);
		map.put("password", MD5.MD5Encoder(l.toString()));
		map.put("id", CommonUtil.getIntegers(ids));
		hbDaoSupport.executeHQL(hql, map);
		//重置密码发送短信
		Member m = hbDaoSupport.findTById(Member.class, Integer.parseInt(ids));
		String c = "您的会员密码已经被成功重置为： " + l;
		communicationService.queueSMS(null, m.getId().toString(), m.getPhone(), c, 5,null);
	}

	@Override
	public Member findMemberByPhone(String phone) {
		String hql = "from Member where phone = ? and status <> ?";
		return hbDaoSupport.findTByHQL(hql, phone,
				Dictionary.MEMBER_STATE_LOGOUT);
	}

	@Override
	public List<MemberDiscountNumberVo> searchDiscountNumberRecords(
			DiscountNumberRecordCriteria criteria) {

		List<Object> args1 = new ArrayList<Object>();
		List<Object> args2 = new ArrayList<Object>();
		String sql = buildSearchDiscountNumberRecordsHQL(criteria, args1,
				args2, false);
		args1.addAll(args2);
		List<Map<String, Object>> list = jdbcDaoSupport.getJdbcTemplate().queryForList(sql,
				args1.toArray());
		List<MemberDiscountNumberVo> vos = new ArrayList<MemberDiscountNumberVo>();
		Iterator<Map<String, Object>> it = list.iterator();
		while (it.hasNext()) {
			Map<String, Object> result = (Map<String, Object>) it.next();
			int id = (Integer) result.get("id");
			Date generatedDate = (Date) result.get("generatedDate");
			Date expiredDate = (Date) result.get("expiredDate");
			String discountNum = (String) result.get("discountNum");
			String content = (String) result.get("content");
			Integer status = (Integer) result.get("status");
			Integer shop_id = (Integer)result.get("shop_id");
			Integer activityInfo_id = (Integer)result.get("activityInfo_id");
			Shop shop = null;
			ActivityInfo activityInfo = null;
			if(null != shop_id){
				shop = hbDaoSupport.findTById(Shop.class, shop_id);
			}
			if(null != activityInfo_id){
				activityInfo = hbDaoSupport.findTById(ActivityInfo.class, activityInfo_id);
			}
			int type = ((Long) result.get("type")).intValue();
			MemberDiscountNumberVo vo = new MemberDiscountNumberVo(id,
					generatedDate, expiredDate, discountNum, content, shop, activityInfo,
					status, type);
			vos.add(vo);
		}
		return vos;
	}

	@Override
	public Long countDiscountNumberRecords(DiscountNumberRecordCriteria criteria) {

		List<Object> args1 = new ArrayList<Object>();
		List<Object> args2 = new ArrayList<Object>();
		String sql = buildSearchDiscountNumberRecordsHQL(criteria, args1,
				args2, true);
		args1.addAll(args2);
		Integer count = jdbcDaoSupport.findCount(sql, args1.toArray());
		return count.longValue();
	}

	@Override
	public List<MemberSMSOutboxHistoryVo> searchMemberSMSOutboxHistory(
			MemberSMSOutboxHistoryCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchMemberSMSOutboxHistoryHQL(criteria, params,
				false);
		List<MemberSMSOutboxHistoryVo> list = hbDaoSupport.executeQuery(hql,
				params, criteria.getPaginationDetail());
		return list;
	}

	@Override
	public Long countMemberSMSOutboxHistory(
			MemberSMSOutboxHistoryCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchMemberSMSOutboxHistoryHQL(criteria, params,
				true);

		List<Long> list = hbDaoSupport.executeQuery(hql, params, null);
		if (null != list && list.size() > 0 && null != list.get(0)) {
			return list.get(0);
		}
		return 0l;
	}

	@Override
	public List<MemberSMSOutboxHistoryVo> searchMemberSMSOutboxWait(
			MemberSMSOutboxHistoryCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchMemberSMSOutboxWaitHQL(criteria, params, false);
		List<MemberSMSOutboxHistoryVo> list = hbDaoSupport.executeQuery(hql,
				params, criteria.getPaginationDetail());
		return list;
	}

	@Override
	public Long countMemberSMSOutboxWait(MemberSMSOutboxHistoryCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchMemberSMSOutboxWaitHQL(criteria, params, true);

		List<Long> list = hbDaoSupport.executeQuery(hql, params, null);
		if (null != list && list.size() > 0 && null != list.get(0)) {
			return list.get(0);
		}
		return 0l;
	}

	@Override
	public List<MemberBrandVo> searchAttendBrands(MemberAttendCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchAttendBrandsHQL(criteria, params, false);
		List<MemberBrandVo> list = hbDaoSupport.executeQuery(hql, params,
				criteria.getPaginationDetail());
		return list;
	}

	@Override
	public Long countAttendBrands(MemberAttendCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchAttendBrandsHQL(criteria, params, true);

		List<Long> list = hbDaoSupport.executeQuery(hql, params, null);
		if (null != list && list.size() > 0 && null != list.get(0)) {
			return list.get(0);
		}
		return 0l;
	}

	protected String buildSearchAttendBrandsHQL(MemberAttendCriteria criteria,
			Map<String, Object> params, boolean isCount) {

		Member member = hbDaoSupport.findTById(Member.class, criteria.getId());
		StringBuffer hql = new StringBuffer();
		if (isCount) {
			hql.append("SELECT COUNT(bu) FROM BrandUnionMember bu INNER JOIN bu.brand b WHERE ");
		} else {
			hql.append("SELECT new com.chinarewards.metro.model.member.MemberBrandVo(b.name as brandName, bu.joinedDate as joinedDate) FROM BrandUnionMember bu INNER JOIN bu.brand b WHERE ");
		}
		if (null != member) {
			hql.append(" bu.member=:member");
			params.put("member", member);

			// TODO
		} else {
			hql.append(" 1=0 ");
		}
		hql.append(" ORDER BY bu.joinedDate DESC");
		return hql.toString();
	}

	protected String buildSearchMemberSMSOutboxHistoryHQL(
			MemberSMSOutboxHistoryCriteria criteria,
			Map<String, Object> params, boolean isCount) {

		Member member = hbDaoSupport.findTById(Member.class, criteria.getId());
		StringBuffer hql = new StringBuffer();
		if (isCount) {
			hql.append("SELECT COUNT(s) FROM SMSOutboxHistory s WHERE ");
		} else {
			hql.append("SELECT new com.chinarewards.metro.model.member.MemberSMSOutboxHistoryVo(s.destination as phoneNumber, s.content as content, s.sentDate as sentDate, s.status as status) FROM SMSOutboxHistory s WHERE ");
		}
		if (null != member) {
			hql.append(" s.destId=:id");
			params.put("id", String.valueOf(criteria.getId()));

			SMSSendStatus status = criteria.getStatus();
			Date sentDateStart = criteria.getSentDateStart();
			Date sentDateEnd = criteria.getSentDateEnd();

			if (null != status && status.equals(SMSSendStatus.QUEUED)) {
				hql.append(" AND 1=0 ");
			} else if (null != status) {
				hql.append(" AND s.status=:status");
				params.put("status", status);
			} else {
				hql.append(" AND (s.status=:status1 OR s.status=:status2)");
				params.put("status1", SMSSendStatus.SENT);
				params.put("status2", SMSSendStatus.ERROR);
			}
			if (null != sentDateEnd) {
				sentDateEnd = DateTools.getDateLastSecond(sentDateEnd);
				hql.append(" AND s.sentDate <=:sentDateEnd");
				params.put("sentDateEnd", sentDateEnd);
			}
			if (null != sentDateStart) {
				hql.append(" AND s.sentDate >=:sentDateStart");
				params.put("sentDateStart", sentDateStart);
			}
			// TODO
		} else {
			hql.append(" 1=0 ");
		}
		hql.append(" ORDER BY s.sentDate DESC");
		return hql.toString();
	}

	protected String buildSearchMemberSMSOutboxWaitHQL(
			MemberSMSOutboxHistoryCriteria criteria,
			Map<String, Object> params, boolean isCount) {

		Member member = hbDaoSupport.findTById(Member.class, criteria.getId());
		StringBuffer hql = new StringBuffer();
		if (isCount) {
			hql.append("SELECT COUNT(s) FROM SMSOutboxHistory s WHERE ");
		} else {
			hql.append("SELECT new com.chinarewards.metro.model.member.MemberSMSOutboxHistoryVo(s.destination as phoneNumber, s.content as content, s.sentDate as sentDate, s.status as status) FROM SMSOutbox s WHERE ");
		}
		if (null != member) {
			hql.append(" s.destId=:id");
			params.put("id", String.valueOf(criteria.getId()));

			SMSSendStatus status = criteria.getStatus();
			Date sentDateStart = criteria.getSentDateStart();
			Date sentDateEnd = criteria.getSentDateEnd();

			if (null != status && !status.equals(SMSSendStatus.QUEUED)) {
				hql.append(" AND 1=0 ");
			} else { // 只查询等待状态的短信记录
				hql.append(" AND s.status=:status");
				params.put("status", SMSSendStatus.QUEUED);
				if (null != sentDateEnd) {
					sentDateEnd = DateTools.getDateLastSecond(sentDateEnd);
					hql.append(" AND s.sentDate <=:sentDateEnd");
					params.put("sentDateEnd", sentDateEnd);
				}
				if (null != sentDateStart) {
					hql.append(" AND s.sentDate >=:sentDateStart");
					params.put("sentDateStart", sentDateStart);
				}
			}
			// TODO
		} else {
			hql.append(" 1=0 ");
		}
		hql.append(" ORDER BY s.sentDate DESC");
		return hql.toString();
	}

	protected String buildSearchDiscountNumberRecordsHQL(
			DiscountNumberRecordCriteria criteria, List<Object> args1,List<Object> args2,
			boolean isCount) {
		
		Integer id = criteria.getId();
		Member member = hbDaoSupport.findTById(Member.class, id);
		
		StringBuffer sql = new StringBuffer();
		StringBuffer sql1 = new StringBuffer();
		StringBuffer sql2 = new StringBuffer();
		
		if (isCount) {
			sql1.append("SELECT d1.id as id FROM DiscountNumber d1 WHERE ");
			sql2.append("SELECT d2.id as id FROM  DiscountNumberHistory d2 WHERE ");
		} else {// TODO 优惠码来源还没做 XXX
			sql1.append("SELECT d1.id as id, d1.generatedDate as generatedDate, d1.expiredDate as expiredDate, d1.discountNum as discountNum, d1.descr as content, d1.shop_id as shop_id, d1.activityInfo_id as activityInfo_id, d1.state as status, 0 as type FROM DiscountNumber d1 WHERE ");
			sql2.append("SELECT d2.id as id, d2.usedDate as generatedDate, d2.expiredDate as expiredDate, d2.discountNum as discountNum, d2.description as content, d2.shop_id as shop_id, d2.activityInfo_id as activityInfo_id, d2.status as status, 1 as type FROM DiscountNumberHistory d2 WHERE ");
		}
		if (null != member) {
			sql1.append(" d1.member_id=?");
			sql2.append(" d2.member_id=?");
			args1.add(id);
			args2.add(id);

			String discountNum = criteria.getDiscountNum();
			Integer discountNumStatus = criteria.getDiscountNumStatus();
			Date transactionDateStart = criteria.getTransactionDateStart();
			Date transactionDateEnd = criteria.getTransactionDateEnd();

			if (null != discountNum && !discountNum.isEmpty()) {
				sql1.append(" AND d1.discountNum LIKE ?");
				sql2.append(" AND d2.discountNum LIKE ?");
				args1.add("%"+discountNum+"%");
				args2.add("%"+discountNum+"%");
			}
			if (null != transactionDateEnd) {
				transactionDateEnd = DateTools
						.getDateLastSecond(transactionDateEnd);
				sql1.append(" AND d1.generatedDate <= ? ");
				sql2.append(" AND ( (d2.usedDate IS NOT null AND d2.usedDate <= ?) OR ( d2.expiredDate <= ?))");
				args1.add(transactionDateEnd);
				args2.add(transactionDateEnd);
				args2.add(transactionDateEnd);
			}
			if (null != transactionDateStart) { // 交易时间，如果使用时间为null，
												// 则取优惠码生成时间，反之则取优惠码使用时间
				sql1.append(" AND d1.generatedDate >= ? ");
				sql2.append(" AND ( (d2.usedDate IS NOT null AND d2.usedDate > ?) OR ( d2.expiredDate >= ?))");
				args1.add(transactionDateStart);
				args2.add(transactionDateStart);
				args2.add(transactionDateStart);
			}

			if (null != discountNumStatus) {
				if(discountNumStatus.equals(Dictionary.MEMBER_DISCOUNT_NUMBER_NOT_USED)){
					sql1.append(" AND d1.state=?");
					sql2.append(" AND 1=0");
					args1.add(1);
				}else if(discountNumStatus.equals(Dictionary.MEMBER_DISCOUNT_NUMBER_USED)){
					sql1.append(" AND 1=0");
					sql2.append(" AND d2.status=?");
					args2.add(1);
				}else if(discountNumStatus.equals(Dictionary.MEMBER_DISCOUNT_NUMBER_EXPIRED)){
					sql1.append(" AND d1.state=?");
					sql2.append(" AND d2.status=?");
					args1.add(0);
					args2.add(0);
				}
			}
			
			// TODO
		} else {
			sql1.append(" 1=0 ");
			sql2.append(" 1=0 ");
		}
		if(isCount){
			sql.append("SELECT COUNT(d.id) FROM ("+sql1.toString()+" UNION ALL "+sql2.toString()+") d ");
		}else{
			Page page = criteria.getPaginationDetail();
			sql.append(sql1.toString()+" UNION ALL "+sql2.toString()+" ORDER BY generatedDate DESC LIMIT "+(page.getStart())+","+(page.getRows()));
		}
		return sql.toString();
	}

	@Override
	public List<OrderInfo> searchIntegralGetRecords(
			IntegralRecordCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchIntegralGetRecordsHQL(criteria, params, false);
		List<OrderInfo> list = hbDaoSupport.executeQuery(hql, params,
				criteria.getPaginationDetail());
		return list;
	}

	@Override
	public Long countIntegralGetRecords(IntegralRecordCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchIntegralGetRecordsHQL(criteria, params, true);
		List<Long> list = hbDaoSupport.executeQuery(hql, params, null);
		if (null != list && list.size() > 0 && null != list.get(0)) {
			return list.get(0);
		}
		return 0l;
	}

	protected String buildSearchIntegralGetRecordsHQL(
			IntegralRecordCriteria criteria, Map<String, Object> params,
			boolean isCount) {

		Member member = hbDaoSupport.findTById(Member.class, criteria.getId());
		StringBuffer hql = new StringBuffer();
		if (isCount) {
			hql.append("SELECT COUNT(oi) FROM OrderInfo oi WHERE 1=1 ");
		} else {
			hql.append("FROM OrderInfo oi WHERE 1=1");
		}
		// else {
		// hql.append("SELECT new com.chinarewards.metro.model.member.IntegralGetRecordVo(oi.orderNo as orderNo, oi.orderTime as orderTime, oi.shop as shop, oi.tx as tx, oi.orderPrice as orderPrice, oi.merchandise as merchandise, oi.redemptionQuantity as giftCount, oi.orderSource as orderSource, oi.beforeUnits as beforeUnits, oi.integration as integration, oi.matchedRules as matchedRules) FROM OrderInfo oi WHERE 1=1");
		// }
		if (null != member) {
			Account account = accountService.findAccountByMember(member);
			hql.append(" AND oi.account=:account");
			params.put("account", account);

			String businiessNo = criteria.getBusiniessNo();
			Date transactionDateStart = criteria.getTransactionDateStart();
			Date transactionDateEnd = criteria.getTransactionDateEnd();

			if (null != businiessNo && !businiessNo.isEmpty()) {
				hql.append(" AND oi.tx.txId LIKE :orderNo");
				params.put("orderNo", "%" + businiessNo + "%");
			}
			if (null != transactionDateEnd) {
				transactionDateEnd = DateTools
						.getDateLastSecond(transactionDateEnd);
				hql.append(" AND oi.tx.transactionDate <= :transactionDateEnd");
				params.put("transactionDateEnd", transactionDateEnd);
			}
			if (null != transactionDateStart) {
				hql.append(" AND oi.tx.transactionDate >= :transactionDateStart");
				params.put("transactionDateStart", transactionDateStart);
			}

			hql.append(" AND (oi.type=0 OR oi.type=4)  ORDER BY oi.orderTime DESC");
			// TODO
		} else {
			hql.append(" AND 1=0 ");
		}

		return hql.toString();
	}

	@Override
	public List<OrderInfo> searchIntegralUseRecords(
			IntegralRecordCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchIntegralUseRecordsHQL(criteria, params, false);
		List<OrderInfo> list = hbDaoSupport.executeQuery(hql, params,
				criteria.getPaginationDetail());
		return list;
	}

	@Override
	public Long countIntegralUseRecords(IntegralRecordCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchIntegralUseRecordsHQL(criteria, params, true);
		List<Long> list = hbDaoSupport.executeQuery(hql, params, null);
		if (null != list && list.size() > 0 && null != list.get(0)) {
			return list.get(0);
		}
		return 0l;
	}

	protected String buildSearchIntegralUseRecordsHQL(
			IntegralRecordCriteria criteria, Map<String, Object> params,
			boolean isCount) {

		Member member = hbDaoSupport.findTById(Member.class, criteria.getId());
		StringBuffer hql = new StringBuffer();
		if (isCount) {
			hql.append("SELECT COUNT(oi) FROM OrderInfo oi WHERE 1=1 ");
		} else {
			hql.append("FROM OrderInfo oi WHERE 1=1");
		}
		// else {
		// hql.append("SELECT new com.chinarewards.metro.model.member.IntegralGetRecordVo(oi.orderNo as orderNo, oi.orderTime as orderTime, oi.shop as shop, oi.tx as tx, oi.orderPrice as orderPrice, oi.merchandise as merchandise, oi.redemptionQuantity as giftCount, oi.orderSource as orderSource, oi.beforeUnits as beforeUnits, oi.integration as integration, oi.matchedRules as matchedRules) FROM OrderInfo oi WHERE 1=1");
		// }
		if (null != member) {
			Account account = accountService.findAccountByMember(member);
			hql.append(" AND oi.account=:account");
			params.put("account", account);

			String businiessNo = criteria.getBusiniessNo();
			Date transactionDateStart = criteria.getTransactionDateStart();
			Date transactionDateEnd = criteria.getTransactionDateEnd();

			if (null != businiessNo && !businiessNo.isEmpty()) {
				hql.append(" AND oi.tx.txId LIKE :orderNo");
				params.put("orderNo", "%" + businiessNo + "%");
			}
			if (null != transactionDateEnd) {
				transactionDateEnd = DateTools
						.getDateLastSecond(transactionDateEnd);
				hql.append(" AND oi.tx.transactionDate <= :transactionDateEnd");
				params.put("transactionDateEnd", transactionDateEnd);
			}
			if (null != transactionDateStart) {
				hql.append(" AND oi.tx.transactionDate >= :transactionDateStart");
				params.put("transactionDateStart", transactionDateStart);
			}

			hql.append(" AND (oi.type=1 OR oi.type=4)  ORDER BY oi.orderTime DESC");
			// TODO
		} else {
			hql.append(" AND 1=0 ");
		}

		return hql.toString();
	}

	@Override
	public List<OrderInfo> searchSavingsAccountGetRecords(
			SavingsAccountRecordCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchSavingsAccountGetRecordsHQL(criteria, params,
				false);
		List<OrderInfo> list = hbDaoSupport.executeQuery(hql, params,
				criteria.getPaginationDetail());
		return list;
	}

	@Override
	public Long countSavingsAccountGetRecords(
			SavingsAccountRecordCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchSavingsAccountGetRecordsHQL(criteria, params,
				true);
		List<Long> list = hbDaoSupport.executeQuery(hql, params, null);
		if (null != list && list.size() > 0 && null != list.get(0)) {
			return list.get(0);
		}
		return 0l;
	}

	protected String buildSearchSavingsAccountGetRecordsHQL(
			SavingsAccountRecordCriteria criteria, Map<String, Object> params,
			boolean isCount) {

		Member member = hbDaoSupport.findTById(Member.class, criteria.getId());
		StringBuffer hql = new StringBuffer();
		if (isCount) {
			hql.append("SELECT COUNT(oi) FROM OrderInfo oi WHERE 1=1 ");
		} else {
			hql.append("FROM OrderInfo oi WHERE 1=1");
		}
		// else {
		// hql.append("SELECT new com.chinarewards.metro.model.member.IntegralGetRecordVo(oi.orderNo as orderNo, oi.orderTime as orderTime, oi.shop as shop, oi.tx as tx, oi.orderPrice as orderPrice, oi.merchandise as merchandise, oi.redemptionQuantity as giftCount, oi.orderSource as orderSource, oi.beforeUnits as beforeUnits, oi.integration as integration, oi.matchedRules as matchedRules) FROM OrderInfo oi WHERE 1=1");
		// }
		if (null != member) {
			Account account = accountService.findAccountByMember(member);
			hql.append(" AND oi.account=:account");
			params.put("account", account);

			String businiessNo = criteria.getBusiniessNo();
			Date transactionDateStart = criteria.getTransactionDateStart();
			Date transactionDateEnd = criteria.getTransactionDateEnd();

			if (null != businiessNo && !businiessNo.isEmpty()) {
				hql.append(" AND oi.tx.txId LIKE :orderNo");
				params.put("orderNo", "%" + businiessNo + "%");
			}
			if (null != transactionDateEnd) {
				transactionDateEnd = DateTools
						.getDateLastSecond(transactionDateEnd);
				hql.append(" AND oi.tx.transactionDate <= :transactionDateEnd");
				params.put("transactionDateEnd", transactionDateEnd);
			}
			if (null != transactionDateStart) {
				hql.append(" AND oi.tx.transactionDate >= :transactionDateStart");
				params.put("transactionDateStart", transactionDateStart);
			}

			hql.append(" AND oi.type=2  ORDER BY oi.orderTime DESC");
			// TODO
		} else {
			hql.append(" AND 1=0 ");
		}

		return hql.toString();
	}

	@Override
	public List<OrderInfo> searchSavingsAccountUseRecords(
			SavingsAccountRecordCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchSavingsAccountUseRecordsHQL(criteria, params,
				false);
		List<OrderInfo> list = hbDaoSupport.executeQuery(hql, params,
				criteria.getPaginationDetail());
		return list;
	}

	@Override
	public Long countSavingsAccountUseRecords(
			SavingsAccountRecordCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchSavingsAccountUseRecordsHQL(criteria, params,
				true);
		List<Long> list = hbDaoSupport.executeQuery(hql, params, null);
		if (null != list && list.size() > 0 && null != list.get(0)) {
			return list.get(0);
		}
		return 0l;
	}

	protected String buildSearchSavingsAccountUseRecordsHQL(
			SavingsAccountRecordCriteria criteria, Map<String, Object> params,
			boolean isCount) {

		Member member = hbDaoSupport.findTById(Member.class, criteria.getId());
		StringBuffer hql = new StringBuffer();
		if (isCount) {
			hql.append("SELECT COUNT(oi) FROM OrderInfo oi WHERE 1=1 ");
		} else {
			hql.append("FROM OrderInfo oi WHERE 1=1");
		}
		// else {
		// hql.append("SELECT new com.chinarewards.metro.model.member.IntegralGetRecordVo(oi.orderNo as orderNo, oi.orderTime as orderTime, oi.shop as shop, oi.tx as tx, oi.orderPrice as orderPrice, oi.merchandise as merchandise, oi.redemptionQuantity as giftCount, oi.orderSource as orderSource, oi.beforeUnits as beforeUnits, oi.integration as integration, oi.matchedRules as matchedRules) FROM OrderInfo oi WHERE 1=1");
		// }
		if (null != member) {
			Account account = accountService.findAccountByMember(member);
			hql.append(" AND oi.account=:account");
			params.put("account", account);

			String businiessNo = criteria.getBusiniessNo();
			Date transactionDateStart = criteria.getTransactionDateStart();
			Date transactionDateEnd = criteria.getTransactionDateEnd();

			if (null != businiessNo && !businiessNo.isEmpty()) {
				hql.append(" AND oi.tx.txId LIKE :orderNo");
				params.put("orderNo", "%" + businiessNo + "%");
			}
			if (null != transactionDateEnd) {
				transactionDateEnd = DateTools
						.getDateLastSecond(transactionDateEnd);
				hql.append(" AND oi.tx.transactionDate <= :transactionDateEnd");
				params.put("transactionDateEnd", transactionDateEnd);
			}
			if (null != transactionDateStart) {
				hql.append(" AND oi.tx.transactionDate >= :transactionDateStart");
				params.put("transactionDateStart", transactionDateStart);
			}

			hql.append(" AND oi.type=3  ORDER BY oi.orderTime DESC");
			// TODO
		} else {
			hql.append(" AND 1=0 ");
		}

		return hql.toString();
	}

	@Override
	public List<MemberExpiredIntegralVo> findExpiredIntegralsByMember(
			Member member, Date fromDate, Date toDate, String unitCodeBinke,
			Page page) {

		StringBuffer listBuf = new StringBuffer();
		StringBuffer countBuf = new StringBuffer();
		Map<String, Object> params = new HashMap<String, Object>();

		listBuf.append("SELECT new com.chinarewards.metro.model.member.MemberExpiredIntegralVo(a.tx.txId as gainTxId, p.tx.txId as expiredTxId, p.tx.transactionDate as expiredDate, a.units "
				+ "as units) FROM PointExpiredQueue p INNER JOIN p.accBalanceUnits a WHERE p.status = :status AND a.accountBalance.account = :account AND a.unit.unitCode = :unitCode AND a.expired = :expired");
		countBuf.append("SELECT COUNT(p.id) "
				+ " FROM PointExpiredQueue p INNER JOIN p.accBalanceUnits a WHERE p.status = :status AND a.accountBalance.account = :account AND a.unit.unitCode = :unitCode AND a.expired = :expired");

		Account account = accountService.findAccountByMember(member);
		params.put("status", QueueStatus.doned);
		params.put("account", account);
		params.put("unitCode", unitCodeBinke);
		params.put("expired", true);
		if (null != fromDate) {
			params.put("fromDate", fromDate);
			listBuf.append(" AND p.tx.transactionDate >=:fromDate");
			countBuf.append(" AND p.tx.transactionDate >=:fromDate");
		}
		if (null != toDate) {
			toDate = DateTools.getDateLastSecond(toDate);
			params.put("toDate", toDate);
			listBuf.append(" AND p.tx.transactionDate <=:toDate");
			countBuf.append(" AND p.tx.transactionDate <=:toDate");
		}
		listBuf.append(" ORDER BY p.tx.transactionDate DESC, p.tx.txId ASC");
		List<MemberExpiredIntegralVo> list = hbDaoSupport.executeQuery(
				listBuf.toString(), params, page);
		List<Long> countList = hbDaoSupport.executeQuery(countBuf.toString(),
				params, null);
		if (null != countList && countList.size() > 0
				&& null != countList.get(0)) {
			page.setTotalRows(countList.get(0).intValue());
		} else {
			page.setTotalRows(0);
		}
		return list;
	}

	@Override
	public Member findMemberByAccountId(String accountId) {
		String hql = "FROM Member WHERE account = ?";
		return hbDaoSupport.findTByHQL(hql, accountId);
	}

	@Override
	public Member findMemberByCardNo(String cardNo) {
		String hql = "FROM Member m WHERE m.card.cardNumber = ?";
		return hbDaoSupport.findTByHQL(hql, cardNo);
	}

	@Override
	public void saveAccountPay(AccountrPay accountPay) {
		Date d = new Date();
		Transaction tx = accountService.createTransaction(accountPay.getMemberName(), Business.HAND_POINT, d);
		Member member = findMemberById(accountPay.getMemberId());
		Account account = accountService.findAccountById(member.getAccount());
		String strUnit = Dictionary.UNIT_CODE_BINKE;
		if (Dictionary.SUFFICIENT_TYPE_STORED == accountPay.getPayType()) {
			strUnit = Dictionary.UNIT_CODE_RMB;
		}
		Unit unit = hbDaoSupport.findTByHQL("FROM Unit where unitCode = ?",strUnit);
		accountPay.setCreateUser(UserContext.getUserId());
		accountPay.setTransaction(d);
		
		OrderInfo orderInfo = new OrderInfo();
		if (Dictionary.SUFFICIENT_TYPE_STORED == accountPay.getPayType()) { //交易类型
			double a = accountService.getAccountBalance(account, Dictionary.UNIT_CODE_RMB);
			orderInfo.setType(2);
			orderInfo.setBeforeCash(BigDecimal.valueOf(a));
			tx.setBusines(Business.HAND_MONEY);
		}else{
			double a = accountService.getAccountBalance(account, Dictionary.UNIT_CODE_BINKE);
			orderInfo.setType(0);
			orderInfo.setBeforeUnits(BigDecimal.valueOf(a));
			tx.setBusines(Business.HAND_POINT);
		}
		orderInfo.setAccount(account);
		orderInfo.setClerkId(UserContext.getUserId().toString());
		orderInfo.setTx(tx);
		orderInfo.setOrderSource("会员账户充值");
		orderInfo.setOrderNo(tx.getTxId());
		orderInfo.setIntegration(BigDecimal.valueOf(accountPay.getMoney()));
		orderInfo.setOrderTime(d);
		orderInfo.setChargeDesc(accountPay.getNote());
		hbDaoSupport.save(accountPay);
		accountService.deposit(accountPay.getMemberName(), account, unit,accountPay.getMoney(), tx);
		hbDaoSupport.save(orderInfo);
	}

	@Override
	public MemberModifyRes updateMemberForClient(MemberModifyReq memberModifyReq) {

		Integer id = memberModifyReq.getId();
		String phone = memberModifyReq.getPhone();
		String mail = memberModifyReq.getMail();
		String alivePhoneNumber = memberModifyReq.getAlivePhoneNumber();
		Date birthday = memberModifyReq.getBirthday();
		Integer memberStatus = memberModifyReq.getMemberStatus();

		MemberModifyRes memberModifyRes = new MemberModifyRes();
		memberModifyRes.setUpdateStatus(2);
		Member member = hbDaoSupport.findTById(Member.class, id);
		String name = null;
		if(null == member){
			name = phone;
		}else {
			String surName = (member.getSurname()==null)?"":member.getSurname();
			String Name = (member.getName()==null)?"":member.getName();
			name = surName + Name;
			if("".equals(name)) 
				name = member.getPhone();
		}
		try {
				if (null == member) {// ID对应的member不存在，修改失败
					memberModifyRes.setFailureReasons("会员id不存在");
				} else {
					memberModifyRes
							.setAlivePhoneNumber(member.getActivePhone());
					memberModifyRes.setBirthday(member.getBirthDay());
					memberModifyRes.setMail(member.getEmail());
					memberModifyRes.setMemberStatus(member.getStatus());
					memberModifyRes.setPhone(member.getPhone());
					memberModifyRes.setRegisterDate(member.getCreateDate());
					memberModifyRes.setId(id);

					Member member2 = findMemberByPhone(phone);
					if (member.getStatus().equals(
							Dictionary.MEMBER_STATE_LOGOUT)) {
						memberModifyRes.setFailureReasons("该会员已注销，不能进行操作");
					} else if (member.getStatus().equals(
							Dictionary.MEMBER_STATE_ACTIVATE)
							&& memberStatus
									.equals(Dictionary.MEMBER_STATE_NOACTIVATE)) {
						memberModifyRes.setFailureReasons("该会员已激活不能改成未激活");
					} else if (null != member2
							&& !member2.getId().equals(member.getId())) {
						memberModifyRes.setFailureReasons("手机号已存在");
					} else {
						StringBuffer hql = new StringBuffer("UPDATE Member SET ");
						Map<String, Object> params = new HashMap<String, Object>();
						
						// birthday
						if (null == birthday) {
						} else {
							memberModifyRes.setBirthday(birthday);
							hql.append("birthDay = :birthDay , ");
							params.put("birthDay", birthday);
						}
						
						// mail
						if (null == mail) {
						} else {
							memberModifyRes.setMail(mail);
							hql.append("email = :email , ");
							params.put("email", mail);
						}
						
						// status
						memberModifyRes.setMemberStatus(memberStatus);
						hql.append("status = :memberStatus , ");
						params.put("memberStatus", memberStatus);
						
						// phone
						memberModifyRes.setPhone(phone);
						hql.append("phone = :phone  ");
						params.put("phone", phone);

						// alivePhoneNumber
						if (memberStatus
								.equals(Dictionary.MEMBER_STATE_ACTIVATE)) {
							memberModifyRes
									.setAlivePhoneNumber(alivePhoneNumber);
							hql.append(" , activePhone = :alivePhoneNumber ");
							params.put("alivePhoneNumber", alivePhoneNumber);
						} 
						hql.append("WHERE id = :id ");
						params.put("id", id);
						logger.trace("会员基本资料修改 ====>"+hql.toString());
						
						hbDaoSupport.executeHQL(hql.toString(), params);
						
						memberModifyRes.setUpdateStatus(1); // 成功
					}
				}
				try {
					if(memberModifyRes.getUpdateStatus().equals(new Integer(1))){
						sysLogService.addSysLog("会员基本资料修改", name, OperationEvent.EVENT_UPDATE.getName(), "成功");
					} else {
						sysLogService.addSysLog("会员基本资料修改", name, OperationEvent.EVENT_UPDATE.getName(), "失败");
					}
				} catch (Exception e) {
				}
			return memberModifyRes;
		} catch (Exception e) {// 数据库异常，修改失败
			memberModifyRes.setFailureReasons("数据库异常");
			try {
					sysLogService.addSysLog("会员基本资料修改", name, OperationEvent.EVENT_UPDATE.getName(), "失败");
			} catch (Exception e2) {
			}
			return memberModifyRes;
		}
	}
	
	@Override
	public void updateActivePhone(Integer id, String phone) {
		String hql = "update Member set activePhone = ? where id = ?";
		hbDaoSupport.executeHQL(hql, phone,id);
	}
	
	@Override
	public List<Member> offExternalMember(String PreSyncTime,Page page) {
		int size = 2000;
		if(PreSyncTime != null){
			// 昨天 23: 59 59
			Calendar cal = Calendar.getInstance();
			cal.setTime(new Date());
			cal.set(Calendar.HOUR, 23);
			cal.set(Calendar.MINUTE, 59);
			cal.set(Calendar.SECOND,59);
		    cal.add(Calendar.DATE, -1);
			// 传过来当天 00:00:01
			Calendar cur = Calendar.getInstance();
			cur.setTime(DateTools.stringsToDate(PreSyncTime));
			cur.set(Calendar.HOUR, 0);
			cur.set(Calendar.MINUTE, 0);
			cur.set(Calendar.SECOND,1);
			
			Integer s = (page.getPage() - 1) * size;
			String sql = "SELECT ab.units integral,m.* FROM Member m LEFT JOIN AccountBalance ab ON m.account = ab.account_accountId WHERE (m.updateDate >= ? and m.updateDate <= ?) or (m.createDate >= ? and m.createDate <= ?) GROUP BY m.id limit "+s+","+size;
			String countSql = "SELECT COUNT(*) FROM (SELECT COUNT(1) FROM Member m LEFT JOIN AccountBalance ab ON m.account = ab.account_accountId WHERE (m.updateDate >= ? and m.updateDate <= ?) or (m.createDate >= ? and m.createDate <= ?) GROUP BY m.id) a";
			Integer totalRows = jdbcDaoSupport.findCount(countSql, cur.getTime(),cal.getTime(),cur.getTime(),cal.getTime());
			//总页数=(总记录数+每页行数-1)/每页行数
			page.setTotalRows((totalRows + size - 1)/size);
			return jdbcDaoSupport.findTsBySQL(Member.class, sql, cur.getTime(),cal.getTime(),cur.getTime(),cal.getTime());
			
		}else{
			Integer s = (page.getPage() - 1) * size;
			String sql = "SELECT ab.units integral,m.* FROM Member m LEFT JOIN AccountBalance ab ON m.account = ab.account_accountId GROUP BY m.id limit "+s+","+size;
			String countSql = "SELECT COUNT(*) FROM (SELECT COUNT(1) FROM Member m LEFT JOIN AccountBalance ab ON m.account = ab.account_accountId GROUP BY m.id) a";
			Integer totalRows = jdbcDaoSupport.findCount(countSql);
			//总页数=(总记录数+每页行数-1)/每页行数
			page.setTotalRows((totalRows + size - 1)/size);
			return jdbcDaoSupport.findTsBySQL(Member.class, sql);
		}
	}
	
	@Override
	public Member offExternalMemberByPhone(String phone) {
		String sql = "SELECT ab.units integral,m.* FROM Member m LEFT JOIN AccountBalance ab ON m.account = ab.account_accountId WHERE m.phone = ? and m.status <> ?";
		return jdbcDaoSupport.findTBySQL(Member.class, sql, phone,Dictionary.MEMBER_STATE_LOGOUT);
	}
	
	@Override
	public Integer findMemberByCard(String cardNo, Integer id) {
		//String hql = "from Member where card.cardNumber = ?";
		//Member m = hbDaoSupport.findTByHQL(hql, cardNo);
		String sql = "select m.id from Member m LEFT JOIN MemberCard mc ON m.card_id = mc.id where m.status <> 3 AND mc.cardNumber = " + cardNo;
		Member m = jdbcDaoSupport.findTBySQL(Member.class, sql);
		if(m == null){
			return 0;
		}else{
			if(m.getId().equals(id)){
				return 0;
			}
			return 1;
		}
	}
	
	@Override
	public Integer findMemberByEmail(String email, Integer id) {
		String sql = "select id from Member where email = ? and status <> ?";
		Member m = jdbcDaoSupport.findTBySQL(Member.class, sql, email,Dictionary.MEMBER_STATE_LOGOUT);
		if(m == null){
			return 0;
		}else{
			if(m.getId().equals(id)){
				return 0;
			}
			return 1;
		}
	}
	
	@Override
	public Integer findMemberByIdentityCard(String idCard, Integer id) {
		String hql = "from Member where identityCard = ? and status <> ?";
		Member m = hbDaoSupport.findTByHQL(hql, idCard,Dictionary.MEMBER_STATE_LOGOUT);
		if(m == null){
			return 0;
		}else{
			if(m.getId().equals(id)){
				return 0;
			}
			return 1;
		}
	}
	
	@Override
	public Integer findMemberByQq(String qq, Integer id) {
		String hql = "from Member where qq = ? and status <> ?";
		Member m = hbDaoSupport.findTByHQL(hql, qq,Dictionary.MEMBER_STATE_LOGOUT);
		if(m == null){
			return 0;
		}else{
			if(m.getId().equals(id)){
				return 0;
			}
			return 1;
		}
	}
	
	@Override
	public Integer findMemberByWeixin(String weixin, Integer id) {
		String hql = "from Member where weixin = ? and status <> ?";
		Member m = hbDaoSupport.findTByHQL(hql, weixin,Dictionary.MEMBER_STATE_LOGOUT);
		if(m == null){
			return 0;
		}else{
			if(m.getId().equals(id)){
				return 0;
			}
			return 1;
		}
	}
	
	@Override
	public MemberPasswordModifyRes updateMemberPasswordForClient(
			MemberPasswordModifyReq memberPasswordModifyReq) {

		Integer id = memberPasswordModifyReq.getId();
		String oldPassword = memberPasswordModifyReq.getOldPassword();
		String newPassword = memberPasswordModifyReq.getNewPassword();
		String updateTime = memberPasswordModifyReq.getUpdateTime();

		MemberPasswordModifyRes memberPasswordModifyRes = new MemberPasswordModifyRes();
		memberPasswordModifyRes.setUpdateStatus(2);

		Member member = hbDaoSupport.findTById(Member.class, id);
		if (null == member) {// ID对应的member不存在，修改失败
			memberPasswordModifyRes.setUpdateDesc("会员id不存在, 修改失败");
		} else {

			memberPasswordModifyRes.setPhone(member.getPhone());
			memberPasswordModifyRes
					.setAlivePhoneNumber(member.getActivePhone());
			memberPasswordModifyRes.setId(id);

			String oldStr = DES3.decryptStrMode(DES3.getKeyBytes(updateTime),
					oldPassword);
			String newStr = DES3.decryptStrMode(DES3.getKeyBytes(updateTime),
					newPassword);

			if (null == oldStr || null == newStr) {
				memberPasswordModifyRes.setUpdateDesc("密码解密错误, 修改失败");
			} else {
				if (member.getStatus().equals(
						Dictionary.MEMBER_STATE_NOACTIVATE)) {
					memberPasswordModifyRes.setUpdateDesc("该会员还没有激活，不能修改密码");
				} else if (member.getStatus().equals(
						Dictionary.MEMBER_STATE_LOGOUT)) {
					memberPasswordModifyRes.setUpdateDesc("该会员已注销，不能修改密码");
				} else if (MD5.MD5Encoder(oldStr).equals(member.getPassword())) {

					hbDaoSupport.executeHQL(
							"update Member set password =? where id=?",
							new Object[] { MD5.MD5Encoder(newStr), id });
					member.setUpdateDate(SystemTimeProvider.getCurrentTime());
					hbDaoSupport.update(member);
					memberPasswordModifyRes.setUpdateStatus(1); // 成功
					memberPasswordModifyRes.setUpdateDesc("修改成功");
				} else {
					memberPasswordModifyRes.setUpdateDesc("老密码不正确，修改失败");
				}
			}
		}

		return memberPasswordModifyRes;
	}

	@Override
	public Member findMemberByPhonePwd(String phone) {
		String sql = "SELECT m.*,MAX(CASE when ab.unitCode = 'BINKE' THEN ab.units ELSE 0 END) integral,MAX(CASE when ab.unitCode = 'RMB' THEN ab.units ELSE 0 END) money  FROM Member m LEFT JOIN AccountBalance ab ON m.account = ab.account_accountId where m.phone = ? and m.status <> ? ";
		List<Member> list = jdbcDaoSupport.findTsBySQL(Member.class,sql,phone,Dictionary.MEMBER_STATE_LOGOUT );
		if(list.size() > 0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	
	@Override
	public List<MemberReport> getTotleMembers(Member member) {

		List<MemberReport> mlist=new ArrayList<MemberReport>();
		List<MemberReport> mlistorder= new ArrayList<MemberReport>();
		List<Object> args = new ArrayList<Object>();
		StringBuffer sql = new StringBuffer();
		sql.append("select m.id, m.`account`,m.`phone`,m.`surname`,m.`name` , m.address,m.`createDate`,m.`birthDay`,m.`sex`,m.`email`,mc.cardNumber,"+
				" m.`province`,m.`city`,m.`area`,m.`status`,s.name as source,m. orderPriceSum   from Member m  "+
              
                 "  left join Source s on s.num=m.source   left join MemberCard mc on m.card_id=mc.id  where m.status < " + Dictionary.MEMBER_STATE_LOGOUT);
		if (StringUtils.isNotEmpty(member.getName())) {
			sql.append(" and CONCAT(m.surname,m.name) like ?");
			args.add(  "%" +member.getName()+ "%"  );
		}
		if (member.getStatus() != null && !"".equals(member.getStatus())) {
			sql.append(" and m.status = ?");
			args.add( member.getStatus());
		}
		if (StringUtils.isNotEmpty(member.getProvince())) {
			sql.append(" and m.province = ?");
			args.add( member.getProvince());
		}
		if (StringUtils.isNotEmpty(member.getCity())) {
			sql.append(" and m.city = ?");
			args.add( member.getCity());
		}
		if (StringUtils.isNotEmpty(member.getArea())) {
			sql.append(" and m.area = ?");
			args.add( member.getArea());
		}
		if (StringUtils.isNotEmpty(member.getPhone())) {
			
			sql.append(" and m.phone = ?");
			args.add( member.getPhone());
		}
		if (member.getCard() != null) {
			if (StringUtils.isNotEmpty(member.getCard().getCardNumber())) {
				
				sql.append(" and m.card.cardNumber like ?");
				args.add("%" + member.getCard().getCardNumber()+"%" );
			}
		}
		if (StringUtils.isNotEmpty(member.getEmail())) {
			sql.append(" and m.email like ?");
			args.add( "%" + member.getEmail() + "%");
		}
		
		
		if(member.getCreateStart()!=null){
			sql.append(" and m.createDate  >= ? ");
			args.add( member.getCreateStart());
		}
		if(member.getCreateEnd()!=null){
			sql.append(" and m.createDate <=? ");
			args.add( member.getCreateEnd());
		}
		int year=DateTools.getYear();
		
		if(member.getAgeStart()!=null&&member.getAgeEnd()==null){
				sql.append(" and (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(m.birthday)), '%Y')+0) >=? ");
				args.add( member.getAgeStart());
		}
		
		if(member.getAgeEnd()!= null&&member.getAgeStart()==null ){
				sql.append(" and (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(m.birthday)), '%Y')+0)  <= ? ");
				args.add( member.getAgeEnd());
		}
		if(member.getAgeStart()!=null&&member.getAgeEnd()!=null&& member.getAgeStart()<member.getAgeEnd()){
				sql.append(" and (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(m.birthday)), '%Y')+0)  between ? and  ? ");
				args.add( member.getAgeStart());
				args.add( member.getAgeEnd());
		}
		
		if(StringUtils.isNotEmpty(member.getSource())&&!"0".equals(member.getSource())){
			sql.append(" and m.source =?");
			args.add( member.getSource());
		}
		
		if(member.getSex()!=null&&member.getSex()!=0){
			sql.append(" and m.sex =?");
			args.add( member.getSex());
		}
		
	//	sql.append(" group by m.`id` ");
	
        if(member.getExpenseStart()!=null||member.getExpenseEnd()!=null){
        	// sql.append("  having  ");
        	 
        	
    		 if(member.getExpenseStart()!=null){
    			 sql.append(" and  m.orderPriceSum>=?  ");
    			 args.add(member.getExpenseStart());
    			 
    		 }
    	
    		 if(member.getExpenseEnd()!=null){
    			 sql.append(" and  m.orderPriceSum<=?  ");
    			 args.add(member.getExpenseEnd());
    			 
    		 }
    		 if(member.getExpenseEnd()!=null&&member.getExpenseStart()==null){
    			 sql.append(" or      m.orderPriceSum is null ");
    		 }
    	
		}
		
		sql.append("  order by m.createDate desc");
		sql.append("   LIMIT ?,?");
		args.add(member.getPaginationDetail().getStart());
		args.add(member.getPaginationDetail().getRows());
		//sql.append("   LIMIT ?,?");
		
		logger.trace(sql);
		RowMapper rowMapper = getRowMemberMapper();
		long d1=System.currentTimeMillis();
		mlist = jdbcDaoSupport.findTsBySQL(rowMapper, sql.toString(),args.toArray());
		long d2=System.currentTimeMillis();
		logger.trace("sql花费时间============="+(d2-d1)/1000);
      return mlist;
		
	}

	
	@Override
	public int getCountMembers(Member member) {

		List<Member> mlist=new ArrayList<Member>();
		List<Member> mlistorder= new ArrayList<Member>();
		List<Object> args = new ArrayList<Object>();
		StringBuffer sql = new StringBuffer();

		
		
		sql.append("select count(p.id) from (select  m.`id` from Member m  "+
    
                 "  left join MemberCard mc on mc.id=m.card_id  where m.status <> " + Dictionary.MEMBER_STATE_LOGOUT);
		if (StringUtils.isNotEmpty(member.getName())) {
			sql.append(" and CONCAT(m.surname,m.name) like ?");
			args.add(  "%" +member.getName()+ "%"  );
		}
		if (member.getStatus() != null && !"".equals(member.getStatus())) {
			sql.append(" and m.status = ?");
			args.add( member.getStatus());
		}
		if (StringUtils.isNotEmpty(member.getProvince())) {
			sql.append(" and m.province = ?");
			args.add( member.getProvince());
		}
		if (StringUtils.isNotEmpty(member.getCity())) {
			sql.append(" and m.city = ?");
			args.add( member.getCity());
		}
		if (StringUtils.isNotEmpty(member.getArea())) {
			sql.append(" and m.area = ?");
			args.add( member.getArea());
		}
		if (StringUtils.isNotEmpty(member.getPhone())) {
			
			sql.append(" and m.phone = ?");
			args.add( member.getPhone());
		}
		if (member.getCard() != null) {
			if (StringUtils.isNotEmpty(member.getCard().getCardNumber())) {
				
				sql.append(" and m.card.cardNumber like ?");
				args.add("%" + member.getCard().getCardNumber()+"%" );
			}
		}
		if (StringUtils.isNotEmpty(member.getEmail())) {
			sql.append(" and m.email like ?");
			args.add( "%" + member.getEmail() + "%");
		}
		
		
		if(member.getCreateStart()!=null){
			sql.append(" and m.createDate  >= ? ");
			args.add( member.getCreateStart());
		}
		if(member.getCreateEnd()!=null){
			sql.append(" and m.createDate <=? ");
			args.add( member.getCreateEnd());
		}
		int year=DateTools.getYear();
		
		if(member.getAgeStart()!=null&&member.getAgeEnd()==null){
			
				sql.append(" and (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(m.birthday)), '%Y')+0) >=? ");
				args.add( member.getAgeStart());
			
		}
		
		if(member.getAgeEnd()!= null&&member.getAgeStart()==null ){
				sql.append(" and (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(m.birthday)), '%Y')+0)  <= ? ");
				args.add( member.getAgeEnd());
		}
		if(member.getAgeStart()!=null&&member.getAgeEnd()!=null&& member.getAgeStart()<member.getAgeEnd()){
				sql.append(" and (DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(m.birthday)), '%Y')+0)  between ? and  ? ");
				args.add( member.getAgeStart());
				args.add( member.getAgeEnd());
		}
		
		

		if(StringUtils.isNotEmpty(member.getSource())&&!"0".equals(member.getSource())){
			sql.append(" and m.source =?");
			args.add( member.getSource());
		}
		if(member.getSex()!=null&&member.getSex()!=0){
			sql.append(" and m.sex =?");
			args.add( member.getSex());
		}
		
		
	//	sql.append(" group by m.`id` ");
	
        if(member.getExpenseStart()!=null||member.getExpenseEnd()!=null){
        	// sql.append("  having  ");
        	 
        	
    		 if(member.getExpenseStart()!=null){
    			 sql.append(" and  m.orderPriceSum>=?  ");
    			 args.add(member.getExpenseStart());
    			 
    		 }
    		
    		 if(member.getExpenseEnd()!=null){
    			 sql.append(" and  m.orderPriceSum<=?  ");
    			 args.add(member.getExpenseEnd());
    			 
    		 }
    		 if(member.getExpenseEnd()!=null&&member.getExpenseStart()==null){
    			 sql.append(" or       m.orderPriceSum is null ");
    		 }
    	
		}
		
        sql.append(" )p");
	
		
	
		logger.trace(sql.toString());
		 if(args.size()>0){
			 return	jdbcDaoSupport.findCount(sql.toString(),args.toArray());
			}else{
				return	jdbcDaoSupport.findCount(sql.toString());
			}
	
    
		
	}
	@Override
	public SavingAccountConsumptionRes savingAccountConsumptionForClient(
			SavingAccountConsumptionReq savingAccountConsumptionReq) {
		
		String orderId = savingAccountConsumptionReq.getOrderId();
		String orderSource = savingAccountConsumptionReq.getOrderSource();
		Integer shopId = savingAccountConsumptionReq.getShopId(); // 可选
		List<CommodityVo> commodities = savingAccountConsumptionReq
				.getCommodities(); // 订单中的商品类表
		Double point = savingAccountConsumptionReq.getPoint(); // 扣除金额。
		String operateTime = savingAccountConsumptionReq.getOperateTime(); // 操作时间。格式yyyyMMddHHmmss
		Integer userId = savingAccountConsumptionReq.getUserId(); // 会员Id
		String description = savingAccountConsumptionReq.getDescription(); // 订单描述。可选

		SavingAccountConsumptionRes savingAccountConsumptionRes = new SavingAccountConsumptionRes();
		savingAccountConsumptionRes.setDescription(description);
		savingAccountConsumptionRes.setOperateStatus(2);// failure
		savingAccountConsumptionRes.setOrderId(orderId);
		savingAccountConsumptionRes.setOrderSource(orderSource);
		savingAccountConsumptionRes.setPoint(point);
		savingAccountConsumptionRes.setOperateTime(operateTime);
		savingAccountConsumptionRes.setUserId(userId);

		try {
			Shop shop = null;
			if (null != shopId) {
				shop = hbDaoSupport.findTById(Shop.class, shopId);
			}
			Integer giftCount = new Integer(0);
			boolean commodityAvailable = true;
			List<Merchandise> merchandises = new ArrayList<Merchandise>(); 
			if (null != commodities && commodities.size() > 0) {
				for (CommodityVo commodity : commodities) {
					String id = commodity.getId();
					String name = commodity.getName();
					Integer count = commodity.getCount();
					Merchandise merchandise = merchandiseService
							.findMerchandiseById(id);
					if (null == merchandise) {
						savingAccountConsumptionRes
								.setStatusDescription("商品id\"" + id + "\"不存在");
						commodityAvailable = false;
						break;
					} else {
						merchandises.add(merchandise);
						if (!merchandise.getName().equals(name)) {
							savingAccountConsumptionRes
									.setStatusDescription("商品id\"" + id
											+ "\"对应的商品名称无效");
							commodityAvailable = false;
							break;
						}
						if (null != shop) {
							MerchandiseShop merchandiseShop = hbDaoSupport
									.findTByHQL(
											"FROM MerchandiseShop m WHERE m.shop=? AND m.merchandise=?",
											shop, merchandise);
							if (null == merchandiseShop) {
								savingAccountConsumptionRes
										.setStatusDescription("商品id为\"" + id
												+ "\"的商品不属于id为\"" + shopId
												+ "\"的门市");
								commodityAvailable = false;
								break;
							}
						}
					}
					giftCount += count;
				}
			}
			OrderInfo info = hbDaoSupport.findTByHQL(
					"FROM OrderInfo WHERE orderNo=?", orderId);
			if (null != info) {
				savingAccountConsumptionRes.setStatusDescription("订单ID已存在");
				return savingAccountConsumptionRes;
			}
			Member member = hbDaoSupport.findTById(Member.class, userId);
			if (!commodityAvailable) {

			} else if (null != shopId && null == shop) {
				savingAccountConsumptionRes.setStatusDescription("门店id不存在");
			} else if (null == member) {
				savingAccountConsumptionRes.setStatusDescription("会员id不存在");
			} else if (member.getStatus().equals(
					Dictionary.MEMBER_STATE_NOACTIVATE)) {
				savingAccountConsumptionRes
						.setStatusDescription("该会员未激活，储值卡不能消费");
			} else if (member.getStatus()
					.equals(Dictionary.MEMBER_STATE_LOGOUT)) {
				savingAccountConsumptionRes
						.setStatusDescription("该会员已注销，储值卡不能消费");
			} else {
				Transaction tx = accountService.createTransaction(
						member.getName(), Business.SAVING_ACCOUNT_CONSUMPTION,
						DateTools.stringsToDate(operateTime));
				Account account = accountService.findAccountById(member
						.getAccount());
				if (null == account) {
					savingAccountConsumptionRes.setStatusDescription("会员没有账户");
					return savingAccountConsumptionRes;
				}

				Unit unit = hbDaoSupport.findTByHQL(
						"FROM Unit where unitCode = ?", Dictionary.UNIT_CODE_RMB);

				OrderInfo orderInfo = new OrderInfo();

				orderInfo.setType(3);
				orderInfo.setAccount(account);
				orderInfo.setClerkId(userId.toString());
				orderInfo.setShop(shop);
				orderInfo.setTx(tx);
				orderInfo.setOrderSource(orderSource);
				orderInfo.setOrderNo(orderId);
				orderInfo.setUsingCode(new BigDecimal(point));
				orderInfo.setOrderPrice(new BigDecimal(point));
				orderInfo.setOrderTime(DateTools.stringsToDate(operateTime));
				orderInfo.setRedemptionQuantity(giftCount);
				double balance = accountService.getAccountBalance(account,
						Dictionary.UNIT_CODE_RMB);
				DecimalFormat df = new DecimalFormat();
				df.setMinimumFractionDigits(0);
				df.setMaximumFractionDigits(2);
				String rmbstr = df.format(balance);
				rmbstr = rmbstr.replaceAll(",", "");
				orderInfo.setBeforeCash(new BigDecimal(balance));
				if (balance < point) {
					savingAccountConsumptionRes.setStatusDescription("余额不足");
				} else {
					accountService.withdrawal(member.getName(), account, unit,
							point.doubleValue(), tx);
					hbDaoSupport.save(orderInfo);
					savingAccountConsumptionRes.setPoint(balance
							- point.doubleValue());
					
					
					for (int i = 0, length = merchandises.size(); i < length; i++) {
						Merchandise merchandise = merchandises.get(i);
						CommodityVo commodity = commodities.get(i);
						String merchandiseId = commodity.getId();
						String merchandiseName = commodity.getName();
						Integer count = commodity.getCount();

						RedemptionDetail redemptionDetail = new RedemptionDetail();
						redemptionDetail.setMerchandiseId(merchandiseId);
						redemptionDetail.setMerchandiseName(merchandiseName);
						redemptionDetail.setOrderInfo(orderInfo);
						redemptionDetail.setPurchasePrice(merchandise
								.getPurchasePrice());
						redemptionDetail
								.setSellUnitCode(Dictionary.UNIT_CODE_RMB);
						redemptionDetail.setQuantity(count);
						List<MerchandiseSaleform> saleforms = merchandise
								.getMerchandiseSaleforms();
						Double sellUnits = null;
						for (MerchandiseSaleform saleform : saleforms) {
							if (saleform.getUnitId().equals(
									Dictionary.INTEGRAL_RMB_ID)) {
								sellUnits = saleform.getPrice();
							}
						}
						redemptionDetail.setSellUnits(sellUnits);
						hbDaoSupport.save(redemptionDetail);
					}
					savingAccountConsumptionRes.setOperateStatus(1);// 成功
					savingAccountConsumptionRes.setStatusDescription("成功");
				}
			}
		} 
		catch (RuntimeException t) {
//			t.printStackTrace(); // ignore 
		}
		return savingAccountConsumptionRes;
	}
	
	@Override
	public List<IntegralRule> getRules(String ruleIds) {
		List<IntegralRule> rules = new ArrayList<IntegralRule>();
		if (!StringUtils.isEmpty(ruleIds)) {

			List<Integer> ids = new ArrayList<Integer>();
			for (String str : ruleIds.split(",")) {
				try {
					ids.add(Integer.parseInt(str));
				} catch (Exception e) {
					// invalid parameter ignore it .
					e.printStackTrace();
				}
			}

			if (ids.size() > 0) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ids", ids);
				rules = hbDaoSupport.findTs(
						"FROM IntegralRule u WHERE u.id in(:ids)", params);
			}
		}
		return rules;
	}

	@Override
	public BigDecimal getOrderPriceSum(String accountId) {
		String sql="select  sum(`orderPrice`) as orderPriceSum FROM OrderInfo  WHERE account_accountId =? and (type=3 or type=0 or type=4) ";
		Long count = jdbcDaoSupport.queryForLong(sql.toString(),accountId );
		BigDecimal orderPriceSum=new BigDecimal(count);
		return  orderPriceSum;
	}

	@Override
	public boolean chechOrderNo(String orderNO) {

		String sql="select  COUNT(*) as orderPriceSum FROM OrderInfo  WHERE orderNo =?";
		
		Long count = jdbcDaoSupport.queryForLong(sql.toString(),orderNO );
		if(count!=0&&count>=1){
			return false;
		}
		return true;
	}
	
	@Override
	public List<Source> findSources() {
		return hbDaoSupport.findAll(Source.class);
	}

	@Override
	public Source findByNum(String num) {
		  logger.trace("========================="+num);
		return hbDaoSupport.findTByHQL("FROM Source  where num=?", num);
	}
}
