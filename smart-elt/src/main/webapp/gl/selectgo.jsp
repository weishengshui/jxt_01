<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="jxt.elt.common.DbPool"%>
<%@ include file="../common/hrlogcheck.jsp" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>

<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
  <body>

<div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>
<%
//取能发放的积分
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try{
strsql="select sum(x.jf-x.yffjf) from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid where x.ldbh="+session.getAttribute("ygid")+" and x.jf<>x.yffjf and f.ffsj<=date(SYSDATE()) and f.ffzt=1";
rs=stmt.executeQuery(strsql);
if (rs.next())
{
	session.setAttribute("qyjf",rs.getInt(1));
}
else
{
	session.setAttribute("qyjf","0");
}
rs.close();

//只取一个
String bmmc="",xzmc="";
strsql="select b.bmmc  from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid inner join tbl_qybm b on x.lxbh=b.nid where x.ldbh="+session.getAttribute("ygid")+" and x.jf<>x.yffjf and f.ffsj<=date(SYSDATE()) and f.ffzt=1 and x.fflx=1";
rs=stmt.executeQuery(strsql);
if (rs.next())
{
	bmmc=rs.getString("bmmc");
}
rs.close();

strsql="select z.xzmc  from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid inner join tbl_qyxz z on x.lxbh=z.nid where x.ldbh="+session.getAttribute("ygid")+" and x.jf<>x.yffjf and f.ffsj<=date(SYSDATE()) and f.ffzt=1 and x.fflx=2";
rs=stmt.executeQuery(strsql);
if (rs.next())
{
	xzmc=rs.getString("xzmc");
}
rs.close();

String showtxt="";
if (bmmc!=null && bmmc.length()>0 && xzmc!=null && xzmc.length()>0)
{
	showtxt="做为 "+bmmc+" 部门管理者登陆<br/>做为 "+xzmc+" 项目组管理者登陆";
}
else if (bmmc!=null && bmmc.length()>0)
{
	showtxt="做为 "+bmmc+" 部门管理者登陆";
}
else
{
	showtxt="做为 "+xzmc+" 项目组管理者登陆";
}
%>
<script type="text/javascript">
openLayer("<div class=\"paywenti\"><div class=\"paywenti2\"><span class=\"paywenti-t\">请选择操作界面</span><span class=\"floatleft\"><a href=\"leaderjf.jsp\"><%=showtxt%></a></span><span class=\"floatleft\"><a href=\"../eltcustom/login!list.do\">做为员工登陆</a></span></div></div>");
</script>
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
