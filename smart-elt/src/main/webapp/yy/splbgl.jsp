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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4004")==-1)
{
	out.print("你没有操作权限！");
	return;
}
Fun fun=new Fun();
int ln=0;


String naction=request.getParameter("naction");
String lbid=request.getParameter("lbid");
if (!fun.sqlStrCheck(lbid))
{	
	response.sendRedirect("splbgl.jsp");
	return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards企业员工忠诚度系统</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/adminstyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">

function delit(lid)
{
	if (confirm("确认删除此类目吗，删除后将无法恢复!"))
	{
		location.href="splbgl.jsp?naction=del&lbid="+lid;
	}
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
String  menun="4004";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
Statement stmt2=conn.createStatement();
Statement stmt3=conn.createStatement();
Statement stmtt=conn.createStatement();
ResultSet rs=null;
ResultSet rs2=null;
ResultSet rs3=null;
ResultSet rst=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
try{
	if (naction!=null && naction.equals("del"))
	{
		strsql="delete from tbl_splm where nid="+lbid;
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
            <td><div class="local"><span>商品管理&gt; 商品类目管理</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">					
					<div class="caxun-r"><a href="splbbianji.jsp" class="daorutxt">增加类目</a></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
           
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
             
              <tr>
                <td><table width="100%" border="0" cellspacing="1" cellpadding="1" class="maintable2">
                  <tr>                   
                   <th>类目名称</th>
                   <th width="60">是否显示</th>                                  
                   <th width="300">操作</th>
                 </tr>
                 <tr><td colspan="3">
                 <%
  		String sLine="0",sLine2="0",sLine3="0",sLine4="0",sLine5="0";
  	
  		int haves=0;
  		int j=1;
  		strsql="select nid,mc,flm,sfxs,lmtp from tbl_splm where flm=0 order by xswz desc";
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
	  		
	  		strsql="select nid from tbl_splm where flm="+rs.getString("nid");
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
	  	    	out.print("<td width=16><span id='simg"+rs.getString("nid")+"'><img border=0 src='images/_close.gif'></span><span style='display:none;' id='oimg"+rs.getString("nid")+"'><img border=0 src='images/folder_open.gif'></span></td><td id='m"+rs.getString("nid")+"' onclick='fitm(this)' style='cursor:hand;padding-top:2px; font-size: 12px; '>"+rs.getString("mc")+"</font></td>");
	  	    	out.print("<td width='60'>"+(rs.getInt("sfxs")==0?"否":"是")+"</td>");
	  	    	out.print("<td width='300'><span class=\"floatleft\"><a class='blue' href=\"splbbianji.jsp?naction=addson&lmid="+rs.getString("nid")+"\">添加子类目</a></span> <span class=\"floatleft\"><a class='blue' href=\"splbbianji.jsp?naction=edit&lmid="+rs.getString("nid")+"\">修改</a></span> <span class=\"floatleft\"><a class='blue' href=\"javascript:void(0);\" onclick=\"delit("+rs.getString("nid")+")\">删除</a></span></td>");
	  	    	out.print("</tr></table>\n");
	  	    	
	  	    	strsql="select nid,mc,flm,sfxs,lmtp from tbl_splm where flm="+rs.getString("nid")+" order by xswz desc";
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
	  		  		
	  		  		strsql="select nid from tbl_splm where flm="+rs2.getString("nid");
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
	  		  	    	out.print("<td width=16><span id='simg"+rs2.getString("nid")+"'><img border=0 src='images/_close.gif'></span><span style='display:none;' id='oimg"+rs2.getString("nid")+"'><img border=0 src='images/folder_open.gif'></span></td><td id='m"+rs2.getString("nid")+"' onclick='fitm(this)' style='cursor:hand;padding-top:2px; font-size: 12px; '>"+rs2.getString("mc")+"</font></td>\n");
	  		  	    	out.print("<td width='60'>"+(rs2.getInt("sfxs")==0?"否":"是")+"</td>");
	  		  	    	out.print("<td width='300'><span class=\"floatleft\"><a class='blue' href=\"splbbianji.jsp?naction=addson&lmid="+rs2.getString("nid")+"\">添加子类目</a></span> <span class=\"floatleft\"><a class='blue' href=\"splbbianji.jsp?naction=edit&lmid="+rs2.getString("nid")+"\">修改</a> </span><span class=\"floatleft\"><a class='blue' href=\"javascript:void(0);\" onclick=\"delit("+rs2.getString("nid")+")\">删除</a></span></td>");
			  	    	out.print("</tr></table>\n");
	  		  	    	
		  		  	    strsql="select nid,mc,flm,sfxs,lmtp  from tbl_splm where flm="+rs2.getString("nid")+" order by xswz desc";
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
			  		  		
			  			    
			  		  	    if (rs3.isLast())
			  		  	    {
			  		  	    	
			  		  	    		out.print("<td width=16><img border=0 src='images/_2.gif'></td>");
			  		  	    	
			  		  	    }
			  		  	    else
			  		  	    {
			  		  	    	
			  		  	    		out.print("<td width=16><img border=0 src='images/_3.gif'></td>");  	    	
			  		  	    }
			  				
			  		  	    
			  		  	    out.print("<td height=20  id=\"td"+rs3.getString("nid")+"\" style='cursor:hand;padding-top:2px;'>"+rs3.getString("mc")+"</td>");
			  		  		out.print("<td width='60'>"+(rs3.getInt("sfxs")==0?"否":"是")+"</td>");
			  		  	    out.print("<td width='300'><span class=\"floatleft\"><a class='blue' href=\"splbbianji.jsp?naction=edit&lmid="+rs3.getString("nid")+"\">修改</a></span> <span class=\"floatleft\"><a class='blue' href=\"javascript:void(0);\" onclick=\"delit("+rs3.getString("nid")+")\">删除</a></span></td>");
				  	    	out.print("</tr></table>\n");
			  		  	   	  	    
			  		  }
			  	  	  rs3.close();
			  	  	  out.print("</div>");
	  		  	    }
	  		  	    else
	  		  	    {
	  		  	    	out.print("<td height=20  id=\"td"+rs2.getString("nid")+"\"  style='cursor:hand;padding-top:2px;'>"+rs2.getString("mc")+"</td>");
	  		  	    	out.print("<td width='60'>"+(rs2.getInt("sfxs")==0?"否":"是")+"</td>");
	  		  	    	out.print("<td width='300'><span class=\"floatleft\"><a class='blue' href=\"splbbianji.jsp?naction=addson&lmid="+rs2.getString("nid")+"\">添加子类目</a></span> <span class=\"floatleft\"><a class='blue' href=\"splbbianji.jsp?naction=edit&lmid="+rs2.getString("nid")+"\">修改</a></span> <span class=\"floatleft\"><a class='blue' href=\"javascript:void(0);\" onclick=\"delit("+rs2.getString("nid")+")\">删除</a></span></td>");
			  	    	out.print("</tr></table>\n");
	  		  	    }	  	    
	  		  }
	  	  	  rs2.close();
	  	  	  out.print("</div>");
	  	    }
	  	    else
	  	    {
	  	    	out.print("<td height=20 id=\"td"+rs.getString("nid")+"\" style='cursor:hand;padding-top:2px;'>"+rs.getString("mc")+"</td>");	  	    	
	  	    	out.print("<td width='60'>"+(rs.getInt("sfxs")==0?"否":"是")+"</td>");
	  	    	out.print("<td width='300'><span class=\"floatleft\"><a class='blue' href=\"splbbianji.jsp?naction=addson&lmid="+rs.getString("nid")+"\">添加子类目</a></span> <span class=\"floatleft\"><a class='blue' href=\"splbbianji.jsp?naction=edit&lmid="+rs.getString("nid")+"\">修改</a></span> <span class=\"floatleft\"><a class='blue' href=\"javascript:void(0);\" onclick=\"delit("+rs.getString("nid")+")\">删除</a></span></td>");
	  	    	out.print("</tr></table>\n");
	  	    }	  	    
	  }
  	  rs.close();
  	  out.print("</div>");
  	  %>
                 </td></tr>
                
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