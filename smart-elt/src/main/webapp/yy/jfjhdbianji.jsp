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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("3002")==-1)
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
	if(document.getElementById("hdmc").value=="")
	{
		alert("请填写活动名称！");
		return false;
	}
	if(document.getElementById("lm").value=="")
	{
		alert("请选择所属类目！");
		return false;
	}
	if(document.getElementById("kssj").value=="")
	{
		alert("请填写活动开始日期！");
		return false;
	}
	if(document.getElementById("jssj").value=="")
	{
		alert("请填写活动结束日期！");
		return false;
	}
	if(!document.getElementById("imghdtp") && document.getElementById("hdtp").value=="")
	{
		alert("活动小图片不能为空！");
		return false;
	}
	if(!document.getElementById("imghdtp2") && document.getElementById("hdtp2").value=="")
	{
		alert("活动大图片不能为空！");
		return false;
	}
	
	
	document.getElementById("cform").submit();
}

function showtjs()
{
	
	if (document.getElementById("lm").value!="")
	{
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "gethdtjs.jsp?lmid="+document.getElementById("lm").value+"&time="+timeParam;
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=showcon;
		xmlHttp.send(null);
	}
}

function showcon()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			document.getElementById("tjs").innerHTML=response;
		}
		catch(exception){}
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="3002";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
String hdmc="",hdtp="",kssj="",jssj="",zxjf="",lm="",tj="0",hdtp2="";
String hdid=request.getParameter("hdid");
String naction=request.getParameter("naction");
if (hdid==null) hdid="";
if (!fun.sqlStrCheck(hdid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='jifenjuanhuodong.jsp';");
	out.print("</script>");
	return;
}
try{
	
	
	if (hdid!=null && hdid.length()>0)
	{
		strsql="select * from tbl_jfqhd where nid="+hdid;		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			hdmc=rs.getString("hdmc");
			hdtp=rs.getString("hdtp");
			kssj=sf.format(rs.getDate("kssj"));
			jssj=sf.format(rs.getDate("jssj"));			
			lm=rs.getString("lm");
			tj=rs.getString("tj");
			hdtp2=rs.getString("hdtp2");
			
			
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
            <td><div class="local"><span>福利券管理 &gt; 活动管理 &gt; <%if (hdid!=null && hdid.length()>0) out.print("修改活动"); else out.print("添加活动");%></span><a href="jifenjuanhuodong.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="jfjhdsave.jsp" enctype="multipart/form-data" name="cform" id="cform" method="post">            		  
            		  <input type="hidden" name="hdid" id="hdid" value="<%=hdid%>" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">活动名称：</td>
                          <td><input type="text" name="hdmc" id="hdmc" value="<%=hdmc%>" maxlength="50" class="input3" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>所属类目：</td>
                          <td>
                            <select name="lm" id="lm" onchange="showtjs()"><option value="">请选择</option>
							<%
							strsql="select nid,lmmc from tbl_jfqlm where sfxs=1 order by xswz desc";
							rs=stmt.executeQuery(strsql);
							while(rs.next())
							{
								out.print("<option value='"+rs.getString("nid")+"'");
								if (lm!=null && rs.getString("nid").equals(lm))
									out.print(" selected='selected'");
								out.print(">"+rs.getString("lmmc")+"</option>");
							}
							rs.close();
							%>
							</select>
                          </td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>活动开始时间：</td>
                          <td><input type="text" name="kssj" id="kssj" class="input3" value="<%=kssj%>" maxlength="25" onclick="new Calendar().show(this);" readonly="readonly" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>活动结束时间：</td>
                          <td><input type="text" name="jssj" id="jssj" class="input3" value="<%=jssj%>" maxlength="25" onclick="new Calendar().show(this);" readonly="readonly" /></td>
                        </tr>
                        
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>是否推荐：</td>
                          <td><input type="radio" name="tj" id="tj" value="1" <%if (tj.equals("1")) out.print("checked='checked'"); %> />是 　　<input type="radio" name="tj" id="tj" value="0" <%if (tj.equals("0")) out.print("checked='checked'"); %> />否&nbsp;&nbsp;<span id="tjs"></span></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>活动小图片：</td>
                          <td><input type="file"  name="hdtp" id="hdtp" />
  							<%if (hdtp!=null && !hdtp.equals("")){%><br/><img id="imghdtp" name="imghdtp" src="<%="../hdimg\\"+hdtp%>" width="197" hspace="147" /><%} %> &nbsp;&nbsp;大小为197*147,格式使用jpg、gif</td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>活动大图片：</td>
                          <td><input type="file"  name="hdtp2" id="hdtp2" />
  							<%if (hdtp2!=null && !hdtp2.equals("")){%><br/><img id="imghdtp2" src="<%="../hdimg\\"+hdtp2%>" width="100" hspace="100" /><%} %> &nbsp;&nbsp;大小为992*320,格式使用jpg、gif</td>
                        </tr>
                        <%if (naction==null || !naction.equals("see")) {%>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="#" class="reset"></a></span></td>
                        </tr>
                        <%} %>
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