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
<%request.setCharacterEncoding("UTF-8");
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("3001")==-1)
{
	out.print("你没有操作权限！");
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
function saveit()
{
	if(document.getElementById("lmmc").value.trim()=="")
	{
		alert("请填写类目名称！");
		return false;
	}
	if(document.getElementById("xswz").value.trim()=="")
	{
		alert("请填写显示位置！");
		return false;
	}
	if(!CheckNumber(document.getElementById("xswz").value.trim()))
	{
		alert("显示位置只能填写数字！");
		return false;
	}
	
	
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="3001";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String lmmc="",xswz="100",sfxs="1";
String lmid=request.getParameter("lmid");
if (lmid==null) lmid="";
if (!fun.sqlStrCheck(lmid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='huodongleimu.jsp';");
	out.print("</script>");
	return;
}
try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{
		lmmc=request.getParameter("lmmc");
		xswz=request.getParameter("xswz");
		sfxs=request.getParameter("sfxs");
		
		if (!fun.sqlStrCheck(lmmc) || !fun.sqlStrCheck(xswz) || !fun.sqlStrCheck(sfxs))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		if (lmid!=null && lmid.length()>0)
		{
		    strsql="select nid from tbl_jfqlm where lmmc='"+lmmc+"' and nid<>"+lmid;
		   rs=stmt.executeQuery(strsql);
		   if (rs.next())
		   {
			    rs.close();
				out.print("<script type='text/javascript'>");
				out.print("alert('此活动类目名称已经存在！ ');");
				out.print("history.back(-1);");
				out.print("</script>");
				return;
		   }
		   rs.close();
			   
			 strsql="update tbl_jfqlm set lmmc='"+lmmc+"',xswz="+xswz+",sfxs="+sfxs+" where nid="+lmid;
			 stmt.execute(strsql);
			 response.sendRedirect("huodongleimu.jsp");
		   	  return;
		}
		else
		{
		   strsql="select nid from tbl_jfqlm where lmmc='"+lmmc+"'";
		   rs=stmt.executeQuery(strsql);
		   if (rs.next())
		   {
			    rs.close();
				out.print("<script type='text/javascript'>");
				out.print("alert('此活动类目名称已经存在！ ');");
				out.print("history.back(-1);");
				out.print("</script>");
				return;
		   }
		   rs.close();
			strsql="insert into tbl_jfqlm (lmmc,xswz,sfxs) values('"+lmmc+"',"+xswz+","+sfxs+")";
			stmt.executeUpdate(strsql);
			response.sendRedirect("huodongleimu.jsp");
	   		return;
		}
	}
	
	if (lmid!=null && lmid.length()>0)
	{
		strsql="select * from tbl_jfqlm where nid="+lmid;		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			lmmc=rs.getString("lmmc");
			xswz=rs.getString("xswz");
			sfxs=rs.getString("sfxs");
		}
		rs.close();
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
            <td><div class="local"><span>福利券管理 &gt; 活动类目管理 &gt; <%if (lmid!=null && lmid.length()>0) out.print("修改类目"); else out.print("添加类目");%></span><a href="huodongleimu.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="hdlmbianji.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="lmid" id="lmid" value="<%=lmid%>" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">类目名称：</td>
                          <td><input type="text" name="lmmc" id="lmmc" value="<%=lmmc%>" maxlength="30" class="input3" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>显示位置：</td>
                       <td><input type="text" name="xswz" id="xswz" class="input3" value="<%=xswz%>" maxlength="5" />&nbsp;请填写数字，数字越大显示位置越靠前</td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>是否显示：</td>
                          <td><input type="radio" name="sfxs" id="sfxs" value="1" <%if (sfxs.equals("1")) out.print("checked='checked'"); %> />是 　　<input type="radio" name="sfxs" id="sfxs" value="0" <%if (sfxs.equals("0")) out.print("checked='checked'"); %> />否</td>
                        </tr>
                        
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="#" class="reset"></a></span></td>
                        </tr>
                      </table>
                      </form>
            </td>
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