package com.wss.lsl.myapp.services;

import org.apache.tapestry5.SymbolConstants;
import org.apache.tapestry5.ioc.MappedConfiguration;

public class AppModule {
	
	public static void contributeApplicationDefaults(MappedConfiguration<String, String> configuration){
		configuration.add(SymbolConstants.SUPPORTED_LOCALES, "zh,en");
		configuration.add(SymbolConstants.FILE_CHECK_INTERVAL, "10 m");
	}
}
