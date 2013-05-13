package com.chinarewards.alading.util;

import net.sf.json.JSONArray;

public class CommonTools {

	public static String toJSONString(Object object) {

		if (null == object) {
			return "";
		}
		JSONArray jsonArray = JSONArray.fromObject(object);
		String str = jsonArray.toString();
		// 去掉外面的 "[]"
		if (str.startsWith("[")) {
			str = str.substring(1);
		}
		if (str.endsWith("]")) {
			str = str.substring(0, str.length() - 1);
		}

		return str;
	}
}
