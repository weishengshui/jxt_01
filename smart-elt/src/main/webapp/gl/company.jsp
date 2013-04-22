<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",2,")==-1) 
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
	
	if(document.getElementById("qydz").value=="")
	{
		alert("请填写企业地址！");
		return false;
	}
	if(document.getElementById("qh").value=="")
	{
		alert("请填写区号！");
		return false;
	}
	if (!CheckNumber(document.getElementById("qh").value))
	{
		alert("填写的区号格式不正确！");
		return false;
	}
	if(document.getElementById("dh").value=="")
	{
		alert("请填写电话！");
		return false;
	}
	
	if(document.getElementById("yb").value=="")
	{
		alert("请填写邮编！");
		return false;
	}
	if (!CheckNumber(document.getElementById("yb").value))
	{
		alert("填写的邮编格式不正确！");
		return false;
	}
	if(document.getElementById("lxr").value=="")
	{
		alert("请填写联系人！");
		return false;
	}
	if(document.getElementById("lxremail").value=="")
	{
		alert("请填写联系人邮箱！");
		return false;
	}
	if (!EmailCheck(document.getElementById("lxremail").value))
	{
		alert("填写的联系人邮箱格式不正确！");
		return false;
	}
	
	if(document.getElementById("yyzz").value!="" && !checkimg(document.getElementById("yyzz").value))
	{
		alert("营业执照图片格式不对");
		return false;
	}
	
	if(document.getElementById("swdj").value!="" && !checkimg(document.getElementById("swdj").value))
	{
		alert("税务登记证图片格式不对");
		return false;
	}
	
	if(document.getElementById("zzjg").value!="" && !checkimg(document.getElementById("zzjg").value))
	{
		alert("组织机构代码图片格式不对");
		return false;
	}
	
	if(document.getElementById("qylog").value!="" && !checkimg(document.getElementById("qylog").value))
	{
		alert("企业Logo照图片格式不对");
		return false;
	}
	
	document.getElementById("cform").submit();
}

function editlxr(id)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "contact.jsp?lxrid="+id+"&time="+timeParam;		
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=lxrshow;
	xmlHttp.send(null);
}

function lxrshow()
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
function savelxr(id)
{
	var xm=document.getElementById("xm").value;
	var gh=document.getElementById("gh").value;
	var sj=document.getElementById("sj").value;
	var email=document.getElementById("email").value;
	var qq=document.getElementById("qq").value;
	var msn=document.getElementById("msn").value;
	var skype=document.getElementById("skype").value;
	var bz=document.getElementById("bz").value;
	var postdata="na=edit&lxrid="+id+"&xm="+encodeURI(escape(xm))+"&gh="+gh+"&sj="+sj+"&email="+encodeURI(escape(email))+"&qq="+qq+"&msn="+encodeURI(escape(msn))+"&skype="+skype+"&bz="+encodeURI(escape(bz));
	
	xmlHttp.open("POST","contactsave.jsp", true);	
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=UTF-8");	
	xmlHttp.onreadystatechange =lxrsave;
	xmlHttp.send(postdata);
}

function lxrsave()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			closeLayer();
			document.getElementById("lxrlist").innerHTML=response;
			
		}
		catch(exception){}
	}
}

