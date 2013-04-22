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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4006")==-1)
{
	out.print("你没有操作权限！");
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
function saveit()
{
	if(document.getElementById("gysmc").value=="")
	{
		alert("请填写供应商名称！");
		return false;
	}
	if(document.getElementById("lxr").value=="")
	{
		alert("请填写联系人！");
		return false;
	}
	if(document.getElementById("lxrdh").value=="")
	{
		alert("请填写联系人电话！");
		return false;
	}
	
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="4006";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String gysmc="",dz="",lxr="",lxrdh="",gtype="1";
String gysid=request.getParameter("gysid");
if (gysid==null) gysid="";
if (!fun.sqlStrCheck(gysid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='spgysgl.jsp';");
	out.print("</script>");
	return;
}
try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{
		gysmc=request.getParameter("gysmc");
		dz=request.getParameter("dz");
		lxr=request.getParameter("lxr");
		lxrdh=request.getParameter("lxrdh");
		gtype=request.getParameter("gtype");
		
		if (!fun.sqlStrCheck(gysid) || !fun.sqlStrCheck(dz) || !fun.sqlStrCheck(lxr) || !fun.sqlStrCheck(lxrdh)|| !fun.sqlStrCheck(gtype))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		if (gysid!=null && gysid.length()>0)
		{
			 strsql="update tbl_spgys set gysmc='"+gysmc+"',dz='"+dz+"',lxr='"+lxr+"',lxrdh='"+lxrdh+"',gtype="+gtype+" where nid="+gysid;
			 stmt.execute(strsql);
			 response.sendRedirect("spgysgl.jsp?pno="+request.getParameter("pno"));
		   	  return;
		}
		else
		{
			strsql="insert into tbl_spgys (gysmc,dz,lxr,lxrdh,gtype) values('"+gysmc+"','"+dz+"','"+lxr+"','"+lxrdh+"',"+gtype+")";
			stmt.executeUpdate(strsql);
			response.sendRedirect("spgysgl.jsp?pno="+request.getParameter("pno"));
	   		return;
		}
	}
	
	if (gysid!=null && gysid.length()>0)
	{
		strsql="select * from tbl_spgys where nid="+gysid;		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			gysmc=rs.getString("gysmc");
			dz=rs.getString("dz");
			lxr=rs.getString("lxr");
			lxrdh=rs.getString("lxrdh");
			gtype=rs.getString("gtype");
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
            <td><div class="local"><span>商品管理 &gt; 供应商管理 &gt; <%if (gysid!=null && gysid.length()>0) out.print("修改供应商"); else out.print("添加供应商");%></span><a href="spgysgl.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="spgysbianji.jsp?pno=${param.pno }" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="gysid" id="gysid" value="<%=gysid%>" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">供应商名称：</td>
                          <td><input type="text" name="gysmc" id="gysmc" value="<%=gysmc%>" maxlength="100" class="input3" /></td>
                        </tr>
                        <tr>
                          <td align="center"></td>
                          <td>地址：</td>
                          <td><input type="text" name="dz" id="dz" value="<%=dz%>" maxlength="150" class="input3" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>联系人：</td>
                          <td><input type="text" name="lxr" id="lxr" value="<%=lxr%>" maxlength="10" class="input3" /></td>
                        </tr>
                          <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>联系人电话：</td>
                          <td><input type="text" name="lxrdh" id="lxrdh" value="<%=lxrdh%>" maxlength="25" class="input3" /></td>
                        </tr>
                         <tr>
	                      <td align="center"><span class="star">*</span></td>
	                      <td>类型：</td>
	                      <td><input type="radio" name="gtype" id="gtype" value="1" <%if (gtype.equals("1")) out.print("checked='checked'"); %> />供货商 　　<input type="radio" name="gtype" id="gtype" value="2" <%if (gtype.equals("2")) out.print("checked='checked'"); %> />物流商</td>
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