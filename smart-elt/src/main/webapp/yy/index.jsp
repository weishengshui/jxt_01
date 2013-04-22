<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="jxt.elt.common.DbPool"%>
<%@page import="jxt.elt.common.SecurityUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/adminstyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript">
function login()
{
	if (document.getElementById("logname").value==null || document.getElementById("logname").value=="")
	{
		document.getElementById("errinfo").innerHTML ="请输入登录账号";
		return false;
	}
	if (document.getElementById("logpwd").value==null || document.getElementById("logpwd").value=="")
	{
		document.getElementById("errinfo").innerHTML ="请输入登录密码";
		return false;
	}
	document.getElementById("logform").submit();
}
function logpwdchecck(t)
{
	if (t==1)
	{
		if (document.getElementById("logpwdtxt").value=="请输入您的密码")
		{				
			document.getElementById("logpwdtxt").style.display="none";
			document.getElementById("logpwd").style.display="";
			document.getElementById("logpwd").focus();
		}
	}
	else
	{
		if (document.getElementById("logpwd").value=="")
		{
			document.getElementById("logpwdtxt").style.display="";
			document.getElementById("logpwd").style.display="none";
		}
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
  <body>
  
  <%
Connection conn=DbPool.getInstance().getConnection();;
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();

try
{

	String logname=request.getParameter("logname");
	String logpwd=request.getParameter("logpwd");
	
	if (logname!=null && !logname.equals("") && logpwd!=null  && !logpwd.equals(""))
	{
		if (fun.sqlStrCheck(logname) && fun.sqlStrCheck(logpwd))
		{
			SecurityUtil su=new SecurityUtil();
			String strsql="select nid,xm,dlm,czqx from tbl_xtyh where dlm='" + logname +"' and dlmm='"+su.md5(logpwd)+"'";
			String reurl="";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				session.setAttribute("xtyh",rs.getString("nid"));
				session.setAttribute("xtxm",rs.getString("xm"));
				session.setAttribute("xtdlm",rs.getString("dlm"));
				session.setAttribute("xtczqx",rs.getString("czqx"));
				if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("1001")>-1)
					reurl="shiyongqiye.jsp";
				else if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("1002")>-1)
					reurl="qiyexinxi.jsp";
				else if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("1003")>-1)
					reurl="qiyeyuangong.jsp";
				else if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("2001")>-1)
					reurl="zzweifukuan.jsp";
				else if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("2002")>-1)
					reurl="zzxianxiafukuan.jsp";
				else if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("2003")>-1)
					reurl="zzzaixianfukuan.jsp";
				else if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("2004")>-1)
					reurl="zzchenggong.jsp";
				else if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("2005")>-1)
					reurl="zzshibai.jsp";
				else if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("3001")>-1)
					reurl="huodongleimu.jsp";
				else if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("3002")>-1)
					reurl="jifenjuanhuodong.jsp";
				else if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("3003")>-1)
					reurl="jifenjuan.jsp";
				else if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("9001")>-1)
					reurl="guanliyuan.jsp";
				else if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("9002")>-1)
					reurl="jianglimingmu.jsp";
				
				
			}
			else
			{
				out.print("<script type='text/javascript'>");
	         		out.print("alert('用户名或者密码错误！');");
	         		
	         		out.print("</script>");
			}
			rs.close();
			
			if (reurl!=null && !reurl.equals(""))
				response.sendRedirect(reurl);
		}
	}

}
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

<form action="index.jsp" name="logform" id="logform" method="post">
<table border="0" cellpadding="0" cellspacing="0" width="813" align="center">
	<tr><td height="150">&nbsp;</td></tr>
    <tr><td background="images/indexback.gif" height="364">	
		<table border="0" cellpadding="0" cellspacing="0">
			<tr><td width="430" height="182">&nbsp;</td>
				<td>
					<table border="0" cellpadding="0" cellspacing="0">
						<tr><td height="38">账号：</td>
						<td><input type="text" class="input1" value="请输入您的用户名" style="width:150px"  onFocus="javascript:if(this.value=='请输入您的用户名') this.value='';" onBlur="javascript:if(this.value=='') this.value='请输入您的用户名';"  name="logname" id="logname" /></td></tr>
						<tr><td height="37">密码：</td>
						<td><input type="text" class="input1" value="请输入您的密码"  style="width:150px" name="logpwdtxt" id="logpwdtxt" onfocus="logpwdchecck(1)" />
							<input type="password" class="input1" name="logpwd" id="logpwd" style="display: none;width:150px" onBlur="logpwdchecck(0)" /></td></tr>
						<tr>
						  <td height="31" colspan="2">&nbsp;</td>
						</tr>
						<tr>
						  <td colspan="2"><input value="" type="submit" class="loginbtn" onclick="login()" /></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>	
			
	</td></tr>
</table>
</form>			
</body>
</html>

