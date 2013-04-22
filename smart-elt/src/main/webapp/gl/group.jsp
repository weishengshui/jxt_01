<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",5,")==-1) 
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


function delgroup(id)
{
	if (confirm("确定要删除此小组吗！"))
	location.href= "group.jsp?gpid="+id;	
	
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
  <body>
  <%menun=6; %>
<%@ include file="head.jsp" %>
<%

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
Statement stmt2=conn.createStatement();
ResultSet rs=null;
ResultSet rs2=null;
Fun fun=new Fun();
String strsql="";
String gpid=request.getParameter("gpid");
int psize=10;
String pno="";
int ygn=0;
pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

if (!fun.sqlStrCheck(pno) || !fun.sqlStrCheck(gpid))
	return;
	
try
{
if (gpid!=null && !gpid.equals(""))
{
	strsql="delete from tbl_qyxz where nid=" +gpid;
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
					<li><a href="group.jsp" class="dangqian"><span><img src="images/ico-zh4.jpg" /></span><h1>小组管理</h1></a></li>
					<li><a href="item.jsp"><span><img src="images/ico-zh5.jpg" /></span><h1>发放名目管理</h1></a></li>
					<li><a href="info.jsp"><span><img src="images/ico-zh6.jpg" /></span><h1>公告管理</h1></a></li>
					<li><a href="admin.jsp"><span><img src="images/ico-zh7.jpg" /></span><h1>管理员管理</h1></a></li>
				</ul>
				<div class="zhszwrap">									
					<div class="zhsz-up">
					<span><strong>项目组管理：</strong>用于项目组的设置和管理</span>
					</div>
					<div class="zhsz-up2"><a href="groupedit.jsp"><img src="images/addbut.jpg" /></a></div>
				
				<div class="scoresjilu">					
					<div class="scoresjilu-t">
					  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="40">&nbsp;</td>
                          <td width="100">小组名称</td>
                          <td width="80">Leader</td>
                          <td width="400">小组成员</td>                    
                          <td>操作</td>
                        </tr>
                      </table>
					</div>
  	
				 	<%
				 	int tn=0;
				 	strsql="select count(*) as hn from tbl_qyxz where  qy="+session.getAttribute("qy");
				 	rs=stmt.executeQuery(strsql);
				 	if (rs.next())
				 	{
				 		tn=rs.getInt("hn");
				 	}
				 	rs.close();
				 	int pages=(tn-1)/psize+1;
				 	
				 	strsql="select x.nid,xzmc,ygxm from tbl_qyxz x left join tbl_qyyg q on x.ld=q.nid where x.qy="+session.getAttribute("qy")+" order by x.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
				 	rs=stmt.executeQuery(strsql);
				 	while(rs.next())
				 	{
				 	%>
				 	<div class="scoresjiluin">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable2">
				       <tr>
				         <td width="40">&nbsp;</td>
				         <td width="100"><%=rs.getString("xzmc")%></td>
				         <td width="80"><%=rs.getString("ygxm")%></td>
				         <td width="400">
				                   <%
				 	strsql="select y.ygxm from tbl_qyxzmc x left  join tbl_qyyg y on x.yg=y.nid where x.xz="+rs.getInt("nid");
				    ygn=0;
				 	rs2=stmt2.executeQuery(strsql);
				 	while(rs2.next())
				 	{				 		
				 		out.print(rs2.getString("ygxm")+",");
				 		ygn++;
				 		if (ygn>5)
				 		{
				 			out.print("...");	
				 			break;
				 		}
				 		
				 	}
				 	rs2.close();
				 	 %>
                    </td>                    
                   
					<td>
					<span class="floatleft"><a href="groupedit.jsp?gpid=<%=rs.getInt("nid") %>"><img src="images/editbut.jpg"/></a></span>
					<span class="floatleft"><a href="#" onclick="delgroup(<%=rs.getInt("nid")%>)"><img src="images/delbut.jpg"/></a></span>
				</td></tr>
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
					  		<h1><a href="group.jsp?pno=<%=Integer.valueOf(pno)-1 %>">上一页</a></h1>
					  	<%} if (Integer.valueOf(pno)<pages) {%>
					  		<h2><a href="group.jsp?pno=<%=Integer.valueOf(pno)+1 %>">下一页</a></h2>
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
