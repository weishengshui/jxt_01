package com.chinarewards.metro.service.account;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.POSSalesCode;
import com.chinarewards.metro.domain.account.Account;
import com.chinarewards.metro.domain.account.AccountBalanceUnits;
import com.chinarewards.metro.domain.account.Business;
import com.chinarewards.metro.domain.account.PointExpiredQueue;
import com.chinarewards.metro.domain.account.QueueStatus;
import com.chinarewards.metro.domain.account.Transaction;
import com.chinarewards.metro.domain.account.TransactionQueue;
import com.chinarewards.metro.domain.account.TxStatus;
import com.chinarewards.metro.domain.account.Unit;
import com.chinarewards.metro.domain.business.OrderInfo;
import com.chinarewards.metro.domain.business.POSSalesDetail;
import com.chinarewards.metro.domain.member.Member;
import com.chinarewards.metro.domain.pos.PosBind;
import com.chinarewards.metro.domain.rules.BirthRule;
import com.chinarewards.metro.domain.rules.IntegralRule;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.factory.order.OrderInfoFactory;
import com.chinarewards.metro.models.DiscountUseCodeResp;
import com.chinarewards.metro.models.SalesResp;
import com.chinarewards.metro.models.order.ExtOrderInfo;
import com.chinarewards.metro.models.order.OrderResp;
import com.chinarewards.metro.models.order.OrderRespArray;
import com.chinarewards.metro.models.order.OrderRespErrorCode;
import com.chinarewards.metro.models.request.DiscountUseCodeReq;
import com.chinarewards.metro.repository.global.SysDefinesRepository;
import com.chinarewards.metro.repository.order.OrderRepository;
import com.chinarewards.metro.repository.shop.ShopRepository;
import com.chinarewards.metro.service.discount.IDiscountService;
import com.chinarewards.metro.service.integral.IRuleService;
import com.chinarewards.metro.service.member.IMemberService;
import com.chinarewards.metro.service.system.ISysLogService;
import com.chinarewards.metro.support.account.RuleMatcher;

@Service
public class TransactionService implements ITransactionService {

	@Autowired
	IAccountService accountService;

	@Autowired
	IMemberService memberService;

	@Autowired
	IRuleService ruleService;

	@Autowired
	HBDaoSupport hbDaoSupport;

	@Autowired
	RuleMatcher ruleMatcher;

	@Autowired
	OrderInfoFactory orderInfoFactory;

	@Autowired
	OrderRepository orderRepository;

	@Autowired
	ShopRepository shopRepository;

	@Autowired
	SysDefinesRepository sysDefinesRepository;

	@Autowired
	IDiscountService discountService;

	@Autowired
	ISysLogService sysLogService;

	SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMddHHmmss");

	public Transaction expiryMemberPoints(String token, Date fromDate,
			Date toDate) {

		if (fromDate == null || toDate == null) {
			throw new IllegalArgumentException(
					"Invalid parameters that not allow null!");
		}
		List<AccountBalanceUnits> accBalanceUnits = accountService
				.findAccountBalanceUnits(fromDate, toDate);

		if (null != accBalanceUnits && accBalanceUnits.size() > 0) {
			Transaction tx = accountService.createTransaction(token,
					Business.EXPIRY_POINT, new Date());
			for (AccountBalanceUnits abu : accBalanceUnits) {
				processExpiryAccBalanceUnits(token, tx, abu);
			}

			sysLogService.addSysLog("积分失效管理",
					fmt.format(fromDate) + "~" + fmt.format(toDate),
					OperationEvent.EVENT_EXPIRY.getName(), "成功");
			return tx;
		}
		return null;
	}

	protected void processExpiryAccBalanceUnits(String token, Transaction tx,
			AccountBalanceUnits accBalanceUnits) {

		// 过期积分
		accountService.expiryBalanceUnits(token, tx, accBalanceUnits);

		// 保存队列
		PointExpiredQueue queue = new PointExpiredQueue();
		queue.setAccBalanceUnits(accBalanceUnits);
		queue.setCreatedAt(new Date());
		queue.setStatus(QueueStatus.doned);
		queue.setTx(tx);

		hbDaoSupport.save(queue);
	}

