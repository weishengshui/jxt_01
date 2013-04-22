package com.chinarewards.metro.service.integralManagement;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.SystemTimeProvider;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.account.Account;
import com.chinarewards.metro.domain.account.AccountBalanceUnits;
import com.chinarewards.metro.domain.account.Business;
import com.chinarewards.metro.domain.account.PointExpiredQueue;
import com.chinarewards.metro.domain.account.Transaction;
import com.chinarewards.metro.domain.account.TxStatus;
import com.chinarewards.metro.domain.account.Unit;
import com.chinarewards.metro.domain.account.UnitLedger;
import com.chinarewards.metro.domain.business.OrderInfo;
import com.chinarewards.metro.domain.business.RedemptionDetail;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.merchandise.Merchandise;
import com.chinarewards.metro.domain.user.UserInfo;
import com.chinarewards.metro.model.integral.IntegralCriteria;
import com.chinarewards.metro.models.IntegralAddResp;
import com.chinarewards.metro.models.IntegralConsumeResp;
import com.chinarewards.metro.models.request.IntegralAddReq;
import com.chinarewards.metro.models.request.IntegralConsumeReq;
import com.chinarewards.metro.models.request.MerchandiseInfo;
import com.chinarewards.metro.service.account.IAccountService;
import com.chinarewards.metro.service.member.IMemberService;
import com.chinarewards.metro.service.merchandise.IMerchandiseService;
import com.chinarewards.metro.vo.integral.ExpiryBalanceUnits;
import com.chinarewards.metro.vo.integral.GroupExpiryBalanceUnits;
import com.chinarewards.utils.StringUtil;

@Service
public class IntegralManagementService implements IIntegralManagementService {

	@Autowired
	private HBDaoSupport hbDaoSupport;
	@Autowired
	IMerchandiseService merchandiseService;
	@Autowired
	private IMemberService memberService;

	@Autowired
	private IAccountService accountService;

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Override
	public Unit findUnitById(String id) {

		return hbDaoSupport.findTById(Unit.class, id);
	}

	@Override
	public Unit findUnitByUnitCode(String unitCode) {
		String hql = "from Unit where unitCode = ?";
		return hbDaoSupport.findTByHQL(hql, unitCode);
	}

	@Override
	public Unit createBinkeUnit(Unit unit) {
		unit.setUnitCode(Dictionary.UNIT_CODE_BINKE);
		unit.setUnitId(Dictionary.INTEGRAL_BINKE_ID);
		unit.setAvailableUnit(Dictionary.INTEGRAL_AVAILABLE_UNIT_MONTH);
		unit.setCreatedAt(SystemTimeProvider.getCurrentTime());
		unit.setCreatedBy(UserContext.getUserName());
		unit.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
		unit.setLastModifiedBy(UserContext.getUserName());
		hbDaoSupport.save(new UnitLedger(unit));
		hbDaoSupport.save(unit);
		return unit;
	}

	@Override
	public void updateUnit(Unit unit) {

		unit.setLastModifiedAt(SystemTimeProvider.getCurrentTime());
		unit.setLastModifiedBy(UserContext.getUserName());
		unit.setAvailableUnit(Dictionary.INTEGRAL_AVAILABLE_UNIT_MONTH);
		unit.setUnitCode(Dictionary.UNIT_CODE_BINKE);

		hbDaoSupport.save(new UnitLedger(unit));
		hbDaoSupport.update(unit);

	}

	@Override
	public List<UnitLedger> searchUnitLedgers(IntegralCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchUnitLedgersHQL(criteria, params, false);
		List<UnitLedger> list = hbDaoSupport.executeQuery(hql, params,
				criteria.getPaginationDetail());
		return list;
	}

	@Override
	public Long countUnitLedgers(IntegralCriteria criteria) {

		Map<String, Object> params = new HashMap<String, Object>();
		String hql = buildSearchUnitLedgersHQL(criteria, params, true);

		List<Long> list = hbDaoSupport.executeQuery(hql, params, null);
		if (null != list && list.size() > 0) {
			return list.get(0);
		}
		return 0l;
	}

