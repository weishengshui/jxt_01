package com.chinarewards.alading.util;

import net.sf.json.JSONArray;

public class CommonTools {

	public static String toJSONString(Object object) {

		if (null == object) {
			return "";
		}
		JSONArray jsonArray = JSONArray.fromObject(object);

		return jsonArray.toString();
	}
}
