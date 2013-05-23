package com.wss.lsl.myapp.services;

import org.apache.tapestry5.SymbolConstants;
import org.apache.tapestry5.ioc.MappedConfiguration;
import org.apache.tapestry5.ioc.ServiceBinder;

import com.wss.lsl.myapp.dao.UserDao;
import com.wss.lsl.myapp.dao.impl.UserDaoImpl;

public class AppModule {
	
	public static void bind(ServiceBinder binder){
		binder.bind(UserDao.class, UserDaoImpl.class);
	}
	
	public static void contributeApplicationDefaults(MappedConfiguration<String, String> configuration){
		configuration.add(SymbolConstants.SUPPORTED_LOCALES, "zh,en");
		configuration.add(SymbolConstants.FILE_CHECK_INTERVAL, "10 m");
		configuration.add(SymbolConstants.APPLICATION_VERSION, "0.0.1-SNAPSHOT");
	}
}
