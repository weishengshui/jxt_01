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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("9001")==-1)
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
<script type="text/javascript" src="../gl/js/jquery-1.7.min.js"></script>
<script type="text/javascript">
function saveit()
{
	if(document.getElementById("xm").value=="")
	{
		alert("请填写姓名！");
		return false;
	}
	if(document.getElementById("dlm").value=="")
	{
		alert("请填写登陆账号！");
		return false;
	}
	if(!EmailCheck(document.getElementById("dlm").value))
	{
		alert("登陆账号请使用Email！");
		return false;
	}
	var n=document.getElementsByName("czqxc").length;
	var czqx="";
	for (i=0;i<n;i++)
	{
		if (document.getElementsByName("czqxc")[i].checked)
			czqx=czqx+document.getElementsByName("czqxc")[i].value+","
	}
	
	document.getElementById("czqx").value=czqx;
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}

	function checkall(this_,name){
		var obj = $("."+name);
		for(var i=0;i<obj.length;i++){
			if(this_.checked)
				obj[i].checked = true;
			else
				obj[i].checked = false;
		}
	}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="9001";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String xm="",dlm="",dlmm="",ffmm="",czqx="",bz="";
String glyid=request.getParameter("glyid");
if (glyid==null) glyid="";
if (!fun.sqlStrCheck(glyid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='guanliyuan.jsp';");
	out.print("</script>");
	return;
}
try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{
		xm=request.getParameter("xm");
		dlm=request.getParameter("dlm");
		dlmm=request.getParameter("dlmm");
		ffmm=request.getParameter("ffmm");
		bz=request.getParameter("bz");
		czqx=request.getParameter("czqx");
		if (!fun.sqlStrCheck(xm) || !fun.sqlStrCheck(dlm) || !fun.sqlStrCheck(dlmm) || !fun.sqlStrCheck(ffmm) || !fun.sqlStrCheck(bz) || !fun.sqlStrCheck(czqx))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		if (glyid!=null && glyid.length()>0)
		{
			 strsql="update tbl_xtyh set xm='"+xm+"',dlm='"+dlm+"',bz='"+bz+"',czqx='"+czqx+"' where nid="+glyid;
			 stmt.execute(strsql);
			 response.sendRedirect("guanliyuan.jsp");
		   	  return;
		}
		else
		{
			strsql="insert into tbl_xtyh (xm,dlm,bz,czqx) values('"+xm+"','"+dlm+"','"+bz+"','"+czqx+"')";
			stmt.executeUpdate(strsql);
			response.sendRedirect("guanliyuan.jsp");
	   		return;
		}
	}
	
	if (glyid!=null && glyid.length()>0)
	{
		strsql="select * from tbl_xtyh where nid="+glyid;		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			xm=rs.getString("xm");
			dlm=rs.getString("dlm");
			
			bz=rs.getString("bz");
			czqx=rs.getString("czqx");
			if (bz==null) bz="";
			if (czqx==null) czqx="";
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
            <td><div class="local"><span>系统管理 &gt; 管理员管理 &gt; <%if (glyid!=null && glyid.length()>0) out.print("修改"); else out.print("添加");%></span><a href="guanliyuan.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="guanliyuanbianji.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="glyid" id="glyid" value="<%=glyid%>" />
            		  <input type="hidden" name="czqx" id="czqx" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">姓名：</td>
                          <td><input type="text" name="xm" id="xm" value="<%=xm%>" maxlength="10" class="input3" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>登陆账号：</td>
                          <td><input type="text" name="dlm" id="dlm" class="input3" value="<%=dlm%>" maxlength="50" />&nbsp;请使用Email,要发送初始密码</td>
                        </tr>
                       
                        <tr>
                          <td align="center"></td>
                          <td>权限菜单：</td>
                          <td align="left">
                          		<table width="800" border="0" cellpadding="0" cellspacing="0">
                          			<tr><td colspan="11">
                          				<label style="line-height:12px">
                          					<input type="checkbox" onclick="checkall(this,'qygl')" <%if (czqx.indexOf("1001")>-1 || czqx.indexOf("1002")>-1 || czqx.indexOf("1003")>-1)out.print(" checked='checked'");%> style="vertical-align: top;"/>&nbsp;企业管理
                          				</label>
                          			</td></tr>
                          			<tr>
                          				<td width="10">&nbsp;</td>
                          				<td width="150"><input type="checkbox" class="qygl" name="czqxc" id="czqxc" value="1001" <%if (czqx.indexOf("1001")>-1) out.print(" checked='checked'");%> /> 试用企业管理</td>
                          				<td width="150"><input type="checkbox" class="qygl" name="czqxc" id="czqxc" value="1002" <%if (czqx.indexOf("1002")>-1) out.print(" checked='checked'");%> /> 企业信息管理</td>
                          				<td width="150"><input type="checkbox" class="qygl" name="czqxc" id="czqxc" value="1003" <%if (czqx.indexOf("1003")>-1) out.print(" checked='checked'");%> /> 企业员工管理</td>
                          				<td colspan="2"></td>
                          			</tr>
                          			<tr><td colspan="11">
                          				<label style="line-height:12px">
                          					<input type="checkbox" onclick="checkall(this,'jfgl')" style="vertical-align: top;" <%if (czqx.indexOf("2001")>-1 || czqx.indexOf("2003")>-1 || czqx.indexOf("2002")>-1 || czqx.indexOf("2004")>-1 ||czqx.indexOf("2005")>-1)out.print(" checked='checked'");%>/>&nbsp;积分管理
                          				</label>
                          			</td></tr>
                          			<tr>
                          				<td>&nbsp;</td>
                          				<td><input type="checkbox" class="jfgl" name="czqxc" id="czqxc" value="2001" <%if (czqx.indexOf("2001")>-1) out.print(" checked='checked'");%> /> 在线订单-未支付</td>
                          				<td><input type="checkbox" class="jfgl" name="czqxc" id="czqxc" value="2003"  <%if (czqx.indexOf("2003")>-1) out.print(" checked='checked'");%> /> 在线订单-已支付</td>
                          				<td><input type="checkbox" class="jfgl" name="czqxc" id="czqxc" value="2002"  <%if (czqx.indexOf("2002")>-1) out.print(" checked='checked'");%> /> 线下订单</td>
                          				<td><input type="checkbox" class="jfgl" name="czqxc" id="czqxc"  value="2004" <%if (czqx.indexOf("2004")>-1) out.print(" checked='checked'");%> /> 待充值订单</td>
                          				<td><input type="checkbox" class="jfgl" name="czqxc" id="czqxc"  value="2005" <%if (czqx.indexOf("2005")>-1) out.print(" checked='checked'");%> /> 交易失败订单</td>                          				
                          			</tr>
                          			<tr><td colspan="11">
                          				<label style="line-height:12px">
                          					<input type="checkbox" onclick="checkall(this,'jfqgl')" style="vertical-align: top;" <%if (czqx.indexOf("3001")>-1 ||czqx.indexOf("3002")>-1 || czqx.indexOf("3003")>-1) out.print(" checked='checked'");%>/>&nbsp;福利券管理
                          				</label>
                          			</td></tr>
                          			<tr>
                          				<td>&nbsp;</td>
                          				<td><input type="checkbox" class="jfqgl" name="czqxc" id="czqxc" value="3001" <%if (czqx.indexOf("3001")>-1) out.print(" checked='checked'");%> /> 活动类目管理</td>
                          				<td><input type="checkbox" class="jfqgl" name="czqxc" id="czqxc" value="3002" <%if (czqx.indexOf("3002")>-1) out.print(" checked='checked'");%> /> 福利券活动管理</td>
                          				<td><input type="checkbox" class="jfqgl" name="czqxc" id="czqxc" value="3003" <%if (czqx.indexOf("3003")>-1) out.print(" checked='checked'");%> /> 福利券内容管理</td>                          				                     				
                          				<td colspan="2"></td>
                          			</tr>
                          			
                          			<tr><td colspan="11">
                          				<label style="line-height:12px">
                          					<input type="checkbox" onclick="checkall(this,'spgl')" style="vertical-align: top;" <%if (czqx.indexOf("4004")>-1 || czqx.indexOf("4001")>-1 ||czqx.indexOf("4002")>-1||czqx.indexOf("4005")>-1||czqx.indexOf("4006")>-1||czqx.indexOf("4007")>-1||czqx.indexOf("4008")>-1||czqx.indexOf("4009")>-1) out.print(" checked='checked'");%>/>&nbsp;商品管理
                          				</label>
                          			</td></tr>
                          			<tr>
                          				<td>&nbsp;</td>
                          				<td><input type="checkbox" class="spgl" name="czqxc" id="czqxc" value="4004" <%if (czqx.indexOf("4004")>-1) out.print(" checked='checked'");%> /> 商品类目管理</td>
                          				<td><input type="checkbox" class="spgl" name="czqxc" id="czqxc" value="4001" <%if (czqx.indexOf("4001")>-1) out.print(" checked='checked'");%> /> 商品系列管理</td>
                          				<td><input type="checkbox" class="spgl" name="czqxc" id="czqxc" value="4002" <%if (czqx.indexOf("4002")>-1) out.print(" checked='checked'");%> /> 商品内容管理</td>
                          				<td><input type="checkbox" class="spgl" name="czqxc" id="czqxc" value="4005" <%if (czqx.indexOf("4005")>-1) out.print(" checked='checked'");%> /> 活动管理</td>
                          				<td><input type="checkbox" class="spgl" name="czqxc" id="czqxc" value="4006" <%if (czqx.indexOf("4006")>-1) out.print(" checked='checked'");%> /> 供应商管理</td>
                          			</tr>
                          			<tr>
                          				<td>&nbsp;</td>                        			
                          				<td><input type="checkbox" class="spgl" name="czqxc" id="czqxc" value="4007" <%if (czqx.indexOf("4007")>-1) out.print(" checked='checked'");%> /> 进货管理</td>
                          				<td><input type="checkbox" class="spgl" name="czqxc" id="czqxc" value="4009" <%if (czqx.indexOf("4009")>-1) out.print(" checked='checked'");%> /> 出库管理</td>
                          				<td colspan="5"><input type="checkbox" class="spgl" name="czqxc" id="czqxc" value="4008" <%if (czqx.indexOf("4008")>-1) out.print(" checked='checked'");%> /> 库存查询</td>
                          			</tr>
                          			<tr><td colspan="11">
                          				<label style="line-height:12px">
                          					<input type="checkbox" onclick="checkall(this,'yhdd')" style="vertical-align: top;" <%if (czqx.indexOf("5001")>-1 ||czqx.indexOf("5002")>-1||czqx.indexOf("5003")>-1||czqx.indexOf("5004")>-1) out.print(" checked='checked'");%>/>&nbsp;兑换订单
                          				</label>
                          			</td></tr>
                          			<tr>
                          				<td>&nbsp;</td>
                          				<td><input type="checkbox" class="yhdd" name="czqxc" id="czqxc" value="5001" <%if (czqx.indexOf("5001")>-1) out.print(" checked='checked'");%> /> 未付款订单</td>
                          				<td><input type="checkbox" class="yhdd" name="czqxc" id="czqxc" value="5002" <%if (czqx.indexOf("5002")>-1) out.print(" checked='checked'");%> /> 未发货订单</td>
                          				<td><input type="checkbox" class="yhdd" name="czqxc" id="czqxc" value="5003" <%if (czqx.indexOf("5003")>-1) out.print(" checked='checked'");%> /> 未收货订单</td>
                          				<td><input type="checkbox" class="yhdd" name="czqxc" id="czqxc" value="5004" <%if (czqx.indexOf("5004")>-1) out.print(" checked='checked'");%> /> 已完成订单</td>
                          				<td>&nbsp;</td>
                          			</tr>
                          			
                          			<tr><td colspan="11">
                          				<label style="line-height:12px">
                          					<input type="checkbox" onclick="checkall(this,'xtgl')" style="vertical-align: top;" <%if (czqx.indexOf("9001")>-1||czqx.indexOf("9002")>-1||czqx.indexOf("9003")>-1||czqx.indexOf("9004")>-1) out.print(" checked='checked'");%>/>&nbsp;系统管理
                          				</label>
                          			</td></tr>
                          			<tr>
                          				<td>&nbsp;</td>
                          				<td><input type="checkbox" class="xtgl" name="czqxc" id="czqxc" value="9001" <%if (czqx.indexOf("9001")>-1) out.print(" checked='checked'");%> />  管理员管理</td>
                          				<td><input type="checkbox" class="xtgl" name="czqxc" id="czqxc" value="9002" <%if (czqx.indexOf("9002")>-1) out.print(" checked='checked'");%> /> 奖励名目管理</td>
                          				<td><input type="checkbox" class="xtgl" name="czqxc" id="czqxc" value="9003" <%if (czqx.indexOf("9003")>-1) out.print(" checked='checked'");%> /> 参数设置</td>
                          				<td><input type="checkbox" class="xtgl" name="czqxc" id="czqxc" value="9004" <%if (czqx.indexOf("9004")>-1) out.print(" checked='checked'");%> /> 帮助中心管理</td>                           				                     				
                          				<td><input type="checkbox" class="xtgl" name="czqxc" id="czqxc" value="9005" <%if (czqx.indexOf("9005")>-1) out.print(" checked='checked'");%> /> 发送邮件设置</td> 
                          			</tr>
                          			<tr>
                          				<td>&nbsp;</td>                        			
                          				<td><input type="checkbox" class="xtgl" name="czqxc" id="czqxc" value="9007" <%if (czqx.indexOf("9007")>-1) out.print(" checked='checked'");%> /> 邮箱模板设置</td>
                          				<td colspan="4"><input type="checkbox" class="xtgl" name="czqxc" id="czqxc" value="9006" <%if (czqx.indexOf("9006")>-1) out.print(" checked='checked'");%> /> 企业汇总表</td>
                          			</tr>
                          			</table>
                          </td>
                        </tr>
                        <tr>
                          <td align="center"></td>
                          <td valign="top">备注：</td>
                          <td>
                          	<textarea rows="3" cols="45" name="bz" id="bz"><%=bz%></textarea>
                          </td>
                        </tr>
                        <tr>
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