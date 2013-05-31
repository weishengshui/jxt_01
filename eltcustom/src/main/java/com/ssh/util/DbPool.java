package com.ssh.util;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import com.mchange.v2.c3p0.DataSources;
import java.sql.Connection;
import java.sql.SQLException;

public final class DbPool {
	private static DbPool instance;
	public ComboPooledDataSource ds;

	private DbPool() throws Exception {
		PropertiesReader pr = new PropertiesReader();

		this.ds = new ComboPooledDataSource();
		this.ds.setDriverClass(pr.getProperty("jdbc.driverClassName"));
		this.ds.setJdbcUrl(pr.getProperty("jdbc.url"));
		this.ds.setUser(pr.getProperty("jdbc.username"));
		this.ds.setPassword(pr.getProperty("jdbc.password"));
		this.ds.setMaxPoolSize(800);
		this.ds.setMinPoolSize(0);
		this.ds.setAcquireIncrement(10);
		this.ds.setMaxIdleTime(120);
	}

	public static final DbPool getInstance() {
		if (instance == null) {
			try {
				instance = new DbPool();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return instance;
	}

	public final synchronized Connection getConnection() {
		try {
			return this.ds.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	protected void finalize() throws Throwable {
		DataSources.destroy(this.ds);
		super.finalize();
	}
}