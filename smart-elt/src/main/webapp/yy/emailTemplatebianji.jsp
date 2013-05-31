<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="jxt.elt.common.EmailTemplate"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%@page import="java.util.Map.Entry"%>
<%request.setCharacterEncoding("UTF-8"); 
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("9007")==-1)
{
	out.print("你没有操作权限！");
	return;
}
%>

<%
String  menun="9007";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String qjmbid=request.getParameter("qjmbid");
if (qjmbid==null) qjmbid="";
String yjmb=request.getParameter("yjmb");
if (yjmb==null) yjmb="";
if (!fun.sqlStrCheck(qjmbid) || "".equals(qjmbid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
   	out.print("location.href='emailTemplate.jsp';");
	out.print("</script>");
	return;
}
try{
    String action = request.getParameter("action");
    if (null != action && action.equals("reset")) {
        strsql = "UPDATE tbl_yjmb SET nr = csnr where nid = " + qjmbid;
        PreparedStatement update = conn.prepareStatement(strsql);
        update.executeUpdate();
        update.close();
        EmailTemplate.init();
        out.print("{\"result\":\"success\"}");
    	return;
    }
    if (!"".equals(yjmb)) {
        strsql = "UPDATE tbl_yjmb SET nr = ? where nid = " + qjmbid;
        PreparedStatement update = conn.prepareStatement(strsql);
        update.setString(1, yjmb);
        update.executeUpdate();
        update.close();
        EmailTemplate.init();
        out.print("<script type='text/javascript'>");
    	out.print("alert('保存模板成功!');"); 
		out.print("location.href='emailTemplatebianji.jsp?qjmbid="+ qjmbid +"';");
    	out.print("</script>");
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
<script type="text/javascript" src="ckeditor/ckeditor.js"></script>
<script type="text/javascript">
function saveit()
{
	if (window.confirm('修改邮件模板影响较大, 需要您的再次确认！')) {
		document.getElementById("etform").submit();
	}
}

function resetContent(nid) {
	if (window.confirm('重置将丢失当前编辑内容！您确定要重置吗？')) {
		var url = 'emailTemplatebianji.jsp?qjmbid='+ nid;
		window.location.href=url;
	}

}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
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
          <%
          strsql = "SELECT mc, zwmc, nr, lz FROM tbl_yjmb where nid = " + qjmbid;
          rs = stmt.executeQuery(strsql);
          String mc = "";
          String nr = "";
          String zwmc = "";
          String lz = "";
          if (rs.next()) {
              mc = rs.getString("mc");
              nr = rs.getString("nr");
              zwmc = rs.getString("zwmc");
              lz = rs.getString("lz");
              if (nr == null) nr = "";
              if (lz == null) lz = "";
          }
          rs.close();
          
          %>
          <tr>
            <td><div class="local"><span>系统管理 &gt; 邮件模板管理&gt; <%=zwmc%></span><a href="emailTemplate.jsp" class="back">返回上一页</a></div></td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            <form id="etform" action="emailTemplatebianji.jsp" method="post">
				<input type="hidden" name="qjmbid" id="qjmbid" value="<%=qjmbid%>" />
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td width="30px" align="center"><span class="star">*</span></td>
				  	<th colspan="2">模板中参数及意义</th>
				  </tr>
				  <tr>
				    <td width="30px" align="center"><span class="star"></span></td>
				    <td width="980px">
					    <table border="0" class="maintable">
					        <tr>
			                    <th width="260px">参数名称</th>
			                    <th width="360px">参数意义</th>
			                    <th width="360px">例子</th>
		                    </tr>
		                    <%
		                    Map<String, Map<String, String>> parameterMap = EmailTemplate.PARAMETER_MAP;
		                    Map<String, String> parameters = parameterMap.get(mc);
		                    if (null != parameters) {
			                    int size = parameters.size();
			                    int index = 1;
			                    for (Entry<String, String> detailEntry : parameters.entrySet()) {
			                    %>
			                    <tr>
				                    <td><%=detailEntry.getKey()%></td>
				                    <td><%=detailEntry.getValue()%></td>
				                    <%
				                    if (index == 1) {
			                        %>
				                    <td rowspan="<%=size%>" style="text-align: left;line-height: 14px"><%=lz%></td>
			                        <%
				                    }
				                    %>
			                    </tr>
			                      <%
			                      index++;
		                        }
		                    }
		                    %>
					    </table>
				    </td>
                  </tr>
                  <tr>
                    <td align="center"><span class="star">*</span></td>
                    <th>模板内容：(请勿随意更改模板中参数名称)</th>
                  </tr>
                 <tr>
                    <td colspan="3"><textarea id="yjmb" name="yjmb"><%=nr%></textarea></td>
                 </tr>
                 <tr>
                  <td>&nbsp;</td>
                  <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span><a href="javascript:void(0);" class="reset" onclick="resetContent('<%=qjmbid%>')"></a></span></td>
                  <td>&nbsp;</td>
                </tr>
                </table>
                <script type="text/javascript">CKEDITOR.replace("yjmb");</script>
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