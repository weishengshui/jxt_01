<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

  <tr>
    <td style="border-bottom:4px #4f8d02 solid"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="256"><img src="images/logo.jpg" /></td>
        <td valign="bottom" style="background:url(images/top-bg.jpg) repeat-x bottom"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="26" align="right" bgcolor="#f4f4f4"><span class="toptxt1">欢迎您：<%=session.getAttribute("xtdlm")%></span><span class="toptxt2"><a href="pwdedit.jsp">修改密码</a></span><span class="toptxt2"><a href="logout.jsp">安全退出</a></span></td>
          </tr>
          <tr>
            <td height="30">&nbsp;</td>
          </tr>
          <tr>
            <td height="26">
				<ul class="nav">
				    <%
					
				    if (session.getAttribute("xtczqx")!=null)
				    {
				    	
				    	if (session.getAttribute("xtczqx").toString().indexOf("10")>-1)
						{
							if (menun!=null && menun.substring(0,2).equals("10"))
								out.print("<li><a class=\"nowone\" ");
							else
								out.print("<li><a ");
							//这里还要判断是否有此子菜单权限
							if (session.getAttribute("xtczqx").toString().indexOf("1001")>-1)
								out.print("href=\"shiyongqiye.jsp\">企业管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("1002")>-1)
								out.print("href=\"qiyexinxi.jsp\">企业管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("1003")>-1)
								out.print("href=\"qiyeyuangong.jsp\">企业管理</a></li>");
						}
					    if (session.getAttribute("xtczqx").toString().indexOf("20")>-1)
						{
							if (menun!=null && menun.substring(0,2).equals("20"))
								out.print("<li><a class=\"nowone\" ");
							else
								out.print("<li><a ");
							if (session.getAttribute("xtczqx").toString().indexOf("2001")>-1)
								out.print("href=\"zzweifukuan.jsp\">积分管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("2003")>-1)
								out.print("href=\"zzzaixianfukuan.jsp\">积分管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("2002")>-1)
								out.print("href=\"zzxianxiafukuan.jsp\">积分管理</a></li>");							
							else if (session.getAttribute("xtczqx").toString().indexOf("2004")>-1)
								out.print("href=\"zzchenggong.jsp\">积分管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("2005")>-1)
								out.print("href=\"zzshibai.jsp\">积分管理</a></li>");
						}
					    if (session.getAttribute("xtczqx").toString().indexOf("30")>-1)
						{
							if (menun!=null && menun.substring(0,2).equals("30"))
								out.print("<li><a class=\"nowone\" ");
							else
								out.print("<li><a ");
							if (session.getAttribute("xtczqx").toString().indexOf("3001")>-1)
								out.print("href=\"huodongleimu.jsp\">积分券管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("3002")>-1)
								out.print("href=\"jifenjuanhuodong.jsp\">积分券管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("3003")>-1)
								out.print("href=\"jifenjuan.jsp\">积分券管理</a></li>");
						}
					    if (session.getAttribute("xtczqx").toString().indexOf("40")>-1)
						{
							if (menun!=null && menun.substring(0,2).equals("40"))
								out.print("<li><a class=\"nowone\" ");
							else
								out.print("<li><a ");
							if (session.getAttribute("xtczqx").toString().indexOf("4004")>-1)
								out.print("href=\"splbgl.jsp\">商品管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("4001")>-1)
								out.print("href=\"spxlgl.jsp\">商品管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("4002")>-1)
								out.print("href=\"spnrgl.jsp\">商品管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("4005")>-1)
								out.print("href=\"sphdgl.jsp\">商品管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("4006")>-1)
								out.print("href=\"spgysgl.jsp\">商品管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("4007")>-1)
								out.print("href=\"spjhgl.jsp\">商品管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("4009")>-1)
								out.print("href=\"spckgl.jsp\">商品管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("4008")>-1)
								out.print("href=\"spkccx.jsp\">商品管理</a></li>");
							
							
						}
					    if (session.getAttribute("xtczqx").toString().indexOf("50")>-1)
						{
							if (menun!=null && menun.substring(0,2).equals("50"))
								out.print("<li><a class=\"nowone\" ");
							else
								out.print("<li><a ");
							if (session.getAttribute("xtczqx").toString().indexOf("5001")>-1)
								out.print("href=\"spwfkd.jsp\">兑换订单</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("5002")>-1)
								out.print("href=\"spwfhd.jsp\">兑换订单</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("5003")>-1)
								out.print("href=\"spwshd.jsp\">兑换订单</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("5004")>-1)
								out.print("href=\"spywcd.jsp\">兑换订单</a></li>");
						}
					    
					    
					    if (session.getAttribute("xtczqx").toString().indexOf("90")>-1)
						{
							if (menun!=null && menun.substring(0,2).equals("90"))
								out.print("<li><a class=\"nowone\" ");
							else
								out.print("<li><a ");
							if (session.getAttribute("xtczqx").toString().indexOf("9001")>-1)								
								out.print("href=\"guanliyuan.jsp\">系统管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("9002")>-1)								
								out.print("href=\"jianglimingmu.jsp\">系统管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("9003")>-1)								
								out.print("href=\"sysconfig.jsp\">系统管理</a></li>");
							else if (session.getAttribute("xtczqx").toString().indexOf("9004")>-1)								
								out.print("href=\"helpgl.jsp\">系统管理</a></li>");
						}
				    }
					%>
					
								
				</ul>
			</td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
 
 
