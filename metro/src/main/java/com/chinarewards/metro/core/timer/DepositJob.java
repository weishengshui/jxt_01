package com.chinarewards.metro.core.timer;

import java.util.List;

import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.JDBCDaoSupport;
import com.chinarewards.metro.core.common.SystemParamsConfig;
import com.chinarewards.metro.domain.account.Business;
import com.chinarewards.metro.domain.account.Transaction;
import com.chinarewards.metro.service.account.IAccountService;

/**
 * 定时积分生效
 * 
 * @author daocao
 * 
 */
public class DepositJob {

	private IAccountService accountService;

	private JDBCDaoSupport jdbcDaoSupport;

	public void doJob() {

		// default
		int l = 7;
		try {
			String fd = SystemParamsConfig
					.getSysVariableValue(Dictionary.V_POS_SALES_FROZEN_DAYS);
			l = Integer.parseInt(fd);
		} catch (Exception e) {
			System.err
					.println("Thar key ["
							+ Dictionary.V_POS_SALES_FROZEN_DAYS
							+ "] System variable is null or not intvalue using default[7]");
		}

		String sql = "SELECT t.* FROM Transaction t WHERE DATEDIFF(now(),t.transactionDate) >= ? AND t.busines = ?";
		List<Transaction> list = jdbcDaoSupport.findTsBySQL(Transaction.class,
				sql, l, Business.POS_SALES.toString());
		for (Transaction tq : list) {
			try {
				accountService.unfrozenPosSales("0", tq.getTxId());
			} catch (Exception e) {
				e.printStackTrace();
				System.err.println("Unforzen possales error!");
			}
		}
	}

	public void setAccountService(IAccountService accountService) {
		this.accountService = accountService;
	}

	public void setJdbcDaoSupport(JDBCDaoSupport jdbcDaoSupport) {
		this.jdbcDaoSupport = jdbcDaoSupport;
	}
}
