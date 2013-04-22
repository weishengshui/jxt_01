<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
int ln=0;
int pages=1;
int psize=10;
String lmid=request.getParameter("lmid");


if (!fun.sqlStrCheck(lmid) || lmid==null || lmid.equals(""))
{	
	return;
}
try
{
	strsql="select count(nid) as hn from tbl_jfqhd where zt=1 and now()>=kssj and now()<=jssj and tj=1 and lm="+lmid;
	
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{
		out.print("本类目还有<font color='red'>"+String.valueOf(4-rs.getInt("hn"))+"</font>个推荐位");
	}
	rs.close();

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
