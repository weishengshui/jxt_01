<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
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
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>

<body>
<%
menun=2;
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
%>
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local">
					<li class="local-ico2">
						<div class="local3-1"><h1>确认购买积分数</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li class="local-ico3">
						<div class="local3-2"><h1>选择支付方式</h1></div>
					</li>
					<li>
						<div class="local3-3"><h1>订单成功</h1></div>
					</li>
				</ul>
				<div class="gsjf-states">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %></div>
				<form name="buyform" id="buyform" action="bipay.jsp" method="post">
				<input type="hidden" name="gmh" id="gmh"  value="<%=session.getAttribute("ygid").toString()+String.valueOf(Calendar.getInstance().getTimeInMillis())%>"/>
				<ul class="gs-states">
					<li>
						<dl>
							<dt>企业名称：</dt>
							<dd class="grey"><%=session.getAttribute("qymc")%></dd>
						</dl>
						<dl>
							<dt>企业账户：</dt>
							<dd class="grey"><%=session.getAttribute("email")%></dd>
						</dl>
					</li>
					<li>
						<dl>
							<dt>支付金额：</dt>
							<dd><input type="hidden" name="zzje" id="zzje" value="<%=request.getParameter("zzje") %>" /><%=request.getParameter("zzje") %> 元 （￥<span class="yellow2">1.00</span>元 = <span class="yellow2">10</span>个积分）</dd>
						</dl>
					</li>
					<li>
						<dl>
							<dt>购买积分：</dt>
							<dd><input type="hidden" name="zzjf" id="zzjf" value="<%=request.getParameter("zzjf") %>" /><%=request.getParameter("zzjf") %> 积分</dd>
						</dl>
					</li>
					
					<li>
						<dl>
							<dt>操 作 人：</dt>
							<dd><%=request.getParameter("zzr") %></dd>
						</dl>
					</li>
					<li>
						<dl>
							<dt>联系电话：</dt>
							<dd><%=request.getParameter("lxdh") %></dd>
						</dl>
					</li>
					<li>
						<dl>
							<dt>备　　注：</dt>
							<dd>
							<input type="hidden" name="bz" id="bz" value="<%=request.getParameter("bz") %>" /><%=request.getParameter("bz") %></dd>
						</dl>
					</li>
				</ul>
				</form>
				<div class="querenbox"><span class="floatleft"><a href="#" class="querenbtn" onclick="javascript:document.getElementById('buyform').submit();"></a></span><span class="modify"><a href="#" onclick="javascript:history.back(-1);">修改订单</a></span></div>
		  </div>
	  	</div>
	</div>
	<%@ include file="footer.jsp" %>
</body>
</html>
