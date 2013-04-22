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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4009")==-1)
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
	if(document.getElementById("ckbh").value=="")
	{
		alert("请填写出库编号！");
		return false;
	}
	if(document.getElementById("spid").value=="")
	{
		alert("请选择商品！");
		return false;
	}
	
	if(document.getElementById("sl").value=="")
	{
		alert("请填写出库量！");
		return false;
	}
	if(!CheckNumber(document.getElementById("sl").value))
	{
		alert("出库数量格式不对！");
		return false;
	}
	if(!parseInt(document.getElementById("sl").value))
	{
		alert("出库数量格式不对！");
		return false;
	}
	if(document.getElementById("cksj").value=="")
	{
		alert("请填写出库时间 ！");
		return false;
	}
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}



function selsp()
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "selectsp.jsp?t=more2&time="+timeParam;	
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
	var url = "getsplist.jsp?t=more2&pno="+p+"&lb1="+document.getElementById("lb1").value+"&sspmc="+encodeURI(escape(document.getElementById("sspmc").value))+"&time="+timeParam;		
	if (document.getElementById("lb2"))
		url=url+"&lb2="+document.getElementById("lb2").value;
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
String  menun="4009";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String spmc="",spid="",sl="",ckbh="",cksj="",bz="";
String ckid=request.getParameter("ckid");
if (ckid==null) ckid="";
if (!fun.sqlStrCheck(ckid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='spckgl.jsp';");
	out.print("</script>");
	return;
}
try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{
		
		spid=request.getParameter("spid");
		ckbh=request.getParameter("ckbh");
		sl=request.getParameter("sl");
		cksj=request.getParameter("cksj");
		bz=request.getParameter("bz");
		if (!fun.sqlStrCheck(ckid) || !fun.sqlStrCheck(spid) || !fun.sqlStrCheck(ckbh) || !fun.sqlStrCheck(sl) || !fun.sqlStrCheck(cksj)|| !fun.sqlStrCheck(bz))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		
		if (ckid!=null && ckid.length()>0)
		{
			
		}
		else
		{
			//先判断库存量是否足够减
			strsql="select nid from tbl_sp where nid="+spid+" and kcsl>="+sl+" and wcdsl>="+sl;
			rs=stmt.executeQuery(strsql);
			if (!rs.next())
			{
				rs.close();
				out.print("<script type='text/javascript'>");
		   		out.print("alert('该商品目前库存量不够');"); 
		   		out.print("history.back(-1);");
		   		out.print("</script>");
		   		return;
			}
			rs.close();
			
			strsql="insert into tbl_spck (sp,sl,ckbh,cksj,srsj,bz) values("+spid+","+sl+",'"+ckbh+"','"+cksj+"',now(),'"+bz+"')";			
			stmt.executeUpdate(strsql);
			
			//更新库存			
			strsql="update tbl_sp set kcsl=kcsl-"+sl+",wcdsl=wcdsl-"+sl+" where nid="+spid;
			stmt.executeUpdate(strsql);
			
			response.sendRedirect("spckgl.jsp");
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
            <td><div class="local"><span>商品管理 &gt; 出库管理 &gt; <%if (ckid!=null && ckid.length()>0) out.print("修改出库"); else out.print("添加出库");%></span><a href="spckgl.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="spckbianji.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="ckid" id="ckid" value="<%=ckid%>" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">出库编号：</td>
                          <td><input type="text" name="ckbh" id="ckbh" value="<%=ckbh%>" maxlength="25" class="input3" />&nbsp;只作记录用</td>
                        </tr>
                          <tr>
		                      <td align="center"><span class="star">*</span></td>
		                      <td>商品：</td>
		                      <td><input type="hidden" name="spid" id="spid" value="<%=spid%>" /><input type="text" class="input3" name="spmc" id="spmc" readonly="readonly"  value="<%=spmc%>" /><input type="button" value="选择"  onclick="selsp()" />		                     
		                      </td>
		                   </tr>
		                   
		                    <tr>
		                     <td align="center"><span class="star">*</span></td>
		                     <td>数量：</td>
		                  	  <td><input type="text" name="sl" id="sl" class="input3" value="<%=sl%>" maxlength="8" /></td>
		                  </tr>
		                  
		                     <tr>
		                      <td align="center"><span class="star">*</span></td>
		                      <td>出库日期：</td>
		                      <td><input type="text" name="cksj" id="cksj" class="input3" value="<%=cksj%>" maxlength="25" onclick="new Calendar().show(this);" readonly="readonly" /></td>
		                    </tr>
                         <tr>
                         <tr>
		                     <td align="center"></td>
		                     <td>备注：</td>
		                  	  <td><textarea name="bz" id="bz" rows="3" cols="50"><%=bz==null?"":bz%></textarea></td>
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