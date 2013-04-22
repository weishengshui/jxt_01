<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.omg.CORBA.INTERNAL"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/select2css.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/calendar3.js"></script>
<script type="text/javascript">

function cancleit(id)
{
	if (confirm("确认要取消此订单！ "))
	{
		var timeParam = Math.round(new Date().getTime()/1000);
		var url = "getwolist.jsp?did="+id+"&time="+timeParam;			
		xmlHttp.open("GET", url, true);
		xmlHttp.onreadystatechange=showlist;
		xmlHttp.send(null);
	}
}
function showlist()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			document.getElementById("wolist").innerHTML=response;
		}
		catch(exception){}
	}
}

function showwolist(p)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "getwolist.jsp?pno="+p+"&sddsj="+document.getElementById("sddsj").value+"&eddsj="+document.getElementById("eddsj").value+"&ddzt="+document.getElementById("ddzt").value+"&time="+timeParam;	
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlist;
	xmlHttp.send(null);
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
Fun fun=new Fun();
ResultSet rs=null;
String strsql="";

try{

%>
	<%@ include file="head.jsp" %>
	<div id="main">
		<div class="main2">
			<div class="jifeng-t"><span class="floatleft txtsize14">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %>&nbsp;&nbsp;&nbsp;&nbsp;<a href="buyintegral.jsp">立即充值&gt;&gt;</a></span><span class="jifeng-t-r"></span></div>
			<div class="jfqcaxun">
				<span class="jfcaxun-t">积分券购买记录</span>
				
				<input type="hidden" name="pno" id="pno" />				
				<div class="jfcaxun-r">
					<span>根据购买时间：</span>
					<div class="floatleft"><input type="text" class="input6" name="sddsj" id="sddsj" onclick="new Calendar().show(this);" readonly="readonly" /></div>
					<span>&nbsp;-&nbsp;</span>
					<div class="floatleft"><input type="text" class="input6" name="eddsj" id="eddsj" onclick="new Calendar().show(this);" readonly="readonly" /></div>
					<span>状态：</span>
					<div class="floatleft" style="margin-top: 5px;">
						<div id="tm2008style">
						<select name="ddzt" id="ddzt">
							<option value="">所有</option>
							<option value="1">交易成功</option>
							<option value="0">未付款</option>
						</select>
						</div>
					</div>
					<div class="floatleft"><a href="#" class="caxun" onclick="showwolist(1)">查 询</a></div>
				</div>
				
			</div>
			<div class="order" id="wolist">
				<div class="order-t">
					<div class="order1">购买日期</div>
					<div class="order2">订单号</div>					
					<div class="order4">数量(张)</div>
					<div class="order5">金额(积分)</div>
					<div class="order6">状态</div>
					<div class="order7"></div>
				</div>
				<ul class="orderin">
					<%
					int ln=0,pages=1;
					SimpleDateFormat sf=new SimpleDateFormat("yyy-MM-dd");
					strsql="select count(*) as hn from tbl_jfqdd where qy="+session.getAttribute("qy");					
					rs=stmt.executeQuery(strsql);
					if (rs.next())
					{
					ln=rs.getInt("hn");
					}
					rs.close();
					pages=(ln-1)/10+1;
					
					strsql="select nid,ddsj,ddbh,ddsl,ddjf,zt from tbl_jfqdd where qy="+session.getAttribute("qy");					
					strsql+=" order by nid desc limit 10";
					rs=stmt.executeQuery(strsql);
					while (rs.next())
						{
						%>
						<li>
							<div class="orderin1"><%=sf.format(rs.getDate("ddsj"))%></div>
							<div class="orderin2"><a href="bworder.jsp?ddid=<%=rs.getString("nid")%>"><%=rs.getString("ddbh")%></a></div>
												
							<div class="orderin4"><%=rs.getString("ddsl")%></div>
							<div class="orderin5"><%=rs.getString("ddjf")%></div>
							<div class="orderin6"><%if (rs.getInt("zt")==1) out.print("交易成功"); if (rs.getInt("zt")==0) out.print("未付款 ");  if (rs.getInt("zt")==-1) out.print("已取消 "); %></div>
							<div class="orderin7"><%if (rs.getInt("zt")==0) {%><span class="floatleft"><a href="bwpay.jsp?jid=<%=rs.getString("nid")%>" class="gopay"></a></span><span class="cancletxt"><a href="#" onclick="cancleit(<%=rs.getString("nid")%>)">取消</a></span><%} %></div>
						</li>
						<%	
						}
					rs.close();
					 %>
					
				</ul>
				<div class="pages">
					<div class="pages-l">
					<%for (int i=1;i<=pages;i++) {
					%>
					<a href="javascript:void(0);" <%if (i==1) out.print(" class='psel'"); %> onclick="showwolist(<%=i%>)"><%=i%></a>
					<%
					if (i>=6) break;
					} %>
					</div>
					<div class="pages-r">
					<%if (pages>1) out.print("<h2><a href='javascript:void(0);' onclick='showwolist(2)'>下一页</a></h2>");%>					
					</div>
				</div>
			</div>
			
			<div class="order-bottom">您还可以查看 <a href="buywelfare.jsp">未发放积分券</a> 或者去 <a href="buywelfare.jsp">购买福利</a></div>
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