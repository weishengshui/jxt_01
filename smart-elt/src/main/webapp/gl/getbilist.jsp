<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<%
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
int ln=0;
int pages=1;
int psize=10;
String zzid=request.getParameter("zzid");
String szzsj=request.getParameter("szzsj");
String ezzsj=request.getParameter("ezzsj");
String zzzt=request.getParameter("zzzt");
String pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

if (!fun.sqlStrCheck(zzzt) || !fun.sqlStrCheck(szzsj) || !fun.sqlStrCheck(ezzsj) || !fun.sqlStrCheck(zzid) || !fun.sqlStrCheck(pno))
{	
	return;
}
try
{
	if (zzid!=null && zzid.length()>0)
	{
		int nowzzzt=0;
		strsql="select zzzt from tbl_jfzz where nid="+zzid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			nowzzzt=rs.getInt("zzzt");
		}
		rs.close();
		
		if (nowzzzt==0 || nowzzzt==2)
		{
			strsql="update tbl_jfzz set zzzt=-1,fksj=now() where nid="+zzid+" and zzzt<3";
			stmt.executeUpdate(strsql);
		}
		if (nowzzzt==3)
		{
			out.print("0");
			return;
		}
	}
	
	%>
	<div class="scoresjilu-t">
	<div class="scoresjilu1">购买日期</div>
	<div class="scoresjilu2">订单号</div>
	<div class="scoresjilu3">购买积分(分)</div>
	<div class="scoresjilu4">支付金额(元)</div>						
	
	<div class="scoresjilu6">到账积分(分)</div>					
	<div class="scoresjilu7">状态</div>
	<div class="scoresjilu8"></div>
	</div>
	<ul class="scoresjiluin">
	<%
	SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
	strsql="select count(nid) as hn from tbl_jfzz  where qy="+session.getAttribute("qy");
	if (szzsj!=null && szzsj.length()>0)
		strsql+=" and zzsj>='"+szzsj+"'";
	if (ezzsj!=null  && ezzsj.length()>0)
		strsql+=" and zzsj<='"+ezzsj+" 23:59:59'";
	if (zzzt!=null && zzzt.length()>0)
		strsql+=" and zzzt="+zzzt;
	
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{ln=rs.getInt("hn");}
	rs.close();
	pages=(ln-1)/psize+1;
	
	
	strsql="select nid,zzsj,zzbh,zzjf,zzje,dzjf, zzzt from tbl_jfzz where qy="+session.getAttribute("qy");
	if (szzsj!=null && szzsj.length()>0)
		strsql+=" and zzsj>='"+szzsj+"'";
	if (ezzsj!=null  && ezzsj.length()>0)
		strsql+=" and zzsj<='"+ezzsj+" 23:59:59'";
	if (zzzt!=null && zzzt.length()>0)
		strsql+=" and zzzt="+zzzt;
	strsql+=" order by nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;	
	rs=stmt.executeQuery(strsql);
	while (rs.next())
	{
	 %>
	<li>
		<div class="scoresjiluin1"><%=sf.format(rs.getDate("zzsj"))%></div>
		<div class="scoresjiluin2"><a href="bidetail.jsp?zzid=<%=rs.getString("nid")%>"><%=rs.getString("zzbh")%> </a></div>
		<div class="scoresjiluin3"><%=rs.getInt("zzjf")%> </div>
		<div class="scoresjiluin4"><%=rs.getString("zzje")%></div>		
		<div class="scoresjiluin6"><%=rs.getString("dzjf")%></div>
		
		<div class="scoresjiluin7"><%
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
		 %></div>
		<div class="scoresjiluin8"><%if (rs.getInt("zzzt")==0) {%><span class="floatleft"><a href="bipay.jsp?zzid=<%=rs.getString("nid")%>" class="gopay"></a></span><%} if (rs.getInt("zzzt")==0 || rs.getInt("zzzt")==2 ) { %><span class="cancletxt"><a href="javascript:void(0);" onclick="canclezz(<%=rs.getString("nid")%>)">取消</a></span><%} %></div>
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
				out.print("<a href='javascript:void(0);' class='psel' onclick='showbilist("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='showbilist("+i+")'>"+String.valueOf(i)+"</a>");
			
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
					out.print("<a href='javascript:void(0);' class='psel' onclick='showbilist("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='showbilist("+i+")'>"+String.valueOf(i)+"</a>");
			}
			out.print("...");
		}
		else
		{
			for (int i=1;i<=pages;i++)
			{
				if (i==page_no)
					out.print("<a href='javascript:void(0);' class='psel' onclick='showbilist("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='showbilist("+i+")'>"+String.valueOf(i)+"</a>");
			}
		}
	}
	else
	{
		for (int i=pages-5;i<=pages;i++)
		{
			if (i==0) i=1;
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='showbilist("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='showbilist("+i+")'>"+String.valueOf(i)+"</a>");
		}
	}

	%>
	
	</div>
	<div class="pages-r">
	<%if (page_no>1) out.print("<h1><a href='javascript:void(0);' onclick='showbilist("+(page_no-1)+")'>上一页</a></h1>");%>
	<%if (page_no<pages) out.print("<h2><a href='javascript:void(0);' onclick='showbilist("+(page_no+1)+")'>下一页</a></h2>");%>					
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
