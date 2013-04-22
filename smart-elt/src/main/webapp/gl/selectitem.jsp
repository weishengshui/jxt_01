<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%

String mid=request.getParameter("mid");
if (mid==null || mid.equals(""))
return;
Fun fun=new Fun();

if (!fun.sqlStrCheck(mid))
return;

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
StringBuffer bmstr=new StringBuffer();
String strsql="";
try
{	
			strsql="select nid,mmmc  from tbl_jfmm where fmm="+mid;			
			rs=stmt.executeQuery(strsql);
			while (rs.next())
			{
				bmstr.append("<option value='"+rs.getString("nid")+"'>"+rs.getString("mmmc")+"</option>");
			}
			rs.close();
			
			if (bmstr.length()>0)
			{
				out.print("<select name='mm2' id='mm2' style=\"height: 30px;\"><option value=''>请选择</option>");
				out.print(bmstr.toString());
				out.print("</select>");
			}
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