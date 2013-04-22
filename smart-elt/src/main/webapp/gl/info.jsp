<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",7,")==-1) 
	response.sendRedirect("main.jsp");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards企业员工忠诚度系统</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">

function delinfo(id)
{
	if (confirm("确定要删除此信息吗！"))
	location.href= "info.jsp?inid="+id;	
	
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
  <body>
  <%menun=6; %>
<%@ include file="head.jsp" %>
<%

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="";
String inid=request.getParameter("inid");
int psize=10;
String pno="";
pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

if (!fun.sqlStrCheck(pno) || !fun.sqlStrCheck(inid))
	return;

SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try
{
	if (inid!=null && !inid.equals(""))
	{
		strsql="delete from tbl_hrgb where nid=" +inid;
		stmt.executeUpdate(strsql);
		
	}

%>

	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="zhsz-top">
					<li><a href="company.jsp"><span><img src="images/ico-zh1.jpg" /></span><h1>企业信息管理</h1></a></li>
					<li><a href="department.jsp"><span><img src="images/ico-zh2.jpg" /></span><h1>组织架构管理</h1></a></li>
					<li><a href="staff.jsp"><span><img src="images/ico-zh3.jpg" /></span><h1>员工信息管理</h1></a></li>
					<li><a href="group.jsp"><span><img src="images/ico-zh4.jpg" /></span><h1>小组管理</h1></a></li>
					<li><a href="item.jsp"><span><img src="images/ico-zh5.jpg" /></span><h1>发放名目管理</h1></a></li>
					<li><a href="info.jsp" class="dangqian"><span><img src="images/ico-zh6.jpg" /></span><h1>公告管理</h1></a></li>
					<li><a href="admin.jsp"><span><img src="images/ico-zh7.jpg" /></span><h1>管理员管理</h1></a></li>
				</ul>
				<div class="zhszwrap">					
					<div class="zhsz-up">
					<span><strong>公告管理</strong></span>
					</div>
					<div class="zhsz-up2"><a href="infoedit.jsp"><img src="images/addbut.jpg" /></a></div>
  	
				<div class="scoresjilu">					
					<div class="scoresjilu-t">
					  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="40">&nbsp;</td>
                          <td width="150">标题</td>
                          <td width="400">内容</td>
                          <td width="100">发布时间</td>                                                
                          <td>操作</td>
                        </tr>
                      </table>
					</div>
					
  	<%
  	int tn=0;
  	strsql="select count(*) as hn from tbl_hrgb where  qy="+session.getAttribute("qy");
  	
  	rs=stmt.executeQuery(strsql);
  	if (rs.next())
  	{
  		tn=rs.getInt("hn");
  	}
  	rs.close();
  	int pages=(tn-1)/psize+1;
  	
  	strsql="select nid, bt,nr,fbsj from tbl_hrgb where qy="+session.getAttribute("qy")+" order by nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
  	
  	rs=stmt.executeQuery(strsql);
  	while(rs.next())
  	{
  	%>
			  	<div class="scoresjiluin">
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable2">
	                    <tr>
	                      <td width="40">&nbsp;</td>
	                      <td width="150"><%=rs.getString("bt")%></td>
	                      <td width="400"><%=rs.getString("nr")%></td>
	                      <td width="100"><%if (rs.getString("fbsj")!=null) out.print(sf.format(rs.getDate("fbsj")));%></td>
	                      <td>
	                     
	                      <span class="floatleft"><a href="#" onclick="delinfo(<%=rs.getInt("nid")%>)"><img src="images/delbut.jpg"/></a></span></td>
	     				</tr>
	     			</table>
	     		</div>
 


  	<%
  	}
  	rs.close();
  	 %>
  	</div>
				<div class="pages marginleft5">
					<div class="pages-l"></div>
					<div class="pages-r">
						<%if (Integer.valueOf(pno)>1) {%>
					  		<h1><a href="info.jsp?pno=<%=Integer.valueOf(pno)-1 %>">上一页</a></h1>
					  	<%} if (Integer.valueOf(pno)<pages) {%>
					  		<h2><a href="info.jsp?pno=<%=Integer.valueOf(pno)+1 %>">下一页</a></h2>
					  	<%} %>
					</div>
				</div>	
			</div>
	  	</div>
	</div>
 <%@ include file="footer.jsp" %> 
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
