package jxt.elt.common;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class Fun
{
	
	public boolean sqlStrCheck(String str)
	{		
		String tempstr=str;
		if (tempstr!=null && !"".equals(tempstr))
		{
			tempstr=tempstr.toUpperCase();
			if (tempstr.indexOf("INSERT ")>-1 || tempstr.indexOf("DELETE ")>-1 || tempstr.indexOf("UPDATE ")>-1 || tempstr.indexOf("DECLARE ")>-1 || tempstr.indexOf("EXEC ")>-1 || tempstr.indexOf("SYSCOLUMNS ")>-1 || tempstr.indexOf("SYSOBJECTS ")>-1 || tempstr.indexOf("ALTER ")>-1 || tempstr.indexOf("DROP ")>-1 || tempstr.indexOf("</SCRIPT>")>-1)
				return false;
			if (tempstr.indexOf("'")>-1)
				return false;
			if (tempstr.indexOf("BENCHMARK")>-1)
				return false;
		}
		return true;
	}
	
	public String httpGet(String urlStr,String chartSet) throws Exception
	{
		URL url = new URL(urlStr);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Connection", "Keep-Alive");
		conn.setRequestProperty("Charset", chartSet);

		// conn.connect();
		
		StringBuffer strbuff = new StringBuffer();
		BufferedReader in = new BufferedReader(new InputStreamReader(
				conn.getInputStream(), chartSet));
		String line;
		while ((line = in.readLine()) != null) {
			if (!"".equals(strbuff.toString())) {
				strbuff.append("\r\n");
			}
			strbuff.append(line);
		}
		in.close();
		conn.disconnect();
		return strbuff.toString();
	}
	
	 public String escape(String src) {  
	        int i;  
	        char j;  
	        StringBuffer tmp = new StringBuffer();  
	        tmp.ensureCapacity(src.length() * 6);  
	        for (i = 0; i < src.length(); i++) {  
	            j = src.charAt(i);  
	            if (Character.isDigit(j) || Character.isLowerCase(j)  
	                    || Character.isUpperCase(j))  
	                tmp.append(j);  
	            else if (j < 256) {  
	                tmp.append("%");  
	                if (j < 16)  
	                    tmp.append("0");  
	                tmp.append(Integer.toString(j, 16));  
	            } else {  
	                tmp.append("%u");  
	                tmp.append(Integer.toString(j, 16));  
	            }  
	        }  
	        return tmp.toString();  
	    }
	 
	 public String unescape(String src) {
		  StringBuffer tmp = new StringBuffer();
		  tmp.ensureCapacity(src.length());
		  int lastPos = 0, pos = 0;
		  char ch;
		  while (lastPos < src.length()) {
		   pos = src.indexOf("%", lastPos);
		   if (pos == lastPos) {
		    if (src.charAt(pos + 1) == 'u') {
		     ch = (char) Integer.parseInt(src
		       .substring(pos + 2, pos + 6), 16);
		     tmp.append(ch);
		     lastPos = pos + 6;
		    } else {
		     ch = (char) Integer.parseInt(src
		       .substring(pos + 1, pos + 3), 16);
		     tmp.append(ch);
		     lastPos = pos + 3;
		    }
		   } else {
		    if (pos == -1) {
		     tmp.append(src.substring(lastPos));
		     lastPos = src.length();
		    } else {
		     tmp.append(src.substring(lastPos, pos));
		     lastPos = pos;
		    }
		   }
		  }
		  return tmp.toString();
		 }

	public String Encrypt(String strOld) 
	{
		String strTemp="";
		try
		{
			Integer i=0,p=0;
			Integer[] Key={Integer.valueOf("36",16),Integer.valueOf("8A",16),Integer.valueOf("D5",16),Integer.valueOf("A5",16),Integer.valueOf("63",16),Integer.valueOf("A8",16),Integer.valueOf("5D",16),Integer.valueOf("5A",16)};
			byte[] bytes = strOld.getBytes("Unicode");
			
			//System.out.println(bytes.length);
			
			for(i=2;i<bytes.length;i++)
			{
				//System.out.println(bytes[i]);
				if (i%2==0)
				{
//					System.out.println(bytes[i+1]);
					if (bytes[i+1]>=0)
						p=bytes[i+1]^Key[(i-2)%8];
					else
						p=(256+bytes[i+1])^Key[(i-2)%8];	
				}
				else
				{
					//System.out.println(bytes[i-1]);
					if (bytes[i-1]>=0)
						p=bytes[i-1]^Key[(i-2)%8];
					else
						p=(256+bytes[i-1])^Key[(i-2)%8];
				}
					
					strTemp+=("000"+p.toString()).substring(("000"+p.toString()).length()-3);
							
			}
			strTemp=Trans(strTemp);
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
			strTemp="";
		}
		return strTemp;
	}
	
	public String DeEncrypt(String strOld)
	{
		String strSource="";
		try
		{
			Integer i=0,j=0;
			int p=0;
			Integer[] Key={Integer.valueOf("36",16),Integer.valueOf("8A",16),Integer.valueOf("D5",16),Integer.valueOf("A5",16),Integer.valueOf("63",16),Integer.valueOf("A8",16),Integer.valueOf("5D",16),Integer.valueOf("5A",16)};
			strOld = Trans(strOld);
			
			
			int[] ss=new int[strOld.length()/3];
			//System.out.println(strOld);
			for (i=0;i<strOld.length()/3;i++)
			{
				p=Integer.valueOf(strOld.substring(i*3,i*3+3))^Key[i%8];
				
				/*if (p>128)
				ss[i]=p-256;
				else*/
				ss[i]=p;
				//System.out.println(ss[i]);
				//bytes[i]=(byte)p;
				//strSource=strSource +(char)p;
				//System.out.println(strSource);
			}
			
			
			int s=0;
			for (i=0;i<ss.length;i++)
			{
				if (i%2==0)
				{
					s=ss[i+1];
					ss[i+1]=ss[i];
					ss[i]=s;
				}
			}
			StringBuffer abc=new StringBuffer();
			for (i=0;i<ss.length;i++)
			{
				
				if (i%2==0)
				{
					
					String a="00" + Integer.toHexString(ss[i]).toString();
					String b="00" +Integer.toHexString(ss[i+1]).toString();
					abc.append("\\u"+a.substring(a.length()-2)+b.substring(b.length()-2));
					//System.out.println("\\u"+Integer.toHexString(ss[i])+Integer.toHexString(ss[i+1]));
				}
			}
			//System.out.println(abc.toString());
			strSource=unicode2string(abc.toString());
			//System.out.println(strSource);
		}
		catch(Exception e)
		{
			e.printStackTrace();
			strSource="";
		}
		return strSource;
	}
    
 
	
	public String Trans(String str) throws Exception
	{
		String strTemp="";
		Integer[] Key={Integer.valueOf("6D",16),Integer.valueOf("71",16),Integer.valueOf("6",16),Integer.valueOf("62",16),Integer.valueOf("8",16),Integer.valueOf("7C",16),Integer.valueOf("1F",16),Integer.valueOf("9",16),Integer.valueOf("44",16),Integer.valueOf("53",16),Integer.valueOf("1D",16),Integer.valueOf("5E",16)};	
		int i=0,p=0;
		for (i=0;i<str.length();i++)
		{
			
			int tempi=(int) str.substring(i,i+1).toCharArray()[0];
			//System.out.println(tempi);
			p=tempi^Key[i%12];
			//System.out.println(p);
			char tempc=(char) p;
			strTemp=strTemp+tempc;
		}
		return strTemp;
	}
	
	
	public String Code1(String lPwd) throws Exception
	{
		Integer TmpAscii;
		String TmpStr="";
		for (int i=0 ;i<lPwd.length();i++)
		{
			TmpAscii=((int)lPwd.substring(i,i+1).toCharArray()[0])-32;
			//System.out.println(TmpAscii);
			if (TmpAscii>47 && TmpAscii<95)
			{
				if (i%2==0)
					TmpStr=TmpStr + (char)(TmpAscii-15);
			}
			if(TmpAscii<48 && TmpAscii>0)
			{
				if (i%2==0)
					TmpStr=TmpStr + (char)(TmpAscii+79);
			}
			
			if (i%2!=0 && TmpAscii>0 && TmpAscii<95)
			{
				TmpStr=TmpStr + (char)(127-TmpAscii);
			}
			
			if (TmpAscii<=0 || TmpAscii>94)
			{
				TmpStr=TmpStr + lPwd.substring(i,i+1);
			}
			//System.out.println(TmpStr);
		}
		return TmpStr;
   
	}
	
	
	 public String unicode2string(String str) {  
	        str = (str == null ? "" : str);  
	        if (str.indexOf("\\u") == -1)  
	            return str;  
	  
	        StringBuffer sb = new StringBuffer(1000);  
	  
	        for (int i = 0; i <= str.length() - 6;) {  
	            String strTemp = str.substring(i, i + 6);  
	            String value = strTemp.substring(2);  
	            int c = 0;  
	            for (int j = 0; j < value.length(); j++) {  
	                char tempChar = value.charAt(j);  
	                int t = 0;  
	                switch (tempChar) {  
	                case 'a':  
	                    t = 10;  
	                    break;  
	                case 'b':  
	                    t = 11;  
	                    break;  
	                case 'c':  
	                    t = 12;  
	                    break;  
	                case 'd':  
	                    t = 13;  
	                    break;  
	                case 'e':  
	                    t = 14;  
	                    break;  
	                case 'f':  
	                    t = 15;  
	                    break;  
	                default:  
	                    t = tempChar - 48;  
	                    break;  
	                }  
	  
	                c += t * ((int) Math.pow(16, (value.length() - j - 1)));  
	            }  
	            sb.append((char) c);  
	            i = i + 6;  
	        }  
	        return sb.toString();  
	    }  
}