	@Override
	public Transaction expiryMemberPoints(String token,
			String... accBalanceUnitsId) {

		Transaction tx = accountService.createTransaction(token,
				Business.EXPIRY_POINT, new Date());

		for (String id : accBalanceUnitsId) {
			AccountBalanceUnits abu = accountService
					.findAccountBalanceUnits(id);
			processExpiryAccBalanceUnits(token, tx, abu);
		}
		return tx;
	}

	public String templateOutput(String template, String merchantCode,
			String memberCode, String amountConsume, String amountPoint,
			String serviceLine) {

		return template.replace("${merchantCode}", merchantCode)
				.replace("${memberCode}", memberCode)
				.replace("${amountConsume}", amountConsume)
				.replace("${amountPoint}", amountPoint)
				.replace("${serviceLine}", serviceLine);
	}

	protected SalesResp checkResendPosSales(String token,
			Map<Long, Double> consumeDetails, String posId, String identity,
			Long serialId, boolean resend) {

		OrderInfo order = orderRepository.findOrderInfo(posId,
				Business.POS_SALES, serialId);
		if (!resend && null == order) {
			return null;
		} else {
			if (resend && null == order) {
				int count = 1;
				while (order == null) {
					try {
						// 尝试3次后就退出
						if (count == 3) {
							break;
						}
						count ++ ;
						Thread.currentThread().sleep(count * 100);
					} catch (InterruptedException e) {
						System.err.println("Retring get order thread failed."
								+ e.getMessage());
					}
					order = orderRepository.findOrderInfo(posId,
							Business.POS_SALES, serialId);
				}
			}

			// 为处理过的重发，重新交易返回数据
			if (null == order) {
				return null;
			}

			SalesResp resp = new SalesResp();
			resp.setResult(POSSalesCode.SUCCESS);
			resp.setXactTime(order.getTx().getTransactionDate());

			resp.setTransactionNo(order.getTx().getTxId());

			resp.setTitle(order.getShop().getName()
					+ "\n"
					+ sysDefinesRepository
							.getVariable(Dictionary.V_POSSALES_MEMBER_TITLE));
			String content = templateOutput(
					sysDefinesRepository
							.getVariable(Dictionary.V_POSSALES_MEMBER_CONTENT),
					String.valueOf(order.getShop().getId()), identity, order
							.getOrderPrice().toString(), String.valueOf(order
							.getIntegration().longValue()),
					sysDefinesRepository.getVariable(Dictionary.V_SERVICE_LINE));
			resp.setTip(content);
			return resp;
		}
	}

