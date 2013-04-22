package com.chinarewards.metro.service.account;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.chinarewards.metro.domain.account.Transaction;
import com.chinarewards.metro.models.SalesResp;
import com.chinarewards.metro.models.order.ExtOrderInfo;
import com.chinarewards.metro.models.order.OrderResp;
import com.chinarewards.metro.models.order.OrderRespArray;

public interface ITransactionService {

	/**
	 * 失效指定的余额积分
	 * 
	 * @param token
	 *            userId
	 * @param accBalanceUnitsId
	 *            余额明细Id
	 * @return
	 */
	public Transaction expiryMemberPoints(String token,
			String... accBalanceUnitsId);

	/**
	 * 失效时间段内的会员积分
	 * 
	 * @param token
	 * @param fromDate
	 * @param toDate
	 * @return
	 */
	public Transaction expiryMemberPoints(String token, Date fromDate,
			Date toDate);

	/**
	 * pos获取积分
	 * 
	 * @param token
	 * @param consumeDetails
	 * @param posId
	 * @param identity
	 * @param serialId
	 * @return
	 */
	public SalesResp posSales(String token,
			Map<Long/* 消费类型 */, Double/* 消费金额 */> consumeDetails, String posId,
			String identity/* mobile or cardNo */, Long serialId,boolean resend);

	/**
	 * 处理外部订单
	 * 
	 * @param orderInfo
	 * @return
	 */
	public OrderResp processExtOrder(ExtOrderInfo orderInfo);

	/**
	 * 批量处理外部订单
	 * 
	 * @param orderList
	 * @return
	 */
	public OrderRespArray processExtOrders(List<ExtOrderInfo> orderList);

}
