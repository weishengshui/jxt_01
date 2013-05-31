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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("9005")==-1)
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
	if(document.getElementById("opmailusername").value.trim()=="")
	{
		alert("请填写发送邮件用户名！");
		return false;
	}
	if(document.getElementById("opmailpassword").value.trim()=="")
	{
		alert("请填写发送邮件密码！");
		return false;
	}

	if(document.getElementById("smtp").value.trim()=="")
	{
		alert("请填写发送邮件smtp地址！");
		return false;
	}
	if(!CheckNumber(document.getElementById("status").value.trim()))
	{
		alert("请选择 邮件启用状态！");
		return false;
	}
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="9005";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String username="", password="", smtp="", status="0";

String emailid=request.getParameter("emailid");
if (emailid==null) emailid="";

if (!fun.sqlStrCheck(emailid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='emailconfig.jsp';");
	out.print("</script>");
	return;
}
try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{	
     	username=request.getParameter("opmailusername");
		password=request.getParameter("opmailpassword");
		smtp=request.getParameter("smtp");
		status=request.getParameter("status");
		
		if (!fun.sqlStrCheck(username) || !fun.sqlStrCheck(password) || !fun.sqlStrCheck(smtp) || !fun.sqlStrCheck(status))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
			
		if (emailid!=null && emailid.length()>0)
		{
			 strsql="update tbl_emailconfig set username='"+username+"',password=AES_ENCRYPT('"+password+"','e1t'),smtpaddress='"+smtp+"',status='"+status+"' where nid="+emailid;
			 stmt.execute(strsql);
			 response.sendRedirect("emailconfig.jsp");
		   	 return;
		}
		else
		{
			strsql="insert into tbl_emailconfig (username,password,smtpaddress,status) values('"+username+"',AES_ENCRYPT('"+password+"','e1t'),'"+smtp+"','"+status+"')";
			stmt.executeUpdate(strsql);
			response.sendRedirect("emailconfig.jsp");
	   		return;
		}
	}
	
	if (emailid!=null && emailid.length()>0)
	{
		strsql="select username, AES_DECRYPT(password, 'e1t') as password, smtpaddress, status from tbl_emailconfig where nid="+emailid;		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			username=rs.getString("username");
			password=rs.getString("password");			
			smtp=rs.getString("smtpaddress");
			status=rs.getString("status");
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
            <td><div class="local"><span>系统管理 &gt; 发送邮件设置 &gt; <%if (emailid!=null && emailid.length()>0) out.print("修改发送邮箱"); else out.print("添加发送邮箱");%></span><a href="emailconfig.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="emailconfigedit.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="emailid" id="emailid" value="<%=emailid%>" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="130">发送邮件用户名：</td>
                          <td><input type="text" name="opmailusername" id="opmailusername" value="<%=username%>" maxlength="30" class="input3" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>发送邮件密码：</td>
                          <td><input type="text" name="opmailpassword" id="opmailpassword" class="input3" value="<%=password%>" maxlength="50" /></td>
                        </tr>
                           <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>发送邮件smtp：</td>
                          <td><input type="text" name="smtp" id="smtp" class="input3" value="<%=smtp%>" maxlength="50" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>是否启用：</td>
                          <td><input type="radio" name="status" id="status" value="1" <%if (status.equals("1")) out.print("checked='checked'"); %> />是 　　<input type="radio" name="status" id="status" value="0" <%if (status.equals("0")) out.print("checked='checked'"); %> />否</td>
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