	@Override
	public SalesResp posSales(String token, Map<Long, Double> consumeDetails,
			String posId, String identity, Long serialId, boolean resend) {

		SalesResp result = checkResendPosSales(token, consumeDetails, posId,
				identity, serialId, resend);
		if (null != result) {
			return result;
		}

		result = new SalesResp();
		Date transactionDate = new Date();
		result.setXactTime(transactionDate);
		try {
			PosBind pos = shopRepository.findBindPos(posId);
			if (null == pos) {
				result.setResult(POSSalesCode.INVALID_POS);
				return result;
			}

			// get shop
			Shop shop = shopRepository.findShop(posId);
			if (null == shop) {
				result.setResult(POSSalesCode.OTHERS);
				return result;
			}

			// get member
			Member member = memberService.findMemberByCardNo(identity);
			if (null == member) {
				member = memberService.findMemberByPhone(identity);
			}
			if (null == member) {
				result.setResult(POSSalesCode.MEMBER_NOT_EXISTS);
				return result;
			}
			Account account = accountService.findAccount(token,
					member.getAccount());

			// get rules
			List<IntegralRule> rules = ruleService.findAll();
			// match rules
			Map<IntegralRule, Double> matcheds = ruleMatcher.match(member,
					consumeDetails, rules, transactionDate);
			Set<Entry<IntegralRule, Double>> set = matcheds.entrySet();

			double total = 0d;
			Iterator<Entry<IntegralRule, Double>> iterator = set.iterator();
			StringBuffer matchrules = new StringBuffer();
			while (iterator.hasNext()) {
				Entry<IntegralRule, Double> item = iterator.next();
				total = NumberHelper.add(total, item.getValue());

				// 规则保存id 　
				matchrules.append(item.getKey().getId() + ",");
			}

			List<BirthRule> bithDayRules = ruleService.findBirthRule();
			if (null != bithDayRules && bithDayRules.size() == 1) {

				double bithdayRates = ruleMatcher.matchBirthday(member,
						consumeDetails, bithDayRules.get(0).getTimes(),
						transactionDate);
				if (bithdayRates > 0) {
					// 生日保存值
					matchrules.append(bithDayRules.get(0).getTimes());
					total = NumberHelper.add(total, bithdayRates);
				}
			}
			// mutipart birthday rules found error .
			else if (null != bithDayRules && bithDayRules.size() > 1) {
				throw new IllegalStateException(
						"Mutipart birthday rules found!");
			}

			Transaction tx = accountService.createTransaction(token,
					Business.POS_SALES, transactionDate, TxStatus.FROZEN);

			double consumeAmount = ruleMatcher.amount(consumeDetails);

			BigDecimal total_rates = null;

			// 匹配到了规则，返回匹配倍数
			if (total > 0) {
				total_rates = new BigDecimal(String.valueOf(total));
			}
			// 未匹配到规则，基本规则，消费金额数等于积分数
			else {
				total_rates = new BigDecimal(String.valueOf(consumeAmount));
			}

			double balance = accountService.getAccountBalance(account,
					Dictionary.UNIT_CODE_BINKE);
			// save order
			OrderInfo orderInfo = orderInfoFactory.createPOSSaleOrder(shop,
					account, pos, tx, serialId, transactionDate,
					new BigDecimal(String.valueOf(consumeAmount)),
					transactionDate, total_rates, "POS获取积分", null != member
							.getCard() ? member.getCard().getCardNumber()
							: null, matchrules.toString(), balance);

			hbDaoSupport.save(orderInfo);

			// 保存到冻结队列
			TransactionQueue queue = new TransactionQueue();
			queue.setAccount(account);
			queue.setCreatedAt(transactionDate);
			queue.setCreatedBy(token);
			queue.setTx(tx);
			queue.setType(0);
			queue.setUnits(total_rates);
			queue.setUnitCode(Dictionary.UNIT_CODE_BINKE);
			hbDaoSupport.save(queue);

			// 保存消费明细
			for (long key : consumeDetails.keySet()) {

				POSSalesDetail saleDetail = new POSSalesDetail();
				saleDetail.setConsumeType(String.valueOf(key));
				saleDetail.setQuantity(new BigDecimal(consumeDetails.get(key)));
				saleDetail.setOrder(orderInfo);
			}

			result.setTransactionNo(tx.getTxId());

			String name = shop.getName();
			result.setTitle(name
					+ "\n"
					+ sysDefinesRepository
							.getVariable(Dictionary.V_POSSALES_MEMBER_TITLE));

			String content = templateOutput(
					sysDefinesRepository
							.getVariable(Dictionary.V_POSSALES_MEMBER_CONTENT),
					String.valueOf(shop.getId()), identity, String
							.valueOf(consumeAmount), String.valueOf(total_rates
							.longValue()), sysDefinesRepository
							.getVariable(Dictionary.V_SERVICE_LINE));
			result.setTip(content);
			result.setResult(POSSalesCode.SUCCESS);
		} catch (Exception e) {
			e.printStackTrace();
			result.setResult(POSSalesCode.FAIL);
			TransactionAspectSupport.currentTransactionStatus()
					.setRollbackOnly();
		}
		return result;
	}

