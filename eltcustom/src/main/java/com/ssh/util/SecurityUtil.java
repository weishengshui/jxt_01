package com.ssh.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SecurityUtil {
	public static String md5(String plainText) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("MD5");
		md.update(plainText.getBytes());
		byte[] b = md.digest();

		StringBuffer buf = new StringBuffer("");
		for (int offset = 0; offset < b.length; offset++) {
			int i = b[offset];
			if (i < 0)
				i += 256;
			if (i < 16)
				buf.append("0");
			buf.append(Integer.toHexString(i));
		}
		return buf.toString();
	}

	public static boolean sqlCheck(String param) {
		String[] keys = { "select ", ";", "update ", "union ", "drop ",
				"delete ", "create ", "insert ", "exec ", "systemcolumn ",
				"alter ", "</script>" };

		for (String k : keys) {
			if (param.toLowerCase().indexOf(k) != -1) {
				return true;
			}
		}
		return false;
	}

	public static boolean sqlParamCheck(String parameter) {
		String tempstr = parameter;
		if ((tempstr != null) && (!"".equals(tempstr))) {
			tempstr = tempstr.toUpperCase();
			if ((tempstr.indexOf("INSERT ") > -1)
					|| (tempstr.indexOf("DELETE ") > -1)
					|| (tempstr.indexOf("UPDATE ") > -1)
					|| (tempstr.indexOf("DECLARE ") > -1)
					|| (tempstr.indexOf("EXEC ") > -1)
					|| (tempstr.indexOf("SYSCOLUMNS ") > -1)
					|| (tempstr.indexOf("SYSOBJECTS ") > -1)
					|| (tempstr.indexOf("ALTER ") > -1)
					|| (tempstr.indexOf("DROP ") > -1)
					|| (tempstr.indexOf("</SCRIPT>") > -1))
				return false;
			if (tempstr.indexOf("'") > -1)
				return false;
			if (tempstr.indexOf("BENCHMARK") > -1)
				return false;
		}
		return true;
	}
}