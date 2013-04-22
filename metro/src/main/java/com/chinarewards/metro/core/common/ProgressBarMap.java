package com.chinarewards.metro.core.common;

import java.util.Hashtable;
import java.util.Map;

public class ProgressBarMap {

	private static Map<String, ProgressBar> progress = new Hashtable<String, ProgressBar>();

	public static ProgressBar get(String key) {

		return progress.get(key);
	}

	public static void put(String key, ProgressBar value) {

		progress.put(key, value);
	}

	public static void remove(String key) {

		progress.remove(key);
	}
}
