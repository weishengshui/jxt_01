package com.chinarewards.alading.listener;

import static org.apache.ibatis.io.Resources.getResourceAsReader;

import javax.sql.DataSource;

import org.apache.ibatis.jdbc.ScriptRunner;
import org.apache.ibatis.mapping.Environment;
import org.apache.ibatis.session.SqlSessionFactory;

import com.chinarewards.alading.module.CommonModule;
import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.servlet.GuiceServletContextListener;

public class GuiceSrtuts2Listener extends GuiceServletContextListener {
	
	@Override
	protected Injector getInjector() {
		Injector injector =null; 
		try {
			injector = Guice.createInjector(new CommonModule());
			// prepare the db schema
			Environment environment = injector.getInstance(SqlSessionFactory.class)
					.getConfiguration().getEnvironment();
			DataSource dataSource = environment.getDataSource();
			ScriptRunner runner = new ScriptRunner(dataSource.getConnection());
			runner.setAutoCommit(false);
			runner.setStopOnError(false);
			runner.runScript(getResourceAsReader("db/database-schema.sql"));
			runner.closeConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return injector;
	}

}
