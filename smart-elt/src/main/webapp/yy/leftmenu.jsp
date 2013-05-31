<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
if (menun!=null && menun.substring(0,2).equals("10"))
{
	out.print("<div class='lefttop'><span>企业管理</span></div><ul class='leftlist'>");
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("1001")>-1)
	{
		if (menun!=null && menun.equals("1001"))
			out.print("<li class=\"current\"><a href=\"shiyongqiye.jsp\">试用企业管理</a></li>");
		else
			out.print("<li><a href=\"shiyongqiye.jsp\">试用企业管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("1002")>-1)
	{
		if (menun!=null && menun.equals("1002"))
			out.print("<li class=\"current\"><a href=\"qiyexinxi.jsp\">企业信息管理</a></li>");
		else
			out.print("<li><a href=\"qiyexinxi.jsp\">企业信息管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("1003")>-1)
	{
		if (menun!=null && menun.equals("1003"))
			out.print("<li class=\"current\"><a href=\"qiyeyuangong.jsp\">企业员工管理</a></li>");
		else
			out.print("<li><a href=\"qiyeyuangong.jsp\">企业员工管理</a></li>");
	}
}

if (menun!=null && menun.substring(0,2).equals("20"))
{
	out.print("<div class='lefttop'><span>积分管理</span></div><ul class='leftlist'>");
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("2001")>-1)
	{
		if (menun!=null && menun.equals("2001"))
			out.print("<li class=\"current\"><a href=\"zzweifukuan.jsp\">在线订单-未支付</a></li>");
		else
			out.print("<li><a href=\"zzweifukuan.jsp\">在线订单-未支付</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("2003")>-1)
	{
		if (menun!=null && menun.equals("2003"))
			out.print("<li class=\"current\"><a href=\"zzzaixianfukuan.jsp\">在线订单-已支付</a></li>");
		else
			out.print("<li><a href=\"zzzaixianfukuan.jsp\">在线订单-已支付</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("2002")>-1)
	{
		if (menun!=null && menun.equals("2002"))
			out.print("<li class=\"current\"><a href=\"zzxianxiafukuan.jsp\">线下订单</a></li>");
		else
			out.print("<li><a href=\"zzxianxiafukuan.jsp\">线下订单</a></li>");
	}
	
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("2004")>-1)
	{
		if (menun!=null && menun.equals("2004"))
			out.print("<li class=\"current\"><a href=\"zzchenggong.jsp\">待充值订单</a></li>");
		else
			out.print("<li><a href=\"zzchenggong.jsp\">待充值订单</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("2005")>-1)
	{
		if (menun!=null && menun.equals("2005"))
			out.print("<li class=\"current\"><a href=\"zzshibai.jsp\">交易失败订单</a></li>");
		else
			out.print("<li><a href=\"zzshibai.jsp\">交易失败订单</a></li>");
	}
}

if (menun!=null && menun.substring(0,2).equals("30"))
{
	out.print("<div class='lefttop'><span>福利券管理</span></div><ul class='leftlist'>");
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("3001")>-1)
	{
		if (menun!=null && menun.equals("3001"))
			out.print("<li class=\"current\"><a href=\"huodongleimu.jsp\">活动类目管理</a></li>");
		else
			out.print("<li><a href=\"huodongleimu.jsp\">活动类目管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("3002")>-1)
	{
		if (menun!=null && menun.equals("3002"))
			out.print("<li class=\"current\"><a href=\"jifenjuanhuodong.jsp\">福利券活动管理</a></li>");
		else
			out.print("<li><a href=\"jifenjuanhuodong.jsp\">福利券活动管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("3003")>-1)
	{
		if (menun!=null && menun.equals("3003"))
			out.print("<li class=\"current\"><a href=\"jifenjuan.jsp\">福利券内容管理</a></li>");
		else
			out.print("<li><a href=\"jifenjuan.jsp\">福利券内容管理</a></li>");
	}
	
}



if (menun!=null && menun.substring(0,2).equals("40"))
{
	out.print("<div class='lefttop'><span>商品管理</span></div><ul class='leftlist'>");
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("4004")>-1)
	{
		if (menun!=null && menun.equals("4004"))
			out.print("<li class=\"current\"><a href=\"splbgl.jsp\">商品类目管理</a></li>");
		else
			out.print("<li><a href=\"splbgl.jsp\">商品类目管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("4001")>-1)
	{
		if (menun!=null && menun.equals("4001"))
			out.print("<li class=\"current\"><a href=\"spxlgl.jsp\">商品系列管理</a></li>");
		else
			out.print("<li><a href=\"spxlgl.jsp\">商品系列管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("4002")>-1)
	{
		if (menun!=null && menun.equals("4002"))
			out.print("<li class=\"current\"><a href=\"spnrgl.jsp\">商品内容管理</a></li>");
		else
			out.print("<li><a href=\"spnrgl.jsp\">商品内容管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("4005")>-1)
	{
		if (menun!=null && menun.equals("4005"))
			out.print("<li class=\"current\"><a href=\"sphdgl.jsp\">活动管理</a></li>");
		else
			out.print("<li><a href=\"sphdgl.jsp\">活动管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("4006")>-1)
	{
		if (menun!=null && menun.equals("4006"))
			out.print("<li class=\"current\"><a href=\"spgysgl.jsp\">供应商管理</a></li>");
		else
			out.print("<li><a href=\"spgysgl.jsp\">供应商管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("4007")>-1)
	{
		if (menun!=null && menun.equals("4007"))
			out.print("<li class=\"current\"><a href=\"spjhgl.jsp\">进货管理</a></li>");
		else
			out.print("<li><a href=\"spjhgl.jsp\">进货管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("4009")>-1)
	{
		if (menun!=null && menun.equals("4009"))
			out.print("<li class=\"current\"><a href=\"spckgl.jsp\">出库管理</a></li>");
		else
			out.print("<li><a href=\"spckgl.jsp\">出库管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("4008")>-1)
	{
		if (menun!=null && menun.equals("4008"))
			out.print("<li class=\"current\"><a href=\"spkccx.jsp\">库存查询</a></li>");
		else
			out.print("<li><a href=\"spkccx.jsp\">库存查询</a></li>");
	}
}
if (menun!=null && menun.substring(0,2).equals("50"))
{
	out.print("<div class='lefttop'><span>兑换订单</span></div><ul class='leftlist'>");
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("5001")>-1)
	{
		if (menun!=null && menun.equals("5001"))
			out.print("<li class=\"current\"><a href=\"spwfkd.jsp\">未付款单</a></li>");
		else
			out.print("<li><a href=\"spwfkd.jsp\">未付款单</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("5002")>-1)
	{
		if (menun!=null && menun.equals("5002"))
			out.print("<li class=\"current\"><a href=\"spwfhd.jsp\">未发货单</a></li>");
		else
			out.print("<li><a href=\"spwfhd.jsp\">未发货单</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("5003")>-1)
	{
		if (menun!=null && menun.equals("5003"))
			out.print("<li class=\"current\"><a href=\"spwshd.jsp\">未收货单</a></li>");
		else
			out.print("<li><a href=\"spwshd.jsp\">未收货单</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("5004")>-1)
	{
		if (menun!=null && menun.equals("5004"))
			out.print("<li class=\"current\"><a href=\"spywcd.jsp\">已完成订单</a></li>");
		else
			out.print("<li><a href=\"spywcd.jsp\">已完成订单</a></li>");
	}
	
}





if (menun!=null && menun.substring(0,2).equals("90"))
{
	out.print("<div class='lefttop'><span>系统管理</span></div><ul class='leftlist'>");
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("9001")>-1)
	{
		if (menun!=null && menun.equals("9001"))
			out.print("<li class=\"current\"><a href=\"guanliyuan.jsp\">管理员管理</a></li>");
		else
			out.print("<li><a href=\"guanliyuan.jsp\">管理员管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("9002")>-1)
	{
		if (menun!=null && menun.equals("9002"))
			out.print("<li class=\"current\"><a href=\"jianglimingmu.jsp\">奖励名目管理</a></li>");
		else
			out.print("<li><a href=\"jianglimingmu.jsp\">奖励名目管理</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("9003")>-1)
	{
		if (menun!=null && menun.equals("9003"))
			out.print("<li class=\"current\"><a href=\"sysconfig.jsp\">参数设置</a></li>");
		else
			out.print("<li><a href=\"sysconfig.jsp\">参数设置</a></li>");
	}
	
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("9004")>-1)
	{
		if (menun!=null && menun.equals("9004"))
			out.print("<li class=\"current\"><a href=\"helpgl.jsp\">帮助中心管理</a></li>");
		else
			out.print("<li><a href=\"helpgl.jsp\">帮助中心管理</a></li>");
	}
	
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("9005")>-1)
	{
		if (menun!=null && menun.equals("9005"))
			out.print("<li class=\"current\"><a href=\"emailconfig.jsp\">发送邮件设置</a></li>");
		else
			out.print("<li><a href=\"emailconfig.jsp\">发送邮件设置</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("9007")>-1)
	{
		if (menun!=null && menun.equals("9007"))
			out.print("<li class=\"current\"><a href=\"emailTemplate.jsp\">邮件模板设置</a></li>");
		else
			out.print("<li><a href=\"emailTemplate.jsp\">邮件模板设置</a></li>");
	}
	if (session.getAttribute("xtczqx")!=null && session.getAttribute("xtczqx").toString().indexOf("9006")>-1)
	{
		if (menun!=null && menun.equals("9006"))
			out.print("<li class=\"current\"><a href=\"entreport.jsp\">企业汇总表</a></li>");
		else
			out.print("<li><a href=\"entreport.jsp\">企业汇总表</a></li>");
	}
}
%>
