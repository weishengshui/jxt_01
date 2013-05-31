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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("5002")==-1)
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
<script type="text/javascript">
function saveit()
{
	if(document.getElementById("ydh").value=="")
	{
		alert("请填写运单号！");
		return false;
	}
	if(document.getElementById("gysid").value=="")
	{
		alert("请选择物流公司！");
		return false;
	}
	if(document.getElementById("fhr").value=="")
	{
		alert("请填写发货人！");
		return false;
	}
	if(document.getElementById("fhrdh").value=="")
	{
		alert("请填写发货人电话！");
		return false;
	}
	if (!CheckNumber(document.getElementById("fhrdh").value))
	{
		alert("发货人电话格式不正确！");
		return false;
	}
	
	
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}


function selgys()
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "selectgys.jsp?gtype=2&time="+timeParam;	
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
function sgysagain(p)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "getgyslist.jsp?pno="+p+"&gtype=2&sgysmc="+encodeURI(escape(document.getElementById("sgysmc").value))+"&slxr="+encodeURI(escape(document.getElementById("slxr").value))+"&time="+timeParam;		
	
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

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>
<%
String  menun="5002";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String ydh="",fhr="",fhrdh="",gysmc="",gysid="";
String did=request.getParameter("did");
if (did==null) did="";
if (!fun.sqlStrCheck(did))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='spwfhd.jsp';");
	out.print("</script>");
	return;
}

