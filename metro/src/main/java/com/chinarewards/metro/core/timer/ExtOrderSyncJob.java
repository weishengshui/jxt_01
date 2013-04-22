package com.chinarewards.metro.core.timer;

import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.chinarewards.metro.models.order.ExtOrderUnit;
import com.chinarewards.metro.repository.order.OrderRepository;
import com.chinarewards.metro.service.order.IOrderService;

public class ExtOrderSyncJob {

	/**
	 * 同步数据单元
	 */

	@Autowired
	private OrderRepository orderRepository;

	@Autowired
	private IOrderService orderService;
	
	Logger logger = LoggerFactory.getLogger(this.getClass());

	public List<ExtOrderUnit> getSyncRecords(Date from, Date to, boolean resend) {

		int pageNo = 1;
		int totalPage = 0;
		List<ExtOrderUnit> list = new LinkedList<ExtOrderUnit>();
		do {
			ExtOrderUnit unit = orderRepository.getSyncOrder(pageNo, from, to,
					resend);
			list.add(unit);
			totalPage = unit.getTotalPage();
			pageNo++;
		} while (pageNo <= totalPage);

		return list;
	}

	/**
	 * 整点同步，失败重新请求三次
	 */
	public void syncEveryHour() {

		Calendar c = Calendar.getInstance();
		c.clear(Calendar.MINUTE);
		c.clear(Calendar.SECOND);
		c.clear(Calendar.MILLISECOND);
		Date from = c.getTime();

		c.add(Calendar.HOUR_OF_DAY, -1);
		Date to = c.getTime();

		List<ExtOrderUnit> list = getSyncRecords(from, to, false);
		for (ExtOrderUnit unit : list) {
			logger.trace("totalPage: " + unit.getTotalPage() + " pageNo:"
					+ unit.getCurrPage() + " order size:"
					+ unit.getList().size());
			// FIXME push
		}

		// 重发延时2秒,第二次延时倍数递增
		long resendDelay = 2000;
		// resend failure
		for (int count = 0; count < 3; count++) {
			try {
				list = getSyncRecords(from, to, true);
				if (list.size() > 0 && list.get(0).getList().size() > 0) {

					if (count > 0) {
						Thread.sleep(resendDelay * (count + 1));
					}
					for (ExtOrderUnit unit : list) {
						logger.trace("totalPage: " + unit.getTotalPage()
								+ " pageNo:" + unit.getCurrPage()
								+ " order size:" + unit.getList().size());
						// FIXME push
					}
				} else {
					break;
				}
			} catch (Exception e) {

			}
		}
	}

	/**
	 * 每天同步所有失败的记录
	 */
	public void syncEveryDay() {

		List<ExtOrderUnit> list = getSyncRecords(null, null, true);
		for (ExtOrderUnit unit : list) {
			logger.trace("totalPage: " + unit.getTotalPage() + " pageNo:"
					+ unit.getCurrPage() + " order size:"
					+ unit.getList().size());
			// FIXME push
		}
	}

	public OrderRepository getOrderRepository() {
		return orderRepository;
	}

	public void setOrderRepository(OrderRepository orderRepository) {
		this.orderRepository = orderRepository;
	}

	public IOrderService getOrderService() {
		return orderService;
	}

	public void setOrderService(IOrderService orderService) {
		this.orderService = orderService;
	}

}
