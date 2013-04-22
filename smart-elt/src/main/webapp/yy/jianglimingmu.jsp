<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("9002")==-1)
{
	out.print("你没有操作权限！");
	return;
}
Fun fun=new Fun();
int ln=0;


String naction=request.getParameter("naction");
String mmid=request.getParameter("mmid");
if (!fun.sqlStrCheck(mmid))
{	
	response.sendRedirect("jianglimingmu.jsp");
	return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/adminstyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">

function delit(lid)
{
	if (confirm("是否确认删除此名目，删除后无法恢复"))
	{
		location.href="jianglimingmu.jsp?naction=del&mmid="+lid;
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="9002";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Statement stmt2=conn.createStatement();
ResultSet rs2=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
try{
	if (naction!=null && naction.equals("del"))
	{
		strsql="select nid from tbl_jfmm where fmm="+mmid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			rs.close();
			out.print("<script type='text/javascript'>");
			out.print("alert('此名目有下级名目，请删除下级名目');");
			out.print("history.back(-1);");
			out.print("</script>");
			return;
		}
		rs.close();
		
		strsql="select nid from tbl_jfff where mm1="+mmid+" or mm2="+mmid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			rs.close();
			out.print("<script type='text/javascript'>");
			out.print("alert('此名目已经使用，不能删除 ');");
			out.print("history.back(-1);");
			out.print("</script>");
			return;
		}
		rs.close();
		

		strsql="select nid from tbl_jfqff where mm1="+mmid+" or mm2="+mmid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			rs.close();
			out.print("<script type='text/javascript'>");
			out.print("alert('此名目已经使用，不能删除 ');");
			out.print("history.back(-1);");
			out.print("</script>");
			return;
		}
		rs.close();
		
		strsql="delete from tbl_jfmm where nid="+mmid;
		stmt.executeUpdate(strsql);
	}
	
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <%@ include file="head.jsp" %>
  <tr>
    <td bgcolor="#f4f4f4"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="200" height="100%" valign="top"style="background:url(images/left-bottom.jpg) bottom">
			<%@ include file="leftmenu.jsp" %>
		  </td>
         <td width="10">&nbsp;</td>
        <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><div class="local"><span>系统管理&gt; 奖励名目管理</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					
					<div class="caxun-r"><a href="jlmmbianji.jsp" class="daorutxt">增加名目</a></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
           
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
             
              <tr>
                <td><table width="100%" border="0" cellspacing="1" cellpadding="1" class="maintable">
                  <tr>                   
                   <th width="60%">奖励名目名称</th>                                   
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select nid,mmmc from tbl_jfmm where qy=0 and fmm=0 order by nid desc"; 
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>                  	
                    <td style="text-align: left;">　　<%=rs.getString("mmmc")%></td>                  
                    <td><a href="jlmmbianji.jsp?naction=addson&itemid=<%=rs.getString("nid")%>" class="blue">增加子名目</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="jlmmbianji.jsp?naction=edit&itemid=<%=rs.getString("nid")%>" class="blue">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" class="blue" onclick="delit(<%=rs.getString("nid")%>)">删除</a></td>
                  </tr>
                  
                 <%
                 	strsql="select * from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and fmm="+rs.getString("nid");
	     	  		rs2=stmt2.executeQuery(strsql);
	     	  		while (rs2.next())
	     	  		{
	     	  			%>
	     	  			 <tr>                  	
		                    <td style="text-align: left;">　　　　<%=rs2.getString("mmmc")%></td>                  
		                    <td><a href="jlmmbianji.jsp?naction=edit&itemid=<%=rs2.getString("nid")%>" class="blue">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" class="blue" onclick="delit(<%=rs2.getString("nid")%>)">删除</a></td>
		                  </tr>
	     	  			<%
	     	  		}
	     	  		rs2.close();
                  }
                  rs.close();
                  %>
                
                </table>
				</td>
              </tr>
            </table></td>
          </tr>
          
        </table></td>
        <td width="20">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
  <%@ include file="bottom.jsp" %>
</table>
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