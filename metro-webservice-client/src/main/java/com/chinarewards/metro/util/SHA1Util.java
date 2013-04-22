package com.chinarewards.metro.util;

import java.security.MessageDigest;

public class SHA1Util {

	public static String SHA1Encode(String sourceString) {
		String resultString = null;
		try {
			resultString = new String(sourceString);
			MessageDigest md = MessageDigest.getInstance("SHA-1");
			resultString = byte2hexString(md.digest(resultString.getBytes("UTF-8")));
		} catch (Exception ex) {
		}
		return resultString;
	}

	public static final String byte2hexString(byte[] bytes) {
		StringBuffer buf = new StringBuffer(bytes.length * 2);
		for (int i = 0; i < bytes.length; i++) {
			if (((int) bytes[i] & 0xff) < 0x10) {
				buf.append("0");
			}
			buf.append(Long.toString((int) bytes[i] & 0xff, 16));
		}
		return buf.toString().toUpperCase();
	}

	public static void main(String[] args) throws Exception {
		System.out.println("999 sha1 encode is " + SHA1Encode("9999"));
		System.out.println("hello sha1 encode is " + SHA1Encode("hello"));
		System.out.println("123456 sha1 encode is " + SHA1Encode("123456"));
		System.out.println("中国 sha1 encode is " + SHA1Encode("中国"));
	}
}
