<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String na=request.getParameter("na");
String lxrid=request.getParameter("lxrid");
String xm=request.getParameter("xm");
String gh=request.getParameter("gh");
String sj=request.getParameter("sj");
String email=request.getParameter("email");
String qq=request.getParameter("qq");
String msn=request.getParameter("msn");
String skype=request.getParameter("skype");
String bz=request.getParameter("bz");
String strsql="";

if (xm!=null)
{
	xm=fun.unescape(xm);	
	xm=URLDecoder.decode(xm,"UTF-8");
}
if (email!=null)
{
	email=fun.unescape(email);	
	email=URLDecoder.decode(email,"UTF-8");
}

if (skype!=null)
{
	skype=fun.unescape(skype);	
	skype=URLDecoder.decode(skype,"UTF-8");
}

if (bz!=null)
{
	bz=fun.unescape(bz);	
	bz=URLDecoder.decode(bz,"UTF-8");
}
if (!fun.sqlStrCheck(xm) || !fun.sqlStrCheck(gh) || !fun.sqlStrCheck(sj) || !fun.sqlStrCheck(email) || !fun.sqlStrCheck(qq) || !fun.sqlStrCheck(qq) || !fun.sqlStrCheck(skype) ||!fun.sqlStrCheck(bz))
{
	
	return;
}

try
{
		if (na!=null && na.equals("edit"))
		{
			if (lxrid!=null && !lxrid.equals("") && !lxrid.equals("0"))
			{
				strsql="update tbl_qylxr set xm='"+xm+"',gh='"+gh+"',sj='"+sj+"',email='"+email+"',qq='"+qq+"',msn='"+msn+"',skype='"+skype+"',bz='"+bz+"' where nid="+lxrid;
				stmt.executeUpdate(strsql);
			}
			else
			{
				strsql="insert into tbl_qylxr (qy,xm,gh,sj,email,qq,msn,skype,bz) values("+session.getAttribute("qy")+",'"+xm+"','"+gh+"','"+sj+"','"+email+"','"+qq+"','"+msn+"','"+skype+"','"+bz+"')";
				stmt.executeUpdate(strsql);
			}
		}
		else if (na!=null && na.equals("del"))
		{
			if (lxrid!=null && !lxrid.equals("") && !lxrid.equals("0"))
			{
				strsql="delete from tbl_qylxr where nid="+lxrid;
				stmt.executeUpdate(strsql);
			}
		}
		
		%>
		<table>
		<tr><td colspan="8">企业联系人</td><td><a href="#" onclick="editlxr(0)">添加</a></td></tr>
  	<tr><td>姓名</td><td>固话</td><td>手机</td><td>email</td><td>qq</td><td>msn</td><td>skype</td><td>备注</td><td>操作</td></tr>
  	<%
  	strsql="select * from tbl_qylxr where qy="+session.getAttribute("qy");
  	rs=stmt.executeQuery(strsql);
  	while(rs.next())
  	{
  	%>
  	<tr><td><%=rs.getString("xm")%></td><td><%=rs.getString("gh") %></td><td><%=rs.getString("sj") %></td><td><%=rs.getString("email") %></td><td><%=rs.getString("qq") %></td><td><%=rs.getString("msn") %></td><td><%=rs.getString("skype") %></td><td><%=rs.getString("bz") %></td><td><a href="#" onclick="editlxr(<%=rs.getInt("nid")%>)">修改</a>  <a href="#" onclick="dellxr(<%=rs.getInt("nid")%>)">删除</a></td></tr>
  	<%
  	}
  	rs.close();
  	%></table><%

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