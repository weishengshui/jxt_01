package jxt.elt.common;

import java.sql.Connection;
import java.sql.SQLException;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import com.mchange.v2.c3p0.DataSources;

public final class DbPool {
	private static DbPool instance;
	public ComboPooledDataSource ds;

	private DbPool() throws Exception {
		PropertiesReader pr=new PropertiesReader();
		
		ds = new ComboPooledDataSource();
		ds.setDriverClass(pr.getProperty("jdbc.driverClassName"));		
		ds.setJdbcUrl(pr.getProperty("jdbc.url"));
		ds.setUser(pr.getProperty("jdbc.username"));
		ds.setPassword(pr.getProperty("jdbc.password"));
		ds.setMaxPoolSize(800);
		ds.setMinPoolSize(0);
		ds.setAcquireIncrement(10);
		ds.setMaxIdleTime(120);
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

	public synchronized final Connection getConnection() {
		try {
			return ds.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	protected void finalize() throws Throwable {
		DataSources.destroy(ds);
		super.finalize();
	}

}