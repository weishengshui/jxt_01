package com.alipay.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jxt.elt.common.DbPool;

public class ConfigService {

	public String getString(String key) {
		String value = null;
		Connection connection = DbPool.getInstance().getConnection();
		PreparedStatement statement;
		try {
			statement = connection
					.prepareStatement("select pname,pvalue from tbl_config where pname=?");
			statement.setString(1, key);

			ResultSet rs = statement.executeQuery();
			while (rs.next()) {
				value = rs.getString("pvalue");
			}
		} catch (SQLException e) {
			throw new IllegalStateException(e);
		}
		return value;
	}
}
