<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.omg.CORBA.INTERNAL"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/calendar3.js"></script>
<script type="text/javascript">
function showlwslist(p)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "getlwslist.jsp?pno="+p+"&sffsj="+document.getElementById("sffsj").value+"&effsj="+document.getElementById("effsj").value+"&time="+timeParam;	
	
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlist;
	xmlHttp.send(null);
}
function showlist()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			document.getElementById("ljfslist").innerHTML=response;
		}
		catch(exception){}
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
menun=5;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try{%>
	<%@ include file="head.jsp" %>	
	<div id="main">
	  	<div class="main2">
  		  	<div class="box">
				<div class="hjr-box2">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="125" height="30" align="center"><strong>积分券发放记录</strong></td>
						<td width="100" align="center"></td>
						<td width="90"></td>
						<td width="20" height="30" align="center"></td>
						<td width="90" valign="top"></td>
						
						<td width="60" align="right"></td>
						<td width="90" valign="top"></td>
						
						<td width="110" align="right">发放日期：</td>
						<td width="90"><input type="text" class="input7" style="margin-top:0" name="sffsj" id="sffsj"  onclick="new Calendar().show(this);" readonly="readonly" /></td>
						<td width="20" align="center">-</td>
						<td width="90"><input type="text" class="input7" style="margin-top:0" name="effsj" id="effsj"  onclick="new Calendar().show(this);" readonly="readonly" /></td>
						
						<td align="right"><span class="caxun" style="margin-right:10px; margin-top:0;" onclick="showlwslist(1)">查询</span></td>
					  </tr>
					</table>
				</div>
				<div class="jfqffjl" id="ljfslist">
					<div class="jfqffjl-t">
						<div class="jfqffjl1">发放日期</div>						
						<div class="jfqffjl2">发放名目</div>
						<div class="jfqffjl3">接收对象</div>
						<div class="jfqffjl9">积分券</div>
						<div class="jfqffjl4">数量</div>
						<div class="jfqffjl5">发放部门</div>
						<div class="jfqffjl8">发放备注</div>
					</div>
					<ul class="jfqffjlin">
					<%
					int ln=0,pages=1;
					strsql="select count(f.nid) as hn from tbl_jfqff f inner join tbl_jfqffxx x on f.ffxx=x.nid where f.ffxx<>0 and ((x.fflx=1 and x.lxbh in ("+session.getAttribute("ffbm")+")) or (x.fflx=2 and x.lxbh in ("+session.getAttribute("ffxz")+")))";
					rs=stmt.executeQuery(strsql);
					if (rs.next())
					{
						ln=rs.getInt("hn");
					}
					rs.close();
					pages=(ln-1)/10+1;
					
					strsql="select f.nid,f.ffsj,m1.mmmc as mc1,m2.mmmc as mc2,f.hjr,ffjf,ffzt,f.srsj,x.jsmc,f.bz,q.mc as jfqmc from tbl_jfqff f inner join tbl_jfqffxx x on f.ffxx=x.nid left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid left join tbl_jfq q on f.jfq=q.nid where f.ffxx<>0 and ((x.fflx=1 and x.lxbh in ("+session.getAttribute("ffbm")+")) or (x.fflx=2 and x.lxbh in ("+session.getAttribute("ffxz")+"))) order by f.nid desc limit 10";
					rs=stmt.executeQuery(strsql);
					while (rs.next())
					{
					%>
						<li>
							<div class="jfqffjlin1"><%=sf.format(rs.getDate("ffsj"))%></div>
							<div class="jfqffjlin2"><a href="aworder.jsp?ffid=<%=rs.getString("nid")%>"><%if (rs.getString("mc2")!=null && rs.getString("mc2").length()>0) out.print(rs.getString("mc2")); else out.print(rs.getString("mc1")); %></a></div>
							<div class="jfqffjlin3"><%if (rs.getString("hjr")!=null && rs.getString("hjr").length()>20) out.print(rs.getString("hjr").substring(0,20)+"..."); else out.print(rs.getString("hjr"));%></div>
							<div class="jfqffjlin9" title="<%=rs.getString("jfqmc")%>"><%=rs.getString("jfqmc")%></div>
							<div class="jfqffjlin4"><%=rs.getString("ffjf")%></div>
							<div class="jfqffjlin5"><%=rs.getString("jsmc")%></div>
							<div class="jfqffjlin8" title="<%=rs.getString("bz")%>"><%=rs.getString("bz")%></div>							
						</li>
					<%}
					rs.close();
					%>	
					</ul>
					<div class="pages">
						<div class="pages-l">
						<%for (int i=1;i<=pages;i++) {
						%>
						<a href="javascript:void(0);" <%if (i==1) out.print(" class='psel'"); %> onclick="showlwslist(<%=i%>)"><%=i%></a>
						<%
						if (i>=6) break;
						} %>
						</div>
						<div class="pages-r">
						<%if (pages>1) out.print("<h2><a href='javascript:void(0);' onclick='showlwslist(2)'>下一页</a></h2>");%>					
						</div>		
					</div>
				</div>
				<div style="clear: both; height: 25px; padding-top: 10px; ">您还可以 <a href="leaderw.jsp" style="color: #2ea6d7">查看积分券库存</a></div>
		  </div>
	  	</div>
	</div>
	<%@ include file="footer.jsp" %> 
	<%
	
	
}
catch(Exception e)
{			
	e.printStackTrace();
}
finally
{
	if (!conn.isClosed())
		conn.close();
}
	 %>
</body>
</html>
		