String ddh="",shdzxx="",ddbz="",qymc="",ygxm="",cjrq="",zje="0",zjf="0",jfqsl="0",jsrq="",fhrq="",shrq="",qsrq="";
int spn=0;
try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{
		ydh=request.getParameter("ydh");
		fhr=request.getParameter("fhr");
		fhrdh=request.getParameter("fhrdh");
		gysid=request.getParameter("gysid");
		if (!fun.sqlStrCheck(did) || !fun.sqlStrCheck(ydh) || !fun.sqlStrCheck(fhr) || !fun.sqlStrCheck(fhrdh)|| !fun.sqlStrCheck(gysid))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		if (did!=null && did.length()>0)
		{
			 strsql="update tbl_ygddzb set ydh='"+ydh+"',fhr='"+fhr+"',fhrdh='"+fhrdh+"',fhrq=now(),state=2,gys="+gysid+" where nid="+did;
			 stmt.execute(strsql);
			 
			 strsql="update tbl_ygddmx set state=2 where dd="+did;
			 stmt.executeUpdate(strsql);
			 
			 response.sendRedirect("spwfhd.jsp");
		   	  return;
		}
		
	}
	
	strsql="select d.cjrq,d.ddh,d.shdzxx,d.ddbz,d.zje,d.zjf,d.jfqsl,d.jsrq,d.fhrq,d.shrq,d.qsrq,y.ygxm,q.qymc from tbl_ygddzb d inner join tbl_qyyg y on d.yg=y.nid inner join tbl_qy q on y.qy=q.nid where d.nid="+did;
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{
		ddh=rs.getString("ddh");
		shdzxx=rs.getString("shdzxx");
		ddbz=rs.getString("ddbz");
		qymc=rs.getString("qymc");
		ygxm=rs.getString("ygxm");
		cjrq=sf.format(rs.getTimestamp("cjrq"));
		zje=rs.getString("zje");
		zjf=rs.getString("zjf");
		jfqsl=rs.getString("jfqsl");
		jsrq=rs.getString("jsrq")==null?"":sf.format(rs.getTimestamp("jsrq"));
		fhrq=rs.getString("fhrq")==null?"":sf.format(rs.getTimestamp("fhrq"));
		qsrq=rs.getString("qsrq")==null?"":sf.format(rs.getTimestamp("qsrq"));
		shrq=rs.getString("shrq")==null?"":sf.format(rs.getTimestamp("shrq"));
	}
	rs.close();
	
	
	
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
            <td><div class="local"><span>订单管理 &gt; 未发货单管理 </span><a href="spwfhd.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px"> 
            
            <table width="980" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr><td>订单号：<span style="font-size: 14px;color: red"><%=ddh%></span>&nbsp;生成日期：<%=cjrq%><%if (!jsrq.equals("")) out.print("&nbsp;&nbsp;付款日期："+jsrq); %><%if (!fhrq.equals("")) out.print("&nbsp;&nbsp;发货日期："+fhrq); %>
	<%if (!qsrq.equals("")) out.print("&nbsp;&nbsp;签收日期："+qsrq); %><%if (!shrq.equals("") && qsrq.equals("")) out.print("&nbsp;&nbsp;确认日期："+shrq); %></td></tr>
	<tr><td>
		<table width="100%" style="border: 1px #CCCCCC solid;" cellpadding="0" cellspacing="0">
			<tr><td style="height: 30px;background-color: #F6F6F6; font-size: 14px; font-weight: bold;">　购买人信息</td></tr>
			<tr><td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td width="300">　所在企业：<%=qymc%></td><td width="100">姓名：<%=ygxm%></td><td></td></tr>
				</table>
			</td></tr>
			<tr><td style="height: 30px;background-color: #F6F6F6; font-size: 14px; font-weight: bold;">　收件人信息</td></tr>
			<tr><td>　<%=shdzxx%></td></tr>
			<tr><td style="height: 30px;background-color: #F6F6F6; font-size: 14px; font-weight: bold;">　订单备注</td></tr>
			<tr><td>　<%=ddbz%>&nbsp;</td></tr>
			<tr><td style="height: 30px;background-color: #F6F6F6; font-size: 14px; font-weight: bold;">　商品信息</td></tr>
			<tr><td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td>&nbsp;商品编号</td><td>商品名称</td><td>商品数量</td><td>小计</td></tr>
					<%
					strsql="select d.sl,d.jf,d.je,d.jfq,s.spbh,s.spmc,t.lj,j.mc from tbl_ygddmx d inner join tbl_sp s on d.sp=s.nid left join tbl_sptp t on s.zstp=t.nid left join tbl_jfq j on d.jfq=j.nid where d.dd="+did;
					rs=stmt.executeQuery(strsql);
					while(rs.next())
					{
						out.print("<tr><td>&nbsp;"+rs.getString("spbh")+"</td><td><img src='../"+rs.getString("lj")+"60x60.jpg'>"+rs.getString("spmc")+"</td><td>"+rs.getString("sl")+"</td>");
						if (rs.getString("jfq")!=null)
						{
							out.print("<td>"+rs.getString("mc")+"X"+rs.getString("sl")+"</td>");
						}
						else
						{
							out.print("<td>"+rs.getString("jf")+"</td>");
						}
						out.print("</tr>");
						spn+=rs.getInt("sl");
					}
					rs.close();
					%>
					<tr><td colspan="11" align="right">产品数量总计：<%=spn%>件&nbsp;&nbsp;消耗福利券总计：<%=jfqsl==null?"0":jfqsl%>&nbsp;&nbsp;消耗积分总计：<%=zjf==null?"0":zjf%>&nbsp;&nbsp;商品金额总额：<%=zje==null?"0":zje%>￥&nbsp;&nbsp;</td></tr>
				</table>
			</td></tr>
		</table>
	</td></tr>
</table>
          
            	<form action="spwfhdbianji.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="did" id="did" value="<%=did%>" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">运单号：</td>
                          <td><input type="text" name="ydh" id="ydh" value="<%=ydh%>" maxlength="25" class="input3" /></td>
                        </tr>
                         <tr>
		                      <td align="center"><span class="star">*</span></td>
		                      <td>物流公司：</td>
		                      <td><input type="hidden" name="gysid" id="gysid" value="<%=gysid%>" /><input type="text" class="input3" name="gysmc" id="gysmc" readonly="readonly"  value="<%=gysmc%>" /><input type="button" value="选择"  onclick="selgys()" />		                      
		                      </td>
		                   </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>发货人：</td>
                          <td><input type="text" name="fhr" id="fhr" value="<%=fhr%>" maxlength="10" class="input3" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>发货人电话：</td>
                          <td><input type="text" name="fhrdh" id="fhrdh" value="<%=fhrdh%>" maxlength="25" class="input3" /></td>
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