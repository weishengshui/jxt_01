<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
function reftopjf(jf)
{
	var shows="";
	for (var i=1;i<=jf.length;i++)
	{
		shows=shows+"<li>"+jf.substring(i-1,i)+"</li>";
	}	
	document.getElementById("headjf").innerHTML=shows;	
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
menun=1;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";

//企业端登陆后，去员工端的福利商城购买商品并用积分支付
if ("1".equals(request.getParameter("ygd")) && !session.getAttribute("qyjf").toString().equals(request.getParameter("hrqyjf"))) {
	String newqyjf = session.getAttribute("qyjf").toString();
	Connection conn2 = null;
	try {
		conn2 = DbPool.getInstance().getConnection();
		Statement stmt2 = conn2.createStatement();
		ResultSet rs2 = null;
		String strsql2 = "SELECT jf FROM tbl_qy where nid=" + session.getAttribute("qy");
		rs2 = stmt2.executeQuery(strsql2);
		if (rs2.next()) {
			newqyjf = rs2.getString("jf");
			rs2.close();
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		try {
			if (conn2 != null && !conn2.isClosed()) {
				conn2.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	session.setAttribute("qyjf", newqyjf);
}

try{%>
	<%@ include file="head.jsp" %>
	<%
	int jfqn=0;
	if (session.getAttribute("ffjf")==null)
	{
		strsql="select sum(sl-ffsl) as hn from tbl_jfqddmc where qy="+session.getAttribute("qy")+" and zt=1 and sl<>ffsl and ddtype=0";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			jfqn=rs.getInt("hn");
		}
		rs.close();
	}
	else
	{
		//取顶部总的待发放积分
		int headjf=0;
		//取部门项目组leader待发放积分
		String ffbm = session.getAttribute("ffbm").toString();
		if ("''".equals(ffbm)) {
	    	ffbm = "-1";
	    }
	    String ffxz = session.getAttribute("ffxz").toString();
	    if ("''".equals(ffxz)) {
	    	ffxz = "-1";
	    }
			
		strsql="select sum(x.jf-x.yffjf) from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid where ((x.fflx=1 and x.lxbh in ("+ffbm+")) or (x.fflx=2 and x.lxbh in ("+ffxz+"))) and x.jf<>x.yffjf  and f.ffzt=1";			
		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			headjf=rs.getInt(1);
		}
		rs.close();
		
		//取福利券
		strsql="select sum(x.jf-x.yffjf) from tbl_jfqffxx x inner join tbl_jfqff f on x.jfqff=f.nid where ((x.fflx=1 and x.lxbh in ("+ffbm+")) or (x.fflx=2 and x.lxbh in ("+ffxz+"))) and x.jf<>x.yffjf  and f.ffzt=1";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			jfqn=rs.getInt(1);
		}
		rs.close();
		
		
		session.setAttribute("qyjf",String.valueOf(headjf));
		out.print("<script type='text/javascript'>reftopjf('"+session.getAttribute("qyjf")+"');</script>");
		getjfxx(stmt, session);
		out.print("<script type='text/javascript'>reftopjfxx('"+session.getAttribute("hrffjf")+"', '"+session.getAttribute("gmjf")+"');</script>");
	}
	%>
	<div id="main">
		<div class="main2">
			<%if (isAuth) {%>
			<div class="jifeng-t">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %>&nbsp;&nbsp;&nbsp;&nbsp;<a href="buyintegral.jsp">立即充值&gt;&gt;</a></div>
			<%} %>
			<ul class="jifeng">
				<li><%if (session.getAttribute("glqx").toString().indexOf(",10,")==-1 && session.getAttribute("ffjf")==null) out.print("<img src=\"images/gmjf-index2.jpg\" />"); else out.print("<a href=\"buyintegral.jsp\"><img src=\"images/gmjf-index.jpg\" /></a>");%><span>企业可以购买积分，用于奖励员工，积分也可用来购买福利品</span></li>
				<li style="border-left:14px #F1F1F1 solid;"><%if (session.getAttribute("glqx").toString().indexOf(",11,")==-1 && session.getAttribute("ffjf")==null) out.print("<img src=\"images/ffjf-index2.jpg\" />"); else out.print("<a href=\"assignintegral.jsp\"><img src=\"images/ffjf-index.jpg\" /></a>");%><span>将账户上的积分选择性发放给员工或项目组</span></li>
			</ul>
			<ul class="fuli">
				<li><%if (session.getAttribute("glqx").toString().indexOf(",12,")==-1 && session.getAttribute("ffjf")==null) out.print("<img src=\"images/gmfl-index2.jpg\" />"); else out.print("<a href=\"buywelfare.jsp\"><img src=\"images/gmfl-index.jpg\" /></a>");%><span>企业可以进行弹性福利的选择和购买</span></li>
				<li style="border-left:14px #F2F8FA solid"><%if (session.getAttribute("glqx").toString().indexOf(",13,")==-1 && session.getAttribute("ffjf")==null) out.print("<img src=\"images/fffl-index2.jpg\" />"); else out.print("<a href=\"mywelfare.jsp\"><img src=\"images/fffl-index.jpg\" /></a>");%><span>将选购的福利品选择性地发放给员工或项目组<br/><a href="mywelfare.jsp" style="color: blue;">您还有 <em class="yellowtxt"><%=jfqn%></em> 张福利券 >></a></span></li>
			</ul>
			<span class="goshop"><!--<a href="ddlist.jsp">查看我的商城订单</a>&nbsp;&nbsp;<a href="#">去商城看看&gt;&gt;</a>--></span>
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