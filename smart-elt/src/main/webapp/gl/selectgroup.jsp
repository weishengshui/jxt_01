<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%
String p=request.getParameter("p");
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="";
try
{
			out.print("<ul class='hjrbox2-l'>");
			strsql="select nid,xzmc from tbl_qyxz where  qy="+session.getAttribute("qy");	
			rs=stmt.executeQuery(strsql);
			while (rs.next())
			{				
			%>			
			<li><h1><input type="checkbox" name="xz<%=p%>" id="xz<%=p%>" onclick="changetjf(<%=p%>,2)" value="<%=rs.getInt("nid")%>" title="<%=rs.getString("xzmc")%>" /></h1><h2><%=rs.getString("xzmc")%></h2></li>
			
			<%
			}
			rs.close();
			out.print("</ul>");
			

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