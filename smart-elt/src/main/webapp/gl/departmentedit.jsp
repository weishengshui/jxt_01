<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",3,")==-1) 
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
function saveit(na)
{
	if (document.getElementById("bmmc").value=="")
	{
		alert("请填写部门名称！");
		return false;
	}
	if (document.getElementById("ldbh").value=="")
	{
		alert("请选择部门Leader！");
		return false;
	}
	if (na=="")
		document.getElementById("naction").value="save";
	if (na=="addson")
		document.getElementById("naction").value="sonsave";
	if (na=="edit")
		document.getElementById("naction").value="editsave";
	document.getElementById("bform").submit();
}

function selectyg(t)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "selectyg.jsp?t="+t+"&time="+timeParam;		
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showyg;
	xmlHttp.send(null);
}
function showyg()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			openLayer(response);			
		}
		catch(exception){}
	}
}
function selectedyg(t)
{
	
	if (t==1)
	{
		document.getElementById("ldxm").value="";
		document.getElementById("ldbh").value="";
		var n=document.getElementsByName("yg").length;	
		for (i=0;i<n;i++)
		{
			if (document.getElementsByName("yg")[i].checked)
			{
				
				document.getElementById("ldxm").value=document.getElementsByName("yg")[i].title;
				document.getElementById("ldbh").value=document.getElementsByName("yg")[i].value;
			}
		}
		closeLayer();
	}
}

	function showlist()
	{
		if (xmlHttp.readyState == 4)
		{
			var response = xmlHttp.responseText;
			try
			{			
				document.getElementById("dyglist").innerHTML=response;
			}
			catch(exception){}
		}
	}
	
	function sygagain(p,t)
	{
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "getyglist.jsp?t="+t+"&pno="+p+"&dsygxm="+encodeURI(escape(document.getElementById("dsygxm").value))+"&dsbm="+document.getElementById("dsbm").value+"&dsemail="+encodeURI(escape(document.getElementById("dsemail").value))+"&time="+timeParam;		
		
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=showlist;
		xmlHttp.send(null);
	}
	
	function noselectedyg(t)
	{
		var n=document.getElementsByName("yg").length;
		for (var i=0;i<n;i++)
		{
			if (document.getElementsByName("yg")[i].checked)
				document.getElementsByName("yg")[i].checked=false;
		}
		selectedyg(t);
	}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
  <body>
<%menun=6; %>
 <div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>
<%@ include file="head.jsp" %>
<%

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="",bmmc="",naction="",bmid="",ldbh="",ldxm="";
naction=request.getParameter("naction");
bmmc=request.getParameter("bmmc");
bmid=request.getParameter("bmid");
ldbh=request.getParameter("ldbh");
if (bmid==null) bmid="";
if (bmmc==null) bmmc="";
if (naction==null) naction="";
if (ldbh==null) ldbh="";
if (!fun.sqlStrCheck(bmid) || !fun.sqlStrCheck(bmmc))
{
	return;
}
try
{
		if (naction!=null && naction.equals("save"))
		{
			strsql="insert into tbl_qybm (qy,bmmc,fbm,ld) values("+session.getAttribute("qy")+",'"+bmmc+"',0,"+ldbh+")";
			stmt.executeUpdate(strsql);			
			response.sendRedirect("department.jsp");
		}
		if (naction!=null && naction.equals("sonsave"))
		{
			strsql="insert into tbl_qybm (qy,bmmc,fbm,ld) values("+session.getAttribute("qy")+",'"+bmmc+"',"+bmid+","+ldbh+")";
			stmt.executeUpdate(strsql);			
			response.sendRedirect("department.jsp");
		}
		if (naction!=null && naction.equals("editsave"))
		{
			strsql="update tbl_qybm set bmmc='"+bmmc+"',ld="+ldbh+" where nid="+bmid;
			stmt.executeUpdate(strsql);			
			response.sendRedirect("department.jsp");
		}
		
		
		if (naction!=null && naction.equals("edit"))
		{
			strsql="select b.bmmc,b.ld,y.ygxm from tbl_qybm b left join tbl_qyyg y on b.ld=y.nid where b.nid="+bmid;		
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				bmmc=rs.getString("bmmc");
				ldbh=rs.getString("ld");
				ldxm=rs.getString("ygxm");
				if (ldbh==null) ldbh="";
				if (ldxm==null) ldxm="";			
			}
			rs.close();
		}
%>		
<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="zhsz-top">
					<li><a href="company.jsp"><span><img src="images/ico-zh1.jpg" /></span><h1>企业信息管理</h1></a></li>
					<li><a href="department.jsp" class="dangqian"><span><img src="images/ico-zh2.jpg" /></span><h1>组织架构管理</h1></a></li>
					<li><a href="staff.jsp"><span><img src="images/ico-zh3.jpg" /></span><h1>员工信息管理</h1></a></li>
					<li><a href="group.jsp"><span><img src="images/ico-zh4.jpg" /></span><h1>小组管理</h1></a></li>
					<li><a href="item.jsp"><span><img src="images/ico-zh5.jpg" /></span><h1>发放名目管理</h1></a></li>
					<li><a href="info.jsp"><span><img src="images/ico-zh6.jpg" /></span><h1>公告管理</h1></a></li>
					<li><a href="admin.jsp"><span><img src="images/ico-zh7.jpg" /></span><h1>管理员管理</h1></a></li>
				</ul>
				<div class="zhszwrap">
					<div class="zhsz-up">
						<span><strong>组织架构管理：</strong></span>
						<div class="zhsz-up-r"><span class="floatleft"><a href="department.jsp" class="caxun" style="margin:0">返 回</a></span></div>
					</div>
					<div class="zhszbox">
					<form action="departmentedit.jsp" name="bform" id="bform" method="post">
					<input type="hidden" name="bmid" id="bmid" value="<%=bmid%>" /> 
					<input type="hidden" name="naction" id="naction" value="<%=naction%>" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
					  

  				
  	<tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">部门名称：</td><td><input  class="input3" type="text" name="bmmc" id="bmmc" value="<%=bmmc%>" maxlength="25" /></td></tr>
  	<tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>部门Leader：</td><td><input  class="input3" type="text" name="ldxm" id="ldxm" readonly="readonly" value="<%=ldxm%>" /> <span class="caxun" onclick="selectyg(1)">选择</span>
  	
  	<input type="hidden" name="ldbh" id="ldbh" value="<%=ldbh%>" />
  	</td></tr>
  
  	
  	<tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit('<%=naction%>')" ></a></span><span class="floatleft" ><a href="departmentedit.jsp?naction=<%=naction%>&bmid=<%=bmid%>" class="reset"></a></span></td>
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