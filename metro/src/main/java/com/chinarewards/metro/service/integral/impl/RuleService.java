package com.chinarewards.metro.service.integral.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.JDBCDaoSupport;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.rules.BirthRule;
import com.chinarewards.metro.domain.rules.IntegralRule;
import com.chinarewards.metro.model.integral.IntegralQueryConditionVo;
import com.chinarewards.metro.model.integral.IntegralReport;
import com.chinarewards.metro.service.integral.IRuleService;

@Service
public class RuleService implements IRuleService {

	@Autowired
	private HBDaoSupport hbDaoSupport;
	@Autowired
	private JDBCDaoSupport jdbcDaoSupport;
	
	private Logger logger = org.slf4j.LoggerFactory.getLogger(this.getClass());

	@Override
	public List<IntegralRule> findIntegralRule(Page page, IntegralRule rule) {
		DetachedCriteria criteria = DetachedCriteria.forClass(rule.getClass());
		criteria.addOrder(Order.desc("id"));
		if (StringUtils.isNotEmpty(rule.getRuleName())) {
			criteria.add(Restrictions.like("ruleName", rule.getRuleName(),
					MatchMode.ANYWHERE));
		}
		if (rule.getTimes() != null) {
			criteria.add(Restrictions.eq("times", rule.getTimes()));
		}
		if (rule.getRangeFrom() != null) {
			criteria.add(Restrictions.ge("rangeFrom", rule.getRangeFrom()));
		}
		if (rule.getRangeTo() != null) {
			criteria.add(Restrictions.le("rangeTo", rule.getRangeTo()));
		}

		criteria.add(Restrictions.eq("disabled", false));

		return hbDaoSupport.findPageByCriteria(page, criteria);
	}

	@Override
	public IntegralRule saveIntegralRule(IntegralRule rule) {
		rule.setCreatedAt(DateTools.dateToHour());
		rule.setLastModifiedAt(DateTools.dateToHour());
		rule.setCreatedBy(UserContext.getUserName());
		rule.setDisabled(false);
		return hbDaoSupport.save(rule);
	}

	@Override
	public IntegralRule findRuleByName(String ruleName) {
		String hql = "from IntegralRule where ruleName = ? and disabled = ?";
		return hbDaoSupport.findTByHQL(hql, ruleName, false);
	}

	@Override
	public IntegralRule findRuleByRule(IntegralRule rule) {
		List<Object> args = new ArrayList<Object>();
		StringBuffer sbf = new StringBuffer();
		sbf.append("from IntegralRule where 1=1 ");
		boolean f = false;
		if(rule.getRangeFrom() != null){
			sbf.append(" and rangeFrom = ?");
			args.add(rule.getRangeFrom());
			f = true;
		}
		if(rule.getRangeTo() != null){
			sbf.append(" and rangeTo = ?");
			args.add(rule.getRangeTo());
			f = true;
		}
		if(rule.getRangeAgeFrom() != null){
			sbf.append(" and rangeAgeFrom = ?");
			args.add(rule.getRangeAgeFrom());
			f = true;
		}
		if(rule.getRangeAgeTo() != null){
			sbf.append(" and rangeAgeTo = ?");
			args.add(rule.getRangeAgeTo());
			f = true;
		}
		if(rule.getAmountConsumedFrom() != null){
			sbf.append(" and AmountConsumedFrom = ?");
			args.add(rule.getAmountConsumedFrom());
			f = true;
		}
		if(rule.getAmountConsumedTo() != null){
			sbf.append(" and AmountConsumedTo = ?");
			args.add(rule.getAmountConsumedTo());
			f = true;
		}
		
		sbf.append(" and gender = ?");
		args.add(rule.getGender());
		sbf.append(" and disabled = false");
		if(f){
			return hbDaoSupport.findTByHQL(sbf.toString(),args.toArray());
		}else{
			String s = "select * from IntegralRule where AmountConsumedTo is null and AmountConsumedFrom is null and rangeAgeTo is null" +
						" and rangeAgeFrom is null and rangeTo is null and rangeFrom is null and disabled = false and gender = ?";
		    return jdbcDaoSupport.findTBySQL(IntegralRule.class, s,rule.getGender());
		}
	}

	@Override
	public IntegralRule findRuleById(Integer id) {
		String hql = "from IntegralRule where id = ? and disabled = ?";
		return hbDaoSupport.findTByHQL(hql, id, false);
	}

