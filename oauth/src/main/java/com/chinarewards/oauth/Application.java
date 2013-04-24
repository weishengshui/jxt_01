package com.chinarewards.oauth;

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

import com.chinarewards.oauth.module.LoggerModule;
import com.chinarewards.oauth.module.ResourcesModule;
import com.chinarewards.oauth.module.ServiceModule;
import com.chinarewards.oauth.reg.mapper.RegistrationMapper;
import com.chinarewards.oauth.reg.mapper.UserMapper;
import com.google.inject.Injector;
import com.google.inject.Module;

public class Application {

	public final static String TEST_DATABASE_PROPERTIES = "test.database.properties";
	public final static String PRODUCTION_DATABASE_PROPERTIES = "production.database.properties";
	
	public Injector setupMyBatisGuice(final String propertiesFileName) throws Exception {
		// bindings
		Injector injector = createInjector(new Module[] { new MyBatisModule() {
			@Override
			protected void initialize() {
				if(propertiesFileName.equals(TEST_DATABASE_PROPERTIES)){
					install(JdbcHelper.HSQLDB_Embedded);
				} else {
					install(JdbcHelper.MySQL);
				}
				bindDataSourceProviderType(PooledDataSourceProvider.class);
				bindTransactionFactoryType(JdbcTransactionFactory.class);

				addMapperClass(RegistrationMapper.class);
				addMapperClass(UserMapper.class);

				bindProperties(binder(), createDatabaseProperties(propertiesFileName));
			}
		}, new ResourcesModule(), new LoggerModule(), new ServiceModule() });
		// prepare the test db
		Environment environment = injector.getInstance(SqlSessionFactory.class)
				.getConfiguration().getEnvironment();
		DataSource dataSource = environment.getDataSource();
		ScriptRunner runner = new ScriptRunner(dataSource.getConnection());
		runner.setAutoCommit(true);
		runner.setStopOnError(true);
		runner.runScript(getResourceAsReader("db/database-schema.sql"));
		runner.runScript(getResourceAsReader("db/database-test-data.sql"));
		runner.closeConnection();

		return injector;
	}

	protected static Properties createTestProperties() {
		try {
			InputStream is = Application.class.getClassLoader()
					.getResourceAsStream(TEST_DATABASE_PROPERTIES);
			final Properties myBatisProperties = new Properties();
			myBatisProperties.load(is);

			// myBatisProperties.setProperty("mybatis.environment.id", "test");
			// myBatisProperties.setProperty("JDBC.username", "sa");
			// myBatisProperties.setProperty("JDBC.password", "");
			// myBatisProperties.setProperty("JDBC.autoCommit", "false");
			return myBatisProperties;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}

	public static Properties createProductionProperties() {
		try {
			InputStream is = Application.class.getClassLoader().getResourceAsStream(PRODUCTION_DATABASE_PROPERTIES);
			final Properties myBatisProperties = new Properties();
			myBatisProperties.load(is);
			
//		myBatisProperties.setProperty("mybatis.environment.id", "test");
//		// configure the database host
//		myBatisProperties.setProperty("JDBC.host", "192.168.4.97");
//		// configure the database port
//		myBatisProperties.setProperty("JDBC.port", "3306");
//		// configure the database schema
//		myBatisProperties.setProperty("JDBC.schema", "metro");
//		myBatisProperties.setProperty("JDBC.username", "metro");
//		myBatisProperties.setProperty("JDBC.password", "metro");
//		myBatisProperties.setProperty("JDBC.autoCommit", "false");

			return myBatisProperties;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
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