	protected String buildSearchUnitLedgersHQL(IntegralCriteria criteria,
			Map<String, Object> params, boolean isCount) {

		StringBuffer strBuffer = new StringBuffer();
		if (isCount) {
			strBuffer.append("SELECT COUNT(u) ");
		} else {
			strBuffer.append("SELECT u ");
		}

		strBuffer.append("FROM UnitLedger u WHERE 1=1 "); // 很奇妙

		if (criteria != null) {
			String operationPeople = criteria.getOperationPeople();
			Date start = criteria.getStart();
			Date end = criteria.getEnd();
			if (null != end) {
				end = DateTools.getDateLastSecond(end);
				strBuffer.append(" AND u.operationTime <= :end");
				params.put("end", end);
			}
			if (null != start) {
				strBuffer.append(" AND u.operationTime >= :start");
				params.put("start", start);
			}
			if (null != operationPeople && !operationPeople.isEmpty()) {
				strBuffer
						.append(" AND u.operationPeople like :operationPeople");
				params.put("operationPeople", operationPeople + "%");
			}
			// TODO
			if (!isCount) {
				strBuffer.append(" ORDER BY u.operationTime DESC");
			}
		}
		return strBuffer.toString();
	}

	@Override
	public long countAccounts(Date fromDate, Date toDate) {

		StringBuffer str = new StringBuffer();
		str.append("SELECT a.accountBalance.account.accountId FROM AccountBalanceUnits a WHERE a.accountBalance.unitCode=:unitCode AND a.expired =:expired ");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("expired", false);
		params.put("unitCode", Dictionary.UNIT_CODE_BINKE);
		if (fromDate != null) {
			str.append("AND a.createdAt >=:fromDate");
			params.put("fromDate", fromDate);
		}
		if (toDate != null) {
			str.append(" AND a.createdAt <:toDate");
			params.put("toDate", toDate);
		}
		str.append(" GROUP BY a.accountBalance.account.accountId");
		List<Object> obj = hbDaoSupport.findTs(str.toString(), params);
		return obj.size();

	}

	@Override
	public double amountPoints(Date fromDate, Date toDate) {

		StringBuffer str = new StringBuffer();
		str.append("SELECT SUM(units) FROM AccountBalanceUnits a WHERE a.accountBalance.unitCode=:unitCode AND a.expired =:expired ");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("expired", false);
		params.put("unitCode", Dictionary.UNIT_CODE_BINKE);

		if (fromDate != null) {
			str.append("AND a.createdAt >=:fromDate");
			params.put("fromDate", fromDate);
		}
		if (toDate != null) {
			str.append(" AND a.createdAt <:toDate");
			params.put("toDate", toDate);
		}

		List<Double> l = hbDaoSupport.findTs(str.toString(), params);

		Double amountPonts = l.size() > 0 ? l.get(0) : null;
		return amountPonts == null ? 0d : amountPonts;
	}

	@Override
	public List<ExpiryBalanceUnits> getAccountBlanceUnits(Date fromDate,
			Date toDate, Page page) {

		List<ExpiryBalanceUnits> result = new LinkedList<ExpiryBalanceUnits>();

		List<AccountBalanceUnits> list = accountService
				.findAccountBalanceUnits(fromDate, toDate, page);

		for (AccountBalanceUnits units : list) {
			ExpiryBalanceUnits item = new ExpiryBalanceUnits();

			item.setId(units.getId());
			item.setObtainedAt(units.getCreatedAt());
			item.setOpt(units.getTx().getCreatedBy());
			item.setTransactionNo(units.getTx().getTxId());
			item.setUnits(units.getUnits());
			item.setUnitPrice(units.getUnitPrice());

			Member member = memberService.findMemberByAccountId(units
					.getAccountBalance().getAccount().getAccountId());
			if (null != member) {
				if (null != member.getCard()) {
					item.setMemberCard(member.getCard().getCardNumber());
				}
				item.setMemberName(((member.getSurname() == null) ? "" : member
						.getSurname()) + ((member.getName() == null) ? "" : member
						.getName()));
				item.setMemberMobile(member.getPhone());
			}
			result.add(item);
		}
		return result;
	}