	@Override
	public void updateIntegralRule(IntegralRule rule) throws Exception {

		IntegralRule nr = new IntegralRule();
		PropertyUtils.copyProperties(nr, rule);
		nr.setLastModifiedAt(DateTools.dateToHour());
		nr.setLastModifiedBy(UserContext.getUserName());
		nr.setDisabled(true);
		nr.setId(null);
		hbDaoSupport.save(nr);
		
		rule.setLastModifiedAt(DateTools.dateToHour());
		rule.setLastModifiedBy(UserContext.getUserName());
		rule.setDisabled(false);
		hbDaoSupport.update(rule);
	}

	@Override
	public void removeRule(String ids) {
		String hql = "update IntegralRule set disabled=:vl where id in(:ids)";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ids", CommonUtil.getIntegers(ids));
		map.put("vl", true);
		hbDaoSupport.executeHQL(hql, map);
	}

	@Override
	public BirthRule saveBirthRule(BirthRule birthRule) {
		return hbDaoSupport.save(birthRule);
	}

	@Override
	public void updateBirthRule(BirthRule birthRule) {
		String hql = "UPDATE BirthRule SET times = ? WHERE id = ?";
		hbDaoSupport.executeHQL(hql, birthRule.getTimes(), birthRule.getId());
	}

	@Override
	public List<BirthRule> findBirthRule() {
		return hbDaoSupport.findAll(BirthRule.class);
	}

	@Override
	public List<IntegralRule> findAll() {
		return hbDaoSupport.findTsByHQL("FROM IntegralRule WHERE disabled<>?",
				true);
	}

	@Override
	public List<IntegralReport> queryIntegralReportData(
			IntegralQueryConditionVo vo, Page page) {
		List<IntegralReport> list = getDataList(vo, page);
		return list;
	}

	/**
	 * 构建积分分析报表sql
	 * 
	 * @param criteria
	 * @param page
	 * @param isCount
	 * @param paramStore
	 * @return
	 */
	protected String buildIntegralReportSql(IntegralQueryConditionVo criteria,
			Page page, boolean isCount, List<Object> paramStore) {

//		String sdata = "select o.tx_txId as txid,o.integration as integralCount,o.usingCode as comsumePoint,concat(m.surname,m.name) as memName ,(CASE WHEN mc.cardNumber IS NOT NULL THEN mc.cardNumber ELSE m.phone END) as memberCard,(CASE WHEN o.orderSource IS NOT NULL THEN o.orderSource ELSE t.origin END) as origin,t.status as status,t.transactionDate as exchangeHour,t.busines as type ";
//		String sdata = "select o.tx_txId as txid,o.integration as integralCount,o.usingCode as comsumePoint,concat(m.surname,m.name) as memName ,mc.cardNumber as memberCard, m.phone as phone,o.orderSource as orderSource , t.origin as origin,t.status as status,t.transactionDate as exchangeHour,t.busines as type ";
		String sdata = "select txid, integralCount, comsumePoint,memName , memberCard,  phone, orderSource ,  origin, status, exchangeHour, type ";
		String scount = "select count(1) ";

		StringBuffer query = new StringBuffer();
		if (isCount) {
			query.append(scount);
		} else {
			query.append(sdata);
		}
		query.append(" from IntegralReport WHERE 1=1 ");

//		query.append(" from OrderInfo o left join Member m on m.account=o.account_accountId left join MemberCard mc on mc.id=m.card_id left join Transaction t on t.txId=o.tx_txId and t.busines != 'HAND_MONEY' WHERE 1=1 ");

		if (!StringUtils.isEmpty(String.valueOf(criteria.getIntegralType()))) {
			// 获取积分   integralType
			if ("1".equals(String.valueOf(criteria.getIntegralType()))) {
//				query.append(" AND (o.type = 4 or o.type=0)");
				query.append(" AND (integralType = 4 or integralType=0)");
			}
			// 使用积分
			else if ("2".equals(String.valueOf(criteria.getIntegralType()))) {
//				query.append(" AND (o.type = 4 or o.type=1)");
				query.append(" AND (integralType = 4 or integralType=1)");
			}
		}

		if (StringUtils.isNotEmpty(criteria.getOrigin())) {
//			query.append(" and  o.orderSource like ? or t.origin like ? ");
			query.append(" and  (orderSource like ? or origin like ?) ");
			paramStore.add("%" + criteria.getOrigin() + "%");
			paramStore.add("%" + criteria.getOrigin() + "%");
		}

		if (StringUtils.isNotEmpty(criteria.getStatus())
				&& !criteria.getStatus().equals("0")) {
//			query.append(" and t.status = ? ");
			query.append(" and status = ? ");
			paramStore.add(criteria.getStatus());
		}

		if (StringUtils.isNotEmpty(criteria.getStartDate())) {
//			query.append(" and t.transactionDate  >= ? ");
			query.append(" and exchangeHour  >= ? ");
			paramStore.add(criteria.getStartDate());
		}

		if (StringUtils.isNotEmpty(criteria.getEndDate())) {
//			query.append(" and t.transactionDate <= ? ");
			query.append(" and exchangeHour <= ? ");
			paramStore.add(criteria.getEndDate());
		}

		if (StringUtils.isNotEmpty(criteria.getMemName())) {
//			query.append(" and CONCAT(m.surname,m.name) like ? ");
			query.append(" and memName like ? ");
			paramStore.add("%" + criteria.getMemName() + "%");
		}

		if (StringUtils.isNotEmpty(criteria.getMemberCard())) {
//			query.append(" and mc.cardNumber like ? or m.phone like ? ");
			query.append(" and (memberCard like ? or phone like ?) ");
			paramStore.add("%" + criteria.getMemberCard() + "%");
			paramStore.add("%" + criteria.getMemberCard() + "%");
		}
		
//		query.append(" order by t.transactionDate desc,t.txId desc");
		
		if (page != null) {
			query.append(" limit ?,? ");
			paramStore.add(page.getStart());
			paramStore.add(page.getRows());
		}

		logger.debug("###### integral report query sql: "+query.toString());
		return query.toString();
	}

