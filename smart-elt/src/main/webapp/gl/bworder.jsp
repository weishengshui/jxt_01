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

String ddid=request.getParameter("ddid");
if (ddid==null || ddid.length()==0 || !fun.sqlStrCheck(ddid))
return;

try{
	int ddzt=0;
	String ddsj="",ztsj="";
	strsql="select ddbh,ddsj,ztsj,zt from tbl_jfqdd where nid="+ddid;
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{
		ddzt=rs.getInt("zt");
		ddsj=sf.format(rs.getDate("ddsj"));
		if (rs.getString("ztsj")!=null)
		ztsj=sf.format(rs.getDate("ztsj"));
	}
	rs.close();
%>
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local">
					<li class="local-ico2">
						<div class="local3-1"><h1>确认购买福利信息</h1><h2><%=ddsj%></h2></div>
					</li>
					<li class="local-ico3">
						<div class="local3-2"><h1>支付订单金额</h1><%if (ztsj!=null && ztsj.length()>0) out.print("<h2>"+ztsj+"</h2>"); %></div>
					</li>
					<li>
						<div class="local3-3"><h1>交易成功</h1><%if (ztsj!=null && ztsj.length()>0) out.print("<h2>"+ztsj+"</h2>"); %></div>
					</li>
				</ul>
				<%if (session.getAttribute("glqx").toString().indexOf(",12,")!=-1) {%>
				<div class="gsjf-states">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %><a href="buyintegral.jsp" class="ljcztxt">立即充值&gt;&gt;</a></div>
				<%} %>
				
				<div class="jfqlist">
					<div class="jfq-th">
						<div class="jfq1">福利券名称</div>
						<div class="jfq2">需支付积分</div>
						<div class="jfq3">数量</div>
						<div class="jfq4">小计</div>
					</div>
					<div class="jfqin">
					
						<%
						
							int wjt=0;
						
							strsql="select q.nid,q.mc,q.sm,q.jf,q.sp,h.hdmc,h.hdtp,d.sl from tbl_jfq q inner join tbl_jfqhd h on q.hd=h.nid inner join tbl_jfqddmc d on q.nid=d.jfq where d.jfqdd="+ddid;
							rs=stmt.executeQuery(strsql);
							while (rs.next())
							{
								wjt=wjt+rs.getInt("jf")*rs.getInt("sl");
								%>
								<div class="jfqin-up">
									<div class="jfqin-up1">
										<img src="../hdimg/<%=rs.getString("hdtp")%>" />
										<dl>
											<dt><%=rs.getString("hdmc")%></dt>
											<dd>[<%=rs.getString("mc")%>]</dd>
											<span>限兑产品</span>
										</dl>
									</div>
									<div class="jfqin-up2"><span class="yellow2"><%=rs.getString("jf")%></span> 积分</div>
									<div class="jfqin-up3"><span class="floatleft"><%=rs.getString("sl")%></span></div>
									<div class="jfqin-up4"><span class="yellow2"><%=rs.getInt("jf")*rs.getInt("sl") %></span> 积分</div>
									
								</div>
								<ul class="jfqpro">
									
									 <%
									strsql="select s.spmc,t.lj  from tbl_jfqspref j left join tbl_sp s on j.sp=s.nid left join tbl_sptp t on s.zstp=t.nid where j.jfq="+rs.getString("nid");				
									rs2=stmt2.executeQuery(strsql);
									while (rs2.next())
									{
										if (!rs2.isLast())
											out.print("<li><img src='../"+rs2.getString("lj")+"' /><span>"+rs2.getString("spmc")+"</span></li>");
										else
											out.print("<li class='jfqprolast'><img src='../"+rs2.getString("lj")+"' /><span>"+rs2.getString("spmc")+"</span></li>");
										
									}
									rs2.close();
									 %>
								</ul>
							<%
							}
							rs.close();
						
						 %>
						 
						<div class="heji">合计：<span class="yellowtxt txtsize" id="wjt"><%=wjt%></span> 积分</div>
					</div>
					<div class="jfqbtnbox"><span class="floatright margintop"><%if (ddzt==0){ %><a href="bwpay.jsp?jid=<%=ddid%>" class="querenbtn"></a><%} %></span></div>
				</div>			
		 
	
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