<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%
if (session.getAttribute("glqx").toString().indexOf(",5,")==-1) 
	response.sendRedirect("main.jsp");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/calendar3.js"></script>
<script type="text/javascript">
function saveit()
{
	if (document.getElementById("xzmc").value=="")
	{
		alert("请填写小组名称！");
		return false;
	}
	if (document.getElementById("ygbh").value=="")
	{
		alert("请填写小组成员！");
		return false;
	}
	if (document.getElementById("ldbh").value=="")
	{
		alert("请填写小组Leader！");
		return false;
	}
	if (document.getElementById("cjsj").value=="")
	{
		alert("请填写创建时间");
		return false;
	}
	document.getElementById("naction").value="save";
	document.getElementById("xform").submit();
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

function delyg()
{
	document.getElementById("ygxm").value="";
	document.getElementById("ygbh").value="";
}
function selectedyg(t)
{
	if (t==0)
	{
		//document.getElementById("ygxm").value="";
		//document.getElementById("ygbh").value="";
		var n=document.getElementsByName("yg").length;	
		for (i=0;i<n;i++)
		{
			if (document.getElementsByName("yg")[i].checked)
			{
				var tygbh=","+document.getElementById("ygbh").value;
				
				if (tygbh.indexOf(","+document.getElementsByName("yg")[i].value+",")==-1)
				{
				document.getElementById("ygxm").value=document.getElementById("ygxm").value+document.getElementsByName("yg")[i].title+",";
				document.getElementById("ygbh").value=document.getElementById("ygbh").value+document.getElementsByName("yg")[i].value+",";
				}
			}
		}
		closeLayer();
	}
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
	function allselyg()
	{
		var n=document.getElementsByName("yg").length;
		
		if (document.getElementById("sygsa").checked)
		{
			for (var i=0;i<n;i++)
			{
				if (!document.getElementsByName("yg")[i].checked)
					document.getElementsByName("yg")[i].checked=true;
			}
		}
		else
		{
			for (var i=0;i<n;i++)
			{
				if (document.getElementsByName("yg")[i].checked)
					document.getElementsByName("yg")[i].checked=false;
			}
		}
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
  <%@ include file="head.jsp" %>
 <div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>
<%

Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="",xzmc="",naction="",gpid="",bz="",ygxm="",ygbh="",ldxm="",ldbh="",cjsj="";
naction=request.getParameter("naction");
gpid=request.getParameter("gpid");
if (gpid==null) gpid="";
if (naction!=null && naction.equals("save"))
{
	xzmc=request.getParameter("xzmc");	
	bz=request.getParameter("bz");
	ygbh=request.getParameter("ygbh");
	ldbh=request.getParameter("ldbh");
	cjsj=request.getParameter("cjsj");
	if (ygbh==null) ygbh="";	
	if (xzmc==null) xzmc="";
	if (bz==null) bz="";
	if (ldbh==null) ldbh="";
	if (cjsj==null) cjsj="";
}


if (!fun.sqlStrCheck(gpid) || !fun.sqlStrCheck(xzmc) || !fun.sqlStrCheck(bz) || !fun.sqlStrCheck(ygbh) || !fun.sqlStrCheck("ldbh") || !fun.sqlStrCheck("cjsj"))
{
	return;
}

try
{
		if (naction!=null && naction.equals("save"))
		{
			String[] yglist=ygbh.split(",");
			
			if (gpid!=null && !gpid.equals(""))
			{
				strsql="update tbl_qyxz set xzmc='"+xzmc+"',bz='"+bz+"',ld="+ldbh+",cjsj='"+cjsj+"' where nid="+gpid;
				stmt.executeUpdate(strsql);
				
				strsql="delete from tbl_qyxzmc where xz=" +gpid;
				stmt.executeUpdate(strsql);
				
				for (int i=0;i<yglist.length;i++)
				{
					if (yglist[i]!=null && !yglist[i].equals(""))
					{
						strsql="insert into tbl_qyxzmc (qy,xz,yg) values("+session.getAttribute("qy")+","+gpid+","+yglist[i]+")";
						stmt.executeUpdate(strsql);
					}
				}
			}
			else
			{
				strsql="insert into tbl_qyxz (qy,xzmc,bz,ld,cjsj) values("+session.getAttribute("qy")+",'"+xzmc+"','"+bz+"',"+ldbh+",'"+cjsj+"')";
				stmt.executeUpdate(strsql);
				int xz=0;
				strsql="select nid from tbl_qyxz where xzmc='"+xzmc+"' and qy="+ session.getAttribute("qy")+" order by nid desc limit 1";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				xz=rs.getInt("nid");
				rs.close();
				
				for (int i=0;i<yglist.length;i++)
				{
					if (yglist[i]!=null && !yglist[i].equals(""))
					{
						strsql="insert into tbl_qyxzmc (qy,xz,yg) values("+session.getAttribute("qy")+","+xz+","+yglist[i]+")";
						stmt.executeUpdate(strsql);
					}
				}
			}
			//out.print(strsql);
			response.sendRedirect("group.jsp");
		}
		else if (gpid!=null && !gpid.equals(""))
		{
			strsql="select x.xzmc,x.ld,x.bz,x.cjsj,y.ygxm from tbl_qyxz x left join tbl_qyyg y on x.ld=y.nid where x.nid="+gpid;		
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				xzmc=rs.getString("xzmc");
				ldbh=rs.getString("ld");
				bz=rs.getString("bz");
				
				ldxm=rs.getString("ygxm");
				if (ldxm==null)
				{
					ldxm="";
					ldbh="";
				}
				SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");		
				if (rs.getDate("cjsj")!=null && !rs.getDate("cjsj").equals(""))
				cjsj=sf.format(rs.getDate("cjsj"));
					
			}
			rs.close();
			
			strsql="select y.nid,y.ygxm from tbl_qyxzmc x left  join tbl_qyyg y on x.yg=y.nid where x.xz="+gpid;
		  	rs=stmt.executeQuery(strsql);
		  	while(rs.next())
		  	{
		  		ygbh=ygbh+rs.getString("nid")+",";
		  		ygxm=ygxm+rs.getString("ygxm")+",";
		  	}
		  	rs.close();
		}
%>


<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="zhsz-top">
					<li><a href="company.jsp"><span><img src="images/ico-zh1.jpg" /></span><h1>企业信息管理</h1></a></li>
					<li><a href="department.jsp"><span><img src="images/ico-zh2.jpg" /></span><h1>组织架构管理</h1></a></li>
					<li><a href="staff.jsp"><span><img src="images/ico-zh3.jpg" /></span><h1>员工信息管理</h1></a></li>
					<li><a href="group.jsp" class="dangqian"><span><img src="images/ico-zh4.jpg" /></span><h1>小组管理</h1></a></li>
					<li><a href="item.jsp"><span><img src="images/ico-zh5.jpg" /></span><h1>发放名目管理</h1></a></li>
					<li><a href="info.jsp"><span><img src="images/ico-zh6.jpg" /></span><h1>公告管理</h1></a></li>
					<li><a href="admin.jsp"><span><img src="images/ico-zh7.jpg" /></span><h1>管理员管理</h1></a></li>
				</ul>
				<div class="zhszwrap">
					<div class="zhsz-up">
						<span><strong>小组管理</strong></span>
						<div class="zhsz-up-r"><span class="floatleft"><a href="group.jsp" class="caxun" style="margin:0">返 回</a></span></div>
					</div>
					<div class="zhszbox">
					<form action="groupedit.jsp" name="xform" id="xform" method="post">
					<input type="hidden" name="gpid" id="gpid" value="<%=gpid%>" /> 
					<input type="hidden" name="naction" id="naction" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
					  <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">小组名称：</td>
                          <td><input class="input3" type="text" name="xzmc" id="xzmc" value="<%=xzmc%>" maxlength="25" /></td>
                        </tr>
  						<tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>小组成员：</td><td><input class="input3" type="text" name="ygxm" id="ygxm" readonly="readonly" value="<%=ygxm%>" />
						  	 <span class="caxun" onclick="selectyg(0)">选择</span>&nbsp;<span class="caxun" onclick="delyg()">删除选择</span>
						  	<input type="hidden" name="ygbh" id="ygbh" value="<%=ygbh%>" /> 
						  	</td></tr>
  	
  						<tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>小组Leader：</td><td><input class="input3" type="text" name="ldxm" id="ldxm" readonly="readonly" value="<%=ldxm%>" />
					  	 <span class="caxun" onclick="selectyg(1)">选择</span>
					  	<input type="hidden" name="ldbh" id="ldbh" value="<%=ldbh%>" /> 
					  	</td></tr>
  	
  						<tr>
                          <td align="center"></td>
                          <td>小组说明：</td><td><textarea rows="3" cols="50" name="bz" id="bz"><%=bz%></textarea></td></tr>
  	<tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>创建时间：</td><td><input class="input3" type="text" name="cjsj" id="cjsj" value="<%=cjsj%>" maxlength="10"  onclick="new Calendar().show(this);" readonly="readonly"  /></td></tr> <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="groupedit.jsp?gpid=<%=gpid%>" class="reset"></a></span></td>
                        </tr>
                      </table>
                      </form>
					</div>
				</div>
			</div>
	  	</div>
	</div>
	<%@ include file="footer.jsp" %> 
  	<%
	
}
  catch(Exception e)
{			
	e.printStackTrace();
	conn.rollback();
	conncommit=0;
}
finally
{
	if (!conn.isClosed())
	{	
		if (conncommit==1)
			conn.commit();
		conn.close();
	}
}
   %>
    </body>
</html>