function dellxr(id)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "contactsave.jsp?na=del&lxrid="+id+"&time="+timeParam;		
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=lxrsave;
	xmlHttp.send(null);
}
function editpwd()
{
	openLayer("<div style=\"border: #CCCCCC 5px solid;width:555px; height: 265px; background: #FFFFFF\"><div style=\"margin: 10px 0 20px 20px;font-size: 14px; font-weight:bold;\">修改账户登录密码</div><div><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" class=\"zhsztable\"><tr><td width=\"100\" align=\"right\">旧密码:</td><td>&nbsp;&nbsp;<input type=\"password\" class=\"input3\"  name=\"pwd1\" id=\"pwd1\" maxlength=\"20\" /></td></tr><tr><td align=\"right\">新密码:</td><td>&nbsp;&nbsp;<input type=\"password\" class=\"input3\" name=\"pwd2\" id=\"pwd2\" maxlength=\"20\" /></td></tr><tr><td align=\"right\">重复新密码:</td><td>&nbsp;&nbsp;<input type=\"password\" class=\"input3\" name=\"pwd3\" id=\"pwd3\" maxlength=\"20\" /></td></tr><tr> <td>&nbsp;</td><td><span class=\"floatleft\"><a href=\"javascript:void(0);\" class=\"submit\" onclick=\"changepwd()\" ></a></span><span class=\"floatleft\" style=\"margin:10px 0 0 20px;\"><a href=\"#\" onclick=\"closeLayer()\" style=\"color: blue;\">取消</a></span></td></tr></table></div></div>");
}
function changepwd()
{
	if (document.getElementById("pwd1").value=="")
		return;
	if (document.getElementById("pwd2").value=="")
		return;
	if (document.getElementById("pwd3").value=="")
		return;
	if (document.getElementById("pwd2").value!=document.getElementById("pwd3").value)
	{
		alert("重复密码不致！");
		return;
	}
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "changepwd.jsp?p1="+document.getElementById("pwd1").value+"&p2="+document.getElementById("pwd2").value+"&time="+timeParam;	
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=cpshow;
	xmlHttp.send(null);
}
function cpshow()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			response=response.replace(new RegExp("","g"),"");
			if (response=="0")
			{
				alert("原密码错误！");
				return;
			}
			else{
			alert("修改成功！");	
			closeLayer();			
			}
		}
		catch(exception){}
	}
}
function outdata()
{
	document.getElementById("outform").submit();
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
String qymc="",qybh="",qydz="",qh="",dh="",yb="",yyzz="",swdj="",zzjg="",qylog="",bz="",strsql="",lxr="",lxremail="";
try
{
		
		strsql="select * from tbl_qy where nid="+session.getAttribute("qy");		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			qymc=rs.getString("qymc");
			qybh=rs.getString("qybh");
			qydz=rs.getString("qydz");
			qh=rs.getString("qh");
			dh=rs.getString("dh");
			yb=rs.getString("yb");
			yyzz=rs.getString("yyzz");
			swdj=rs.getString("swdj");
			zzjg=rs.getString("zzjg");
			qylog=rs.getString("log");
			bz=rs.getString("bz");
			lxr=rs.getString("lxr");
			lxremail=rs.getString("lxremail");
		}
		rs.close();
		
		if (lxr==null) lxr="";
		if (lxremail==null) lxremail="";

%>
	
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="zhsz-top">
					<li><a href="company.jsp" class="dangqian"><span><img src="images/ico-zh1.jpg" /></span><h1>企业信息管理</h1></a></li>
					<li><a href="department.jsp"><span><img src="images/ico-zh2.jpg" /></span><h1>组织架构管理</h1></a></li>
					<li><a href="staff.jsp"><span><img src="images/ico-zh3.jpg" /></span><h1>员工信息管理</h1></a></li>
					<li><a href="group.jsp"><span><img src="images/ico-zh4.jpg" /></span><h1>小组管理</h1></a></li>
					<li><a href="item.jsp"><span><img src="images/ico-zh5.jpg" /></span><h1>发放名目管理</h1></a></li>
					<li><a href="info.jsp"><span><img src="images/ico-zh6.jpg" /></span><h1>公告管理</h1></a></li>
					<li><a href="admin.jsp"><span><img src="images/ico-zh7.jpg" /></span><h1>管理员管理</h1></a></li>
				</ul>
				<div class="zhszwrap">					
					<div class="zhsz-up">
					<span><strong>企业信息设置：</strong>用于设置企业的基本信息</span>
					<div class="zhsz-up-r"><span class="floatleft"></span></div>
					</div>
					
					<div class="zhszbox">
					<form action="companysave.jsp" enctype="multipart/form-data" name="cform" id="cform" method="post">
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="100">企 业 名 称：</td>
                          <td><input type="text" name="qymc" id="qymc" value="<%=qymc%>" readonly="readonly"  maxlength="150" class="input2" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>企 业 域 名：</td>
                          <td><input type="text" name="qybh" id="qybh" class="input2" readonly="readonly"  value="<%=qybh%>" maxlength="25" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>地　　　址：</td>
                          <td><input type="text" class="input1" name="qydz" id="qydz" value="<%=qydz%>" maxlength="100" /></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>邮　　　编：</td>
                          <td><input type="text" class="input3" name="yb" id="yb"  value="<%=yb%>" maxlength="10" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>电　　　话：</td>
                          <td><input type="text" class="input3" style="width: 50px;" name="qh" id="qh"  value="<%=qh%>" maxlength="10" />-<input type="text" class="input3"  style="width: 116px;" name="dh" id="dh" value="<%=dh%>" maxlength="25" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>企业联系人：</td>
                          <td><input type="text" class="input3" name="lxr" id="lxr"  value="<%=lxr%>" maxlength="25" /></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>联系人信箱：</td>
                          <td><input type="text" class="input3" name="lxremail" id="lxremail"  value="<%=lxremail%>" maxlength="50" /></td>
                        </tr>
                       
                        <tr>
                          <td align="center" valign="top"><span class="star">*</span></td>
                          <td valign="top">营 业 执 照：</td>
                          <td><input type="file"  name="yyzz" id="yyzz" />&nbsp;请不要超过500K,格式为：jpg、gif
  							<%if (yyzz!=null && !yyzz.equals("")){%><br/><img src="<%="../"+yyzz%>" width="100" hspace="100" /><%} %></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td valign="top">税务登记证：</td>
                          <td><input type="file"  name="swdj" id="swdj" />&nbsp;请不要超过500K,格式为：jpg、gif
  						<%if (swdj!=null && !swdj.equals("")){%><br/><img src="<%="../"+swdj%>" width="100" hspace="100" /><%} %></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td valign="top">组织机构代码：</td>
                          <td><input type="file"  name="zzjg" id="zzjg" /> &nbsp;请不要超过500K,格式为：jpg、gif
  						<%if (zzjg!=null && !zzjg.equals("")){%><br/><img src="<%="../"+zzjg%>" width="100" hspace="100" /><%} %></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td valign="top">企 业 Logo:</td>
                          <td><input type="file" name="qylog" id="qylog" />&nbsp;请不要超过500K,高度75，宽度不超过200，格式为：jpg、gif
  						<%if (qylog!=null && !qylog.equals("")){%><br/><img src="<%="../"+qylog%>" width="100" hspace="100" /><%} %></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td valign="top">备　　　注：</td>
                          <td><textarea rows="5" cols="50" name="bz" id="bz" ><%=bz %></textarea></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="company.jsp" class="reset"></a></span></td>
                        </tr>                        
                      </table>
                      </form>
					</div>
					<div>
						<form action="outhrbb.jsp" method="post" name="outform" id="outform" target="_blank">
						<table width="100%" cellpadding="0" cellspacing="0" style="border-bottom: #CCCCCC 1px solid;border-top: #CCCCCC 1px solid;">
							<tr><td height="50" width="130"><strong>报表导出：<strong></td>
							<td width="400">日期：<input type="text" name="soutdate" id="soutdate" onclick="new Calendar().show(this);" />--<input type="text" name="eoutdate" id="eoutdate" onclick="new Calendar().show(this);" /></td>
							<td><a href="#" onclick="outdata()"><img src="images/bbdc.jpg"/></a></td>
							</tr>
							<tr><td><strong>报表名称：</strong></td><td colspan="11">《积分购买明细报表》，《积分发放明细报表》，《积分券购买明细报表》，《积分券发放明细报表》</td></tr>
							<tr><td>&nbsp;</td><td colspan="11">《发放名目统计分析报表》，《员工账户状况报表》，《员工账户获得明细报表》</td></tr>
						</table>
						</form>
					</div>
					
					<div style="margin-top: 20px;margin-bottom: 10px;">
					<span style="font-size:14px;font-weight: bold;">账号信息</span>
					</div>
					<div class="zhszbox">
					 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"></td>
                          <td width="100">账　　　号：</td>
                          <td><%=session.getAttribute("email")%></td>
                        </tr>
                         <tr>
                          <td width="30" align="center"></td>
                          <td width="100">姓　　　名：</td>
                          <td><%=session.getAttribute("ygxm")%></td>
                        </tr>
                         <tr>
                          <td width="30" align="center"></td>
                          <td width="100">密　　　码：</td>
                          <td>********&nbsp;<a href="javascript:void(0);" style="color: blue;" onclick="editpwd()">修改密码</a></td>
                        </tr>
                      </table>
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
