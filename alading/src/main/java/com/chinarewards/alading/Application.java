package com.chinarewards.alading;

import static com.google.inject.Guice.createInjector;
import static com.google.inject.name.Names.bindProperties;
import static org.apache.ibatis.io.Resources.getResourceAsReader;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.sql.DataSource;

import org.apache.ibatis.jdbc.ScriptRunner;
import org.apache.ibatis.mapping.Environment;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.transaction.jdbc.JdbcTransactionFactory;
import org.mybatis.guice.MyBatisModule;
import org.mybatis.guice.datasource.builtin.PooledDataSourceProvider;
import org.mybatis.guice.datasource.helper.JdbcHelper;

import com.chinarewards.alading.module.LoggerModule;
import com.chinarewards.alading.module.ServiceModule;
import com.google.inject.Injector;
import com.google.inject.Module;

public class Application {

	public final static String TEST_DATABASE_PROPERTIES = "test.database.properties";
	public final static String PRODUCTION_DATABASE_PROPERTIES = "production.database.properties";
	
	// just for test
	public Injector setupMyBatisGuice() throws Exception {
		// bindings
		Injector injector = createInjector(new Module[] { new MyBatisModule() {
			@Override
			protected void initialize() {
				install(JdbcHelper.HSQLDB_IN_MEMORY_NAMED);
				bindDataSourceProviderType(PooledDataSourceProvider.class);
				bindTransactionFactoryType(JdbcTransactionFactory.class);
				
				addSimpleAliases("com.chinarewards.alading.domain");
				
				addMapperClasses("com.chinarewards.alading.reg.mapper");
				
				bindProperties(binder(), createDatabaseProperties(Application.TEST_DATABASE_PROPERTIES));
			}
		}, new LoggerModule(), new ServiceModule() });
		// prepare the test db
		Environment environment = injector.getInstance(SqlSessionFactory.class)
				.getConfiguration().getEnvironment();
		DataSource dataSource = environment.getDataSource();
		ScriptRunner runner = new ScriptRunner(dataSource.getConnection());
		runner.setAutoCommit(true);
		runner.setStopOnError(true);
		runner.runScript(getResourceAsReader("db/database-test-schema.sql"));
		runner.runScript(getResourceAsReader("db/database-test-data.sql"));
		
		runner.closeConnection();

		return injector;
	}

	public static Properties createDatabaseProperties(String propertiesFileName){
		
		try {
			InputStream is = Application.class.getClassLoader().getResourceAsStream(propertiesFileName);
			final Properties myBatisProperties = new Properties();
			myBatisProperties.load(is);
			
			return myBatisProperties;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}
}
