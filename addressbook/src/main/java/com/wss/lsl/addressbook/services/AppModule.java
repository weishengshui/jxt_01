package com.wss.lsl.addressbook.services;

import org.apache.tapestry5.SymbolConstants;
import org.apache.tapestry5.ioc.MappedConfiguration;
import org.apache.tapestry5.ioc.ServiceBinder;

import com.wss.lsl.addressbook.dao.UserDao;
import com.wss.lsl.addressbook.dao.impl.UserDaoImpl;

public class AppModule {
	
	public static void bind(ServiceBinder binder){
		binder.bind(UserDao.class, UserDaoImpl.class);
	}
	
	public static void contributeApplicationDefaults(MappedConfiguration<String, Object> configuration){
		configuration.add(SymbolConstants.SUPPORTED_LOCALES, "en");
		configuration.add(SymbolConstants.PRODUCTION_MODE, false);
		configuration.add(SymbolConstants.FILE_CHECK_INTERVAL, "10s");
		configuration.add(SymbolConstants.APPLICATION_VERSION, "0.0.1-SNAPSHOT");
		configuration.add(SymbolConstants.HMAC_PASSPHRASE, "00-1E-90-BD-4F-EB");
		configuration.add(SymbolConstants.START_PAGE_NAME, "listAddresses");
	}
}
