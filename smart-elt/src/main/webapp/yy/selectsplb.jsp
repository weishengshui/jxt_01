<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%

String lbid=request.getParameter("lbid");
String lbl=request.getParameter("lbl");
if (lbid==null || lbid.equals("") || lbl==null || lbl.equals(""))
return;
Fun fun=new Fun();

if (!fun.sqlStrCheck(lbid) || !fun.sqlStrCheck(lbl))
return;

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
StringBuffer bmstr=new StringBuffer();
String strsql="";
try
{
			
			
			strsql="select nid,mc from tbl_splm where flm="+lbid;			
			rs=stmt.executeQuery(strsql);
			while (rs.next())
			{
				bmstr.append("<option value='"+rs.getString("nid")+"'>"+rs.getString("mc")+"</option>");
			}
			rs.close();
			if (bmstr.length()>0)
			{
				out.print("<select  name='lb"+lbl+"' id='lb"+lbl+"' onchange='lbshow(this.value,"+lbl+")'><option value=''>请选择</option>");
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