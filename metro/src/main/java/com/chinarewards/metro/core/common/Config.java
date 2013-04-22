package com.chinarewards.metro.core.common;

import java.io.InputStream;
import java.util.Properties;

public class Config {

	public final static String CONFIG_FILE = "config.properties";
	private static Config config = null;
	private static Properties pro = null;

	private Config() {
		loadData();
	}

	private synchronized void loadData() {
		pro = new Properties();
		InputStream is = Config.class.getClassLoader().getResourceAsStream(CONFIG_FILE);
		try {
			pro.load(is);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static String getProperty(String key) {
		if (config == null) {
			config = new Config();
		}
		return pro.getProperty(key);
	}

}