	@Override
	public List<GroupExpiryBalanceUnits> getExpiryHistory(String operator,
			Date fromDate, Date toDate, Page page) {

		List<GroupExpiryBalanceUnits> result = new LinkedList<GroupExpiryBalanceUnits>();
		Map<String, Object> params = new HashMap<String, Object>();

		StringBuffer thql = new StringBuffer(
				"FROM Transaction t WHERE t.busines=:business ");
		params.put("business", Business.EXPIRY_POINT);

		Calendar calendar = Calendar.getInstance();
		if (fromDate != null) {
			thql.append(" AND t.createdAt >=:fromDate");
			calendar.setTime(fromDate);
			calendar.set(Calendar.HOUR, 00);
			calendar.set(Calendar.MINUTE, 00);
			calendar.set(Calendar.SECOND, 00);
			calendar.set(Calendar.MILLISECOND, 00);

			fromDate = calendar.getTime();
			params.put("fromDate", fromDate);
		}
		if (toDate != null) {
			calendar.setTime(toDate);
			calendar.set(Calendar.HOUR, 00);
			calendar.set(Calendar.MINUTE, 00);
			calendar.set(Calendar.SECOND, 00);
			calendar.set(Calendar.MILLISECOND, 00);
			calendar.add(Calendar.DAY_OF_MONTH, 1);

			toDate = calendar.getTime();

			params.put("toDate", toDate);
			thql.append(" AND t.createdAt <:toDate");
		}
		logger.trace("##Operator : " + operator);
		if (!StringUtils.isEmpty(operator)) {
			thql.append(" AND EXISTS(SELECT u FROM UserInfo u WHERE u.id=t.createdBy AND u.userName like :userName)");
			params.put("userName", "%" + operator + "%");
		}
		thql.append(" ORDER BY t.transactionDate desc");
		List<Transaction> list = hbDaoSupport.findTsByHQLPage(thql.toString(),
				params, page);

		String hql = "SELECT SUM(p.accBalanceUnits.units) FROM PointExpiredQueue p WHERE p.tx=?";
		String chql = "SELECT p.accBalanceUnits.accountBalance.account.accountId FROM PointExpiredQueue p WHERE p.tx=? GROUP BY p.accBalanceUnits.accountBalance.account.accountId ";
		for (Transaction tx : list) {
			String txId = tx.getTxId();
			GroupExpiryBalanceUnits item = new GroupExpiryBalanceUnits();

			UserInfo user = hbDaoSupport.findTById(UserInfo.class,
					Integer.parseInt(tx.getCreatedBy()));
			item.setOpt(user != null ? user.getUserName() : "");

			String status = "";
			switch (tx.getStatus()) {
			case COMPLETED:
				status = "完成";
				break;
			case DISABLED:
				status = "失效";
				break;
			case FROZEN:
				status = "冻结";
				break;
			case RETURNED:
				status = "退单";
				break;
			}
			item.setStatus(status);
			item.setTransactionDate(tx.getTransactionDate());
			item.setTransactionNo(txId);

			Double amount = hbDaoSupport.findTByHQL(hql, tx);
			List cl = hbDaoSupport.findTsByHQL(chql, tx);

			item.setAmountPoints(amount == null ? 0d : amount);
			item.setCountMembers(cl == null ? 0 : cl.size());

			result.add(item);
		}
		return result;
	}

	@Override
	public List<ExpiryBalanceUnits> getExpiedDetailHistory(
			String transactionNo, Page page) {

		List<ExpiryBalanceUnits> result = new LinkedList<ExpiryBalanceUnits>();

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("transactionNo", transactionNo);
		List<PointExpiredQueue> list = hbDaoSupport.findTsByHQLPage(
				"FROM PointExpiredQueue p WHERE p.tx.txId=:transactionNo ",
				params, page);
		for (PointExpiredQueue units : list) {
			ExpiryBalanceUnits item = new ExpiryBalanceUnits();

			item.setId(units.getId());
			item.setObtainedAt(units.getCreatedAt());
			item.setOpt(units.getTx().getCreatedBy());
			item.setTransactionNo(units.getTx().getTxId());
			item.setUnits(units.getAccBalanceUnits().getUnits());
			item.setUnitPrice(units.getAccBalanceUnits().getUnitPrice());
			Member member = memberService.findMemberByAccountId(units
					.getAccBalanceUnits().getAccountBalance().getAccount()
					.getAccountId());

			if (null != member) {
				if (null != member.getCard()) {
					item.setMemberCard(member.getCard().getCardNumber());
				}
				if (null != member.getSurname()) {
					item.setMemberName(member.getSurname() + member.getName());
				} else {
					item.setMemberName(member.getName());
				}
				
				if (StringUtils.isNotEmpty(member.getPhone())) {
					int flag = member.getPhone().indexOf("_");
					String phone = (flag > 0) ? member.getPhone().substring(0,
							flag) : member.getPhone();
					item.setMemberMobile(phone);
				}
			}
			result.add(item);
		}
		return result;
	}

