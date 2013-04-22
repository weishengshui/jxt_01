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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("9002")==-1)
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
function saveit(na)
{
	if (document.getElementById("mmmc").value=="")
	{
		alert("请填写名目！");
		return false;
	}
	if (na=="")
		document.getElementById("naction").value="save";
	if (na=="addson")
		document.getElementById("naction").value="sonsave";
	if (na=="edit")
		document.getElementById("naction").value="editsave";
	document.getElementById("iform").submit();
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="9002";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="",mmmc="",naction="",itemid="",bz="";
naction=request.getParameter("naction");
mmmc=request.getParameter("mmmc");
itemid=request.getParameter("itemid");
bz=request.getParameter("bz");
if (itemid==null) itemid="";
if (mmmc==null) mmmc="";
if (naction==null) naction="";
if (bz==null) bz="";

if (!fun.sqlStrCheck(itemid) || !fun.sqlStrCheck(mmmc) || !fun.sqlStrCheck(bz))
{
	return;
}
try
{
		if (naction!=null && naction.equals("save"))
		{
			strsql="insert into tbl_jfmm (qy,mmmc,fmm,bz) values(0,'"+mmmc+"',0,'"+bz+"')";
			stmt.executeUpdate(strsql);			
			response.sendRedirect("jianglimingmu.jsp");
		}
		if (naction!=null && naction.equals("sonsave"))
		{
			strsql="insert into tbl_jfmm (qy,mmmc,fmm,bz) values(0,'"+mmmc+"',"+itemid+",'"+bz+"')";
			stmt.executeUpdate(strsql);			
			response.sendRedirect("jianglimingmu.jsp");
		}
		if (naction!=null && naction.equals("editsave"))
		{
			strsql="update tbl_jfmm set mmmc='"+mmmc+"',bz='"+bz+"' where nid="+itemid;
			stmt.executeUpdate(strsql);			
			response.sendRedirect("jianglimingmu.jsp");
		}
		
		
		if (naction!=null && naction.equals("edit"))
		{
			strsql="select * from tbl_jfmm where nid="+itemid;	
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				mmmc=rs.getString("mmmc");
				bz=rs.getString("bz");		
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
            <td><div class="local"><span>系统管理 &gt; 奖励名目管理</span><a href="jianglimingmu.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="jlmmbianji.jsp" name="iform" id="iform" method="post">
				<input type="hidden" name="itemid" id="itemid" value="<%=itemid%>" /> 
				<input type="hidden" name="naction" id="naction" value="<%=naction%>" /> 
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
				  <tr>
                    <td width="30" align="center"><span class="star">*</span></td>
                    <td width="90">名目名称：</td>
                    <td><input type="text" class="input3" name="mmmc" id="mmmc" value="<%=mmmc%>" maxlength="25" /></td>
                  </tr>
                  <tr>
                    <td align="center"></td>
                    <td>名目说明：</td>
                    <td><textarea rows="3" cols="50" name="bz" id="bz"><%=bz%></textarea></textarea></td>
                  </tr>
                   <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit('<%=naction%>')" ></a></span><span class="floatleft" ><a href="#" class="reset"></a></span></td>
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