<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%

if (session.getAttribute("glqx").toString().indexOf(",6,")==-1) 
	response.sendRedirect("main.jsp");

Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
String mmmc=request.getParameter("mmmc");

if (mmmc!=null)
{
	mmmc=fun.unescape(mmmc);	
	mmmc=URLDecoder.decode(mmmc,"UTF-8");
}
else
{
	return;
}

if (!fun.sqlStrCheck(mmmc))
{
	return;
}

try
{
	strsql="select nid from tbl_jfmm where (qy="+session.getAttribute("qy")+"  or qy=0) and mmmc='"+mmmc+"'";
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{
		out.print("0");
		return;
	}
	rs.close();
	strsql="insert into tbl_jfmm (qy,mmmc,fmm,bz) values("+session.getAttribute("qy")+",'"+mmmc+"',0,'')";
	stmt.executeUpdate(strsql);	
	
	out.print("<select name=\"mm1\" id=\"mm1\" onchange=\"showmm(this.value)\" style=\"height: 30px;\"><option value=''>请选择</option>");	
	strsql="select nid,mmmc from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and fmm=0";
		rs=stmt.executeQuery(strsql);
		while (rs.next())
		{
			if (rs.getString("mmmc").equals(mmmc))
				out.print("<option value='"+rs.getString("nid")+"' selected='selected'>"+rs.getString("mmmc")+"</option>");
			else
				out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("mmmc")+"</option>");	
		}
		rs.close();
	out.print("</select>");
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
