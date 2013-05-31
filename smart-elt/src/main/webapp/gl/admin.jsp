<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",1,")==-1) 
	response.sendRedirect("main.jsp");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards企业员工忠诚度系统</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="js/common.js"></script>
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">


function delad(id)
{
	if (confirm("确定要删除此管理员吗！"))
	location.href= "admin.jsp?adid="+id;	
	
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
  <body>
<%menun=6; %>
<%

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="";
String adid=request.getParameter("adid");
int psize=10;
String pno="";
pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

if (!fun.sqlStrCheck(pno) || !fun.sqlStrCheck(adid))
	return;
	
try
{
if (adid!=null && !adid.equals(""))
{
	strsql="update tbl_qyyg set gly=0,glqx='' where nid=" +adid;
	stmt.executeUpdate(strsql);
	
}

%>

	<%@ include file="head.jsp" %>
  	
  	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="zhsz-top">
					<li><a href="company.jsp"><span><img src="images/ico-zh1.jpg" /></span><h1>企业信息管理</h1></a></li>
					<li><a href="department.jsp"><span><img src="images/ico-zh2.jpg" /></span><h1>组织架构管理</h1></a></li>
					<li><a href="staff.jsp"><span><img src="images/ico-zh3.jpg" /></span><h1>员工信息管理</h1></a></li>
					<li><a href="group.jsp"><span><img src="images/ico-zh4.jpg" /></span><h1>小组管理</h1></a></li>
					<li><a href="item.jsp"><span><img src="images/ico-zh5.jpg" /></span><h1>发放名目管理</h1></a></li>
					<li><a href="info.jsp"><span><img src="images/ico-zh6.jpg" /></span><h1>公告管理</h1></a></li>
					<li><a href="admin.jsp" class="dangqian"><span><img src="images/ico-zh7.jpg" /></span><h1>管理员管理</h1></a></li>
				</ul>
				<div class="zhszwrap">
					
					<div class="zhsz-up">
					<span><strong>管理员管理：</strong>用于操作员在系统中各功能模块的操作权限设置</span>
					</div>
				
				
  	
				<div class="scoresjilu">					
					<div class="scoresjilu-t">
					  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="40">&nbsp;</td>
                          <td width="80">姓名</td>
                          <td width="600">权限</td>                                                  
                          <td>操作</td>
                        </tr>
                      </table>
					</div>
	
  	<%
  
  	
  	strsql="select nid,ygxm,glqx from tbl_qyyg where qy="+session.getAttribute("qy")+"  and gly=1 order by nid desc";
  	rs=stmt.executeQuery(strsql);
  	while(rs.next())
  	{
  	%>
	<div class="scoresjiluin">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable2">
                  <tr>
                    <td width="40">&nbsp;</td>
                    <td width="80"><%=rs.getString("ygxm")%></td>
                    <td width="600">
                    	<%
					  		if (rs.getString("glqx")!=null && rs.getString("glqx").indexOf(",1,")>-1)
					  		out.print("[管理员管理]");
					  		if (rs.getString("glqx")!=null && rs.getString("glqx").indexOf(",2,")>-1)
					  		out.print("[企业信息管理] ");
					  		if (rs.getString("glqx")!=null && rs.getString("glqx").indexOf(",3,")>-1)
					  		out.print("[组织架构管理]");					  		
					  		if (rs.getString("glqx")!=null && rs.getString("glqx").indexOf(",4,")>-1)
					  		out.print("[员工信息管理]");
					  		if (rs.getString("glqx")!=null && rs.getString("glqx").indexOf(",5,")>-1)
					  		out.print("[小组管理]");
					  		if (rs.getString("glqx")!=null && rs.getString("glqx").indexOf(",6,")>-1)
					  		out.print("[奖励名目管理 ]");
					  		if (rs.getString("glqx")!=null && rs.getString("glqx").indexOf(",7,")>-1)
					  		out.print("[公告管理]");
					  		
					  		if (rs.getString("glqx")!=null && rs.getString("glqx").indexOf(",10,")>-1)
						  		out.print("[购买积分]");
					  		
					  		if (rs.getString("glqx")!=null && rs.getString("glqx").indexOf(",11,")>-1)
						  		out.print("[发放积分]");
					  		
					  		if (rs.getString("glqx")!=null && rs.getString("glqx").indexOf(",12,")>-1)
						  		out.print("[购买福利]");
					  		
					  		if (rs.getString("glqx")!=null && rs.getString("glqx").indexOf(",13,")>-1)
						  		out.print("[发放福利]");
					  		
					  		if (rs.getString("glqx")!=null && rs.getString("glqx").indexOf(",14,")>-1)
						  		out.print("[福利商城]");
					  	 %>
                    </td>
                    <td>
                    <span class="floatleft"><a href="adminedit.jsp?adid=<%=rs.getInt("nid") %>"><img src="images/editbut.jpg"/></a></span>                    
                    <span class="floatleft"><a href="#" onclick="delad(<%=rs.getInt("nid")%>)"><img src="images/delbut.jpg"/></a></span></td>
   				</tr>
   			</table>
   		</div>
	     		
  	
  	<%
  	}
  	rs.close();
  	 %>
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
