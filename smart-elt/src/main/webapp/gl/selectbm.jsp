<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%

String bmid=request.getParameter("bmid");
String bml=request.getParameter("bml");
if (bmid==null || bmid.equals("") || bml==null || bml.equals(""))
return;
Fun fun=new Fun();

if (!fun.sqlStrCheck(bmid) || !fun.sqlStrCheck(bml))
return;

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
StringBuffer bmstr=new StringBuffer();
String strsql="";
try
{
			
			
			strsql="select nid,bmmc from tbl_qybm where fbm="+bmid;			
			rs=stmt.executeQuery(strsql);
			while (rs.next())
			{
				bmstr.append("<option value='"+rs.getString("nid")+"'>"+rs.getString("bmmc")+"</option>");
			}
			rs.close();
			if (bmstr.length()>0)
			{
				out.print("<select  name='bm"+bml+"' id='bm"+bml+"' onchange='bmshow(this.value,"+bml+")'><option value=''>请选择</option>");
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