	/**
	 * 汇总条件内的使用积分数量和获取积分数量
	 * 
	 * @param vo
	 * @return
	 */
	public Map<String/* consume->消耗积分;obtain->获取积分 */, Object> sumIntegralPoint(
			IntegralQueryConditionVo criteria) {
		List<Object> queryParameters = new ArrayList<Object>();
		String query = buildIntegralReportSql(criteria, null, false,
				queryParameters);
		query = "select sum(tb.integralCount) as obtain,sum(tb.comsumePoint) as consume from ("
				+ query + ") tb ";
		Map<String, Object> result = jdbcDaoSupport.findMapBySQL(query,
				queryParameters.toArray());
		return result;
	}

	/**
	 * 检索积分分析报表数据，获取符合条件的记录总数
	 * 
	 * @param criteria
	 * @return
	 */
	public Long countIntegralReport(IntegralQueryConditionVo criteria) {

		List<Object> queryParameters = new ArrayList<Object>();
		String query = buildIntegralReportSql(criteria, null, true,
				queryParameters);

		long count = jdbcDaoSupport.queryForLong(query, queryParameters.toArray());
		return count;
	}

	/**
	 * 检索积分分析报表数据
	 * 
	 * @param criteria
	 *            检索条件，如果为null　or empty 不计入检索条件
	 * @param page
	 *            如果不为空，获取分页数据，如果为空获取符合条件的所有数据
	 * @return
	 */
	public List<IntegralReport> getIntegralReport(
			IntegralQueryConditionVo criteria, Page page) {

		List<IntegralReport> result = new ArrayList<IntegralReport>();
		List<Object> queryParameters = new ArrayList<Object>();
		String query = buildIntegralReportSql(criteria, page, false,
				queryParameters);
		RowMapper rowMapper = getRowMapper();
		long onceTime = System.currentTimeMillis();
		result = jdbcDaoSupport.findTsBySQL(rowMapper, query, queryParameters.toArray());
		logger.trace("jdbcDaoSupport query time ====>>> :  "
				+ ((System.currentTimeMillis() - onceTime) / 1000)
				+ " seconds");
		return result;
	}

