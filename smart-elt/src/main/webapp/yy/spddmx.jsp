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
<%
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("500")==-1)
{
	out.print("你没有操作权限！");
	return;
}

Fun fun=new Fun();
String did=request.getParameter("did");
String naction=request.getParameter("naction");

if (!fun.sqlStrCheck(did))
{	
	
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
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String ddh="",shdzxx="",ddbz="",qymc="",ygxm="",cjrq="",zje="0",zjf="0",jfqsl="0",jsrq="",fhrq="",shrq="",qsrq="",ydh="",fhr="",fhrdh="",gysmc="";
int spn=0;

try{
	strsql="select d.cjrq,d.ddh,d.shdzxx,d.ddbz,d.zje,d.zjf,d.jfqsl,d.jsrq,d.fhrq,d.shrq,d.qsrq,d.ydh,d.fhr,d.fhrdh,y.ygxm,q.qymc,g.gysmc from tbl_ygddzb d inner join tbl_qyyg y on d.yg=y.nid inner join tbl_qy q on y.qy=q.nid left join tbl_spgys g on d.gys=g.nid where d.nid="+did;
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
		ydh=rs.getString("ydh");
		fhr=rs.getString("fhr");
		fhrdh=rs.getString("fhrdh");
		gysmc=rs.getString("gysmc");
	}
	rs.close();
%>
<table width="980" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr><td>订单号：<span style="font-size: 14px;color: red"><%=ddh%></span>&nbsp;生成时间：<%=cjrq%><%if (!jsrq.equals("")) out.print("&nbsp;&nbsp;付款时间："+jsrq); %><%if (!fhrq.equals("")) out.print("&nbsp;&nbsp;发货时间："+fhrq); %>
	<%if (!qsrq.equals("")) out.print("&nbsp;&nbsp;签收时间："+qsrq); %><%if (!shrq.equals("") && qsrq.equals("")) out.print("&nbsp;&nbsp;确认时间："+shrq); %></td></tr>
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
			<%if (ydh!=null && ydh.length()>0) {%>
			<tr><td style="height: 30px;background-color: #F6F6F6; font-size: 14px; font-weight: bold;">　物流信息</td></tr>
			<tr><td>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td width="150">　运单号：<%=ydh%></td><td width="150">物流公司：<%=gysmc%></td><td width="150">发货人：<%=fhr%></td><td width="150">发货人电话：<%=fhrdh%></td><td></td></tr>
				</table>
			</td></tr>
			<%} %>
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
							out.print("<td>"+rs.getString("jf")+"积分</td>");
						}
						out.print("</tr>");
						spn+=rs.getInt("sl");
					}
					rs.close();
					%>
					<tr><td colspan="11" align="right">产品数量总计：<%=spn%>件&nbsp;&nbsp;消耗福利券总计：<%=jfqsl==null?"0":jfqsl%>&nbsp;&nbsp;消耗积分总计：<%=zjf==null?"0":zjf%>&nbsp;&nbsp;商品金额总额：￥<%=zje==null?"0":zje%>&nbsp;&nbsp;</td></tr>
				</table>
			</td></tr>
		</table>
	</td></tr>
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