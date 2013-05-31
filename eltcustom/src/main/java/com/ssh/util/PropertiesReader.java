package com.ssh.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.util.Properties;

public class PropertiesReader {
	private Properties prop = new Properties();

	public PropertiesReader() throws IOException {
		propertyRead("/jdbc.properties");
	}

	public PropertiesReader(String propertyFile) throws IOException {
		propertyRead(propertyFile);
	}

	private void propertyRead(String propertyFile) throws IOException {
		this.prop.clear();
		InputStream is = null;
		try {
			is = getClass().getResourceAsStream(propertyFile);
			this.prop.load(is);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (is != null)
				is.close();
		}
	}

	public String getProperty(String aprop) {
		if (this.prop.containsKey(aprop)) {
			return this.prop.getProperty(aprop).trim();
		}
		return null;
	}

	public static void main(String[] str) throws IOException {
		PropertiesReader read = new PropertiesReader();
		String a = read.getProperty("a");
		try {
			System.out.println(a);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}