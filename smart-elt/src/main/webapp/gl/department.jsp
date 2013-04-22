<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",3,")==-1) 
	response.sendRedirect("main.jsp");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">


function deldept(id)
{
	if (confirm("是否确定要删除此部门！"))
	location.href= "department.jsp?bmid="+id;	
	
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

<%
menun=6;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
Statement stmt2=conn.createStatement();
Statement stmt3=conn.createStatement();
Statement stmt4=conn.createStatement();
Statement stmt5=conn.createStatement();
Statement stmtt=conn.createStatement();
ResultSet rs=null;
ResultSet rs2=null;
ResultSet rs3=null;
ResultSet rs4=null;
ResultSet rs5=null;
ResultSet rst=null;
Fun fun=new Fun();
String strsql="";
String bmid=request.getParameter("bmid");


if (!fun.sqlStrCheck(bmid))
	return;
	
try
{
if (bmid!=null && !bmid.equals(""))
{
	strsql="select nid from tbl_qyyg where bm like '%,"+bmid+",%'";
	
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{
		rs.close();
		out.print("<script type='text/javascript'>");
		out.print("alert('此部门已经使用，不能删除 ');");
		out.print("history.back(-1);");
		out.print("</script>");
		return;
	}
	rs.close();
	//这里要把子部门全部删除掉
	strsql="delete from tbl_qybm where nid=" +bmid;
	stmt.executeUpdate(strsql);
	
}

%>


 	<%@ include file="head.jsp" %>
  	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="zhsz-top">
					<li><a href="company.jsp"><span><img src="images/ico-zh1.jpg" /></span><h1>企业信息管理</h1></a></li>
					<li><a href="department.jsp" class="dangqian"><span><img src="images/ico-zh2.jpg" /></span><h1>组织架构管理</h1></a></li>
					<li><a href="staff.jsp"><span><img src="images/ico-zh3.jpg" /></span><h1>员工信息管理</h1></a></li>
					<li><a href="group.jsp"><span><img src="images/ico-zh4.jpg" /></span><h1>小组管理</h1></a></li>
					<li><a href="item.jsp"><span><img src="images/ico-zh5.jpg" /></span><h1>发放名目管理</h1></a></li>
					<li><a href="info.jsp"><span><img src="images/ico-zh6.jpg" /></span><h1>公告管理</h1></a></li>
					<li><a href="admin.jsp"><span><img src="images/ico-zh7.jpg" /></span><h1>管理员管理</h1></a></li>
				</ul>
				
				<div class="zhszwrap">
					<div class="zhsz-up">
					<span><strong>组织架构管理：</strong>设置设置公司的组织架构层级，用于部门奖励/福利发放，最多可设置5级</span>
					</div>
					<div class="zhsz-up2"><a href="departmentedit.jsp"><img src="images/adddepartment.jpg" /></a></div>
				
				<div class="scoresjilu">					
					<div class="scoresjilu-t">
					  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="40">&nbsp;</td>
                          <td>部门名称</td>                                     
                          <td width="300">操作</td>
                        </tr>
                      </table>
					</div>
	
  	<%
  		String sLine="0",sLine2="0",sLine3="0",sLine4="0",sLine5="0";
  	
  		int haves=0;
  		int j=1;
  		strsql="select b.nid,b.bmmc,y.ygxm from tbl_qybm b left join tbl_qyyg y on b.ld=y.nid where b.qy="+session.getAttribute("qy")+" and b.fbm=0";
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
	  		
	  		strsql="select nid from tbl_qybm where fbm="+rs.getString("nid");
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
	  	    	out.print("<td width=16><span id='simg"+rs.getString("nid")+"'><img border=0 src='images/_close.gif'></span><span style='display:none;' id='oimg"+rs.getString("nid")+"'><img border=0 src='images/folder_open.gif'></span></td><td id='m"+rs.getString("nid")+"' onclick='fitm(this)' style='cursor:hand;padding-top:2px; font-size: 12px; '>"+rs.getString("bmmc")+"</font></td>");
	  	    	out.print("<td width='300'><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=addson&bmid="+rs.getString("nid")+"\"><img src=\"images/addsonbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=edit&bmid="+rs.getString("nid")+"\"><img src=\"images/editbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"javascript:void(0);\" onclick=\"deldept("+rs.getString("nid")+")\"><img src=\"images/delbut.jpg\" /></a></span></td>");
	  	    	out.print("</tr></table>\n");
	  	    	
	  	    	strsql="select b.nid,b.bmmc,y.ygxm from tbl_qybm b left join tbl_qyyg y on b.ld=y.nid where b.qy="+session.getAttribute("qy")+" and b.fbm="+rs.getString("nid");
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
	  		  	    	sLine3=sLine2 +"0";	  	    	
	  		  	    	if (haves==1)
	  		  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs2.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_4.gif'></span><span style='display:none;cursor:hand' id='on"+rs2.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_41.gif'></span></td>");
	  		  	    	else
	  		  	    		out.print("<td width=16><img border=0 src='images/_2.gif'></td>");
	  		  	    	
	  		  	    }
	  		  	    else
	  		  	    {
	  		  	    	sLine3=sLine2 +"1";
	  		  	    	if (haves==1)
	  		  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs2.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_5.gif'></span><span style='display:none;cursor:hand' id='on"+rs2.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_51.gif'></span></td>");
	  		  	    	else
	  		  	    		out.print("<td width=16><img border=0 src='images/_3.gif'></td>");  	    	
	  		  	    }
	  				
	  		  	    if (haves==1)
	  		  	    {
	  		  	    	out.print("<td width=16><span id='simg"+rs2.getString("nid")+"'><img border=0 src='images/_close.gif'></span><span style='display:none;' id='oimg"+rs2.getString("nid")+"'><img border=0 src='images/folder_open.gif'></span></td><td id='m"+rs2.getString("nid")+"' onclick='fitm(this)' style='cursor:hand;padding-top:2px; font-size: 12px; '>"+rs2.getString("bmmc")+"</font></td>\n");
		  		  	    out.print("<td width='300'><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=addson&bmid="+rs2.getString("nid")+"\"><img src=\"images/addsonbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=edit&bmid="+rs2.getString("nid")+"\"><img src=\"images/editbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"javascript:void(0);\" onclick=\"deldept("+rs2.getString("nid")+")\"><img src=\"images/delbut.jpg\" /></a></span></td>");
			  	    	out.print("</tr></table>\n");
	  		  	    	
		  		  	    strsql="select b.nid,b.bmmc,y.ygxm from tbl_qybm b left join tbl_qyyg y on b.ld=y.nid where b.qy="+session.getAttribute("qy")+" and b.fbm="+rs2.getString("nid");
			  	  		rs3=stmt3.executeQuery(strsql);
			  	  		
			  	  		while (rs3.next())
			  	  		{	  		  	   
			  	  		if (rs3.isFirst())
			  	  			out.print("<div id='D"+rs2.getString("nid")+"' style='display:none;'>");
			  	  	out.print("<table width='100%'  class='zhsztable2'  border='0' height=18 cellspacing=0 cellpadding=0><tr><td width=16> </td>");
			  		  		for (j=1;j<sLine3.length();j++)
			  		  		{
			  		  			if (sLine3.substring(j,j+1).equals("1"))
			  		  				out.print("<td width=16><img border=0 src='images/_1.gif' style='display:block;'></td>");
			  		  			else
			  		  				out.print("<td width=16> </td>");
			  		  		}
			  		  		
			  		  		strsql="select nid from tbl_qybm where fbm="+rs3.getString("nid");
			  			    rst=stmtt.executeQuery(strsql);
			  			    if (rst.next())
			  			    	haves=1;
			  			    else
			  			    	haves=0;
			  			    rst.close();
			  			    
			  		  	    if (rs3.isLast())
			  		  	    {
			  		  	    	sLine4=sLine3 +"0";	  	    	
			  		  	    	if (haves==1)
			  		  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs3.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_4.gif'></span><span style='display:none;cursor:hand' id='on"+rs3.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_41.gif'></span></td>");
			  		  	    	else
			  		  	    		out.print("<td width=16><img border=0 src='images/_2.gif'></td>");
			  		  	    	
			  		  	    }
			  		  	    else
			  		  	    {
			  		  	    	sLine4=sLine3 +"1";
			  		  	    	if (haves==1)
			  		  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs3.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_5.gif'></span><span style='display:none;cursor:hand' id='on"+rs3.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_51.gif'></span></td>");
			  		  	    	else
			  		  	    		out.print("<td width=16><img border=0 src='images/_3.gif'></td>");  	    	
			  		  	    }
			  				
			  		  	    if (haves==1)
			  		  	    {
			  		  	    	out.print("<td width=16><span id='simg"+rs3.getString("nid")+"'><img border=0 src='images/_close.gif'></span><span style='display:none;' id='oimg"+rs3.getString("nid")+"'><img border=0 src='images/folder_open.gif'></span></td><td id='m"+rs3.getString("nid")+"' onclick='fitm(this)' style='cursor:hand;padding-top:2px; font-size: 12px; '>"+rs3.getString("bmmc")+"</font></td>");
				  		  	    out.print("<td width='300'><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=addson&bmid="+rs3.getString("nid")+"\"><img src=\"images/addsonbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=edit&bmid="+rs3.getString("nid")+"\"><img src=\"images/editbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"javascript:void(0);\" onclick=\"deldept("+rs3.getString("nid")+")\"><img src=\"images/delbut.jpg\" /></a></span></td>");
					  	    	out.print("</tr></table>\n");
			  		  	    	
			  		  	    	
				  		  	    strsql="select b.nid,b.bmmc,y.ygxm from tbl_qybm b left join tbl_qyyg y on b.ld=y.nid where b.qy="+session.getAttribute("qy")+" and b.fbm="+rs3.getString("nid");
					  	  		rs4=stmt4.executeQuery(strsql);
					  	  		
					  	  		while (rs4.next())
					  	  		{	  		  	   
					  	  			if (rs4.isFirst())
					  	  			out.print("<div id='D"+rs3.getString("nid")+"' style='display:none;'>");
					  	  		out.print("<table width='100%'  class='zhsztable2'  border='0' height=18 cellspacing=0 cellpadding=0><tr><td width=16> </td>");
					  		  		for (j=1;j<sLine4.length();j++)
					  		  		{
					  		  			if (sLine4.substring(j,j+1).equals("1"))
					  		  				out.print("<td width=16><img border=0 src='images/_1.gif' style='display:block;'></td>");
					  		  			else
					  		  				out.print("<td width=16> </td>");
					  		  		}
					  		  		
					  		  		strsql="select nid from tbl_qybm where fbm="+rs4.getString("nid");
					  			    rst=stmtt.executeQuery(strsql);
					  			    if (rst.next())
					  			    	haves=1;
					  			    else
					  			    	haves=0;
					  			    rst.close();
					  			    
					  		  	    if (rs4.isLast())
					  		  	    {
					  		  	    	sLine5=sLine4 +"0";	  	    	
					  		  	    	if (haves==1)
					  		  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs4.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_4.gif'></span><span style='display:none;cursor:hand' id='on"+rs4.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_41.gif'></span></td>");
					  		  	    	else
					  		  	    		out.print("<td width=16><img border=0 src='images/_2.gif'></td>");
					  		  	    	
					  		  	    }
					  		  	    else
					  		  	    {
					  		  	    	sLine5=sLine4 +"1";
					  		  	    	if (haves==1)
					  		  	    		out.print("<td width=16><span style='cursor:hand' id='off"+rs4.getString("nid")+"' onclick='fiton(this)'><img border=0 src='images/_5.gif'></span><span style='display:none;cursor:hand' id='on"+rs4.getString("nid")+"' onclick='fitoff(this)'><img border=0 src='images/_51.gif'></span></td>");
					  		  	    	else
					  		  	    		out.print("<td width=16><img border=0 src='images/_3.gif'></td>");  	    	
					  		  	    }
					  				
					  		  	    if (haves==1)
					  		  	    {
					  		  	    	out.print("<td width=16><span id='simg"+rs4.getString("nid")+"'><img border=0 src='images/_close.gif'></span><span style='display:none;' id='oimg"+rs4.getString("nid")+"'><img border=0 src='images/folder_open.gif'></span></td><td id='m"+rs4.getString("nid")+"' onclick='fitm(this)' style='cursor:hand;padding-top:2px; font-size: 12px; '>"+rs4.getString("bmmc")+"</font></td>");
						  		  	    out.print("<td width='300'><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=addson&bmid="+rs4.getString("nid")+"\"><img src=\"images/addsonbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=edit&bmid="+rs4.getString("nid")+"\"><img src=\"images/editbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"javascript:void(0);\" onclick=\"deldept("+rs4.getString("nid")+")\"><img src=\"images/delbut.jpg\" /></a></span></td>");
							  	    	out.print("</tr></table>\n");
						  		  	    strsql="select b.nid,b.bmmc,y.ygxm from tbl_qybm b left join tbl_qyyg y on b.ld=y.nid where b.qy="+session.getAttribute("qy")+" and b.fbm="+rs4.getString("nid");
							  	  		rs5=stmt5.executeQuery(strsql);
							  	  		
							  	  		while (rs5.next())
							  	  		{	  		  	   
							  	  			if (rs5.isFirst())
							  	  			out.print("<div id='D"+rs4.getString("nid")+"' style='display:none;'>");
							  	  		out.print("<table width='100%'  class='zhsztable2'  border='0' height=18 cellspacing=0 cellpadding=0><tr><td width=16> </td>");
							  		  		for (j=1;j<sLine5.length();j++)
							  		  		{
							  		  			if (sLine5.substring(j,j+1).equals("1"))
							  		  				out.print("<td width=16><img border=0 src='images/_1.gif' style='display:block;'></td>");
							  		  			else
							  		  				out.print("<td width=16> </td>");
							  		  		}
							  			    haves=0;							  			    
							  		  	    if (rs5.isLast())
							  		  	    {
							  		  	    	out.print("<td width=16><img border=0 src='images/_2.gif'></td>");							  		  	    	
							  		  	    }
							  		  	    else
							  		  	    {							  		  	    	
							  		  	    	out.print("<td width=16><img border=0 src='images/_3.gif'></td>");  	    	
							  		  	    }							  				
							  		  	    
							  		  	    out.print("<td width=16><img border=0 src='images/file.gif'></td><td height=20 onmousedown=\"ChangeMyStyle(this)\" id=\"td"+rs5.getString("nid")+"\" style='cursor:hand;padding-top:2px;'>"+rs5.getString("bmmc")+"</td>");
								  		  	out.print("<td width='300'><span class=\"floatleft\"></span><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=edit&bmid="+rs5.getString("nid")+"\"><img src=\"images/editbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"javascript:void(0);\" onclick=\"deldept("+rs5.getString("nid")+")\"><img src=\"images/delbut.jpg\" /></a></span></td>");
								  	    	out.print("</tr></table>\n");	    	  	    
							  		  }
							  	  	  rs5.close();
							  	  	  out.print("</div>");
					  		  	    	
					  		  	    }
					  		  	    else
					  		  	    {
					  		  	    	out.print("<td width=16><img border=0 src='images/file.gif'></td><td height=20 onmousedown=\"ChangeMyStyle(this)\" id=\"td"+rs4.getString("nid")+"\" style='cursor:hand;padding-top:2px;'>"+rs4.getString("bmmc")+"</td>");
						  		  	    out.print("<td width='300'><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=addson&bmid="+rs4.getString("nid")+"\"><img src=\"images/addsonbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=edit&bmid="+rs4.getString("nid")+"\"><img src=\"images/editbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"javascript:void(0);\" onclick=\"deldept("+rs4.getString("nid")+")\"><img src=\"images/delbut.jpg\" /></a></span></td>");
							  	    	out.print("</tr></table>\n");
					  		  	    }	  	    
					  		  }
					  	  	  rs4.close();
					  	  	  out.print("</div>");
				  	  	  
				  	  	  
			  		  	    }
			  		  	    else
			  		  	    {
			  		  	    	out.print("<td width=16><img border=0 src='images/file.gif'></td><td height=20 onmousedown=\"ChangeMyStyle(this)\" id=\"td"+rs3.getString("nid")+"\" style='cursor:hand;padding-top:2px;'>"+rs3.getString("bmmc")+"</td>");
			  		  	    out.print("<td width='300'><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=addson&bmid="+rs3.getString("nid")+"\"><img src=\"images/addsonbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=edit&bmid="+rs3.getString("nid")+"\"><img src=\"images/editbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"javascript:void(0);\" onclick=\"deldept("+rs3.getString("nid")+")\"><img src=\"images/delbut.jpg\" /></a></span></td>");
				  	    	out.print("</tr></table>\n");
			  		  	    }	  	    
			  		  }
			  	  	  rs3.close();
			  	  	  out.print("</div>");
	  		  	    }
	  		  	    else
	  		  	    {
	  		  	    	out.print("<td width=16><img border=0 src='images/file.gif'></td><td height=20 onmousedown=\"ChangeMyStyle(this)\" id=\"td"+rs2.getString("nid")+"\"  style='cursor:hand;padding-top:2px;'>"+rs2.getString("bmmc")+"</td>");
		  		  	    out.print("<td width='300'><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=addson&bmid="+rs2.getString("nid")+"\"><img src=\"images/addsonbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=edit&bmid="+rs2.getString("nid")+"\"><img src=\"images/editbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"javascript:void(0);\" onclick=\"deldept("+rs2.getString("nid")+")\"><img src=\"images/delbut.jpg\" /></a></span></td>");
			  	    	out.print("</tr></table>\n");
	  		  	    }	  	    
	  		  }
	  	  	  rs2.close();
	  	  	  out.print("</div>");
	  	    }
	  	    else
	  	    {
	  	    	out.print("<td width=16><img border=0 src='images/file.gif'></td><td height=20 id=\"td"+rs.getString("nid")+"\" style='cursor:hand;padding-top:2px;'>"+rs.getString("bmmc")+"</td>");
	  	    	out.print("<td width='300'><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=addson&bmid="+rs.getString("nid")+"\"><img src=\"images/addsonbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"departmentedit.jsp?naction=edit&bmid="+rs.getString("nid")+"\"><img src=\"images/editbut.jpg\" /></a></span><span class=\"floatleft\"><a href=\"javascript:void(0);\" onclick=\"deldept("+rs.getString("nid")+")\"><img src=\"images/delbut.jpg\" /></a></span></td>");
	  	    	out.print("</tr></table>\n");
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
