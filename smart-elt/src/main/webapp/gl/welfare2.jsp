<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
function addbuycar(id,t)
{
	
	var bwcarp=readCookie("bwcarp");
	var tempstr=","+bwcarp;
	if (tempstr.indexOf(","+id+",")==-1)
	{
		writeCookie("bwcarp",bwcarp+id+",",24);
		writeCookie("bwcarn",readCookie("bwcarn")+"1,",24);
		showjfqcar();
	}	
	if (t==1)
	location.href="bwconfirm.jsp";
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
String hid=request.getParameter("hid");
if (hid==null || hid.equals("") || !fun.sqlStrCheck(hid))
{
	response.sendRedirect("buywelfare.jsp");
	return;
}
String sp="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try{%>
	<%@ include file="head.jsp" %>	
	
				<%
				//这里库存数量为零的是否要显示
				//strsql="select nid,mc,sm,jf,sp from tbl_jfq where hd="+hid+" and kcsl>0";
				if(request.getParameter("sid") != null){
					strsql="select q.yxq,q.nid,q.mc,q.sm,q.jf,q.sp,q.yxq,q.kcsl,h.hdtp2 from tbl_jfq q inner join tbl_jfqhd h on q.hd=h.nid where q.hd="+hid;
				}else{
					strsql="select q.nid,q.mc,q.sm,q.jf,q.sp,q.yxq,q.kcsl,h.hdtp2 from tbl_jfq q inner join tbl_jfqhd h on q.hd=h.nid where q.zt=1 and q.hd="+hid;
				}
				rs=stmt.executeQuery(strsql);
				int qn=1;
				int n = 0;
				while(rs.next())
				{
					if (rs.isFirst())
					{
				%>
		<div class="bannerbox" style="background:#f9f9f9;">
		<div class="bannerbox2">
			<div style="width:992px;height:320px;">
				<img src='../hdimg/<%=rs.getString("hdtp2")%>' width="992" height="320" />
			</div>
			<div class="bannerbox3" style="margin-top: 10px;">
			<%} 

				String css = "quan quanbg-";
				if(rs.isLast() && n==0){
					css += "0";
				}else{
					css += + qn;
				}
				n++;
				
				String strsqls="select sum(m.sl-m.ffsl) as sys from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where q.nid="+ request.getParameter("sid")+" and m.qy="+session.getAttribute("qy")+" and m.zt=1 and m.sl<>m.ffsl group by m.jfq,q.mc,q.jf";
				ResultSet ress =  stmt2.executeQuery(strsqls);
				String s = "";
				while (ress.next()){
					s = ress.getString("sys");
				}
				ress.close();
			
				if(request.getParameter("sid") == null){
			%>
				<div class="<%=css %>" <%if (qn>1) out.print(" style='margin-top:0px'"); %>>
					<div class="quanbuy">
						<span class="quan-name" style="font-size=20px;">[<%=rs.getString("mc").length()>15?rs.getString("mc").substring(0,15):rs.getString("mc")%>]</span><span class="quan-num"  style="margin-left:210px"><%=rs.getString("jf")%></span><span class="quan-jifeng">积分</span><span class="floatleft"></span><span class="floatleft"></span></div>
					<div class="quan-main">
						<div class="quan-ad-txt" style="width: 850px;">
							<h1 style="width:410px;padding-left:5px;font-size:15px;" align="left"><%=rs.getString("sm")%></h1>
							<span>有效期：<%=sf.format(rs.getDate("yxq"))%>&nbsp;&nbsp;库存量：<%=s%><%--=rs.getString("kcsl")--%></span></div>
						<ul class="quan-pro-list">
						<%
						//sp=rs.getString("sp");
						//sp=sp.substring(1,sp.length()-1);
						strsql="select s.nid, s.spmc,t.lj  from tbl_jfqspref j left join tbl_sp s on j.sp=s.nid left join tbl_sptp t on s.zstp=t.nid where j.jfq="+rs.getString("nid");				
						rs2=stmt2.executeQuery(strsql);
						int m = 0;
						while (rs2.next())
						{m++;
						%>
						<li><a href="pdetail.jsp?sp=<%=rs2.getString("nid")%>" target="_blank"><img src="../<%=rs2.getString("lj")%>" /></a><span><%=rs2.getString("spmc")%></span></li>						
						<%
						}
						rs2.close();
						 %>						
						</ul>
						<div style="clear: both;border:0px;height:0px"></div>		
						<div style="font-weight: bold;padding-left:47px;">
						<%
							if(m > 1){
								out.println("员工凭券可在商城中免费兑换以上任一商品");
							}else{
								out.println("员工凭此券可免费兑换以上商品");
							}
						%>
						</div>					
					</div>
				</div>
			<%
				}else{
					if(rs.getString("nid").equals(request.getParameter("sid"))){
			%>
						<div class="quan quanbg-0" <%if (qn>1) out.print(" style='margin-top:0px'"); %>>
							<div class="quanbuy">
								<span class="quan-name">[<%=rs.getString("mc").length()>15?rs.getString("mc").substring(0,15):rs.getString("mc")%>]</span>
								<span class="quan-num"  style="margin-left:210px"><%=rs.getString("jf")%></span>
								<span class="quan-jifeng">积分</span>
								<%
									if(rs.getDate("yxq").after(new Date())){
								%>
								<span class="floatleft"></span>
								<span class="floatleft"></span>
								<%}else{
								%>
									<span class="floatleft" style="width:150px;line-height:35px;text-align:right;font-size:16px;">已过期</span>							
								<%	
								}
								%>
								
							</div>
							<div class="quan-main">
								<div class="quan-ad-txt" style="width: 850px;">
									<h1 style="width: 350px;padding-left:5px;font-size:21px;overflow: hidden;" title="<%=rs.getString("sm")%>"><%=rs.getString("sm")%></h1>
									<span>有效期：<%=sf.format(rs.getDate("yxq"))%>&nbsp;&nbsp;库存量：<%=s%><%--=rs.getString("kcsl")--%></span>
								</div>
								<ul class="quan-pro-list">
								<%
								//sp=rs.getString("sp");
								//sp=sp.substring(1,sp.length()-1);
								strsql="select s.nid, s.spmc,t.lj  from tbl_jfqspref j left join tbl_sp s on j.sp=s.nid left join tbl_sptp t on s.zstp=t.nid where j.jfq="+rs.getString("nid");				
								rs2=stmt2.executeQuery(strsql);
								int m = 0;
								while (rs2.next())
								{m++;
								%>
								<li><a href="pdetail.jsp?sp=<%=rs2.getString("nid")%>" target="_blank"><img src="../<%=rs2.getString("lj")%>" /></a><span><%=rs2.getString("spmc")%></span></li>						
								<%
								}
								rs2.close();
								 %>						
								</ul>
								<div style="clear: both;border:0px;height:0px"></div>		
								<div style="font-weight: bold;padding-left:47px;">
								<%
									if(m > 1){
										out.println("员工凭券可在商城中免费兑换以上任一商品");
									}else{
										out.println("员工凭此券可免费兑换以上商品");
									}
								%></div>					
							</div>
						</div>
				<%
					}
				}
				
				qn++;
				}
				rs.close();
				
				if (qn>1)
				{
				%>	
			</div>
		</div>
	</div>
	<%
				}
				else
				{
					%>
					
						
			  	<div class="main2">
			  		<div class="box">	
			  		<%out.print("<div class=\"jfqbtnbox\"><span class=\"cancletxt\"><a href=\"buywelfare.jsp\" >&gt;&gt;积分券暂时为空，请选择其他积分券</a></span></div>"); %>			
					</div>
				</div>
					
					<%
				}
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