	@Override
	public OrderResp processExtOrder(ExtOrderInfo orderInfo) {

		OrderResp resp = new OrderResp();
		resp.setOrdered(orderInfo.getOrderId());
		resp.setResponseTime(fmt.format(new Date()));

		// 订单ID 不能为空
		if (StringUtils.isEmpty(orderInfo.getOrderId())) {
			resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
			resp.setResponseText("订单ID 不能为空");
			return resp;
		}

		// 门店ID不能为 空
		if (StringUtils.isEmpty(orderInfo.getShopId())) {
			resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
			resp.setResponseText("门店ID不能为 空");
			return resp;
		}

		// posid 为必选参数
		if (StringUtils.isEmpty(orderInfo.getPosId())) {
			resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
			resp.setResponseText("posid 为必选参数");
			return resp;
		}

		// 订单状态 为必选参数
		if (StringUtils.isEmpty(orderInfo.getOrderState())) {
			resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
			resp.setResponseText("订单状态 为必选参数");
			return resp;
		}

		PosBind posBind = shopRepository.findBindPos(orderInfo.getPosId());
		// 不存在的POS 终端号
		if (null == posBind) {
			resp.setResponseCode(OrderRespErrorCode.POS_NOT_EXISTS);
			resp.setResponseText("不存在的POS 终端号");
			return resp;
		}

		// 门店 POS 的关系不 存在
		if (posBind.getMark() == 0
				|| posBind.getfId() != Integer.parseInt(orderInfo.getShopId())) {
			resp.setResponseCode(OrderRespErrorCode.INVALID_SHOP_POS);
			resp.setResponseText("门店 POS 的关系不 存在");
			return resp;
		}

		// 营业员为必填项 需求二中已经去除
		/*
		 * if (StringUtils.isEmpty(orderInfo.getClerkId())) {
		 * resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
		 * resp.setResponseText("营业员为必填项"); return resp; }
		 */

		// 订单来源为必填项
		if (StringUtils.isEmpty(orderInfo.getOrderSource())) {
			resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
			resp.setResponseText("订单来源为必填项");
			return resp;
		}

		// 订单金额为必填项
		if (StringUtils.isEmpty(orderInfo.getOrderPrice())) {
			resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
			resp.setResponseText("订单金额为必填项");
			return resp;
		}

		// 使用现金不为空的话，必须为正数
		if (!StringUtils.isEmpty(orderInfo.getCash())) {
			try {
				int l = Integer.parseInt(orderInfo.getCash());
				if (l < 0) {
					resp.setResponseText("使用现金数需为正数");
					resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
					return resp;
				}
			} catch (NumberFormatException e) {
				resp.setResponseText("使用现金需为数字类型");
				resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
				return resp;
			}
		}

		// 使用银行支付不为空的话，必须为正数
		if (!StringUtils.isEmpty(orderInfo.getBankPay())) {
			try {
				int l = Integer.parseInt(orderInfo.getBankPay());
				if (l < 0) {
					resp.setResponseText("使用银行支付需为正数");
					resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
					return resp;
				}
			} catch (NumberFormatException e) {
				resp.setResponseText("使用银行支付需为数字类型");
				resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
				return resp;
			}
		}

		// 订单金额必须为正整型
		try {
			long l = Long.parseLong(orderInfo.getOrderPrice());
			if (l < 0) {
				resp.setResponseText("订单金额需为正数");
				resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
				return resp;
			}
		} catch (NumberFormatException e) {
			resp.setResponseText("订单金额需为数字类型");
			resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
			return resp;
		}

		// 累积积分数为必填项
		if (StringUtils.isEmpty(orderInfo.getIntegration())) {
			resp.setResponseText("累积积分数为必填项");
			resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
			return resp;
		}

		// 累积积分数必须为浮点型
		try {
			double d = Double.parseDouble(orderInfo.getIntegration());
			if (d < 0) {
				resp.setResponseText("累积积分数必须为浮点型");
				resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
				return resp;
			}
		} catch (NumberFormatException e) {
			resp.setResponseText("累积积分数必须为数字类型");
			resp.setResponseCode(OrderRespErrorCode.ILLEGAL_ARGUMENT);
			return resp;
		}

		// 检查是否重复
		OrderInfo entity = orderRepository
				.findOrderByNo(orderInfo.getOrderId());
		if (entity != null && !StringUtils.isEmpty(entity.getOrderNo())) {
			resp.setResponseCode(OrderRespErrorCode.REPEART);
			resp.setResponseText("重复提交订单");
			return resp;
		}

		OrderInfo order = null;
		try {
			OrderInfoFactory factory = new OrderInfoFactory();
			// find member
			Member member = memberService.findMemberById(Integer
					.parseInt(orderInfo.getUserId()));

			// 会员不存在
			if (null == member
					|| member.getStatus() == Dictionary.MEMBER_STATE_LOGOUT) {
				resp.setResponseText("会员不存在");
				resp.setResponseCode(OrderRespErrorCode.MEMBER_NOT_EXISTS);
				return resp;
			}

			Account memAccount = accountService.findAccountByMember(member);

			// find shop
			Shop shop = shopRepository.findShopById(orderInfo.getShopId());

			// 门店不存在
			if (null == shop) {
				resp.setResponseText("门店不存在");
				resp.setResponseCode(OrderRespErrorCode.SHOP_NOT_EXISTS);
				return resp;
			}

			order = factory.createExtOrderInfo(memAccount, shop, orderInfo);

			double bkBalance = accountService.getAccountBalance(memAccount,
					Dictionary.UNIT_CODE_BINKE);
			double rmbBalance = accountService.getAccountBalance(memAccount,
					Dictionary.UNIT_CODE_RMB);
			order.setBeforeCash(new BigDecimal(String.valueOf(rmbBalance)));
			order.setBeforeUnits(new BigDecimal(String.valueOf(bkBalance)));

			Transaction tx = accountService.createTransaction("0",
					Business.EXT_ORDER, new Date());
			order.setTx(tx);

			// 假如优惠码非空使用优惠码
			if (!StringUtils.isEmpty(orderInfo.getCouponCode())) {
				try {
					DiscountUseCodeReq req = new DiscountUseCodeReq();
					req.setCouponCode(orderInfo.getCouponCode());
					req.setUserId(orderInfo.getUserId());
					req.setShopOrActivityId(orderInfo.getShopId());
					req.setCouponType(1);
					DiscountUseCodeResp r = discountService
							.useDiscountNumber2(req);
					String useStatus = r.getUsedState();
					if (!useStatus.equals("1")) {
						throw new IllegalArgumentException(
								"invalid coupon that id :"
										+ orderInfo.getCouponCode()
										+ " errorCode:" + useStatus);
					}
				} catch (Exception e) {
					e.printStackTrace();
					resp.setResponseText("无效优惠码,错误描述: " + e.getMessage());
					resp.setResponseCode(OrderRespErrorCode.INVALID_COUPON);
					return resp;
				}
			}

			// 获取积分
			if (null != order.getIntegration()
					&& order.getIntegration().doubleValue() > 0) {
				order.setType(0);
				Unit unit = accountService
						.getUnitById(Dictionary.INTEGRAL_BINKE_ID);
				accountService.deposit("0", memAccount, unit, order
						.getIntegration().doubleValue(), tx);
			}
			hbDaoSupport.save(order);
			resp.setResponseCode(OrderRespErrorCode.SUCCESS);
			return resp;
		} catch (ParseException e) {
			throw new IllegalArgumentException(e);
		}
	}

	@Override
	public OrderRespArray processExtOrders(List<ExtOrderInfo> orderList) {
		OrderRespArray resp = new OrderRespArray();
		for (ExtOrderInfo o : orderList) {
			try {
				OrderResp result = processExtOrder(o);
				resp.getList().add(result);
			} catch (Exception e) {
				e.printStackTrace();
				OrderResp r = new OrderResp();
				r.setOrdered(o.getOrderId());
				r.setResponseCode(OrderRespErrorCode.FAIL);
				r.setResponseTime(fmt.format(new Date()));
				resp.getList().add(r);
			}
		}
		return resp;
	}
}
