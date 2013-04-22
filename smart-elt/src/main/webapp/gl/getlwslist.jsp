<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<div class="jfqffjl-t">
	<div class="jfqffjl1">发放日期</div>						
	<div class="jfqffjl2">发放名目</div>
	<div class="jfqffjl3">接收对象</div>
	<div class="jfqffjl9">积分券</div>
	<div class="jfqffjl4">数量</div>
	<div class="jfqffjl5">发放部门</div>
	<div class="jfqffjl8">发放备注</div>
</div>
<ul class="jfqffjlin">

<%
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
int ln=0;
int pages=1;
int psize=10;

String sffsj=request.getParameter("sffsj");
String effsj=request.getParameter("effsj");
String pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

if (!fun.sqlStrCheck(sffsj) || !fun.sqlStrCheck(effsj) ||  !fun.sqlStrCheck(pno))
{	
	return;
}
try
{
	
	SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
	strsql="select count(f.nid) as hn from tbl_jfqff f inner join tbl_jfqffxx x on f.ffxx=x.nid where f.ffxx<>0 and ((x.fflx=1 and x.lxbh in ("+session.getAttribute("ffbm")+")) or (x.fflx=2 and x.lxbh in ("+session.getAttribute("ffxz")+")))";	
	
	if (sffsj!=null && sffsj.length()>0)
		strsql+=" and ffsj>='"+sffsj+"'";
	if (effsj!=null  && effsj.length()>0)
		strsql+=" and ffsj<='"+effsj+" 23:59:59'";	
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{ln=rs.getInt("hn");}
	rs.close();
	pages=(ln-1)/psize+1;
	
	strsql="select f.nid,f.ffsj,m1.mmmc as mc1,m2.mmmc as mc2,f.hjr,ffjf,ffzt,f.srsj,x.jsmc,f.bz,q.mc as jfqmc from tbl_jfqff f inner join tbl_jfqffxx x on f.ffxx=x.nid left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid left join tbl_jfq q on f.jfq=q.nid where f.ffxx<>0 and ((x.fflx=1 and x.lxbh in ("+session.getAttribute("ffbm")+")) or (x.fflx=2 and x.lxbh in ("+session.getAttribute("ffxz")+")))";
	
	if (sffsj!=null && sffsj.length()>0)
		strsql+=" and f.ffsj>='"+sffsj+"'";
	if (effsj!=null  && effsj.length()>0)
		strsql+=" and f.ffsj<='"+effsj+" 23:59:59'";
	
	strsql+=" order by f.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;	
	//out.print(strsql);
	rs=stmt.executeQuery(strsql);
	while (rs.next())
	{
	 %>
	<li>
		<div class="jfqffjlin1"><%=sf.format(rs.getDate("ffsj"))%></div>
		<div class="jfqffjlin2"><a href="aworder.jsp?ffid=<%=rs.getString("nid")%>"><%if (rs.getString("mc2")!=null && rs.getString("mc2").length()>0) out.print(rs.getString("mc2")); else out.print(rs.getString("mc1")); %></a></div>
		<div class="jfqffjlin3"><%if (rs.getString("hjr")!=null && rs.getString("hjr").length()>20) out.print(rs.getString("hjr").substring(0,20)+"..."); else out.print(rs.getString("hjr"));%></div>
		<div class="jfqffjlin9" title="<%=rs.getString("jfqmc")%>"><%=rs.getString("jfqmc")%></div>
		<div class="jfqffjlin4"><%=rs.getString("ffjf")%></div>
		<div class="jfqffjlin5"><%=rs.getString("jsmc")%></div>
		<div class="jfqffjlin8" title="<%=rs.getString("bz")%>"><%=rs.getString("bz")%></div>							
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
				out.print("<a href='javascript:void(0);' class='psel' onclick='showljfslist("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='showljfslist("+i+")'>"+String.valueOf(i)+"</a>");
			
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
					out.print("<a href='javascript:void(0);' class='psel' onclick='showljfslist("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='showljfslist("+i+")'>"+String.valueOf(i)+"</a>");
			}
			out.print("...");
		}
		else
		{
			for (int i=1;i<=pages;i++)
			{
				if (i==page_no)
					out.print("<a href='javascript:void(0);' class='psel' onclick='showljfslist("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='showljfslist("+i+")'>"+String.valueOf(i)+"</a>");
			}
		}
	}
	else
	{
		for (int i=pages-5;i<=pages;i++)
		{
			if (i==0) i=1;
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='showljfslist("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='showljfslist("+i+")'>"+String.valueOf(i)+"</a>");
		}
	}

	%>
	
	</div>
	<div class="pages-r">
	<%if (page_no>1) out.print("<h1><a href='javascript:void(0);' onclick='showljfslist("+(page_no-1)+")'>上一页</a></h1>");%>
	<%if (page_no<pages) out.print("<h2><a href='javascript:void(0);' onclick='showljfslist("+(page_no+1)+")'>下一页</a></h2>");%>					
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
