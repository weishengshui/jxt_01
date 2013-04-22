package com.ssh.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SecurityUtil {
	
	public static String md5(String plainText) throws NoSuchAlgorithmException {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(plainText.getBytes());
			byte b[] = md.digest();
			int i;
			StringBuffer buf = new StringBuffer("");
			for (int offset = 0; offset < b.length; offset++) {
				i = b[offset];
				if (i < 0)
					i += 256;
				if (i < 16)
					buf.append("0");
				buf.append(Integer.toHexString(i));
			}
			return buf.toString();
	}
	
	
	public static boolean sqlCheck (String param){
		String[] keys = {"select ",";","update ","union ","drop ","delete ","create ",
				"insert ","exec ","systemcolumn ","alter ","</script>"}; 
		for (String k : keys){
			if(param.toLowerCase().indexOf(k)!=-1){
				return true;
			}
		}
		return false;
	}
}
