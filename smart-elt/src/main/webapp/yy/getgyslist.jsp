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


String pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

String sgysmc=request.getParameter("sgysmc");
if (sgysmc!=null)
{
	sgysmc=fun.unescape(sgysmc);
	sgysmc=URLDecoder.decode(sgysmc,"utf-8");
}

String slxr=request.getParameter("slxr");
if (slxr!=null)
{
	slxr=fun.unescape(slxr);
	slxr=URLDecoder.decode(slxr,"utf-8");
}
String gtype=request.getParameter("gtype");

if (!fun.sqlStrCheck(pno)   || !fun.sqlStrCheck(sgysmc) || !fun.sqlStrCheck(slxr)|| !fun.sqlStrCheck(gtype))
{	
	return;
}
%>
<div class="workers-t">
	<div class="workers1">&nbsp;</div>
	<div class="workers4">供应商品称</div>
	<div class="workers1">联系人</div>
	<div class="workers1">联系电话</div>
</div>
<ul class="workersin">
<%
try
{
	
	strsql="select count(nid) as hn from tbl_spgys where 1=1"; 
	if (sgysmc!=null && sgysmc.length()>0)
		strsql+=" and gysmc like '%"+sgysmc+"%'";
	if (slxr!=null && slxr.length()>0)
		strsql+=" and lxr like '%"+slxr+"%'";
	if (gtype!=null && gtype.length()>0)
		strsql=strsql+" and gtype="+gtype;
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{
		ln=rs.getInt("hn");
	}
	rs.close();
	pages=(ln-1)/psize+1;
	
	 strsql="select nid,gysmc,dz,lxr,lxrdh from tbl_spgys where 1=1";
	 if (sgysmc!=null && sgysmc.length()>0)
			strsql+=" and gysmc like '%"+sgysmc+"%'";
	if (slxr!=null && slxr.length()>0)
		strsql+=" and lxr like '%"+slxr+"%'";
	if (gtype!=null && gtype.length()>0)
		strsql=strsql+" and gtype="+gtype;
	strsql+=" order by nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
	
	rs=stmt.executeQuery(strsql);
	while (rs.next())
	{
	 %>
	<li>
		<div class="workersin1">					
		<input type="radio" name="sgysid" id="sgysid" value="<%=rs.getInt("nid")%>" title="<%=rs.getString("gysmc")%>" />					
		</div>
		<div class="workersin4"><%=rs.getString("gysmc") %></div>
		<div class="workersin1"><%=rs.getString("lxr") %></div>
		<div class="workersin1"><%=rs.getString("lxrdh") %></div>
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
				out.print("<a href='javascript:void(0);' class='psel' onclick='sgysagain("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='sgysagain("+i+")'>"+String.valueOf(i)+"</a>");
			
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
					out.print("<a href='javascript:void(0);' class='psel' onclick='sgysagain("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='sgysagain("+i+")'>"+String.valueOf(i)+"</a>");
			}
			out.print("...");
		}
		else
		{
			for (int i=1;i<=pages;i++)
			{
				if (i==page_no)
					out.print("<a href='javascript:void(0);' class='psel' onclick='sgysagain("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='sgysagain("+i+")'>"+String.valueOf(i)+"</a>");
			}
		}
	}
	else
	{
		for (int i=pages-5;i<=pages;i++)
		{
			if (i==0) i=1;
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='sgysagain("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='sgysagain("+i+")'>"+String.valueOf(i)+"</a>");
		}
	}

	%>
	
	</div>
	<div class="pages-r">
	<%if (page_no>1) out.print("<h1><a href='javascript:void(0);' onclick='sgysagain("+(page_no-1)+")'>上一页</a></h1>");%>
	<%if (page_no<pages) out.print("<h2><a href='javascript:void(0);' onclick='sgysagain("+(page_no+1)+")'>下一页</a></h2>");%>					
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
