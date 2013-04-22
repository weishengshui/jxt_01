package com.chinarewards.metro.factory.order;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Repository;

import com.chinarewards.metro.domain.account.Account;
import com.chinarewards.metro.domain.account.Transaction;
import com.chinarewards.metro.domain.business.OrderInfo;
import com.chinarewards.metro.domain.pos.PosBind;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.models.order.ExtOrderInfo;

@Repository
public class OrderInfoFactory {

	public OrderInfo createExtOrderInfo(Account memberAccount, Shop shop,
			ExtOrderInfo extOrder) throws ParseException {

		BigDecimal ts = new BigDecimal(100);
		
		SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMddHHmmss");

		OrderInfo orderInfo = new OrderInfo();

		orderInfo.setAccount(memberAccount);

		if (!StringUtils.isEmpty(extOrder.getBankPay())) {
			orderInfo.setBankPay(new BigDecimal(extOrder.getBankPay()).divide(ts));
		}

		if (!StringUtils.isEmpty(extOrder.getCash())) {
			orderInfo.setCash(new BigDecimal(extOrder.getCash()).divide(ts));
		}

		orderInfo.setClerkId(extOrder.getClerkId());

		orderInfo.setCouponCode(extOrder.getCouponCode());

		// 
		if(StringUtils.isNotEmpty(extOrder.getDeliverTime())){
			orderInfo.setDeliverTime(fmt.parse(extOrder.getDeliverTime()));
		}
		
		if (!StringUtils.isEmpty(extOrder.getIntegration())) {
			orderInfo.setIntegration(new BigDecimal(extOrder.getIntegration()));
		}


		orderInfo.setOrderNo(extOrder.getOrderId());

		if (!StringUtils.isEmpty(extOrder.getOrderPrice())) {
			orderInfo.setOrderPrice(new BigDecimal(extOrder.getOrderPrice()).divide(ts));
		}

		orderInfo.setOrderSource(extOrder.getOrderSource());

		orderInfo.setOrderTime(fmt.parse(extOrder.getOrderTime()));

		orderInfo.setPosCode(extOrder.getPosId());
		
		orderInfo.setOrderState(extOrder.getOrderState());
		orderInfo.setMemberId(extOrder.getUserId());
		
		orderInfo.setShop(shop);

		return orderInfo;
	}

	public OrderInfo createPOSSaleOrder(Shop shop, Account memberAccount,
			PosBind pos, Transaction tx, long serialId, Date orderTime,
			BigDecimal orderPrice, Date deliverTime,
			BigDecimal /* 积分总数 */integration, String orderSource,
			String memberCard, String matchedRules, double accBalance) {

		OrderInfo orderInfo = new OrderInfo();
		orderInfo.setAccount(memberAccount);
		orderInfo.setShop(shop);

		// orderInfo.setPosBind(pos);
		orderInfo.setPosCode(pos.getCode());

		orderInfo.setDeliverTime(deliverTime);
		orderInfo.setOrderTime(orderTime);
		orderInfo.setTx(tx);
		orderInfo.setSerialId(String.valueOf(serialId));
		orderInfo.setOrderPrice(orderPrice);
		orderInfo.setIntegration(integration);
		orderInfo.setOrderSource(orderSource);
		//orderInfo.setMemberCard(memberCard);
		orderInfo.setType(0);
		//
		orderInfo.setOrderNo(tx.getTxId());
		orderInfo.setMatchedRules(matchedRules);
		orderInfo.setBeforeUnits(new BigDecimal(String.valueOf(accBalance)));

		return orderInfo;
	}
}
