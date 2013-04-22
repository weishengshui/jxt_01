<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String lxrid="",strsql="";
try
{
		lxrid=request.getParameter("lxrid");
		if (!fun.sqlStrCheck(lxrid)) lxrid="0";
		if (lxrid!=null && !lxrid.equals("") && !lxrid.equals("0"))
		{
			strsql="select * from tbl_qylxr where nid=" +lxrid;
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
			%>
			
			 <table>
			 <tr><td colspan="2">企业联系人编辑</td></tr>
			<tr><td>姓名</td><td><input type="text" name="xm" id="xm" maxlength="12" value="<%=rs.getString("xm")%>" /></td></tr>
			<tr><td>固话</td><td><input type="text" name="gh" id="gh" maxlength="50" value="<%=rs.getString("gh")%>" /></td></tr>
			<tr><td>手机</td><td><input type="text" name="sj" id="sj" maxlength="25" value="<%=rs.getString("sj")%>" /></td></tr>
			<tr><td>Email</td><td><input type="text" name="email" id="email" maxlength="50" value="<%=rs.getString("email")%>" /></td></tr>
			<tr><td>QQ</td><td><input type="text" name="qq" id="qq" maxlength="25" value="<%=rs.getString("qq")%>" /></td></tr>
			<tr><td>MSN</td><td><input type="text" name="msn" id="msn" maxlength="50" value="<%=rs.getString("msn")%>" /></td></tr>
			<tr><td>Skype</td><td><input type="text" name="skype" id="skype" maxlength="50" value="<%=rs.getString("skype")%>" /></td></tr>
			<tr><td>备注</td><td><textarea rows="3" cols="30" name="bz" id="bz"><%=rs.getString("bz") %></textarea></td></tr>
			<tr><td colspan="2"><input type="button" value="保存" onclick="savelxr(<%=rs.getInt("nid") %>)" /></td></tr>
			 </table>
			<%
			}
			rs.close();
		}
		else
		{
		%>
		 <table>
			 <tr><td colspan="2">企业联系人编辑</td></tr>
			<tr><td>姓名</td><td><input type="text" name="xm" id="xm" maxlength="12" /></td></tr>
			<tr><td>固话</td><td><input type="text" name="gh" id="gh" maxlength="50" /></td></tr>
			<tr><td>手机</td><td><input type="text" name="sj" id="sj" maxlength="25" /></td></tr>
			<tr><td>Email</td><td><input type="text" name="email" id="email" maxlength="50" /></td></tr>
			<tr><td>QQ</td><td><input type="text" name="qq" id="qq" maxlength="25" /></td></tr>
			<tr><td>MSN</td><td><input type="text" name="msn" id="msn" maxlength="50" /></td></tr>
			<tr><td>Skype</td><td><input type="text" name="skype" id="skype" maxlength="50" /></td></tr>
			<tr><td>备注</td><td><textarea rows="3" cols="30" name="bz" id="bz"></textarea></td></tr>
			<tr><td colspan="2"><input type="button" value="保存" onclick="savelxr(0)" /></td></tr>
			 </table>
		<%
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