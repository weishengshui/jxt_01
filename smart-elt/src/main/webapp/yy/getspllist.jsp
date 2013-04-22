<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8");%>


<%
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;

String strsql="";
int ln=0;
int pages=1;
int psize=10;

String lb1=request.getParameter("lb1");
String lb2=request.getParameter("lb2");
String pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

String ssplmc=request.getParameter("ssplmc");
if (ssplmc!=null)
{
	ssplmc=fun.unescape(ssplmc);
	ssplmc=URLDecoder.decode(ssplmc,"utf-8");
}


if (!fun.sqlStrCheck(pno) || !fun.sqlStrCheck(lb1) || !fun.sqlStrCheck(lb2) || !fun.sqlStrCheck(ssplmc))
{	
	return;
}
%>
<div class="workers-t">
	<div class="workers1">&nbsp;</div>
	<div class="workers4">系列名</div>
	<div class="workers1">类目1</div>
	<div class="workers1">类目2</div>
	<div class="workers1">类目3</div>
</div>
<ul class="workersin">
<%
try
{
	
	strsql="select count(nid) as hn from tbl_spl where zt>=0";
	if (ssplmc!=null && ssplmc.length()>0)
		strsql+=" and mc like '%"+ssplmc+"%'";
	if (lb1!=null && lb1.length()>0)
		strsql+=" and lb1="+lb1;
	if (lb2!=null && lb2.length()>0)
		strsql+=" and lb2="+lb2;
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{
		ln=rs.getInt("hn");
	}
	rs.close();
	pages=(ln-1)/psize+1;
	
	strsql="select l.nid,l.mc as lmc,l.zt,s.spmc as spmc,m1.mc as lmmc1,m2.mc as lmmc2,m3.mc as lmmc3 from tbl_spl l left join tbl_sp s on l.sp=s.nid left join tbl_splm m1 on l.lb1=m1.nid left join tbl_splm m2 on l.lb2=m2.nid left join tbl_splm m3 on l.lb3=m3.nid where l.zt>=0";
	if (ssplmc!=null && ssplmc.length()>0)
		strsql+=" and l.mc like '%"+ssplmc+"%'";
 	if (lb1!=null && lb1.length()>0)
 			strsql+=" and l.lb1="+lb1;
 	if (lb2!=null && lb2.length()>0)
		strsql+=" and l.lb2="+lb2;
	strsql+=" order by l.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
	//out.print(strsql);
	rs=stmt.executeQuery(strsql);
	while (rs.next())
	{
	 %>
	<li>
		<div class="workersin1">					
		<input type="radio" name="splid" id="splid" value="<%=rs.getInt("nid")%>" title="<%=rs.getString("lmc")%>" />					
		</div>
		<div class="workersin4" style="overflow: hidden;white-space: nowrap;"><%=rs.getString("lmc") %></div>
		<div class="workersin1" style="overflow: hidden;white-space: nowrap;"><%=rs.getString("lmmc1")==null?"":rs.getString("lmmc1")%></div>
		<div class="workersin1" style="overflow: hidden;white-space: nowrap;"><%=rs.getString("lmmc2")==null?"":rs.getString("lmmc2") %></div>
		<div class="workersin1" style="overflow: hidden;white-space: nowrap;"><%=rs.getString("lmmc3")==null?"":rs.getString("lmmc3") %></div>
	</li>
				
	<%}
	rs.close();
	 %>
	 </ul>
	<div class="pages-worker">
	<div class="pages-l">
	<%
	int page_no=Integer.valueOf(pno);	
	if (page_no>=5 && page_no<=pages-2)
	{
		for (int i=page_no-3;i<=page_no+2;i++)
		{
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='ssplagain("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='ssplagain("+i+")'>"+String.valueOf(i)+"</a>");
			
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
					out.print("<a href='javascript:void(0);' class='psel' onclick='ssplagain("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='ssplagain("+i+")'>"+String.valueOf(i)+"</a>");
			}
			out.print("...");
		}
		else
		{
			for (int i=1;i<=pages;i++)
			{
				if (i==page_no)
					out.print("<a href='javascript:void(0);' class='psel' onclick='ssplagain("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='ssplagain("+i+")'>"+String.valueOf(i)+"</a>");
			}
		}
	}
	else
	{
		for (int i=pages-5;i<=pages;i++)
		{
			if (i==0) i=1;
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='ssplagain("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='ssplagain("+i+")'>"+String.valueOf(i)+"</a>");
		}
	}

	%>
	
	</div>
	<div class="pages-r">
	<%if (page_no>1) out.print("<h1><a href='javascript:void(0);' onclick='ssplagain("+(page_no-1)+")'>上一页</a></h1>");%>
	<%if (page_no<pages) out.print("<h2><a href='javascript:void(0);' onclick='ssplagain("+(page_no+1)+")'>下一页</a></h2>");%>					
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
