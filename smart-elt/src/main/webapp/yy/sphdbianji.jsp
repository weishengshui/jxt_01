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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4005")==-1)
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
<script type="text/javascript" src="ckeditor/ckeditor.js"></script>
<script type="text/javascript">
function saveit()
{
	if (document.getElementById("bt").value.trim()=="")
	{
		alert("请填写标题！");
		return false;
	}
	if(document.getElementById("ksrq").value=="")
	{
		alert("请填写开始日期！");
		return false;
	}
	if(document.getElementById("jsrq").value=="")
	{
		alert("请填写结束日期！");
		return false;
	}
	if(document.getElementById("xswz").value.trim()=="")
	{
		alert("请填写显示位置！");
		return false;
	}
	if(!CheckNumber(document.getElementById("xswz").value))
	{
		alert("显示位置只能为数字！");
		return false;
	}
	
	if (document.getElementById("spid").value=="" && editor.document.getBody().getText()=="")
	{
		alert("对应商品和活动内容必须填写一个！");
		return false;
	}
	
	document.getElementById("iform").submit();
}

function delsp()
{
	document.getElementById("spid").value="";
	document.getElementById("spmc").value="";
}

function selsp()
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "selectsp.jsp?time="+timeParam;		
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showsp;
	xmlHttp.send(null);
}

function showsp()
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
function sptrshow(obj){
	if(obj.checked = true){
		document.getElementById("dysptr").style.display = "";
		document.getElementById("hdnrtr").style.display = "none";
	}
}
function nrtrshow(obj){
	if(obj.checked = true){
		document.getElementById("dysptr").style.display = "none";
		document.getElementById("hdnrtr").style.display = "";
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>
<%
String  menun="4005";
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="",bt="",hdid="",syxs="1",xswz="",ksrq="",jsrq="",sp="",tplj="",spmc="",spid="",hdnr="",sfgg="1";
hdid=request.getParameter("hdid");
if (hdid==null) hdid="";

if (!fun.sqlStrCheck(hdid))
{
	return;
}
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try
{
		
		
		
		if (hdid!=null && hdid.length()>0)
		{
			strsql="select c.bt,c.syxs,c.xswz,c.ksrq,c.jsrq,c.tplj,c.sp,c.sfgg,c.hdnr,s.spmc from tbl_cxhd c left join tbl_sp s on c.sp=s.nid where c.nid="+hdid;	
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				bt=rs.getString("bt");
				syxs=rs.getString("syxs");
				xswz=rs.getString("xswz");
				ksrq=sf.format(rs.getDate("ksrq"));
				jsrq=sf.format(rs.getDate("jsrq"));
				tplj=rs.getString("tplj");
				spmc=rs.getString("spmc");
				spid=rs.getString("sp");
				sfgg=rs.getString("sfgg");
				hdnr=rs.getString("hdnr");
			}
			rs.close();
		}
		
		if (spmc==null) spmc="";
		if (spid==null || spid.equals("0")) spid="";
	
	
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
            <td><div class="local"><span>商品管理 &gt; 活动管理</span><a href="sphdgl.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="sphdsave.jsp?pno=${param.pno }" enctype="multipart/form-data" name="iform" id="iform" method="post">
				<input type="hidden" name="hdid" id="hdid" value="<%=hdid%>" /> 				
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
				  <tr>
                    <td width="30" align="center"><span class="star">*</span></td>
                    <td width="90">标题：</td>
                    <td><input type="text" class="input3" name="bt" id="bt" value="<%=bt%>" maxlength="25" /></td>
                  </tr>
                  <tr>
                     <td align="center"><span class="star">*</span></td>
                     <td>显示位置：</td>
                  	  <td><input type="text" name="xswz" id="xswz" class="input3" value="<%=xswz==null?"":xswz%>" maxlength="4" />&nbsp;请填写数字，数字越大显示位置越靠前</td>
                  </tr>
                   <tr>
                      <td align="center"><span class="star">*</span></td>
                      <td>活动开始时间：</td>
                      <td><input type="text" name="ksrq" id="ksrq" class="input3" value="<%=ksrq%>" maxlength="25" onclick="new Calendar().show(this);" readonly="readonly" /></td>
                    </tr>
                    <tr>
                      <td align="center"><span class="star">*</span></td>
                      <td>活动结束时间：</td>
                      <td><input type="text" name="jsrq" id="jsrq" class="input3" value="<%=jsrq%>" maxlength="25" onclick="new Calendar().show(this);" readonly="readonly" /></td>
                    </tr>
                     <tr>
	                      <td align="center"><span class="star">*</span></td>
	                      <td>广告栏显示：</td>
	                      <td><input type="radio" name="sfgg" id="sfgg" value="1" <%if (sfgg.equals("1")) out.print("checked='checked'"); %> />是 　　<input type="radio" name="sfgg" id="sfgg" value="0" <%if (sfgg.equals("0")) out.print("checked='checked'"); %> />否</td>
	                    </tr>
                     <tr>
                      <td align="center"></td>
                      <td>活动图片：</td>
                      <td><input type="file"  name="tplj" id="tplj" />
					<%if (tplj!=null && !tplj.equals("")){%><br/><img src="<%="../"+tplj%>" /><%} %> &nbsp;&nbsp格式使用jpg、gif，宽度680px高度318px的图片最佳</td>
                   </tr>
                   
                  <tr>
	                    <td align="center"><span class="star">*</span></td>
	                      <td>活动内容选择：</td>
	                      <td><input type="radio" onclick="sptrshow(this);" name="sfdp" id="sfdp1" checked> 单品活动　　<input type="radio"  onclick="nrtrshow(this);"  name="sfdp" id="sfdp2" value="0" /> 活动页面</td>
	                 </tr>
                    <tr id="dysptr">
                      <td align="center"><span class="star">*</span></td>
                      <td>对应商品：</td>
                      <td><input type="hidden" name="spid" id="spid" value="<%=spid%>" /><input type="text" class="input3" name="spmc" id="spmc" readonly="readonly"  value="<%=spmc%>" /><input type="button" value="选择"  onclick="selsp()" />&nbsp;<input type="button" value="删除"  onclick="delsp()" />
                      &nbsp;当无活动具体页面直接跳到商品页面时设置此值
                      </td>
                   </tr>
                   <tr id="hdnrtr" style="display:none">
                       <td align="center"><span class="star">*</span></td>
                       <td>活动内容：</td>
                       <td><textarea id="hdnr" name="hdnr"><%=hdnr==null?"":hdnr%></textarea></td>
                     </tr>
                   <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="#" class="reset"></a></span></td>
                  </tr>
                </table>
                <script type="text/javascript">var editor=CKEDITOR.replace("hdnr");</script>
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