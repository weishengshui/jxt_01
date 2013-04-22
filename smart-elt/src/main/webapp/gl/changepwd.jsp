<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="jxt.elt.common.SecurityUtil"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>


<%
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";

String p1=request.getParameter("p1");
String p2=request.getParameter("p2");

if (!fun.sqlStrCheck(p1) || !fun.sqlStrCheck(p2))
{	
	out.print("0");
	return;
}
try
{
	SecurityUtil su=new SecurityUtil();
	strsql="select nid from tbl_qyyg where nid="+session.getAttribute("ygid")+" and dlmm='"+su.md5(p1)+"'";
	rs=stmt.executeQuery(strsql);
	if (!rs.next())
	{
		rs.close();
		out.print("0");
		return;
	}
	rs.close();
	strsql="update tbl_qyyg set dlmm='"+su.md5(p2)+"' where nid="+session.getAttribute("ygid");
	stmt.executeUpdate(strsql);
	out.print("1");
	return;

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
