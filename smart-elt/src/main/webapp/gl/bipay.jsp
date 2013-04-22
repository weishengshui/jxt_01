<%@page import="java.math.RoundingMode"%>
<%@page import="com.tenpay.util.TenpayUtil"%>
<%@page import="com.tenpay.*"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.tenpay.TenpayParameterProvider"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",10,")==-1) 
	response.sendRedirect("main.jsp");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <link href="css/style.css" type="text/css" rel="stylesheet" />
 <script type="text/javascript" src="js/common.js"></script>
 <script type='text/javascript' src='http://union.tenpay.com/bankList/jquery.js'></script>
 <link rel="stylesheet" type="text/css" href="http://union.tenpay.com/bankList/css_col4.css"/>
<script type="text/javascript">
function topay(bh)
{
	var ptype = $("input[name='bank_type']:checked").val();	
	
	if (ptype == "3")
	{
		location.href="bipaysuccess.jsp?bh="+bh+"&pt=3";
	}
	// 财付通支付
	else{
		document.getElementById("tenpayform").submit();
	}
}
function gopay()
{
	document.getElementById("alipayform").submit();
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>
<%
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
Fun fun=new Fun();
ResultSet rs=null;
String strsql="",zzjf="",zzje="",bz="",zzbh="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
String zzsj="";

String requestUrl="";
try
{
  String zzid=request.getParameter("zzid");
  if (zzid!=null && !zzid.equals(""))
  {
  	if (!fun.sqlStrCheck(zzid))
  	{
  		response.sendRedirect("buyintegral.jsp");
	  	return;
  	}
  	strsql="select nid,zzje,zzjf,zzbz,zzbh,zzsj from tbl_jfzz where nid="+zzid;  	
  	rs=stmt.executeQuery(strsql);
  	if (rs.next())
  	{
  		zzbh=rs.getString("zzbh");
  		zzjf=rs.getString("zzjf");
  		zzje=rs.getString("zzje");
  		bz=rs.getString("zzbz");
  		zzsj=sf.format(rs.getDate("zzsj"));		
  		if (bz==null) bz="";
  		rs.close();
  	}
  	else
  	{
  		rs.close();
  		response.sendRedirect("buyintegral.jsp");
	  	return;
  	}
  	
  }
  else
  {
	  zzjf=request.getParameter("zzjf");
	  zzje=request.getParameter("zzje");
	  bz=request.getParameter("bz");
	  
	  if (zzjf==null || zzjf.equals("") || zzje==null || zzje.equals(""))
	  {
	  	response.sendRedirect("buyintegral.jsp");
	  	return;
	  }
	  if (!fun.sqlStrCheck(zzje) || !fun.sqlStrCheck(zzjf) || !fun.sqlStrCheck(bz))
	  {
	  	response.sendRedirect("buyintegral.jsp");
	  	return;
	  }
	  
	  try{
	  	int jf=Integer.valueOf(zzjf);
	  	double je=Double.valueOf(zzje);
	  }
	  catch(Exception en){response.sendRedirect("buyintegral.jsp");
	  	return;}
	  
	  String gmh=request.getParameter("gmh");
	  strsql="select nid from tbl_jfzz where gmh='"+gmh+"'";
	  rs=stmt.executeQuery(strsql);
	  if (rs.next())
	  {
		rs.close();
		out.print("<script type='text/javascript'>");
		out.print("alert('请不要重复提交!');");
		out.print("location.href='buyintegral.jsp';");
		out.print("</script>");
		return;
	  }
	  rs.close();
	  
	  Calendar now=Calendar.getInstance();
	  zzsj=sf.format(now.getTime());
	  strsql="select zzbh from tbl_jfzz where zzsj>='"+sf.format(now.getTime())+"' order by nid desc limit 1";
	  rs=stmt.executeQuery(strsql);
	  if (rs.next())
	  {
	  	zzbh=rs.getString("zzbh");
	  }
	  rs.close();
	  
	  if (zzbh==null || zzbh.equals(""))
	  {
	  	zzbh=sf.format(now.getTime());
	  	zzbh=zzbh.replace("-","")+"1";  	
	  }
	  else
	  {
	  	zzbh=zzbh.substring(0,8)+String.valueOf(Integer.valueOf(zzbh.substring(8))+1);
	  }
	  strsql="insert into tbl_jfzz (zzbh,qy,zzjf,zzje,zzbz,zzr,zzsj,gmh) values('"+zzbh+"',"+session.getAttribute("qy")+","+zzjf+","+zzje+",'"+bz+"',"+session.getAttribute("ygid")+",now(),'"+gmh+"')";
	  
	  stmt.executeUpdate(strsql);
  }
 %>
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local">
					<li class="local-ico1">
						<div class="local-1"><h1>确认购买积分数</h1><h2><%=zzsj%></h2></div>
					</li>
					<li class="local-ico2">
						<div class="local-2"><h1>选择支付方式</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li>
						<div class="local-3"><h1>订单成功</h1></div>
					</li>
				</ul>
				<div class="jfstate">
					<ul class="jfstate-in">
						<li>尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %></li>
						
						<li class="bold">订单<%=zzbh%> 购买 <%=zzjf%>积分，需要支付 <span class="yellowtxt txtsize"><%=zzje%></span> 元</li>
						<li>备注：<%=bz%></li>
					</ul>
				</div>
				
				<div class="bankselect margintop">
					<h1>请选择网上支付平台</h1>
					
					<div id="tenpayBankList"></div>
					<!-- <script>$.getScript("http://union.tenpay.com/bankList/bank.js");</script> -->
					
					<ul class="banklist">
						<!-- <li><span><input name="ptype" id="ptype" type="radio" value="1" /></span><img src="images/zhifubao.jpg" /></li> -->
						<li><span><input name="bank_type" id="bank_type" checked="checked" type="radio" value="2" /></span><img src="images/canfugtong.jpg" /></li>
					</ul>
					
				</div>
				<div class="bankselect margintop">
					<h1>您还可以选择银行转账等方式进行线下支付</h1>
					<ul class="banklist">
						<li><span><input name="bank_type" id="ptype" type="radio" value="3" /></span><img src="images/xianxia.jpg" /></li>
						
					</ul>
				</div>
				
				<form action="tenpayto.jsp" name="tenpayform" id="tenpayform" method="post">
					<input type="hidden" name="zzid" id="zzid" value="<%=zzid%>">
					<input type="hidden" name="zzbh" id="zzbh" value="<%=zzbh%>" /> 
					<input type="hidden" name="subject" id="subject" value="<%=zzbh%>" />
					<input type="hidden" name="total_fee" id="total_fee" value="<%=zzje%>" />
					<input type="hidden" name="alibody" id="alibody" value="<%=session.getAttribute("qymc")%>购买积分订单" />
				</form>
				
				<form action="alipayto.jsp" name="alipayform" id="alipayform" method="post" target="_blank">
				<input type="hidden" name="zzbh" id="zzbh" value="<%=zzbh%>" /> 
				<input type="hidden" name="subject" id="subject" value="<%=zzbh%>" />
				<input type="hidden" name="total_fee" id="total_fee" value="<%=zzje%>" />
				<input type="hidden" name="alibody" id="alibody" value="<%=session.getAttribute("qymc")%>购买积分订单" />
				</form>
				<!-- 立即支付 -->
				<div class="bandbtnbox"><a href="#" onclick="topay(<%=zzbh%>)" class="buybtn"></a></div>
		  </div>
	  	</div>
	</div>
	<%@ include file="footer.jsp" %>
	<%
}
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
