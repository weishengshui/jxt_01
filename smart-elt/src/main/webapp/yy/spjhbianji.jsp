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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4007")==-1)
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
<script type="text/javascript" src="../gl/js/calendar3.js"></script>
<script type="text/javascript">
function saveit()
{
	if(document.getElementById("jhbh").value=="")
	{
		alert("请填写进货编号！");
		return false;
	}
	if(document.getElementById("spid").value=="")
	{
		alert("请选择商品！");
		return false;
	}
	if(document.getElementById("gysid").value=="")
	{
		alert("请选择供应商！");
		return false;
	}
	if(document.getElementById("sl").value=="")
	{
		alert("请填写进货数量！");
		return false;
	}
	if(!CheckNumber(document.getElementById("sl").value))
	{
		alert("进货数量格式不对！");
		return false;
	}
	if(document.getElementById("jhsj").value=="")
	{
		alert("请填写进货时间 ！");
		return false;
	}
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}

function selgys()
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "selectgys.jsp?gtype=1&time="+timeParam;	
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showcon;
	xmlHttp.send(null);
}

function selsp()
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "selectsp.jsp?time="+timeParam;	
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showcon;
	xmlHttp.send(null);
}

function showcon()
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



function sspagain(p)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "getsplist.jsp?pno="+p+"&lb1="+document.getElementById("lb1").value+"&sspmc="+encodeURI(escape(document.getElementById("sspmc").value))+"&time="+timeParam;		
	if (document.getElementById("lb2"))
		url=url+"&lb2="+document.getElementById("lb2").value;
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlist;
	xmlHttp.send(null);
}

function sgysagain(p)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "getgyslist.jsp?pno="+p+"&gtype=1&sgysmc="+encodeURI(escape(document.getElementById("sgysmc").value))+"&slxr="+encodeURI(escape(document.getElementById("slxr").value))+"&time="+timeParam;		
	
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlist;
	xmlHttp.send(null);
}

function showlist()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			document.getElementById("dspllist").innerHTML=response;
		}
		catch(exception){}
	}
}
function getsp()
{
	var n=document.getElementsByName("sspid").length;	
	for (i=0;i<n;i++)
	{
		if (document.getElementsByName("sspid")[i].checked)
		{
			
			document.getElementById("spmc").value=document.getElementsByName("sspid")[i].title;
			document.getElementById("spid").value=document.getElementsByName("sspid")[i].value;
		}
	}
	closeLayer();
}

function getgys()
{
	var n=document.getElementsByName("sgysid").length;	
	for (i=0;i<n;i++)
	{
		if (document.getElementsByName("sgysid")[i].checked)
		{
			
			document.getElementById("gysmc").value=document.getElementsByName("sgysid")[i].title;
			document.getElementById("gysid").value=document.getElementsByName("sgysid")[i].value;
		}
	}
	closeLayer();
}

var lbl=1;
function lbshow(v,l)
{
	if (l==2) return;
	lbl=l+1;
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "selectsplb.jsp?lbid="+v+"&lbl="+lbl+"&time="+timeParam;	
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlb;
	xmlHttp.send(null);
	
}
function showlb()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			for(i=lbl;i<3;i++)
			document.getElementById("lblist"+i).innerHTML="";
			document.getElementById("lblist"+lbl).innerHTML=response;
		}
		catch(exception){}
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>
<%
String  menun="4007";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String gysmc="",gysid="",spmc="",spid="",sl="",jhbh="",jhsj="",sfxn="0";
String jhid=request.getParameter("jhid");
if (jhid==null) jhid="";
if (!fun.sqlStrCheck(jhid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='spjhgl.jsp';");
	out.print("</script>");
	return;
}
try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{
		gysid=request.getParameter("gysid");
		spid=request.getParameter("spid");
		jhbh=request.getParameter("jhbh");
		sl=request.getParameter("sl");
		jhsj=request.getParameter("jhsj");
		sfxn=request.getParameter("sfxn");
		if (!fun.sqlStrCheck(jhid) || !fun.sqlStrCheck(gysid) || !fun.sqlStrCheck(spid) || !fun.sqlStrCheck(jhbh) || !fun.sqlStrCheck(sl) || !fun.sqlStrCheck(jhsj)|| !fun.sqlStrCheck(sfxn))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		
		if (jhid!=null && jhid.length()>0)
		{
			
		}
		else
		{
			strsql="insert into tbl_spjh (sp,gys,sl,jhbh,jhsj,srsj,sfxn) values("+spid+","+gysid+","+sl+",'"+jhbh+"','"+jhsj+"',now(),"+sfxn+")";
			
			stmt.executeUpdate(strsql);
			
			//更新库存
			strsql="update tbl_sp set kcsl=kcsl+"+sl+",wcdsl=wcdsl+"+sl+" where nid="+spid;
			stmt.executeUpdate(strsql);
			
			response.sendRedirect("spjhgl.jsp");
	   		return;
		}
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
            <td><div class="local"><span>商品管理 &gt; 进货管理 &gt; <%if (jhid!=null && jhid.length()>0) out.print("修改进货"); else out.print("添加进货");%></span><a href="spjhgl.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="spjhbianji.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="jhid" id="jhid" value="<%=jhid%>" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"></td>
                          <td width="90">进货编号：</td>
                          <td><input type="text" name="jhbh" id="jhbh" value="<%=jhbh%>" maxlength="25" class="input3" />&nbsp;只作记录用</td>
                        </tr>
                          <tr>
		                      <td align="center"><span class="star">*</span></td>
		                      <td>商品：</td>
		                      <td><input type="hidden" name="spid" id="spid" value="<%=spid%>" /><input type="text" class="input3" name="spmc" id="spmc" readonly="readonly"  value="<%=spmc%>" /><input type="button" value="选择"  onclick="selsp()" />		                     
		                      </td>
		                   </tr>
		                   
		                    <tr>
		                      <td align="center"><span class="star">*</span></td>
		                      <td>供应商：</td>
		                      <td><input type="hidden" name="gysid" id="gysid" value="<%=gysid%>" /><input type="text" class="input3" name="gysmc" id="gysmc" readonly="readonly"  value="<%=gysmc%>" /><input type="button" value="选择"  onclick="selgys()" />		                      
		                      </td>
		                   </tr>
		                   
		                    <tr>
		                     <td align="center"><span class="star">*</span></td>
		                     <td>数量：</td>
		                  	  <td><input type="text" name="sl" id="sl" class="input3" value="<%=sl%>" maxlength="8" /></td>
		                  </tr>
		                  
		                     <tr>
		                      <td align="center"><span class="star">*</span></td>
		                      <td>进货日期：</td>
		                      <td><input type="text" name="jhsj" id="jhsj" class="input3" value="<%=jhsj%>" maxlength="25" onclick="new Calendar().show(this);" readonly="readonly" /></td>
		                    </tr>
                        <tr>
                        <tr>
	                      <td align="center"><span class="star">*</span></td>
	                      <td>虚拟商品：</td>
	                      <td><input type="radio" name="sfxn" id="sfxn" value="1" <%if (sfxn.equals("1")) out.print("checked='checked'"); %> />是 　　<input type="radio" name="sfxn" id="sfxn" value="0" <%if (sfxn.equals("0")) out.print("checked='checked'"); %> />否</td>
	                    </tr>
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