	/**
	 * 获得数据集
	 * 
	 * @param vo
	 * @param page
	 */
	public List<IntegralReport> getDataList(IntegralQueryConditionVo vo,
			Page page) {
		StringBuffer sqlBuf = new StringBuffer();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		List<Object> objList = new ArrayList<Object>();
		/*
		 * String sql =
		 * "SELECT tab.integralCount,tab.memName,tab.memberCard,tab.origin,tab.status,tab.exchangeHour,tab.type from "
		 * +
		 * "(SELECT sum(l.units) as integralCount,l.transaction_txid as txid,group_concat(DISTINCT m.surname,m.name) as memName,mc.cardNumber as memberCard,"
		 * +
		 * "(CASE WHEN o.orderSource IS NOT NULL THEN o.orderSource ELSE t.origin END) as origin,t.status as status,t.transactionDate as exchangeHour,t.busines as type "
		 * +
		 * "FROM Transaction t LEFT JOIN Ledger l ON t.txId = l.transaction_txId AND l.unitCode = 'BINKE'"
		 * + "LEFT JOIN OrderInfo o ON t.txId = o.tx_txId " +
		 * "LEFT JOIN Account a ON l.account_accountId = a.accountId " +
		 * "LEFT JOIN Member m ON a.accountId = m.account " +
		 * "LEFT JOIN MemberCard mc ON m.card_id = mc.id ";
		 */
		String sql = "SELECT l.units as integralCount,l.transaction_txid as txid,"
				+ "group_concat(DISTINCT m.surname,m.name) as memName,mc.cardNumber as memberCard,"
				+ "(CASE WHEN o.orderSource IS NOT NULL THEN o.orderSource ELSE t.origin END) as origin,"
				+ "t.status as status,t.transactionDate as exchangeHour,t.busines as type "
				+ "FROM Transaction t LEFT JOIN Ledger l ON t.txId = l.transaction_txId AND l.unitCode = 'BINKE' "
				+ "LEFT JOIN OrderInfo o ON t.txId = o.tx_txId "
				+ "LEFT JOIN Account a ON l.account_accountId = a.accountId "
				+ "LEFT JOIN Member m ON a.accountId = m.account "
				+ "LEFT JOIN MemberCard mc ON m.card_id = mc.id where 1=1 ";
		sqlBuf.append(sql);
		condition(vo, sqlBuf, objList);
		List<IntegralReport> list = new ArrayList<IntegralReport>();
		try {
			// sqlBuf.append(" GROUP BY t.busines,mc.cardNumber) tab");
			sqlBuf.append(" GROUP BY t.txId,mc.cardNumber order by t.transactionDate desc,t.txId desc");
			if (page != null) {
				sqlBuf.append(" limit ?,? ");
				objList.add(page.getStart());
				objList.add(page.getRows());
			}
			RowMapper rowMapper = getRowMapper();
			list = jdbcDaoSupport.findTsBySQL(rowMapper, sqlBuf.toString(),
					objList.toArray());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	private RowMapper getRowMapper() {
		RowMapper rowMapper = new RowMapper<IntegralReport>() {

			@Override
			public IntegralReport mapRow(ResultSet rs, int arg1)
					throws SQLException {
				IntegralReport report = new IntegralReport();
				report.setExchangeHour(rs.getDate("exchangeHour"));
				report.setIntegralCount(rs.getLong("integralCount"));
				report.setUsedIntegral(rs.getLong("comsumePoint"));
				report.setMemberCard(rs.getString("memberCard"));
				report.setMemName(rs.getString("memName"));
				report.setOrderSource(rs.getString("orderSource"));
				report.setStatus(rs.getString("status"));
				report.setType(rs.getString("type"));
//				report.setPhone(rs.getString("phone"));
//				report.setOrigin(rs.getString("origin"));
				if(rs.getString("memberCard") == null || "".equals(rs.getString("memberCard"))){
					String phone = rs.getString("phone");
					if(phone.indexOf("_") == -1){
						report.setMemberCard(phone);
					}else{
						report.setMemberCard(phone.substring(0,phone.indexOf("_")));
					}
				}
				if(rs.getString("orderSource") == null || "".equals(rs.getString("orderSource"))){
					report.setOrderSource(rs.getString("origin"));
				}
				return report;
			}
		};
		return rowMapper;
	}

	@Override
	public Long getIntegralTotalCount(IntegralQueryConditionVo vo) {
		long count = 0;
		StringBuffer sqlBuf = new StringBuffer();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		List<Object> objList = new ArrayList<Object>();
		String sql = "SELECT sum(tab.integralCount) as integralCount from "
				+ "(SELECT sum(l.units) as integralCount,l.transaction_txid as txid,m.name as memName,mc.cardNumber as memberCard,"
				+ "(CASE WHEN o.orderSource IS NOT NULL THEN o.orderSource ELSE t.origin END) as origin,t.status as status,t.transactionDate as exchangeHour,t.busines as type "
				+ "FROM Transaction t LEFT JOIN Ledger l ON t.txId = l.transaction_txId AND l.unitCode = 'BINKE'  AND t.busines in('POS_SALES','HAND_POINT') "
				+ "LEFT JOIN OrderInfo o ON t.txId = o.tx_txId "
				+ "LEFT JOIN Account a ON l.account_accountId = a.accountId "
				+ "LEFT JOIN Member m ON a.accountId = m.account "
				+ "LEFT JOIN MemberCard mc ON m.card_id = mc.id  where 1=1 ";
		sqlBuf.append(sql);
		condition(vo, sqlBuf, objList);
		sqlBuf.append(" GROUP BY t.busines,mc.cardNumber) tab ");
		try {
			count = jdbcDaoSupport.queryForLong(sqlBuf.toString(),
					objList.toArray());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return count;
	}

	@Override
	public Long useIntegralTotalCount(IntegralQueryConditionVo vo) {
		long count = 0;
		StringBuffer sqlBuf = new StringBuffer();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		List<Object> objList = new ArrayList<Object>();
		String sql = "SELECT sum(tab.integralCount) as integralCount from "
				+ "(SELECT sum(l.units) as integralCount,l.transaction_txid as txid,m.name as memName,mc.cardNumber as memberCard,"
				+ "(CASE WHEN o.orderSource IS NOT NULL THEN o.orderSource ELSE t.origin END) as origin,t.status as status,t.transactionDate as exchangeHour,t.busines as type "
				+ "FROM Transaction t LEFT JOIN Ledger l ON t.txId = l.transaction_txId AND l.unitCode = 'BINKE'  AND t.busines in('POS_REDEMPTION') "
				+ "LEFT JOIN OrderInfo o ON t.txId = o.tx_txId "
				+ "LEFT JOIN Account a ON l.account_accountId = a.accountId "
				+ "LEFT JOIN Member m ON a.accountId = m.account "
				+ "LEFT JOIN MemberCard mc ON m.card_id = mc.id  where 1=1 ";
		sqlBuf.append(sql);
		condition(vo, sqlBuf, objList);
		sqlBuf.append(" GROUP BY t.busines,mc.cardNumber) tab ");
		try {
			count = jdbcDaoSupport.queryForLong(sqlBuf.toString(),
					objList.toArray());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return count;
	}

	private void condition(IntegralQueryConditionVo vo, StringBuffer sqlBuf,
			List<Object> objList) {
		if (vo != null) {
			if (StringUtils.isNotEmpty(vo.getType())) {
				switch (Integer.valueOf(vo.getType())) {
				case 1: // 获得积分
					sqlBuf.append(" and t.busines in('POS_SALES','HAND_POINT') ");
					break;
				case 2: // 使用积分
					sqlBuf.append(" and t.busines = 'POS_REDEMPTION' ");
					break;

				default:
					break;
				}
			}

			if (StringUtils.isNotEmpty(vo.getOrigin())) {
				sqlBuf.append(" and (CASE WHEN o.orderSource IS NOT NULL THEN o.orderSource ELSE t.origin END) like ? ");
				objList.add("%" + vo.getOrigin() + "%");
			}

			if (StringUtils.isNotEmpty(vo.getStatus())
					&& !vo.getStatus().equals("0")) {
				sqlBuf.append(" and t.status = ? ");
				objList.add(vo.getStatus());
			}

			if (StringUtils.isNotEmpty(vo.getStartDate())) {
				sqlBuf.append(" and t.transactionDate  >= ? ");
				objList.add(vo.getStartDate());
			}

			if (StringUtils.isNotEmpty(vo.getEndDate())) {
				sqlBuf.append(" and t.transactionDate <= ? ");
				objList.add(vo.getEndDate());
			}

			if (StringUtils.isNotEmpty(vo.getMemName())) {
				sqlBuf.append(" and CONCAT(m.surname,m.name) like ? ");
				objList.add("%" + vo.getMemName() + "%");
			}

			if (StringUtils.isNotEmpty(vo.getMemberCard())) {
				sqlBuf.append(" and mc.cardNumber like ? ");
				objList.add("%" + vo.getMemberCard() + "%");
			}

		}
	}

	@Override
	public List<IntegralReport> getIntegralReportData(
			IntegralQueryConditionVo vo) {
		List<IntegralReport> list = getDataList(vo, null);
		return list;
	}
}
