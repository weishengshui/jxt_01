<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
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
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
int ln=0;
int pages=1;
int psize=10;
String did=request.getParameter("did");
String sddsj=request.getParameter("sddsj");
String eddsj=request.getParameter("eddsj");
String ddzt=request.getParameter("ddzt");
String pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

if (!fun.sqlStrCheck(ddzt) || !fun.sqlStrCheck(sddsj) || !fun.sqlStrCheck(eddsj) || !fun.sqlStrCheck(did) || !fun.sqlStrCheck(pno))
{	
	return;
}
try
{
	if (did!=null && did.length()>0)
	{
		strsql="update tbl_jfqdd set zt=-1,ztsj=now() where nid="+did;
		stmt.executeUpdate(strsql);
	}
	SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
	String ffbm = session.getAttribute("ffbm").toString();
    if ("''".equals(ffbm)) {
    	ffbm = "-1";
    }
    String ffxz = session.getAttribute("ffxz").toString();
    if ("''".equals(ffxz)) {
    	ffxz = "-1";
    }
	if (session.getAttribute("glqx").toString().indexOf(",12,")!=-1) {
		strsql="select count(*) as hn from tbl_jfqdd where qy="+session.getAttribute("qy")+" and ddtype=0";
	} else if (isLeader) {
		strsql="select count(*) as hn from tbl_jfqdd where qy="+session.getAttribute("qy")+" and ddtype>0 and ((ddtype=1 and bmxz in ("+ffbm+")) or (ddtype=2 and bmxz in ("+ffxz+")) or (ddtype=3 and xdr="+session.getAttribute("ygid")+"))";
	}
	if (sddsj!=null && sddsj.length()>0)
		strsql+=" and ddsj>='"+sddsj+"'";
	if (eddsj!=null  && eddsj.length()>0)
		strsql+=" and ddsj<='"+eddsj+" 23:59:59'";
	if (ddzt!=null && ddzt.length()>0)
		strsql+=" and zt="+ddzt;
	
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{ln=rs.getInt("hn");}
	rs.close();
	pages=(ln-1)/psize+1;
	
	if (session.getAttribute("glqx").toString().indexOf(",12,")!=-1) {
		strsql="select nid,ddsj,ddbh,ddsl,ddjf,zt from tbl_jfqdd where qy="+session.getAttribute("qy")+" and ddtype=0";
	} else if (isLeader) {
		strsql="select nid,ddsj,ddbh,ddsl,ddjf,zt from tbl_jfqdd where qy="+session.getAttribute("qy")+" and ddtype>0 and ((ddtype=1 and bmxz in ("+ffbm+")) or (ddtype=2 and bmxz in ("+ffxz+")) or (ddtype=3 and xdr="+session.getAttribute("ygid")+"))";
	}
	if (sddsj!=null && sddsj.length()>0)
		strsql+=" and ddsj>='"+sddsj+"'";
	if (eddsj!=null  && eddsj.length()>0)
		strsql+=" and ddsj<='"+eddsj+" 23:59:59'";
	if (ddzt!=null && ddzt.length()>0)
		strsql+=" and zt="+ddzt;
	strsql+=" order by nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;	
	
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
	
	<%}
	rs.close();
	 %>
	 </ul>
	<div class="pages">
	<div class="pages-l">
	<%
	int page_no=Integer.valueOf(pno);	
	if (page_no>=5 && page_no<=pages-2)
	{
		for (int i=page_no-3;i<=page_no+2;i++)
		{
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='showwolist("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='showwolist("+i+")'>"+String.valueOf(i)+"</a>");
			
		}
		out.print("...");
	}
	else if (page_no<5)
	{
		if (pages>6)
		{
			for (int i=1;i<=6;i++)
			{
				if (i==page_no)
					out.print("<a href='javascript:void(0);' class='psel' onclick='showwolist("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='showwolist("+i+")'>"+String.valueOf(i)+"</a>");
			}
			out.print("...");
		}
		else
		{
			for (int i=1;i<=pages;i++)
			{
				if (i==page_no)
					out.print("<a href='javascript:void(0);' class='psel' onclick='showwolist("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='showwolist("+i+")'>"+String.valueOf(i)+"</a>");
			}
		}
	}
	else
	{
		for (int i=pages-5;i<=pages;i++)
		{
			if (i==0) i=1;
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='showwolist("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='showwolist("+i+")'>"+String.valueOf(i)+"</a>");
		}
	}

	%>
	
	</div>
	<div class="pages-r">
	<%if (page_no>1) out.print("<h1><a href='javascript:void(0);' onclick='showwolist("+(page_no-1)+")'>上一页</a></h1>");%>
	<%if (page_no<pages) out.print("<h2><a href='javascript:void(0);' onclick='showwolist("+(page_no+1)+")'>下一页</a></h2>");%>					
	</div>		
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
