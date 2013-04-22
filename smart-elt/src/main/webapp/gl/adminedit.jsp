<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",1,")==-1) 
	response.sendRedirect("main.jsp");
%>
<%request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
function saveit()
{
	var savestr=",";
	var n=document.getElementsByName("glqx1").length;
	for (i=0;i<n;i++)
	{
		if (document.getElementsByName("glqx1")[i].checked)
		{
		savestr=savestr+document.getElementsByName("glqx1")[i].value+",";		
		}
	}
	n=document.getElementsByName("glqx2").length;
	for (i=0;i<n;i++)
	{
		if (document.getElementsByName("glqx2")[i].checked)
		{
		savestr=savestr+document.getElementsByName("glqx2")[i].value+",";		
		}
	}
	
	document.getElementById("glqxstr").value=savestr;
	document.getElementById("naction").value="save";
	document.getElementById("aform").submit();
}
function allcheck(t)
{
	var n=document.getElementsByName("glqx"+t).length;
	if (document.getElementsByName("xtsz")[t-1].checked)
	{
		for (i=0;i<n;i++)
			document.getElementsByName("glqx"+t)[i].checked=true;
	}
	else
	{
		for (i=0;i<n;i++)
			document.getElementsByName("glqx"+t)[i].checked=false;
	}
}
function reset()
{
	var n=document.getElementsByName("glqx1").length;
	for (i=0;i<n;i++)
			document.getElementsByName("glqx1")[i].checked=false;
	n=document.getElementsByName("glqx2").length;
	for (i=0;i<n;i++)
			document.getElementsByName("glqx2")[i].checked=false;
	
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
  <body>
<%menun=6; %>
<%

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="",naction="",adid="",glqx="",ygid="";
naction=request.getParameter("naction");
adid=request.getParameter("adid");
glqx=request.getParameter("glqxstr");
ygid=request.getParameter("ygid");
if (adid==null) adid="";
if (glqx==null) glqx="";
if (ygid==null) ygid="";

if (!fun.sqlStrCheck(adid) || !fun.sqlStrCheck(glqx))
{
	return;
}

try
{
		if (naction!=null && naction.equals("save"))
		{
			if (adid!=null && !adid.equals(""))
			strsql="update tbl_qyyg set gly=1,glqx='"+glqx+"' where nid="+adid;
			else
			strsql="update tbl_qyyg set gly=1,glqx='"+glqx+"' where nid="+ygid;
			stmt.executeUpdate(strsql);
			//out.print(strsql);
			response.sendRedirect("admin.jsp");
		}
		else if (adid!=null && !adid.equals(""))
		{
			strsql="select glqx from tbl_qyyg where nid="+adid;		
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				glqx=rs.getString("glqx");
				if (glqx==null) glqx=""; 			
			}
			rs.close();
		}
%>		
<%@ include file="head.jsp" %>
<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="zhsz-top">
					<li><a href="company.jsp"><span><img src="images/ico-zh1.jpg" /></span><h1>企业信息管理</h1></a></li>
					<li><a href="department.jsp"><span><img src="images/ico-zh2.jpg" /></span><h1>组织架构管理</h1></a></li>
					<li><a href="staff.jsp"><span><img src="images/ico-zh3.jpg" /></span><h1>员工信息管理</h1></a></li>
					<li><a href="group.jsp"><span><img src="images/ico-zh4.jpg" /></span><h1>小组管理</h1></a></li>
					<li><a href="item.jsp"><span><img src="images/ico-zh5.jpg" /></span><h1>发放名目管理</h1></a></li>
					<li><a href="info.jsp"><span><img src="images/ico-zh6.jpg" /></span><h1>公告管理</h1></a></li>
					<li><a href="admin.jsp" class="dangqian"><span><img src="images/ico-zh7.jpg" /></span><h1>管理员管理</h1></a></li>
				</ul>
				<div class="zhszwrap">
					<div class="zhsz-up">
						<span><strong>菜单权限</strong></span>
						<div class="zhsz-up-r"><span class="floatleft"><a href="admin.jsp" class="caxun" style="margin:0">返 回</a></span></div>
					</div>
					<div class="zhszbox">
					
					<form action="adminedit.jsp" name="aform" id="aform" method="post">
					<input type="hidden" name="adid" id="adid" value="<%=adid%>" /> 
					<input type="hidden" name="naction" id="naction" />
					<input type="hidden" name="glqxstr" id="glqxstr" value="<%=glqx%>" />
					  	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"></td>
                          <td width="90">菜单权限</td>
                          <td>
                          	<div><ul>
	                        <li><input type="checkbox" name="xtsz" id="xtsz" onclick="allcheck(1)"/> 系统设置：</li>
	                        <li>　　<input type="checkbox" name="glqx1" id="glqx1" value="1" <%if (glqx.indexOf(",1,")>-1) out.print("checked='checked'"); %> /> 管理员管理：用于操作员在系统中各功能模块的操作权限设置</li>
						  	<li>　　<input type="checkbox" name="glqx1" id="glqx1" value="2" <%if (glqx.indexOf(",2,")>-1) out.print("checked='checked'"); %> /> 企业信息设置：用于设置企业的基本信息</li>
						  	<li>　　<input type="checkbox" name="glqx1" id="glqx1" value="3" <%if (glqx.indexOf(",3,")>-1) out.print("checked='checked'"); %> /> 组织架构管理：用于设置公司的组织架构层级，用于部门奖励/福利发放</li>						  
						  	<li>　　<input type="checkbox" name="glqx1" id="glqx1" value="4" <%if (glqx.indexOf(",4,")>-1) out.print("checked='checked'"); %> /> 员工信息管理：用于设置员工基本信息，用于员工奖励</li>
						  	<li>　　<input type="checkbox" name="glqx1" id="glqx1" value="5" <%if (glqx.indexOf(",5,")>-1) out.print("checked='checked'"); %> /> 项目组管理：用于项目组的设置和管理</li>
						  	<li>　　<input type="checkbox" name="glqx1" id="glqx1" value="6" <%if (glqx.indexOf(",6,")>-1) out.print("checked='checked'"); %> /> 奖励名目管理：用于设置企业奖励和福利发放的名目</li>
						  	<li>　　<input type="checkbox" name="glqx1" id="glqx1" value="7" <%if (glqx.indexOf(",7,")>-1) out.print("checked='checked'"); %> /> 公司公告管理：用于企业内部公告、通知的发布和管理</li>
                          	<br/>
                          	<li><input type="checkbox" name="xtsz" id="xtsz" onclick="allcheck(2)"/> 操作设置：</li>
                          	<li>　　<input type="checkbox" name="glqx2" id="glqx2" value="10" <%if (glqx.indexOf(",10,")>-1) out.print("checked='checked'"); %> /> 购买积分：用于企业购买积分，该积分可用于向员工发放或购买福利发放给员工</li>
						  	<li>　　<input type="checkbox" name="glqx2" id="glqx2" value="11" <%if (glqx.indexOf(",11,")>-1) out.print("checked='checked'"); %> /> 发放积分：用于设置发放给员工和授权给部门积分</li>
						  	<li>　　<input type="checkbox" name="glqx2" id="glqx2" value="12" <%if (glqx.indexOf(",12,")>-1) out.print("checked='checked'"); %> /> 购买福利：用于企业使用积分购买相关的积分券</li>						  
						  	<li>　　<input type="checkbox" name="glqx2" id="glqx2" value="13" <%if (glqx.indexOf(",13,")>-1) out.print("checked='checked'"); %> /> 发放福利：用于设置发放给员工和授权给部门积分</li>
                          	</ul></div>
                          </td>
                        </tr>
                       
                      <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="javascript:void(0);" onclick="reset()" class="reset"></a></span></td>
                        </tr>
                      </table>
                      </form>
					</div>
				</div>
			</div>
	  	</div>
	</div>
	<%@ include file="footer.jsp" %> 
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