package com.chinarewards.metro.repository.order;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.chinarewards.metro.core.common.HBDaoSupport;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.domain.account.Business;
import com.chinarewards.metro.domain.business.OrderInfo;
import com.chinarewards.metro.models.order.ExtOrderInfo;
import com.chinarewards.metro.models.order.ExtOrderUnit;

@Repository
public class OrderRepository {

	@Autowired
	HBDaoSupport hbDaoSupport;

	public OrderInfo findOrderByNo(String orderNo) {
		OrderInfo o = hbDaoSupport.findTByHQL(
				"FROM OrderInfo o WHERE o.orderNo=?", orderNo);
		return o;
	}

	public OrderInfo findOrderInfo(String posId, Business business,
			long serialId) {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.HOUR, 00);
		calendar.set(Calendar.MINUTE, 00);
		calendar.set(Calendar.SECOND, 00);
		calendar.set(Calendar.MILLISECOND, 00);

		Date from = calendar.getTime();
		calendar.add(Calendar.DAY_OF_MONTH, 1);
		Date to = calendar.getTime();

		OrderInfo od = hbDaoSupport
				.findTByHQL(
						"FROM OrderInfo o WHERE o.serialId=? AND o.tx.busines=? AND o.posCode=? AND o.tx.transactionDate>=? AND o.tx.transactionDate<?",
						String.valueOf(serialId), business, posId, from, to);
		return od;
	}

	public Integer countSyncOrder(Date from, Date to, boolean resend) {

		Map<String, Object> params = new HashMap<String, Object>();

		StringBuffer str = new StringBuffer();
		str.append("SELECT count(1) FROM OrderInfo o WHERE o.tx.busines=:business ");
		params.put("business", Business.EXT_ORDER);
		
		if (null != from) {
			str.append(" AND o.tx.transactionDate>=:from");
			params.put("from", from);
		}
		if (null != to) {
			str.append(" AND o.tx.transactionDate<to");
			params.put("to", to);
		}
		
		if (resend) {
			str.append(" AND o.sync=:sync");
			params.put("sync", false);
		}
		List<Long> counts = hbDaoSupport.findTs(str.toString(), params);
		return counts.get(0).intValue();
	}

	public ExtOrderUnit getSyncOrder(int pageNo, Date from, Date to,
			boolean resend) {

		ExtOrderUnit result = new ExtOrderUnit();

		Map<String, Object> params = new HashMap<String, Object>();

		StringBuffer str = new StringBuffer();
		str.append("SELECT o FROM OrderInfo o WHERE o.tx.busines=:business ");

		params.put("business", Business.EXT_ORDER);
		
		if (null != from) {
			str.append(" AND o.tx.transactionDate>=:from");
			params.put("from", from);
		}
		if (null != to) {
			str.append(" AND o.tx.transactionDate<to");
			params.put("to", to);
		}


		if (resend) {
			str.append(" AND o.sync=:sync");
			params.put("sync", false);
		}
		Page page = new Page();
		page.setRows(50);
		page.setTotalRows(countSyncOrder(from, to, resend));

		List<OrderInfo> orders = hbDaoSupport.findTsByHQLPage(str.toString(),
				params, page);

		result.setCurrPage(pageNo);
		result.setTotalPage(page.getTotalPage());

		List<ExtOrderInfo> exto = new LinkedList<ExtOrderInfo>();
		SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMddHHmmss");

		for (OrderInfo o : orders) {
			ExtOrderInfo e = new ExtOrderInfo();
			e.setBankPay(o.getBankPay().toString());
			e.setCash(o.getCash().toString());
			e.setClerkId(o.getClerkId());
			e.setCouponCode(o.getCouponCode());
			e.setDeliverTime(fmt.format(o.getDeliverTime()));
			e.setIntegration(o.getIntegration().toString());
			e.setOrderId(o.getOrderNo());
			e.setOrderPrice(o.getOrderPrice().toString());
			e.setOrderSource(o.getOrderSource());
			e.setOrderState(o.getOrderState());
			e.setOrderTime(fmt.format(o.getOrderTime()));
			e.setPosId(o.getPosCode());
			e.setShopId(String.valueOf(o.getShop().getId()));
			e.setUserId(o.getMemberId());

			exto.add(e);
		}
		result.setList(exto);
		return result;
	}

	public OrderInfo createOrderInfo() {

		return null;
	}
}
