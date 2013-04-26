package com.chinarewards.oauth.module;

import static com.google.inject.name.Names.bindProperties;

import org.apache.ibatis.transaction.jdbc.JdbcTransactionFactory;
import org.mybatis.guice.MyBatisModule;
import org.mybatis.guice.datasource.builtin.PooledDataSourceProvider;
import org.mybatis.guice.datasource.helper.JdbcHelper;

import com.chinarewards.oauth.Application;
import com.google.inject.Binder;
import com.google.inject.Module;

public class CommonModule implements Module {

	@Override
	public void configure(Binder binder) {
		
		// add mybatis module
		binder.install(new MyBatisModule() {
			@Override
			protected void initialize() {
				install(JdbcHelper.MySQL);
				bindDataSourceProviderType(PooledDataSourceProvider.class);
				bindTransactionFactoryType(JdbcTransactionFactory.class);
				
				addSimpleAliases("com.chinarewards.oauth.domain");
				
				addMapperClasses("com.chinarewards.oauth.reg.mapper");

				bindProperties(binder(), Application.createDatabaseProperties(Application.PRODUCTION_DATABASE_PROPERTIES));
			}
		});
		
		// add logger module
		binder.install(new LoggerModule());
		
		// add resources module
		binder.install(new ResourcesModule());
		
		// add service module
		binder.install(new ServiceModule());
	}

}
