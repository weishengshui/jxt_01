<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",12,")==-1 && !isLeader) 
	response.sendRedirect("main.jsp");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">

function changejf(j,p,t,kc)
{
	if (!CheckNumber(document.getElementById("wn"+p).value) || parseInt(document.getElementById("wn"+p).value)<1)
	{
		document.getElementById("wn"+p).value="1";
	}
	if (parseInt(document.getElementById("wn"+p).value)>kc)
		document.getElementById("wn"+p).value=kc;
	
	var wjt=0;
	document.getElementById("wj"+p).innerHTML=parseInt(document.getElementById("wn"+p).value)*j;
	for (var i=0;i<t;i++)
	{
		
		wjt=wjt+parseInt(document.getElementById("wj"+i).innerHTML);
	}
	document.getElementById("wjt").innerHTML=wjt;
}
function delone(p,t)
{
	var bwcarp="";
	var bwcarn="";
	for (var i=0;i<t;i++)
	{
		if (i!=p)
		{
			bwcarp=bwcarp+document.getElementById("jid"+i).value+",";
			bwcarn=bwcarn+document.getElementById("wn"+i).value+",";
		}
	}
	
	writeCookie("bwcarp",bwcarp,24);
	writeCookie("bwcarn",bwcarn,24);
	location.href="bwconfirm.jsp";
}
function gobuy(t)
{
	var bwcarp="";
	var bwcarn="";
	for (var i=0;i<t;i++)
	{
		bwcarp=bwcarp+document.getElementById("jid"+i).value+",";
		bwcarn=bwcarn+document.getElementById("wn"+i).value+",";		
	}
	
	writeCookie("bwcarp",bwcarp,24);
	writeCookie("bwcarn",bwcarn,24);
	location.href="buywelfare.jsp";
}
function gopay(t)
{
	if (document.getElementById("wjt").innerHTML=="0")
	{
		alert("请先选择要购买的福利！");
		return;
	}
	var bwcar="";
	for (var i=0;i<t;i++)
	{
		bwcar=bwcar+document.getElementById("jid"+i).value+","+document.getElementById("wn"+i).value+",";
	}
	document.getElementById("bwpay").value=bwcar;
	document.getElementById("bwform").submit();
}
function changesl(j,n,l,t,kc)
{
	var va=document.getElementById("wn"+n).value;
	if (t==0)
	{
		if (parseInt(va)<=1) return;
		document.getElementById("wn"+n).value=parseInt(va)-1;
	}
	else
	{
		if (parseInt(va)<parseInt(kc))
		document.getElementById("wn"+n).value=parseInt(va)+1;
	}
	changejf(j,n,l,kc);
}

