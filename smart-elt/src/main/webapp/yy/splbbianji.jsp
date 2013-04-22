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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4004")==-1)
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
	if (document.getElementById("mc").value.trim()=="")
	{
		alert("请填写名称！");
		return false;
	}
	if(document.getElementById("xswz").value.trim()=="")
	{
		alert("请填写显示位置！");
		return false;
	}
	if(!CheckNumber(document.getElementById("xswz").value))
	{
		alert("显示位置只能填写数字！");
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
String  menun="4004";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="",mc="",naction="",lmid="",sfxs="1",xswz="",lmtp="",flm="";
naction=request.getParameter("naction");

lmid=request.getParameter("lmid");

if (lmid==null) lmid="";
if (naction==null) naction="";

if (!fun.sqlStrCheck(lmid))
{
	return;
}
try
{
		
		
		
		if (naction!=null && naction.equals("edit"))
		{
			strsql="select nid,mc,sfxs,xswz,lmtp,flm from tbl_splm where nid="+lmid;	
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				mc=rs.getString("mc");
				sfxs=rs.getString("sfxs");
				xswz=rs.getString("xswz");
				lmtp=rs.getString("lmtp");
				flm=rs.getString("flm");
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
            <td><div class="local"><span>商品管理 &gt; 商品类目管理</span><a href="splbgl.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="splbsave.jsp" enctype="multipart/form-data" name="iform" id="iform" method="post">
				<input type="hidden" name="lmid" id="lmid" value="<%=lmid%>" /> 
				<input type="hidden" name="naction" id="naction" value="<%=naction%>" /> 
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
				  <tr>
                    <td width="30" align="center"><span class="star">*</span></td>
                    <td width="90">类目名称：</td>
                    <td><input type="text" class="input3" name="mc" id="mc" value="<%=mc%>" maxlength="10" /></td>
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
                   <%if (lmid==null || lmid.length()==0 || flm.equals("0")) {%>
                     <tr>
                      <td align="center"><span class="star">*</span></td>
                      <td>类目小图片：</td>
                      <td><input type="file"  name="hdtp" id="hdtp" />
					<%if (lmtp!=null && !lmtp.equals("")){%><br/><img src="<%="../"+lmtp%>" /><%} %> &nbsp;&nbsp;第一层类目前面显示,使用背景透明的gif图片，不超过50*50</td>
                   </tr>
                   <%} %>
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