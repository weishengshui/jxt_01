<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",6,")==-1) 
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


function deldept(id)
{
	if (confirm("确定要删除此名目吗！"))
	location.href= "item.jsp?itemid="+id;	
	
}

function fiton(obj)
  {
     if (obj!=null){
			var subName=obj.id.substr(3);
			document.getElementById('D'+subName).style.display='';   
			obj.style.display='none';
			document.getElementById('simg'+subName).style.display='none';
			document.getElementById('on'+subName).style.display='';
			document.getElementById('oimg'+subName).style.display='';
	 }
  }
function fitoff(obj)
  {
     if (obj!=null){
			var subName=obj.id.substr(2);
			document.getElementById('D'+subName).style.display='none';   
			obj.style.display='none';
			document.getElementById('oimg'+subName).style.display='none'
			document.getElementById('off'+subName).style.display='';
			document.getElementById('simg'+subName).style.display='';
     }
  }

function fitm(obj)
   {
      if (obj!=null){
			var subName=obj.id.substr(1);
			if (document.getElementById('D'+subName).style.display=='none')
			   {
			    document.getElementById('D'+subName).style.display='block';
			    document.getElementById('on'+subName).style.display='block';
			    document.getElementById('oimg'+subName).style.display='block'
			    document.getElementById('off'+subName).style.display='none';
			    document.getElementById('simg'+subName).style.display='none'	   
			    }
			else
			   {
			    document.getElementById('oimg'+subName).style.display='none';
			    document.getElementById('D'+subName).style.display='none';
			    document.getElementById('off'+subName).style.display='block';
			    document.getElementById('on'+subName).style.display='none';
			    document.getElementById('simg'+subName).style.display='block'
			    }
		}
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
Statement stmtt=conn.createStatement();
ResultSet rs=null;
ResultSet rs2=null;
ResultSet rst=null;
Fun fun=new Fun();
String strsql="";
String itemid=request.getParameter("itemid");


if (!fun.sqlStrCheck(itemid))
	return;
	
try
{
if (itemid!=null && !itemid.equals(""))
{
	//
	strsql="select nid from tbl_jfmm where fmm="+itemid;
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
	
	strsql="select nid from tbl_jfff where mm1="+itemid+" or mm2="+itemid;
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
	

	strsql="select nid from tbl_jfqff where mm1="+itemid+" or mm2="+itemid;
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
	
	
	
	strsql="delete from tbl_jfmm where qy="+session.getAttribute("qy")+" and  nid=" +itemid;
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
					<li><a href="item.jsp" class="dangqian"><span><img src="images/ico-zh5.jpg" /></span><h1>发放名目管理</h1></a></li>
					<li><a href="info.jsp"><span><img src="images/ico-zh6.jpg" /></span><h1>公告管理</h1></a></li>
					<li><a href="admin.jsp"><span><img src="images/ico-zh7.jpg" /></span><h1>管理员管理</h1></a></li>
				</ul>
				<div class="zhszwrap">
					<div class="zhsz-up">
					<span><strong>奖励名目管理：</strong>用于设置企业奖励和福利发放的名目，最多可设置2级</span>
					</div>
					<div class="zhsz-up2"><a href="itemedit.jsp"><img src="images/addbut.jpg" /></a></div>
					
				
				<div class="scoresjilu">					
					<div class="scoresjilu-t">
					  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="40">&nbsp;</td>
                          <td>名目名称</td>                                            
                          <td width="300">操作</td>
                        </tr>
                      </table>
					</div>
  	
  	
  	
  
  	<%
  		
  		String sLine="0",sLine2="0";
  		int haves=0;
		int j=1;
		strsql="select * from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and fmm=0";
		rs=stmt.executeQuery(strsql);
		
		while (rs.next())
		{	  		  	   
			if (rs.isFirst())
			out.print("<div class='scoresjiluin' id='D0' style='display:block;'>");
			out.print("<table width='100%'  class='zhsztable2'  border='0' height=18 cellspacing=0 cellpadding=0><tr><td width=16> </td>");
	  		for (j=1;j<sLine.length();j++)
	  		{
	  			if (sLine.substring(j,j+1).equals("1"))
	  				out.print("<td width=16><img border=0 src='images/_1.gif' style='display:block;'></td>");
	  			else
	  				out.print("<td width=16> </td>");
	  		}
	  		
	  		strsql="select nid from tbl_jfmm where fmm="+rs.getString("nid");
		    rst=stmtt.executeQuery(strsql);
		    if (rst.next())
		    	haves=1;
		    else
		    	haves=0;
		    rst.close();
		    
	  	    if (rs.isLast())
	  	    {
	  	    	sLine2=sLine +"0";	  	    	
	  	    	if (haves==1)
	  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_4.gif'></span><span style='display:none;cursor:hand' id='on"+rs.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_41.gif'></span></td>");
	  	    	else
	  	    		out.print("<td width=16><img border=0 src='images/_2.gif'></td>");
	  	    	
	  	    }
	  	    else
	  	    {
	  	    	sLine2=sLine +"1";
	  	    	if (haves==1)
	  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_5.gif'></span><span style='display:none;cursor:hand' id='on"+rs.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_51.gif'></span></td>");
	  	    	else
	  	    		out.print("<td width=16><img border=0 src='images/_3.gif'></td>");     	
	  	    }
			
	  	    if (haves==1)
	  	    {
	  	    	out.print("<td width=16><span id='simg"+rs.getString("nid")+"'><img border=0 src='images/_close.gif'></span><span style='display:none;' id='oimg"+rs.getString("nid")+"'><img border=0 src='images/folder_open.gif'></span></td><td id='m"+rs.getString("nid")+"' onclick='fitm(this)' style='cursor:hand;padding-top:2px; font-size: 12px; '>"+rs.getString("mmmc")+"</font></td>");
	  	    	out.print("<td width='300'>");
	  	    	if (rs.getInt("qy")!=0)
	  	    	out.print("<span class=\"floatleft\"><a href=\"itemedit.jsp?naction=addson&itemid="+rs.getString("nid")+"\"><img src=\"images/addmmbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"itemedit.jsp?naction=edit&itemid="+rs.getString("nid")+"\"><img src=\"images/editbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"item.jsp?itemid="+rs.getString("nid")+"\"><img src=\"images/delbut.jpg\" /></a></span>");
	  	    	out.print("&nbsp;</td></tr></table>\n");
	  	    	
	  	    	strsql="select * from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and fmm="+rs.getString("nid");
	  	  		rs2=stmt2.executeQuery(strsql);
	  	  		
	  	  		while (rs2.next())
	  	  		{	  		  	   
	  	  			if (rs2.isFirst())
	  	  				out.print("<div id='D"+rs.getString("nid")+"' style='display:none;'>");
	  	  			out.print("<table width='100%'  class='zhsztable2'  border='0' height=18 cellspacing=0 cellpadding=0><tr><td width=16> </td>");
	  		  		for (j=1;j<sLine2.length();j++)
	  		  		{
	  		  			if (sLine2.substring(j,j+1).equals("1"))
	  		  				out.print("<td width=16><img border=0 src='images/_1.gif' style='display:block;'></td>");
	  		  			else
	  		  				out.print("<td width=16> </td>");
	  		  		}
	  		  		
	  		  		strsql="select nid from tbl_qybm where fbm="+rs2.getString("nid");
	  			    rst=stmtt.executeQuery(strsql);
	  			    if (rst.next())
	  			    	haves=1;
	  			    else
	  			    	haves=0;
	  			    rst.close();
	  			    
	  		  	    if (rs2.isLast())
	  		  	    {
	  		  	    		out.print("<td width=16><img border=0 src='images/_2.gif'></td>");
	  		  	    	
	  		  	    }
	  		  	    else
	  		  	    {
	  		  	    		out.print("<td width=16><img border=0 src='images/_3.gif'></td>");  	    	
	  		  	    }
	  				
	  		  	   
			  	    out.print("<td width=16><img border=0 src='images/file.gif'></td><td height=20 onmousedown=\"ChangeMyStyle(this)\" id=\"td"+rs2.getString("nid")+"\"  style='cursor:hand;padding-top:2px;'>"+rs2.getString("mmmc")+"</td>");
			  	  	out.print("<td width='197'>");
			  	    if (rs2.getInt("qy")!=0)
			  	    out.print("<span class=\"floatleft\"><a href=\"itemedit.jsp?naction=edit&itemid="+rs2.getString("nid")+"\"><img src=\"images/editbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"item.jsp?itemid="+rs2.getString("nid")+"\"><img src=\"images/delbut.jpg\" /></a></span>");
		  	    	out.print("&nbsp;</td></tr></table>\n");
	  		  	     	    
	  		  }
	  	  	  rs2.close();
	  	  	  out.print("</div>");
	  	    }
	  	    else
	  	    {
	  	    	out.print("<td width=16><img border=0 src='images/file.gif'></td><td height=20 id=\"td"+rs.getString("nid")+"\" style='cursor:hand;padding-top:2px;'>"+rs.getString("mmmc")+"</td>");
	  	    	out.print("<td width='300'>");
	  	    	if (rs.getInt("qy")!=0)
	  	    	out.print("<span class=\"floatleft\"><a href=\"itemedit.jsp?naction=addson&itemid="+rs.getString("nid")+"\"><img src=\"images/addmmbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"itemedit.jsp?naction=edit&itemid="+rs.getString("nid")+"\"><img src=\"images/editbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"item.jsp?itemid="+rs.getString("nid")+"\"><img src=\"images/delbut.jpg\" /></a></span>");
	  	    	out.print("&nbsp;</td></tr></table>\n");
	  	    }	  	    
	  }
	  rs.close();
	  out.print("</div>");
	  
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
