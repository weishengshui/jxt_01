<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<div class="jfqffjl-t">
	<div class="jfqffjl1">发放时间</div>
	<div class="jfqffjl22">积分券名称</div>
	<div class="jfqffjl33">发放名目</div>						
	<div class="jfqffjl44">发放对象/发放授权</div>					
</div>
<ul class="jfqffjlin">

<%
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Statement stmt2=conn.createStatement();
ResultSet rs2=null;
String strsql="";
int ln=0;
int pages=1;
int psize=10;
String ffid=request.getParameter("ffid");
String sffsj=request.getParameter("sffsj");
String effsj=request.getParameter("effsj");
String ffzt=request.getParameter("ffzt");
String pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

if (!fun.sqlStrCheck(ffzt) || !fun.sqlStrCheck(sffsj) || !fun.sqlStrCheck(effsj) || !fun.sqlStrCheck(ffid) || !fun.sqlStrCheck(pno))
{	
	return;
}
try
{
	
	SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
	strsql="select count(nid) as hn from tbl_jfqff  where qy="+session.getAttribute("qy");
	if (sffsj!=null && sffsj.length()>0)
		strsql+=" and ffsj>='"+sffsj+"'";
	if (effsj!=null  && effsj.length()>0)
		strsql+=" and ffsj<='"+effsj+" 23:59:59'";	
	if (ffzt!=null && ffzt.length()>0)
		strsql+=" and ffzt="+ffzt;
	//判断是否是hr发放
	if (session.getAttribute("ffjf")!=null && session.getAttribute("ffjf").equals("1"))
		strsql+=" and ffr="+session.getAttribute("ygid");
	else
		strsql+=" and ffxx=0";
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{ln=rs.getInt("hn");}
	rs.close();
	pages=(ln-1)/psize+1;
	
	
	strsql="select f.nid,f.ffsj,m1.mmmc as mc1,m2.mmmc as mc2,f.hjr,ffjf,ffzt,f.srsj,q.mc,q.hd from tbl_jfqff f left join tbl_jfq q on f.jfq=q.nid left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where f.qy="+session.getAttribute("qy");
	if (sffsj!=null && sffsj.length()>0)
		strsql+=" and f.ffsj>='"+sffsj+"'";
	if (effsj!=null  && effsj.length()>0)
		strsql+=" and f.ffsj<='"+effsj+" 23:59:59'";	
	if (ffzt!=null && ffzt.length()>0)
		strsql+=" and f.ffzt="+ffzt;
	//判断是否是hr发放
	if (session.getAttribute("ffjf")!=null && session.getAttribute("ffjf").equals("1"))
		strsql+=" and ffr="+session.getAttribute("ygid");
	else
		strsql+=" and ffxx=0";
	strsql+=" order by f.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;	
	rs=stmt.executeQuery(strsql);
	while (rs.next())
	{
	 %>
	<li>
							<div class="jfqffjlin1"><%=sf.format(rs.getDate("ffsj"))%></div>							
							<div class="jfqffjlin22"><a href="welfare.jsp?hid=<%=rs.getString("hd")%>"><%=rs.getString("mc")%></a></div>
							<div class="jfqffjlin33"><a href="aworder.jsp?ffid=<%=rs.getString("nid")%>&backurl=myw"><%if (rs.getString("mc2")!=null && rs.getString("mc2").length()>0) out.print(rs.getString("mc2")); else out.print(rs.getString("mc1")); %></a></div>							
							<div class="jfqffjlin44">&nbsp;
							<%
							strsql="select m.ffjf,y.ygxm from tbl_jfqffmc m inner join tbl_qyyg y on m.hqr=y.nid where m.jfqff="+rs.getString("nid");
							rs2=stmt2.executeQuery(strsql);
							while(rs2.next())
							{
								out.print(rs2.getString("ygxm")+"(<span>"+rs2.getString("ffjf")+"</span>),");
							}
							rs2.close();
							strsql="select x.jf,b.bmmc from tbl_jfqffxx x inner join tbl_qybm b on x.lxbh=b.nid where x.fflx=1 and jfqff="+rs.getString("nid");
							rs2=stmt2.executeQuery(strsql);
							while(rs2.next())
							{
								out.print(rs2.getString("bmmc")+"(<span>"+rs2.getString("jf")+"</span>),");
							}
							rs2.close();
							
							strsql="select x.jf,z.xzmc from tbl_jfqffxx x inner join tbl_qyxz z on x.lxbh=z.nid where x.fflx=2 and jfqff="+rs.getString("nid");
							rs2=stmt2.executeQuery(strsql);
							while(rs2.next())
							{
								out.print(rs2.getString("xzmc")+"(<span>"+rs2.getString("jf")+"</span>),");
							}
							rs2.close();
							%>
							</div>
							<div class="jfqffjlin55"><%
							if (rs.getInt("ffzt")==-1)
								out.print("已取消");
							if (rs.getInt("ffzt")==0)
								out.print("未发放");
							if (rs.getInt("ffzt")==1)
								out.print("已发放");
							%></div>						
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
				out.print("<a href='javascript:void(0);' class='psel' onclick='showwslist("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='showwslist("+i+")'>"+String.valueOf(i)+"</a>");
			
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
					out.print("<a href='javascript:void(0);' class='psel' onclick='showwslist("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='showwslist("+i+")'>"+String.valueOf(i)+"</a>");
			}
			out.print("...");
		}
		else
		{
			for (int i=1;i<=pages;i++)
			{
				if (i==page_no)
					out.print("<a href='javascript:void(0);' class='psel' onclick='showwslist("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='showwslist("+i+")'>"+String.valueOf(i)+"</a>");
			}
		}
	}
	else
	{
		for (int i=pages-5;i<=pages;i++)
		{
			if (i==0) i=1;
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='showwslist("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='showwslist("+i+")'>"+String.valueOf(i)+"</a>");
		}
	}

	%>
	
	</div>
	<div class="pages-r">
	<%if (page_no>1) out.print("<h1><a href='javascript:void(0);' onclick='showwslist("+(page_no-1)+")'>上一页</a></h1>");%>
	<%if (page_no<pages) out.print("<h2><a href='javascript:void(0);' onclick='showwslist("+(page_no+1)+")'>下一页</a></h2>");%>					
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
