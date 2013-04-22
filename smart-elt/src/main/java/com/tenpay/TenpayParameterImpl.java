package com.tenpay;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jxt.elt.common.DbPool;

public class TenpayParameterImpl implements TenpayParameterProvider {

	// 收款方
	String spname;

	// 商户号
	String partner; // 1900000113 test

	// 密钥
	String key;// e82573dc7e6136ba414f2e2affbe39fa

	// 交易完成后跳转的URL
	String return_url;

	// 接收财付通通知的URL
	String notify_url;

	public TenpayParameterImpl() {
		try {
			Connection connection = DbPool.getInstance().getConnection();
			PreparedStatement statement;

			statement = connection
					.prepareStatement("select pname,pvalue from tbl_config where pname=?");
			statement.setString(1, "tenpay.spname");
			ResultSet set = statement.executeQuery();
			if (set.next())
				spname = set.getString("pvalue");
			statement.clearParameters();

			statement.setString(1, "tenpay.partner");
			set = statement.executeQuery();
			if (set.next())
				partner = set.getString("pvalue");
			statement.clearParameters();

			statement.setString(1, "tenpay.key");
			set = statement.executeQuery();
			if (set.next())
				key = set.getString("pvalue");
			statement.clearParameters();

			statement.setString(1, "rootPath");
			set = statement.executeQuery();
			String root = "";
			if (set.next())
				root = set.getString("pvalue");
			statement.clearParameters();

			return_url = root + "/gl/bipaysuccess.jsp";

			notify_url = root + "/gl/payNotifyUrl.jsp";//"http://119.145.4.25:8098/gl/payNotifyUrl.jsp";
		} catch (SQLException e) {
			throw new RuntimeException(
					"Get system configuration tenpay parameters error happended!",
					e);
		}
	}

	@Override
	public String getSPName() {
		return spname;
	}

	@Override
	public String getReturnUrl() {
		return return_url;
	}

	@Override
	public String getPartner() {
		return partner;
	}

	@Override
	public String getNotifyUrl() {
		return notify_url;
	}

	@Override
	public String getKey() {
		return key;
	}

	@Override
	public String getGW() {
		return "https://gw.tenpay.com/gateway/pay.htm";
	}
}
