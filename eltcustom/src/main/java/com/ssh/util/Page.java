package com.ssh.util;

public class Page {
	
	public static String oraclePageSql(String sql,String total,String pagesize,String currentpage){
		String result = "";
		int pz = Integer.parseInt(pagesize.trim());
		int cp = Integer.parseInt(currentpage.trim());
		int tal = Integer.parseInt(total.trim());
		int from = pz*(cp-1)+1;
		int to = tal;
		if(tal>pz*cp){
			to = pz*cp;
		}
		if(!sql.equals("")){
			result +=" select * from ( "+
			sql.replaceFirst("(?i)select", "select rownum as finalpagenum,")
			+") where finalpagenum >="+from +" and finalpagenum <="+to;
		}
		return result;
	}

	
	public static String mysqlPageSql(String sql,String total,String pagesize,String currentpage){
		String result = "";
		int pz = Integer.parseInt(pagesize.trim());
		int cp = Integer.parseInt(currentpage.trim());
		int tal = Integer.parseInt(total.trim());
		int from = pz*(cp-1);
		int to = tal;
		if(tal>pz*cp){
			to = pz*cp;
		}
		if(!sql.equals("")){
			result +=sql+" LIMIT "+from +", "+(to-from);
		}
		return result;
	}
}
