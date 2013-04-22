package com.chinarewards.metro.core.common;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.annotation.PostConstruct;

import com.chinarewards.metro.domain.system.SYSVariable;

public class SystemParamsConfig {

	private static HBDaoSupport hbDaoSupport;
	public final static String CONFIG_FILE = "system.params.properties";
	private static Properties pro = null;

	// 根据默认初始化系统参数
	@PostConstruct
	public synchronized void init() {
		pro = new Properties();
		InputStream is = SystemParamsConfig.class.getClassLoader()
				.getResourceAsStream(CONFIG_FILE);
		try {
			pro.load(is);
			Set<String> keys = pro.stringPropertyNames();
			if (null != keys && keys.size() > 0) {
				for (String key : keys) {

					String value = pro.getProperty(key);
					SYSVariable sysVariable = hbDaoSupport.findTById(
							SYSVariable.class, key);

					if (null == sysVariable) {
						sysVariable = new SYSVariable();
						sysVariable.setKey(key);
						sysVariable.setValue(value);

						hbDaoSupport.save(sysVariable);
					} else {
						pro.setProperty(key, sysVariable.getValue());
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void setSYSVariable(SYSVariable sysVariable) {

		hbDaoSupport.executeHQL("UPDATE SYSVariable SET value=? WHERE key=?",
				sysVariable.getValue(), sysVariable.getKey());
	}

	/**
	 * Get value by key ,if not exists return null
	 * 
	 * @param key
	 * @return
	 */
	public static String getSysVariableValue(String key) {
		SYSVariable v = getSysVariable(key);
		if (null != v) {
			return v.getValue();
		} else {
			return null;
		}
	}

	public static SYSVariable getSysVariable(String key) {
		if (null == pro.getProperty(key)) {
			SYSVariable sysVariable = hbDaoSupport.findTById(SYSVariable.class,
					key);
			if (null != sysVariable) {
				pro.setProperty(key, sysVariable.getValue() == null ? ""
						: sysVariable.getValue());
				return sysVariable;
			} else {
				return null;
			}
		}
		SYSVariable sysVariable = new SYSVariable();
		sysVariable.setKey(key);
		sysVariable.setValue(pro.getProperty(key));
		return sysVariable;
	}

	public static Set<String> getAllParamsName() {
		return pro.stringPropertyNames();
	}

	public static List<SYSVariable> getAllParams() {
		List<SYSVariable> list = new ArrayList<SYSVariable>();
		Set<String> keys = pro.stringPropertyNames();
		if (null != keys && keys.size() > 0) {
			for (String key : keys) {

				SYSVariable sysVariable = new SYSVariable();
				sysVariable.setKey(key);
				sysVariable.setValue(pro.getProperty(key));

				list.add(sysVariable);
			}
		}

		return list;
	}

	/**
	 * 根据参数名称刷新指定参数
	 * 
	 * @param key
	 *            参数名称
	 */
	public static void refresh(String key) {

		SYSVariable sysVariable = hbDaoSupport
				.findTById(SYSVariable.class, key);

		if (null != sysVariable) {
			pro.setProperty(key, (sysVariable.getValue() == null ? ""
					: sysVariable.getValue()));
		}
	}

	/**
	 * 刷新所有系统参数
	 */
	public static void refresh() {

		Set<String> keys = pro.stringPropertyNames();
		if (null != keys && keys.size() > 0) {
			for (String key : keys) {
				refresh(key);
			}
		}
	}

	public void setHbDaoSupport(HBDaoSupport hbDaoSupport) {
		SystemParamsConfig.hbDaoSupport = hbDaoSupport;
	}

}