function addbuycar(id)
{
	var bwcarp=readCookie("bwcarp");
	var tempstr=","+bwcarp;
	if (tempstr.indexOf(","+id+",")==-1)
	{
		writeCookie("bwcarp",bwcarp+id+",",24);
		writeCookie("bwcarn",readCookie("bwcarn")+"1,",24);
		showjfqcar();
	}	
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
menun=4;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Statement stmt2=conn.createStatement();
ResultSet rs2=null;
String strsql="";
Fun fun=new Fun();

String sp="",bwcarp="",bwcarn="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try{
%>
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local">
					<li class="local-ico2">
						<div class="local3-1"><h1>确认购买福利信息</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li class="local-ico3">
						<div class="local3-2"><h1>支付订单金额</h1></div>
					</li>
					<li>
						<div class="local3-3"><h1>交易成功</h1></div>
					</li>
				</ul>
				<%if (session.getAttribute("glqx").toString().indexOf(",12,")!=-1) {%>
				<div class="gsjf-states">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %><a href="buyintegral.jsp" class="ljcztxt">立即充值&gt;&gt;</a></div>
				<%} %>
				
	<%
	
	Cookie[] cookie=request.getCookies();
	if (cookie!=null)		
	{
		for (int i=0;i<cookie.length;i++)
		{
			Cookie mycook=cookie[i];
			
			if (mycook.getName().equals("bwcarp"))
			{
				bwcarp=mycook.getValue();
				bwcarp=fun.unescape(bwcarp);
				
			}
			if (mycook.getName().equals("bwcarn"))
			{
				bwcarn=mycook.getValue();
				bwcarn=fun.unescape(bwcarn);
				
			}
		}
	}
	
	//员工端生成福利券
	String flqid = request.getParameter("flqid");
	String scflq = request.getParameter("scflq");
	if (flqid != null && "1".equals(scflq)) {
		%>
		<script type="text/javascript">addbuycar('<%=flqid%>');</script>
		<%
	}
	String[] bw=null;
	String[] bwn=null;
	if ((bwcarp!=null && bwcarp.length()>0) || (flqid != null && "1".equals(scflq)))
	{
		if ((bwcarp!=null && bwcarp.length()>0) && (flqid != null && "1".equals(scflq))) {
			bwcarp+=flqid;
			bwcarn+="1";
			bw=bwcarp.split(",");
			bwn=bwcarn.split(",");
		} else if (bwcarp!=null && bwcarp.length()>0){
			bw=bwcarp.split(",");
			bwn=bwcarn.split(",");
		} else if (flqid != null && "1".equals(scflq)){
			bw = new String[]{flqid};
			bwn = new String[]{"1"};
		}
	%>	
	
				<div class="jfqlist">
					<div class="jfq-th">
						<div class="jfq1">福利券名称</div>
						<div class="jfq2">需支付积分</div>
						<div class="jfq3">数量</div>
						<div class="jfq4">小计</div>
						<div class="jfq2">库存</div>
					</div>
					<div class="jfqin">
					
						<%
						int wjt=0;
						for (int i=0;i<bw.length;i++)
						{
							strsql="select q.nid,q.mc,q.sm,q.jf,q.sp,q.kcsl,h.hdmc,h.hdtp from tbl_jfq q inner join tbl_jfqhd h on q.hd=h.nid where q.nid="+bw[i];
							rs=stmt.executeQuery(strsql);
							if (rs.next())
							{
								String num = "自选福利".equals(rs.getString("hdmc")) ? "" + rs.getInt("kcsl") : bwn[i];
								wjt=wjt+rs.getInt("jf")*Integer.valueOf(num);
								%>
								<div class="jfqin-up">
									<div class="jfqin-up1">
										<img src="../hdimg/<%=rs.getString("hdtp")%>" />
										<dl>
											<dt><input type="hidden" name="jid<%=i%>" id="jid<%=i%>" value="<%=rs.getString("nid")%>" /><%=rs.getString("hdmc")%></dt>
											<dd>[<%=rs.getString("mc")%>]</dd>
											<span>限兑产品</span>
										</dl>
									</div>
									<div class="jfqin-up2"><span class="yellow2"><%=rs.getString("jf")%></span> 积分</div>
									<div class="jfqin-up3">
										<span class="addbtn">
											<a href="javascript:void(0);" onclick="changesl(<%=rs.getString("jf")%>,<%=i%>,<%=bw.length%>,0,<%=rs.getInt("kcsl")%>)">
											<img src="images/ico4.jpg" /></a></span>
										<span class="floatleft">
											<input type="text" onchange="changejf(<%=rs.getString("jf")%>,<%=i%>,<%=bw.length%>,<%=rs.getInt("kcsl")%>)" name="wn<%=i%>" id="wn<%=i%>" value="<%=num%>" class="input5" />
										</span>
										<span class="addbtn">
											<a href="javascript:void(0);" onclick="changesl(<%=rs.getString("jf")%>,<%=i%>,<%=bw.length%>,1,<%=rs.getInt("kcsl")%>)">
											<img src="images/ico5.jpg" />
											</a>
										</span>
									</div>
									<div class="jfqin-up4"><span class="yellow2" id="wj<%=i%>"><%=rs.getInt("jf")*Integer.valueOf(bwn[i]) %></span> 积分</div>
									<div class="jfqin-up2"><span class="yellow2"><%=rs.getInt("kcsl")%></div>
									<div class="jfqin-up5"><a href="javascript:void(0);" class="deltxt" onclick="delone(<%=i%>,<%=bw.length%>)">&times;删除</a></div>
								</div>
								<ul class="jfqpro">
									<%
									strsql="select s.nid,s.spmc,t.lj  from tbl_jfqspref j left join tbl_sp s on j.sp=s.nid left join tbl_sptp t on s.zstp=t.nid where j.jfq="+rs.getString("nid");				
									rs2=stmt2.executeQuery(strsql);
									while (rs2.next())
									{
										if (!rs2.isLast())
											out.print("<li><a href=\"/eltcustom/sp!detail.do?sp="+rs2.getString("nid")+"\" target=\"_blank\"><img src='../"+rs2.getString("lj")+"' /><p class='jfqpro-title'><span class='jfqpro-title-content'>"+rs2.getString("spmc")+"</span></p></a></li>");
										else
											out.print("<li class='jfqprolast'><a href=\"pdetail.jsp?sp="+rs2.getString("nid")+"\" target=\"_blank\"><img src='../"+rs2.getString("lj")+"' /><p class='jfqpro-title'><span class='jfqpro-title-content'>"+rs2.getString("spmc")+"</span></p></a></li>");
										
									}
									rs2.close();
									 %>
								</ul>
							<%
							}
							rs.close();
						}
						
						 %>
						 <form action="bwpay.jsp" method="post" name="bwform" id="bwform">
						 <input type="hidden" name="bwpay" id="bwpay" />
						 <input type="hidden" name="gmh" id="gmh"  value="<%=session.getAttribute("ygid").toString()+String.valueOf(Calendar.getInstance().getTimeInMillis())%>"/>
						 </form>
						
						<div class="heji">合计：<span class="yellowtxt txtsize" id="wjt"><%=wjt%></span> 积分</div>
					</div>
					<div class="jfqbtnbox"><span class="cancletxt"><a href="javascript:void(0);" onclick="gobuy(<%=bw.length%>)">&gt;&gt;继续购买</a></span><span class="floatright margintop"><a href="javascript:void(0);" class="querenbtn" onclick="gopay(<%=bw.length%>)"></a></span></div>
				</div>			
		 
	<%
	}
	else
	{
		out.print("<div class=\"jfqbtnbox\"><span class=\"cancletxt\"><a href=\"buywelfare.jsp\" >&gt;&gt;购物车为空，去购买福利</a></span></div>");
	}
	%>
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