	@Override
	public IntegralConsumeResp useIntegral(IntegralConsumeReq req,IntegralConsumeResp resp) {
       
	    Member m=memberService.findMemberById(Integer.valueOf(req.getUserId()));
		
		if(m==null){
			resp.setErrorInformation("该用户不存在！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(m.getStatus()==2){
			resp.setErrorInformation("该用户未激活！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(m.getStatus()==3){
			resp.setErrorInformation("该用户已 注销！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else{
			  boolean isExist=true;
			  Transaction tx=null;
				Date transactionDate =DateTools.dateToHour24();
				Account account =accountService.findAccount("0", m.getAccount());
				if(account==null){
					resp.setErrorInformation("该用户对应账号不存在！");
					resp.setOperateStatus(0);
					resp.setStatusDescription("失败！");
					isExist=false;
				}
				if(req.getCommodityIdList().size()>0){
					for (int i = 0; i < req.getCommodityIdList().size(); i++) {
						MerchandiseInfo com=req.getCommodityIdList().get(i);
						if(com!=null){
							Merchandise merchandise=merchandiseService.findMerchandiseById(com.getMerchandiseId());
							if(StringUtil.isEmptyString(com.getMerchandiseId())||com.getMerchandiseId()==null){
								resp.setErrorInformation(com.getMerchandiseId()+"商品id不能为空！");
								resp.setOperateStatus(0);
								resp.setStatusDescription("失败！");
								isExist=false;
								break;
							}else if(merchandise==null){
								resp.setErrorInformation(com.getMerchandiseId()+"商品不存在！");
								resp.setOperateStatus(0);
								resp.setStatusDescription("失败！");
								isExist=false;
								break;
							}else if(com.getCount()<=0){
								resp.setErrorInformation(com.getMerchandiseId()+"商品数量填写有误！");
								resp.setOperateStatus(0);
								resp.setStatusDescription("失败！");
								isExist=false;
								break;
							}
						}
					}
				}else{
					resp.setErrorInformation("请填写商品！");
					resp.setOperateStatus(0);
					resp.setStatusDescription("失败！");
					isExist=false;
				}
				if(isExist){
					boolean cheorderno= memberService.chechOrderNo(req.getOrderId());
					double avalableJiFen=0 ;
					if(cheorderno){
						 avalableJiFen = accountService.getAccountBalance(account,
								Dictionary.UNIT_CODE_BINKE);
						//扣除该积分
						try {
							if(req.getPoint()!=0&&req.getPoint()<=avalableJiFen){
								//交易
								 tx=accountService.createTransaction("0",
										Business.EXT_REDEMPTION, transactionDate, TxStatus.COMPLETED);
								accountService.withdrawal("0", account, Dictionary.UNIT_CODE_BINKE, req.getPoint(), tx);
								
								 //保存该订单
								OrderInfo orderInfo=new OrderInfo();
								orderInfo.setOrderNo(req.getOrderId());
								orderInfo.setAccount(account);
								orderInfo.setTx(tx);
								orderInfo.setBeforeUnits(new BigDecimal(avalableJiFen));
								orderInfo.setUsingCode(new BigDecimal(req.getPoint()));
								orderInfo.setOrderTime(req.getOperateTime());
								orderInfo.setOrderSource(req.getOrderSource());
								orderInfo.setType(1);
								hbDaoSupport.save(orderInfo);
							    int redemptionQuantity=0;
								//查看该商品存在不    
								for (int i = 0; i < req.getCommodityIdList().size(); i++) {
									MerchandiseInfo com=req.getCommodityIdList().get(i);
									if(com!=null){
										Merchandise merchandise=merchandiseService.findMerchandiseById(com.getMerchandiseId());
										
											redemptionQuantity+=com.getCount();
											 orderInfo.setRedemptionQuantity(redemptionQuantity);
												RedemptionDetail rDetail = new RedemptionDetail();
												rDetail.setMerchandiseId(merchandise.getId());
												rDetail.setMerchandiseName(merchandise.getName());
												rDetail.setOrderInfo(orderInfo);
												rDetail.setPurchasePrice(merchandise.getPurchasePrice());
												rDetail.setQuantity(com.getCount());
												hbDaoSupport.save(rDetail);
									}
								}
								resp.setOperateStatus(1);
								resp.setStatusDescription("成功！");
							}else{
							
								resp.setErrorInformation(m.getAccount()+"该帐号用户积分不足");
								resp.setOperateStatus(0);
								resp.setStatusDescription("失败！");
							}
						} catch (Exception e) {
							e.printStackTrace();
							resp.setErrorInformation(e.getMessage());
							resp.setOperateStatus(0);
							resp.setStatusDescription("失败！");
							isExist=false;
						}
				}else{
					resp.setOperateStatus(0);
					resp.setStatusDescription("失败！");
					resp.setErrorInformation("订单号不能重复！");
					isExist=false;
				}
			}
		}
		return resp;
	}
 
	@Override
	public IntegralAddResp addIntegral(IntegralAddReq req) {
		IntegralAddResp resp=new IntegralAddResp();
		Member m=memberService.findMemberById(Integer.valueOf(req.getUserId()));
		if(m==null){
			resp.setErrorInformation("该用户不存在！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(m.getStatus()==2){
			resp.setErrorInformation("该用户未激活！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else if(m.getStatus()==3){
			resp.setErrorInformation("该用户已 注销！");
			resp.setOperateStatus(0);
			resp.setStatusDescription("失败！");
		}else{
			  boolean isExist=true;
			Account account =accountService.findAccount("0", m.getAccount());
			if(account==null){
				resp.setErrorInformation("该用户对应账号不存在！");
				resp.setOperateStatus(0);
				resp.setStatusDescription("失败！");
				isExist=false;
			}
			
			if(req.getCommodityIdList().size()>0){
				for (int i = 0; i < req.getCommodityIdList().size(); i++) {
					MerchandiseInfo com=req.getCommodityIdList().get(i);
					if(com!=null){
						Merchandise merchandise=merchandiseService.findMerchandiseById(com.getMerchandiseId());
						if(StringUtil.isEmptyString(com.getMerchandiseId())||com.getMerchandiseId()==null){
							resp.setErrorInformation(com.getMerchandiseId()+"商品id不能为空！");
							resp.setOperateStatus(0);
							resp.setStatusDescription("失败！");
							isExist=false;
							break;
						}else if(merchandise==null){
							resp.setErrorInformation(com.getMerchandiseId()+"商品不存在！");
							resp.setOperateStatus(0);
							resp.setStatusDescription("失败！");
							isExist=false;
							break;
						}else if(com.getCount()<=0){
							resp.setErrorInformation(com.getMerchandiseId()+"商品数量填写有误！");
							resp.setOperateStatus(0);
							resp.setStatusDescription("失败！");
							isExist=false;
							break;
					}
				}}
			}else{
				resp.setErrorInformation("请填写商品！");
				resp.setOperateStatus(0);
				resp.setStatusDescription("失败！");
				isExist=false;
			}

			Transaction tx= new Transaction();
		 if(isExist){
			 try {
					//交易
					Date transactionDate =DateTools.dateToHour24();
					 tx=accountService.createTransaction("0",
							Business.EXT_REDEMPTION, transactionDate, TxStatus.COMPLETED);
					double avalableJiFen = accountService.getAccountBalance(account,
							Dictionary.UNIT_CODE_BINKE);
					 //保存该订单
					OrderInfo orderInfo=new OrderInfo();
					orderInfo.setOrderNo(tx.getTxId());
					orderInfo.setAccount(account);
					orderInfo.setTx(tx);
					BigDecimal orderPrice=new BigDecimal(req.getMoney()); 
					orderInfo.setOrderPrice(orderPrice);
					if(!"".equals(req.getPoint())){
						 //获得积分
						orderInfo.setIntegration(new BigDecimal(req.getPoint()));
					}
					orderInfo.setBeforeUnits(new BigDecimal(avalableJiFen));
					orderInfo.setOrderTime(req.getOperateTime());
					orderInfo.setOrderSource(req.getRequestRource());
					orderInfo.setType(0);
					hbDaoSupport.save(orderInfo);
					  int redemptionQuantity=0;
					  logger.trace(tx.getTxId());
				   for (int i = 0; i < req.getCommodityIdList().size(); i++) {
					    MerchandiseInfo com=req.getCommodityIdList().get(i);
						if(com!=null){
							logger.trace(com.getMerchandiseId());
							Merchandise merchandise=merchandiseService.findMerchandiseById(com.getMerchandiseId());
								redemptionQuantity+=com.getCount();
								 orderInfo.setRedemptionQuantity(redemptionQuantity);
									RedemptionDetail rDetail = new RedemptionDetail();
									rDetail.setMerchandiseId(merchandise.getId());
									rDetail.setMerchandiseName(merchandise.getName());
									rDetail.setOrderInfo(orderInfo);
									hbDaoSupport.save(rDetail);
						}
			 		}
			     //增加积分
					if(!"".equals(req.getPoint())){
						Unit unit=new Unit();
						unit=this.findUnitByUnitCode(Dictionary.UNIT_CODE_BINKE);
						accountService.deposit("0", account, unit,Double.valueOf(req.getPoint()) , tx);
						resp.setOperateStatus(1);
						resp.setStatusDescription("成功！");
					}
				} catch (Exception e) {
					resp.setErrorInformation(e.getMessage());
					resp.setOperateStatus(0);
					resp.setStatusDescription("失败！");
				}
		    }
		}
		return resp;
	}

}
