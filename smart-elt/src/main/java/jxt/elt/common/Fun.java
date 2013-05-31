package jxt.elt.common;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Fun
{
  public boolean sqlStrCheck(String str)
  {
    String tempstr = str;
    if ((tempstr != null) && (!"".equals(tempstr)))
    {
      tempstr = tempstr.toUpperCase();
      if ((tempstr.indexOf("INSERT ") > -1) || (tempstr.indexOf("DELETE ") > -1) || (tempstr.indexOf("UPDATE ") > -1) || (tempstr.indexOf("DECLARE ") > -1) || (tempstr.indexOf("EXEC ") > -1) || (tempstr.indexOf("SYSCOLUMNS ") > -1) || (tempstr.indexOf("SYSOBJECTS ") > -1) || (tempstr.indexOf("ALTER ") > -1) || (tempstr.indexOf("DROP ") > -1) || (tempstr.indexOf("</SCRIPT>") > -1))
        return false;
      if (tempstr.indexOf("'") > -1)
        return false;
      if (tempstr.indexOf("BENCHMARK") > -1)
        return false;
    }
    return true;
  }

  public String httpGet(String urlStr, String chartSet) throws Exception
  {
    URL url = new URL(urlStr);
    HttpURLConnection conn = (HttpURLConnection)url.openConnection();
    conn.setRequestMethod("GET");
    conn.setRequestProperty("Connection", "Keep-Alive");
    conn.setRequestProperty("Charset", chartSet);

    StringBuffer strbuff = new StringBuffer();
    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), chartSet));
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

  public String escape(String src)
  {
    StringBuffer tmp = new StringBuffer();
    tmp.ensureCapacity(src.length() * 6);
    for (int i = 0; i < src.length(); i++) {
      char j = src.charAt(i);
      if ((Character.isDigit(j)) || (Character.isLowerCase(j)) || (Character.isUpperCase(j)))
      {
        tmp.append(j);
      } else if (j < 256) {
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
    int lastPos = 0; int pos = 0;

    while (lastPos < src.length()) {
      pos = src.indexOf("%", lastPos);
      if (pos == lastPos) {
        if (src.charAt(pos + 1) == 'u') {
          char ch = (char)Integer.parseInt(src.substring(pos + 2, pos + 6), 16);

          tmp.append(ch);
          lastPos = pos + 6; continue;
        }
        char ch = (char)Integer.parseInt(src.substring(pos + 1, pos + 3), 16);

        tmp.append(ch);
        lastPos = pos + 3; continue;
      }

      if (pos == -1) {
        tmp.append(src.substring(lastPos));
        lastPos = src.length(); continue;
      }
      tmp.append(src.substring(lastPos, pos));
      lastPos = pos;
    }

    return tmp.toString();
  }

  public String Encrypt(String strOld)
  {
    String strTemp = "";
    try
    {
      Integer i = Integer.valueOf(0); Integer p = Integer.valueOf(0);
      Integer[] Key = { Integer.valueOf("36", 16), Integer.valueOf("8A", 16), Integer.valueOf("D5", 16), Integer.valueOf("A5", 16), Integer.valueOf("63", 16), Integer.valueOf("A8", 16), Integer.valueOf("5D", 16), Integer.valueOf("5A", 16) };
      byte[] bytes = strOld.getBytes("Unicode");
      Integer localInteger1;
      Integer localInteger2;
      for (i = Integer.valueOf(2); i.intValue() < bytes.length; localInteger2 = i = Integer.valueOf(i.intValue() + 1))
      {
        if (i.intValue() % 2 == 0)
        {
          if (bytes[(i.intValue() + 1)] >= 0)
            p = Integer.valueOf(bytes[(i.intValue() + 1)] ^ Key[((i.intValue() - 2) % 8)].intValue());
          else {
            p = Integer.valueOf(256 + bytes[(i.intValue() + 1)] ^ Key[((i.intValue() - 2) % 8)].intValue());
          }

        }
        else if (bytes[(i.intValue() - 1)] >= 0)
          p = Integer.valueOf(bytes[(i.intValue() - 1)] ^ Key[((i.intValue() - 2) % 8)].intValue());
        else {
          p = Integer.valueOf(256 + bytes[(i.intValue() - 1)] ^ Key[((i.intValue() - 2) % 8)].intValue());
        }

        strTemp = strTemp + new StringBuilder().append("000").append(p.toString()).toString().substring(new StringBuilder().append("000").append(p.toString()).toString().length() - 3);

        localInteger1 = i;
      }

      strTemp = Trans(strTemp);
    }
    catch (Exception e)
    {
      e.printStackTrace();
      strTemp = "";
    }
    return strTemp;
  }

  public String DeEncrypt(String strOld)
  {
    String strSource = "";
    try
    {
      Integer i = Integer.valueOf(0); Integer j = Integer.valueOf(0);
      int p = 0;
      Integer[] Key = { Integer.valueOf("36", 16), Integer.valueOf("8A", 16), Integer.valueOf("D5", 16), Integer.valueOf("A5", 16), Integer.valueOf("63", 16), Integer.valueOf("A8", 16), Integer.valueOf("5D", 16), Integer.valueOf("5A", 16) };
      strOld = Trans(strOld);

      int[] ss = new int[strOld.length() / 3];
      Integer localInteger1;
      Integer localInteger2;
      for (i = Integer.valueOf(0); i.intValue() < strOld.length() / 3; localInteger2 = i = Integer.valueOf(i.intValue() + 1))
      {
        p = Integer.valueOf(strOld.substring(i.intValue() * 3, i.intValue() * 3 + 3)).intValue() ^ Key[(i.intValue() % 8)].intValue();

        ss[i.intValue()] = p;

        localInteger1 = i;
      }

      int s = 0;
      Integer localInteger3;
      for (i = Integer.valueOf(0); i.intValue() < ss.length; localInteger3 = i = Integer.valueOf(i.intValue() + 1))
      {
        if (i.intValue() % 2 == 0)
        {
          s = ss[(i.intValue() + 1)];
          ss[(i.intValue() + 1)] = ss[i.intValue()];
          ss[i.intValue()] = s;
        }
        localInteger2 = i;
      }

      StringBuffer abc = new StringBuffer();
      Object a;
      String b;
      for (i = Integer.valueOf(0); i.intValue() < ss.length; i = Integer.valueOf(i.intValue() + 1))
      {
    	b = String.valueOf(i) ;
        if (i.intValue() % 2 == 0)
        {
          a = "00" + Integer.toHexString(ss[i.intValue()]).toString();
          b = "00" + Integer.toHexString(ss[(i.intValue() + 1)]).toString();
          abc.append("\\u" + ((String)a).substring(((String)a).length() - 2) + b.substring(b.length() - 2));
        }
        a = i;
      }

      strSource = unicode2string(abc.toString());
    }
    catch (Exception e)
    {
      e.printStackTrace();
      strSource = "";
    }
    return (String)strSource;
  }

  public String Trans(String str)
    throws Exception
  {
    String strTemp = "";
    Integer[] Key = { Integer.valueOf("6D", 16), Integer.valueOf("71", 16), Integer.valueOf("6", 16), Integer.valueOf("62", 16), Integer.valueOf("8", 16), Integer.valueOf("7C", 16), Integer.valueOf("1F", 16), Integer.valueOf("9", 16), Integer.valueOf("44", 16), Integer.valueOf("53", 16), Integer.valueOf("1D", 16), Integer.valueOf("5E", 16) };
    int i = 0; int p = 0;
    for (i = 0; i < str.length(); i++)
    {
      int tempi = str.substring(i, i + 1).toCharArray()[0];

      p = tempi ^ Key[(i % 12)].intValue();

      char tempc = (char)p;
      strTemp = strTemp + tempc;
    }
    return strTemp;
  }

  public String Code1(String lPwd)
    throws Exception
  {
    String TmpStr = "";
    for (int i = 0; i < lPwd.length(); i++)
    {
      Integer TmpAscii = Integer.valueOf(lPwd.substring(i, i + 1).toCharArray()[0] - ' ');

      if ((TmpAscii.intValue() > 47) && (TmpAscii.intValue() < 95))
      {
        if (i % 2 == 0)
          TmpStr = TmpStr + (char)(TmpAscii.intValue() - 15);
      }
      if ((TmpAscii.intValue() < 48) && (TmpAscii.intValue() > 0))
      {
        if (i % 2 == 0) {
          TmpStr = TmpStr + (char)(TmpAscii.intValue() + 79);
        }
      }
      if ((i % 2 != 0) && (TmpAscii.intValue() > 0) && (TmpAscii.intValue() < 95))
      {
        TmpStr = TmpStr + (char)(127 - TmpAscii.intValue());
      }

      if ((TmpAscii.intValue() > 0) && (TmpAscii.intValue() <= 94))
        continue;
      TmpStr = TmpStr + lPwd.substring(i, i + 1);
    }

    return TmpStr;
  }

  public String unicode2string(String str)
  {
    str = str == null ? "" : str;
    if (str.indexOf("\\u") == -1) {
      return str;
    }
    StringBuffer sb = new StringBuffer(1000);

    for (int i = 0; i <= str.length() - 6; ) {
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
          t = tempChar - '0';
        }

        c += t * (int)Math.pow(16.0D, value.length() - j - 1);
      }
      sb.append((char)c);
      i += 6;
    }
    return sb.toString();
  }
  public boolean isNumeric(String str) {
    Pattern pattern = Pattern.compile("[0-9]*");
    Matcher isNum = pattern.matcher(str);

    return isNum.matches();
  }
}