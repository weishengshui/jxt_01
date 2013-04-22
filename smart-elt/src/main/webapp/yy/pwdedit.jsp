<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@page import="jxt.elt.common.SecurityUtil"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/adminstyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
function saveit(t)
{
	if (t==1)
	{
		if(document.getElementById("pwd1").value=="")
		{
			alert("请输入原登陆密码");
			return false;
		}
		if(document.getElementById("pwd2").value=="")
		{
			alert("请输入新登陆密码");
			return false;
		}
		if(document.getElementById("pwd3").value=="")
		{
			alert("请输入重复新登陆密码");
			return false;
		}
		if(document.getElementById("pwd2").value!=document.getElementById("pwd3").value)
		{
			alert("重复密码不一致");
			return false;
		}
		document.getElementById("naction").value="dlpwd";
	}
	if (t==2)
	{
		if(document.getElementById("pwd11").value=="")
		{
			alert("请输入原追加密码");
			return false;
		}
		if(document.getElementById("pwd22").value=="")
		{
			alert("请输入新追加密码");
			return false;
		}
		if(document.getElementById("pwd33").value=="")
		{
			alert("请输入重复新追加密码");
			return false;
		}
		if(document.getElementById("pwd22").value!=document.getElementById("pwd33").value)
		{
			alert("重复密码不一致");
			return false;
		}
		document.getElementById("naction").value="zjpwd";
	}
	
	if (t==3)
	{
		if(document.getElementById("pwd111").value=="")
		{
			alert("请输入原发放密码");
			return false;
		}
		if(document.getElementById("pwd222").value=="")
		{
			alert("请输入新发放密码");
			return false;
		}
		if(document.getElementById("pwd333").value=="")
		{
			alert("请输入重复新发放密码");
			return false;
		}
		if(document.getElementById("pwd222").value!=document.getElementById("pwd333").value)
		{
			alert("重复密码不一致");
			return false;
		}
		document.getElementById("naction").value="ffpwd";
	}
	
	document.getElementById("cform").submit();
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="9009";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SecurityUtil su=new SecurityUtil();
try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("dlpwd"))
	{
		String pwd1=request.getParameter("pwd1");
		String pwd2=request.getParameter("pwd2");
		
		if (!fun.sqlStrCheck(pwd1) || !fun.sqlStrCheck(pwd2))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("location.href='pwdedit.jsp';");
	   		out.print("</script>");
	   		return;
		}
		
		strsql="select nid from tbl_xtyh where nid="+session.getAttribute("xtyh")+" and dlmm='"+su.md5(pwd1)+"'";
		rs=stmt.executeQuery(strsql);
		if (!rs.next())
		{
			rs.close();
			out.print("<script type='text/javascript'>");
	   		out.print("alert('原登陆密码不正确');"); 
	   		out.print("location.href='pwdedit.jsp';");
	   		out.print("</script>");
	   		return;
		}
		rs.close();
		
		strsql="update tbl_xtyh set dlmm='"+su.md5(pwd2)+"' where nid="+session.getAttribute("xtyh");
		stmt.executeUpdate(strsql);
		out.print("<script type='text/javascript'>");
   		out.print("alert('登陆密码修改成功');");
   		out.print("</script>");   				
	}
	
	if (naction!=null && naction.equals("zjpwd"))
	{
		String pwd11=request.getParameter("pwd11");
		String pwd22=request.getParameter("pwd22");
		
		if (!fun.sqlStrCheck(pwd11) || !fun.sqlStrCheck(pwd22))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("location.href='pwdedit.jsp';");
	   		out.print("</script>");
	   		return;
		}
		
		strsql="select nid from tbl_xtyh where nid="+session.getAttribute("xtyh")+" and ffmm='"+su.md5(pwd11)+"'";
		rs=stmt.executeQuery(strsql);
		if (!rs.next())
		{
			rs.close();
			out.print("<script type='text/javascript'>");
	   		out.print("alert('原追加密码不正确');"); 
	   		out.print("location.href='pwdedit.jsp';");
	   		out.print("</script>");
	   		return;
		}
		rs.close();
		
		strsql="update tbl_xtyh set ffmm='"+su.md5(pwd22)+"' where nid="+session.getAttribute("xtyh");
		stmt.executeUpdate(strsql);
		out.print("<script type='text/javascript'>");
   		out.print("alert('追加密码修改成功');");
   		out.print("</script>");   				
	}
	
	if (naction!=null && naction.equals("ffpwd"))
	{
		String pwd111=request.getParameter("pwd111");
		String pwd222=request.getParameter("pwd222");
		
		if (!fun.sqlStrCheck(pwd111) || !fun.sqlStrCheck(pwd222))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("location.href='pwdedit.jsp';");
	   		out.print("</script>");
	   		return;
		}
		
		strsql="select nid from tbl_xtyh where nid="+session.getAttribute("xtyh")+" and syffmm='"+su.md5(pwd111)+"'";
		rs=stmt.executeQuery(strsql);
		if (!rs.next())
		{
			rs.close();
			out.print("<script type='text/javascript'>");
	   		out.print("alert('原发放密码不正确');"); 
	   		out.print("location.href='pwdedit.jsp';");
	   		out.print("</script>");
	   		return;
		}
		rs.close();
		
		strsql="update tbl_xtyh set syffmm='"+su.md5(pwd222)+"' where nid="+session.getAttribute("xtyh");
		stmt.executeUpdate(strsql);
		out.print("<script type='text/javascript'>");
   		out.print("alert('发放密码修改成功');");
   		out.print("</script>");   				
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
            <td><div class="local"><span>系统管理 &gt; 密码管理 </span></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="pwdedit.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />            		 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr><td colspan="3" style="font-size: 14px; font-weight: bold;">登陆密码修改</td></tr>
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="110">原登陆密码：</td>
                          <td><input type="password" name="pwd1" id="pwd1" class="input3" maxlength="50" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>新登陆密码：</td>
                          <td><input type="password" name="pwd2" id="pwd2" class="input3" maxlength="50" /></td>
                        </tr>
                       
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>重复新登陆密码：</td>
                          <td><input type="password" name="pwd3" id="pwd3" class="input3" maxlength="50" /></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit(1)" ></a></span></td>
                        </tr>
                        <%if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("2004")>-1) {%>
                         <tr><td colspan="3" style="font-size: 14px; font-weight: bold; border-top: #CCCCCC 3px solid;">追加密码修改</td></tr>
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="110">原追加密码：</td>
                          <td><input type="password" name="pwd11" id="pwd11" class="input3" maxlength="50" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>新追加密码：</td>
                          <td><input type="password" name="pwd22" id="pwd22" class="input3" maxlength="50" /></td>
                        </tr>
                       
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>重复新追加密码：</td>
                          <td><input type="password" name="pwd33" id="pwd33" class="input3" maxlength="50" /></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit(2)" ></a></span></td>
                        </tr>
                        <%} %>
                        
                        <%if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("2004")>-1) {%>
                         <tr><td colspan="3" style="font-size: 14px; font-weight: bold; border-top: #CCCCCC 3px solid;">使用企业发放密码修改</td></tr>
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="110">原发放密码：</td>
                          <td><input type="password" name="pwd111" id="pwd111" class="input3" maxlength="50" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>新发放密码：</td>
                          <td><input type="password" name="pwd222" id="pwd222" class="input3" maxlength="50" /></td>
                        </tr>
                       
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>重复新发放密码：</td>
                          <td><input type="password" name="pwd333" id="pwd333" class="input3" maxlength="50" /></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit(3)" ></a></span></td>
                        </tr>
                        <%} %>
                        
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