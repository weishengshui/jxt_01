<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.omg.CORBA.INTERNAL"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%

if (session.getAttribute("ffjf")!=null && session.getAttribute("ffjf").equals("1")){
	
	out.print("<script type='text/javascript'>");
	out.print("location.href='leaderw.jsp';");
	out.print("</script>");
	return;
}


if (session.getAttribute("glqx").toString().indexOf(",13,")==-1) 
{
	out.print("<script type='text/javascript'>");
	out.print("location.href='main.jsp';");
	out.print("</script>");
	return;
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<style type="text/css">
.jf5{width:120px; float:left}
.jfin5{width:120px; color:#3eae21; font-weight:bold; float:left}
.jf3{width:130px; float:left}
.jfin3{width:130px; color:#ff6600; font-weight:bold; float:left}
</style>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
function showlist()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			document.getElementById("bwlist").innerHTML=response;
		}
		catch(exception){}
	}
}

function showbwlist(p)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "getbwlist.jsp?flag=fmfl&pno="+p+"&jfqmc="+encodeURI(escape(document.getElementById("jfqmc").value))+"&time="+timeParam;	
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlist;
	xmlHttp.send(null);
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
				<ul class="local2">
					<li class="local2-ico2"><h1 class="current-local">选择积分券</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></li>
					<li class="local2-ico3"><h1>选择发放对象</h1></li>
					<li class="local2-ico3"><h1>确认发放信息</h1></li>
					<li><h1>确认发放</h1></li>
				</ul>
				<div class="selectsend-top">
					<h1>您拥有的积分券</h1><div class="selectsend-top-r"><span class="floatleft txtsize14">关键字：</span><input type="text" class="cxinput" name="jfqmc" id="jfqmc" /><span class="floatleft"><span class="caxun" onclick="showbwlist(1)">查 询</span></span></div>
				</div>
				<div class="jftable" style="margin:3px 0 0 8px;"  id="bwlist">
					<div class="jftable-t">
						<div class="jf1">积分券</div>
						<div class="jf2">数量(张)</div>
						<div class="jf2">冻结(张)</div>
						<div class="jf3">单价(积分)</div>
						<div class="jf5">有效期</div>
						<div class="jf4"></div>
					</div>
					<ul class="jfin">
						<%
					int ln=0,pages=0;
					//strsql="select count(*) as hn from (select m.jfq from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where m.qy="+session.getAttribute("qy")+" and m.zt=1 and (m.sl<>m.ffsl or m.djsl>0) group by m.jfq,q.mc,q.jf) abc";
					strsql="select count(*) as hn from (select m.jfq from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where m.qy="+session.getAttribute("qy")+" and m.zt=1 and m.sl<>m.ffsl and q.yxq >= curdate() group by m.jfq,q.mc,q.jf) abc";					
					rs=stmt.executeQuery(strsql);
					if (rs.next())
					{ln=rs.getInt("hn");}
					rs.close();
					pages=(ln-1)/10+1;
					//strsql="select m.jfq,sum(m.sl-m.ffsl) as sysl,sum(m.djsl) as djsl,q.mc,q.jf from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where m.qy="+session.getAttribute("qy")+" and m.zt=1 and (m.sl<>m.ffsl or m.djsl>0) group by m.jfq,q.mc,q.jf order by m.nid desc limit 10";					
					strsql="select m.jfq,sum(m.sl-m.ffsl) as sysl,sum(m.djsl) as djsl,q.nid sid,q.hd hid,q.mc,q.jf, q.yxq as yxq from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where m.qy="+session.getAttribute("qy")+" and m.zt=1 and m.sl<>m.ffsl and q.yxq >= curdate() group by m.jfq,q.mc,q.jf order by m.nid desc limit 10";
					rs=stmt.executeQuery(strsql);
					System.out.println(strsql);
					while(rs.next())
					{
					%>
					<li>
						<div class="jfin1"><a href="welfare2.jsp?hid=<%=rs.getString("hid")%>&sid=<%=rs.getString("sid")%>"><%=rs.getString("mc")%></a></div>
						<div class="jfin2"><%=rs.getInt("sysl")%></div>
						<div class="jfin2"><%=rs.getInt("djsl")>0?"<a href='welfaresendlist.jsp?ffzt=0'>"+rs.getString("djsl")+"</a>":rs.getInt("djsl")%></div>
						<div class="jfin3"><%=rs.getInt("jf")%></div>
						<div class="jfin5"><%=rs.getDate("yxq")%></div>
						<div class="jfin4"><a href="assignwelfare.jsp?qid=<%=rs.getString("jfq")%>"><img src="images/fafang.jpg" /></a></div>					
					</li>
					<%}
					rs.close();
					%>
					</ul>
					<div class="pages bianju">
					<div class="pages-l">
					<%for (int i=1;i<=pages;i++) {
					%>
					<a href="javascript:void(0);" <%if (i==1) out.print(" class='psel'"); %> onclick="showbwlist(<%=i%>)"><%=i%></a>
					<%
					if (i>=6) break;
					} %>
					</div>
					<div class="pages-r">
					<%if (pages>1) out.print("<h2><a href='javascript:void(0);' onclick='showbwlist(2)'>下一页</a></h2>");%>					
					</div>
					<div style="clear: both; height: 25px; padding-top:10px; font-weight: bold;"><a href="welfaresendlist.jsp" style="color:#2ea6d7;">积分券发放记录>></a></div>				
				</div>
				
				</div>
				</div>
				
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