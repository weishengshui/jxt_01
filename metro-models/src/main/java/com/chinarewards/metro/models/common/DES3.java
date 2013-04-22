package com.chinarewards.metro.models.common;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

public class DES3 {

	private static final String Algorithm = "DESede"; // 定义 加密算法,可用
														// DES,DESede,Blowfish

	// keybyte为加密密钥，长度为24字节
	// src为被加密的数据缓冲区（源）
	public static byte[] encryptMode(byte[] keybyte, byte[] src) {
		try {
			// 生成密钥
			SecretKey deskey = new SecretKeySpec(keybyte, Algorithm);

			// 加密
			Cipher c1 = Cipher.getInstance(Algorithm);
			c1.init(Cipher.ENCRYPT_MODE, deskey);
			return c1.doFinal(src);
		} catch (java.security.NoSuchAlgorithmException e1) {
			e1.printStackTrace();
		} catch (javax.crypto.NoSuchPaddingException e2) {
			e2.printStackTrace();
		} catch (java.lang.Exception e3) {
			e3.printStackTrace();
		}
		return null;
	}

	public synchronized static String encryptStrMode(byte[] keybyte, String src)
			{
		String encrypt = null;
		try {
			byte[] ret = encryptMode(keybyte, src.getBytes("UTF-8"));
			System.out.println("after encryptStrMode is " + Arrays.toString(ret));
			encrypt = Base64.encodeBase64String(ret);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return encrypt;
	}

	public synchronized static String decryptStrMode(byte[] keybyte, String src) {
		String decrypt = null;
		System.out.println("before decryptStrMode is "
				+ Arrays.toString(Base64.decodeBase64(src)));
		byte[] ret = decryptMode(keybyte, Base64.decodeBase64(src));
		System.out.println("decryptStrMode is " + Arrays.toString(ret));
		try {
			decrypt = new String(ret, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return decrypt;
	}

	// keybyte为加密密钥，长度为24字节
	// src为加密后的缓冲区
	public static byte[] decryptMode(byte[] keybyte, byte[] src) {
		try {
			// 生成密钥
			SecretKey deskey = new SecretKeySpec(keybyte, Algorithm);

			// 解密
			Cipher c1 = Cipher.getInstance(Algorithm);
			c1.init(Cipher.DECRYPT_MODE, deskey);
			return c1.doFinal(src);
		} catch (java.security.NoSuchAlgorithmException e1) {
			e1.printStackTrace();
		} catch (javax.crypto.NoSuchPaddingException e2) {
			e2.printStackTrace();
		} catch (InvalidKeyException e) {
			e.printStackTrace();
		} catch (IllegalBlockSizeException e) {
			e.printStackTrace();
		} catch (BadPaddingException e) {
			e.printStackTrace();
		}
		return null;
	}

	// 转换成十六进制字符串
	public static String byte2hex(byte[] b) {
		String hs = "";
		String stmp = "";

		for (int n = 0; n < b.length; n++) {
			stmp = (java.lang.Integer.toHexString(b[n] & 0XFF));
			if (stmp.length() == 1)
				hs = hs + "0" + stmp;
			else
				hs = hs + stmp;
			if (n < b.length - 1)
				hs = hs + "";
		}
		return hs.toUpperCase();
	}

	public static void main(String[] args) throws Exception {
		// 添加新安全算法,如果用JCE就要把它添加进去

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		final byte[] keyBytes = getKeyBytes(dateFormat.format(new Date())); // 24字节的密钥
		String szSrc = "This is a 3DES test. 测试";

		System.out.println("加密前的字符串:" + szSrc);
		System.out.println("" + new Date().toString().getBytes("UTF-8").length);
		byte[] encoded = encryptMode(keyBytes, szSrc.getBytes("UTF-8"));
		String str1 = new String(encoded, "ISO-8859-1");
		System.out.println("str1 is " + str1);
		byte[] encoded2 = str1.getBytes("ISO-8859-1");

		for (int i = 0, length = encoded.length; i < length; i++) {
			System.out.println("encoded[" + i + "] == encoded2[" + i + "] is "
					+ (encoded[i] == encoded2[i]));
		}

		System.out.println("encoded.length is " + encoded.length);
		System.out.println("encoded2.length is " + encoded2.length);
		System.out.println("encoded.equals(encoded2) is "
				+ (encoded.length == encoded2.length));
		System.out.println("加密后的字符串:" + byte2hex(encoded));

		byte[] srcBytes = decryptMode(keyBytes, encoded);
		System.out.println("解密后的字符串:" + new String(srcBytes, "utf-8"));
	}

	/**
	 * 根据时间生成24字节的密钥
	 * 
	 * @param time
	 *            yyyyMMddHHmmss
	 * @return
	 * @throws Exception
	 */
	public static byte[] getKeyBytes(String time) {
		try {
			byte[] keyBytes = (time + "0000000000").getBytes(); // 24字节的密钥
			return keyBytes;
		} catch (Exception e) {
		}
		return null;
	}

	public final static String byteToHexString(byte[] bytes) {
		char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
				'a', 'b', 'c', 'd', 'e', 'f' };
		try {
			int j = bytes.length;
			char str[] = new char[j * 2];
			int k = 0;
			for (int i = 0; i < j; i++) {
				byte byte0 = bytes[i];
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf];
			}
			return new String(str);
		} catch (Exception e) {
			return null;
		}
	}
}
