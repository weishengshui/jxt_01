<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards企业员工忠诚度系统</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">


function delzw(id)
{
	if (confirm("确定要删除此职务吗，删除后此职务对应的员工信息有可能找不到！"))
	location.href= "post.jsp?zwid="+id;	
	
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
  <body>

<%

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="";
String zwid=request.getParameter("zwid");
int psize=10;
String pno="";
pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

if (!fun.sqlStrCheck(pno) || !fun.sqlStrCheck(zwid))
	return;
	
try
{
if (zwid!=null && !zwid.equals(""))
{
	strsql="delete from tbl_qyzw where nid=" +zwid;
	stmt.executeUpdate(strsql);
	
}

%>


 
  	
  	<table>
  	<tr><td>职务管理</td><td><a href="postedit.jsp">添加</a>　　<a href="main.jsp">返回</a></td></tr>
  	<tr><td>职位名称</td><td>操作</td></tr>
  	<%
  	int tn=0;
  	strsql="select count(*) as hn from tbl_qyzw where  qy="+session.getAttribute("qy");
  	rs=stmt.executeQuery(strsql);
  	if (rs.next())
  	{
  		tn=rs.getInt("hn");
  	}
  	rs.close();
  	int pages=(tn-1)/psize+1;
  	
  	strsql="select * from tbl_qyzw where qy="+session.getAttribute("qy")+" order by nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
  	rs=stmt.executeQuery(strsql);
  	while(rs.next())
  	{
  	%>
  	<tr><td><%=rs.getString("zwmc")%></td><td><a href="postedit.jsp?zwid=<%=rs.getInt("nid") %>">修改</a>  <a href="#" onclick="delzw(<%=rs.getInt("nid")%>)">删除</a></td></tr>
  	<%
  	}
  	rs.close();
  	 %>
  	</table>
  	<table><tr><td>
  	<%if (Integer.valueOf(pno)>1) {%>
  		<a href="post.jsp?pno=<%=Integer.valueOf(pno)-1 %>">上一页</a>
  	<%} if (Integer.valueOf(pno)<pages) {%>
  		<a href="post.jsp?pno=<%=Integer.valueOf(pno)+1 %>">下一页</a>
  	<%} %>
  	</td></tr></table>
  	</div>
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
