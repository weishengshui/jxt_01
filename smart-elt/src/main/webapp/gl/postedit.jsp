<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
function saveit()
{
	if (document.getElementById("zwmc").value=="")
	{
		alert("请填写职务名称！");
		return false;
	}
	document.getElementById("naction").value="save";
	document.getElementById("pform").submit();
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
  <body>

<%

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="",zwmc="",naction="",zwid="";
naction=request.getParameter("naction");
zwmc=request.getParameter("zwmc");
zwid=request.getParameter("zwid");
if (zwid==null) zwid="";
if (zwmc==null) zwmc="";

if (!fun.sqlStrCheck(zwid) || !fun.sqlStrCheck(zwmc))
{
	return;
}

try
{
		if (naction!=null && naction.equals("save"))
		{
			if (zwid!=null && !zwid.equals(""))
			strsql="update tbl_qyzw set zwmc='"+zwmc+"' where nid="+zwid;
			else
			strsql="insert into tbl_qyzw (qy,zwmc) values("+session.getAttribute("qy")+",'"+zwmc+"')";
			stmt.executeUpdate(strsql);
			//out.print(strsql);
			response.sendRedirect("post.jsp");
		}
		else if (zwid!=null && !zwid.equals(""))
		{
			strsql="select * from tbl_qyzw where nid="+zwid;		
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				zwmc=rs.getString("zwmc");			
			}
			rs.close();
		}
%>		

<form action="postedit.jsp" name="pform" id="pform" method="post">
<input type="hidden" name="zwid" id="zwid" value="<%=zwid%>" /> 
<input type="hidden" name="naction" id="naction" /> 
  	<table>
  	<tr><td colspan="2">职务设置</td></tr>
  	<tr><td><font color="red">*</font>  职务名称：</td><td><input type="text" name="zwmc" id="zwmc" value="<%=zwmc%>" maxlength="25" /></td></tr>
  	
  	<tr><td colspan="2"><input type="button" value="保存" onclick="saveit()" /></td></tr>
  	</table>
</form>
  	<%}
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