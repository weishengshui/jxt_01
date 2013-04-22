package com.tenpay;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Calendar;

import jxt.elt.common.DbPool;

public class PayLogger {

	private static PayLogger logger = new PayLogger();

	public static PayLogger getLogger() {
		if (logger == null) {
			logger = new PayLogger();
		}
		return logger;
	}

	public void log(String action, String info, String... parameters) {
		System.out.println("@@@@@@@@action: " + action + "info:" + info
				+ "parameters:" + parameters);
		
		Connection conn = DbPool.getInstance().getConnection();
		try {
			PreparedStatement statement = conn
					.prepareStatement("insert into tbl_paylog (action,content,param1,param2,param3,otsParams,logDate) values (?,?,?,?,?,?,?)");
			statement.setString(1, action);
			statement.setString(2, info);
			int i = 0;
			StringBuffer otsParams = new StringBuffer();
			if (parameters != null) {
				for (; i < (parameters.length < 3 ? 3 : parameters.length); i++) {
					// parameter not enough fil with empty
					if (i >= parameters.length) {
						statement.setString(i + 3, "");
					}
					// set parameter
					else {
						statement.setString(i + 3, parameters[i]);
					}
					// if parameter out of 3,append it set to otsParams field
					if (i > 2) {
						otsParams.append("[[" + parameters[i] + "]]");
					}
				}
			}
			statement.setString(6, otsParams.toString());
			statement.setDate(7, new Date(Calendar.getInstance()
					.getTimeInMillis()));
			statement.execute();

		} catch (SQLException e) {
			System.err.println("pay log failed, that action is: " + action
					+ " info" + info + "parameters: " + parameters
					+ ",That error is:" + e.getMessage());
			e.printStackTrace();
		} finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				System.err.println("Close connection error!");
				conn = null;
			}
		}
	}
}
