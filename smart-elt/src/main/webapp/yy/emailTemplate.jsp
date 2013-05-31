<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8"); 
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("9007")==-1)
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
<script type="text/javascript" src="js/jquery-1.7.min.js"></script>
<script type="text/javascript">
function resetMB(ele, nid) {
	if (window.confirm('是否将"'+ele+'"模板恢复到初始版本！')) {
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "emailTemplatebianji.jsp?qjmbid="+nid+"&action=reset&time="+timeParam;
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=processResetResponse;
		xmlHttp.send(null);
	}
};

function processResetResponse() {
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{	
			var responseJson = $.parseJSON(response);
			if (responseJson.result == 'success') {
				alert('重置成功！');
			} else {
				alert('重置失败！');
			}
		}
		catch(exception){
			alert('重置失败！');
		}
	}
};
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" />
</head>
<body>
<div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>
<%
String  menun="9007";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
try{
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
            <td><div class="local"><span>系统管理 &gt; 邮件模板管理</span></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
				  <tr>
				  <%		
				    strsql = "SELECT count(*) as size FROM tbl_yjmb";
        			rs = stmt.executeQuery(strsql);
        			int size = 0;
        			while (rs.next()) {
        			    size = rs.getInt("size");
              		}
              		rs.close();
                 	%>
				  	<td height="30">一共 <span class="red"><%=size%></span> 个模板 </td>
              	  </tr>
                <tr>
                	<td>
                		<table width="100%" border="0" cellspacing="1" cellpadding="1" class="maintable">
                  			<tr>
			                   <th width="10%">模板编号</th>
			                   <th width="20%">模板名称</th>
			                   <th width="55%">模板说明</th>
			                   <th width="15%">操作</th>
                 			</tr>
                 			<%
                 			strsql = "SELECT nid, zwmc, ms FROM tbl_yjmb";
                 			rs = stmt.executeQuery(strsql);
                 			String nid = "";
                 			String zwmc = "";
                 			String ms = "";
                 			int i = 1;
                 			while (rs.next()) {
                 			    nid = rs.getString("nid");
                 			    zwmc = rs.getString("zwmc");
                 			    ms = rs.getString("ms");
                 			    if (zwmc == null) zwmc = "";
                 			    if (ms == null) ms = "";
                 			   %>
                 			   <tr>
			                   <td><%=i%></td>
			                   <td><%=zwmc%></td>
			                   <td><%=ms%></td>
			                   <td><a href="emailTemplatebianji.jsp?qjmbid=<%=nid%>" class="blue">修改</a>&nbsp;&nbsp;<a href="javascript:void(0)" class="blue" onclick="resetMB('<%=zwmc%>','<%=nid%>')">恢复至初始版本</a></td>
                 			</tr>
                 			   <%
                 			    i++;
                 			}
                 			rs.close();
                 			 %>
                 			
                		</table>
             		</td>
               </tr>
           </table></td>
        <td width="20">&nbsp;</td>
      </tr>
    </table></td>
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