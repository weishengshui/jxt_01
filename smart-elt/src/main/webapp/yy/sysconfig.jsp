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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("9003")==-1)
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
	if(document.getElementById("spkcyj").value=="")
	{
		alert("库存预警值不能为空！");
		return false;
	}
	if(document.getElementById("sendemailsmtp").value=="")
	{
		alert("邮件发送Smtp不能为空！");
		return false;
	}
	if(document.getElementById("sendemail").value=="")
	{
		alert("邮件发送账号不能为空！");
		return false;
	}
	
	if(document.getElementById("sendemailpwd").value=="")
	{
		alert("邮件发送密码不能为空！");
		return false;
	}
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="9003";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String spkcyj="",sendemail="",sendemailpwd="",sendemailsmtp="";

try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{
		spkcyj=request.getParameter("spkcyj");
		sendemailsmtp=request.getParameter("sendemailsmtp");
		sendemail=request.getParameter("sendemail");
		sendemailpwd=request.getParameter("sendemailpwd");
		if (!fun.sqlStrCheck(spkcyj)||!fun.sqlStrCheck(sendemail)||!fun.sqlStrCheck(sendemailpwd)||!fun.sqlStrCheck(sendemailsmtp))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		//
		strsql="select pname from tbl_config where pname='spkcyj'";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			rs.close();
			strsql="update tbl_config set pvalue='"+spkcyj+"' where pname='spkcyj'";
			stmt.executeUpdate(strsql);
		}
		else
		{
			rs.close();
			strsql="insert into tbl_config (pname,pvalue,bz) values('spkcyj','"+spkcyj+"','商品库存预警值')";
			stmt.executeUpdate(strsql);
		}
		
		//
		strsql="select pname from tbl_config where pname='sendemailsmtp'";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			rs.close();
			strsql="update tbl_config set pvalue='"+sendemailsmtp+"' where pname='sendemailsmtp'";
			stmt.executeUpdate(strsql);
		}
		else
		{
			rs.close();
			strsql="insert into tbl_config (pname,pvalue,bz) values('sendemailsmtp','"+sendemailsmtp+"','邮件发送smtp')";
			stmt.executeUpdate(strsql);
		}
		
		//
		strsql="select pname from tbl_config where pname='sendemail'";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			rs.close();
			strsql="update tbl_config set pvalue='"+sendemail+"' where pname='sendemail'";
			stmt.executeUpdate(strsql);
		}
		else
		{
			rs.close();
			strsql="insert into tbl_config (pname,pvalue,bz) values('sendemail','"+sendemail+"','邮件发送账号')";
			stmt.executeUpdate(strsql);
		}
		//
		strsql="select pname from tbl_config where pname='sendemailpwd'";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			rs.close();
			strsql="update tbl_config set pvalue='"+sendemailpwd+"' where pname='sendemailpwd'";
			stmt.executeUpdate(strsql);
		}
		else
		{
			rs.close();
			strsql="insert into tbl_config (pname,pvalue,bz) values('sendemailpwd','"+sendemailpwd+"','邮件发送密码')";
			stmt.executeUpdate(strsql);
		}
		
		out.print("<script type='text/javascript'>");
   		out.print("alert('参数设置成功！');");    		
   		out.print("</script>");
		
	}
	else
	{
		strsql="select pname,pvalue from tbl_config";
		rs=stmt.executeQuery(strsql);
		while(rs.next())
		{
			if (rs.getString("pname").equals("spkcyj"))
				spkcyj=rs.getString("pvalue");
			if (rs.getString("pname").equals("sendemailsmtp"))
				sendemailsmtp=rs.getString("pvalue");
			if (rs.getString("pname").equals("sendemail"))
				sendemail=rs.getString("pvalue");
			if (rs.getString("pname").equals("sendemailpwd"))
				sendemailpwd=rs.getString("pvalue");
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
            <td><div class="local"><span>系统管理 &gt; 参数设置 </span></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="sysconfig.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />            		 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">库存预警值：</td>
                          <td><input type="text" name="spkcyj" id="spkcyj" value="<%=spkcyj%>" maxlength="5" class="input3" />&nbsp;个别商品可以到商品内容管理中个别设置</td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>邮件发送Smtp：</td>
                          <td><input type="text" name="sendemailsmtp" id="sendemailsmtp" class="input3" value="<%=sendemailsmtp%>" maxlength="50" /></td>
                        </tr>
                       <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>邮件发送账号：</td>
                          <td><input type="text" name="sendemail" id="sendemail" class="input3" value="<%=sendemail%>" maxlength="50" /></td>
                        </tr>
                      <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>邮件发送密码：</td>
                          <td><input type="text" name="sendemailpwd" id="sendemailpwd" class="input3" value="<%=sendemailpwd%>" maxlength="50" /></td>
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