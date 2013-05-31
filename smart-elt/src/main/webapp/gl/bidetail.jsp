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
if (!isAuth && !isLeader) 
	response.sendRedirect("main.jsp");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
Fun fun=new Fun();
ResultSet rs=null;
String strsql="";
try
{
  
  String zzid=request.getParameter("zzid");
 
  if (zzid==null || !fun.sqlStrCheck(zzid))
  {
  	response.sendRedirect("buyintegral.jsp");
  	return;
  }
  
  SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
  strsql="select z.nid,z.zzbh,z.zzjf,z.zzje,z.dzjf,z.zzzt,z.zzbz,z.zzsj,z.fksj,y.ygxm,y.lxdh from tbl_jfzz z left join tbl_qyyg y on z.zzr=y.nid where z.nid="+zzid;
  rs=stmt.executeQuery(strsql);
  if (rs.next())
  {
 %>
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local">
					<li class="local-ico1">
						<div class="local-1"><h1>确认购买积分数</h1><h2><%=sf.format(rs.getDate("zzsj"))%></h2></div>
					</li>
					<li class="local-ico2">
						<div class="local-2"><h1>选择支付方式</h1><h2><%if (rs.getDate("fksj")!=null) out.print(sf.format(rs.getDate("fksj")));%></h2></div>
					</li>
					<li>	
						<div class="local-3"><h1>订单成功</h1><%if (rs.getDate("fksj")!=null) out.print(sf.format(rs.getDate("fksj")));%></div>
					</li>
				</ul>
				<div class="order-ico"></div>
				<div class="orderdetail">
					<h1>当前订单状态：<%
					if (rs.getInt("zzzt")==0)
						out.print("未付款");
					if (rs.getInt("zzzt")==1)
						out.print("完成支付");
					if (rs.getInt("zzzt")==2)
						out.print("线下支付");
					if (rs.getInt("zzzt")==3)
						out.print("交易成功");
					if (rs.getInt("zzzt")==-1 || rs.getInt("zzzt")==-2)
						out.print("已取消");	
							%></h1>
					<ul class="currentstate">
						<li>
							<dl><dt>订单号：</dt><dd><%=rs.getString("zzbh") %></dd></dl>
							<dl><dt>下单日期：</dt><dd><%=sf.format(rs.getDate("zzsj"))%></dd></dl>
						</li>
						<li>
							<dl><dt>购买积分：</dt><dd><%=rs.getInt("zzjf") %>分</dd></dl>
							<dl><dt>应支付金额：</dt><dd><%=rs.getInt("zzje") %>元</dd></dl>
							<dl><dt>优惠：</dt><dd><%if (rs.getInt("dzjf")>0) out.print(rs.getDouble("dzjf")/10-rs.getDouble("zzje")); else out.print("0"); %>元</dd></dl>
						</li>
						<li class="margintop">
							<dl><dt>到账积分：</dt><dd><span class="yellowtxt"><%=rs.getInt("dzjf") %></span> 分</dd></dl>
						</li>
						<li>
							<dl><dt>备注信息：</dt><dd><%=rs.getString("zzbz") %></dd></dl>
						</li>
					</ul>
					<div class="statebtnbox"><%if (rs.getInt("zzzt")==0) {%><a href="bipay.jsp?zzid=<%=rs.getString("nid")%>" class="ljfkbtn"></a><%} %><a href="#" class="backbtn" onclick="javascript:history.back(-1);"></a></div>
					<div class="other">
						<h2>其他信息：</h2>
						<ul>
							<li><span>企业名称：<%=session.getAttribute("qymc") %></span><span>企业账户：<%=session.getAttribute("email") %></span></li>
							<li><span>操作人：<%=rs.getString("ygxm") %></span><span>操作人电话：<%=rs.getString("lxdh") %></span></li>
						</ul>
					</div>
				</div>
			</div>
	  	</div>
	</div>
	<%}
	rs.close();
	%>
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
