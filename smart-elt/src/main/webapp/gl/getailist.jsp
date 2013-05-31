<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<div class="jfqffjl-t">
	<div class="jfqffjl1">设置日期</div>
	<div class="jfqffjl2">发放名目</div>
	<div class="jfqffjl3">发放对象</div>
	<div class="jfqffjl4">积分</div>
	<div class="jfqffjl5">状态</div>
	<div class="jfqffjl6">发放日期</div>
	<div class="jfqffjl7"></div>
</div>
<ul class="jfqffjlin">

<%
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
int ln=0;
int pages=1;
int psize=10;
String ffid=request.getParameter("ffid");
String sffsj=request.getParameter("sffsj");
String effsj=request.getParameter("effsj");
String ssrsj=request.getParameter("ssrsj");
String esrsj=request.getParameter("esrsj");
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
	//取消发放
	if (ffid!=null && ffid.length()>0)
	{
		//先判断状态是否可以取消
		int nowffzt=1;
		int ffjf=0;
		strsql="select ffzt,ffjf from tbl_jfff where nid="+ffid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			nowffzt=rs.getInt("ffzt");
			ffjf=rs.getInt("ffjf");
		}
		rs.close();
		
		//还没有发放，则可以取消
		//取消后冻结积分减掉，可用积分添加
		if (nowffzt==0)
		{
			strsql="update tbl_jfff set ffzt=-1,ztsj=now() where nid="+ffid;
			stmt.executeUpdate(strsql);
			//更新企业表中数据
			strsql="update tbl_qy set jf=jf+"+ffjf+",djjf=djjf-"+ffjf+" where nid="+session.getAttribute("qy");
			stmt.executeUpdate(strsql);
			
			Integer jfye=Integer.valueOf(session.getAttribute("qyjf").toString())+Integer.valueOf(ffjf);
			session.setAttribute("qyjf",String.valueOf(jfye));
			//冻结积分
			
			Integer sdjjf=Integer.valueOf(session.getAttribute("djjf").toString())-Integer.valueOf(ffjf);
			session.setAttribute("djjf",String.valueOf(sdjjf));
			
		}
	}
	SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
	strsql="select count(nid) as hn from tbl_jfff  where qy="+session.getAttribute("qy");
	if (sffsj!=null && sffsj.length()>0)
		strsql+=" and ffsj>='"+sffsj+"'";
	if (effsj!=null  && effsj.length()>0)
		strsql+=" and ffsj<='"+effsj+" 23:59:59'";
	if (ssrsj!=null && ssrsj.length()>0)
		strsql+=" and srsj>='"+ssrsj+"'";
	if (esrsj!=null  && esrsj.length()>0)
		strsql+=" and srsj<='"+esrsj+" 23:59:59'";
	if (ffzt!=null && ffzt.length()>0)
		strsql+=" and ffzt="+ffzt;
	if (session.getAttribute("glqx").toString().indexOf(",11,")!=-1) {
		strsql+=" and fftype=0 and ffxx=0";
	} else if (isLeader) {
		strsql+=" and ffr="+session.getAttribute("ygid");
	}
	
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{ln=rs.getInt("hn");}
	rs.close();
	pages=(ln-1)/psize+1;
	
	
	strsql="select f.nid,f.ffsj,m1.mmmc as mc1,m2.mmmc as mc2,f.hjr,ffjf,ffzt,f.srsj from tbl_jfff f left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where f.qy="+session.getAttribute("qy");
	if (sffsj!=null && sffsj.length()>0)
		strsql+=" and f.ffsj>='"+sffsj+"'";
	if (effsj!=null  && effsj.length()>0)
		strsql+=" and f.ffsj<='"+effsj+" 23:59:59'";
	if (ssrsj!=null && ssrsj.length()>0)
		strsql+=" and f.srsj>='"+ssrsj+"'";
	if (esrsj!=null  && esrsj.length()>0)
		strsql+=" and f.srsj<='"+esrsj+" 23:59:59'";
	if (ffzt!=null && ffzt.length()>0)
		strsql+=" and f.ffzt="+ffzt;
	
	if (session.getAttribute("glqx").toString().indexOf(",11,")!=-1) {
		strsql+=" and f.fftype=0 and f.ffxx=0";
	} else if (isLeader) {
		strsql+=" and f.ffr="+session.getAttribute("ygid");
	}
	
	strsql+=" order by f.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;	
	
	rs=stmt.executeQuery(strsql);
	while (rs.next())
	{
	 %>
	<li>
		<div class="jfqffjlin1"><%=sf.format(rs.getDate("srsj"))%></div>
		<div class="jfqffjlin2"><a href="aiorder.jsp?ffid=<%=rs.getString("nid")%>"><%if (rs.getString("mc2")!=null && rs.getString("mc2").length()>0) out.print(rs.getString("mc2")); else out.print(rs.getString("mc1")); %></a></div>
		<div class="jfqffjlin3"><%if (rs.getString("hjr")!=null && rs.getString("hjr").length()>20) out.print(rs.getString("hjr").substring(0,20)+"..."); else out.print(rs.getString("hjr"));%></div>
		<div class="jfqffjlin4"><%=rs.getString("ffjf")%><%if (rs.getInt("ffzt")==0) out.print("冻结"); %></div>
		<div class="jfqffjlin5"><%
			if (rs.getInt("ffzt")==-1)
				out.print("已取消");
			if (rs.getInt("ffzt")==0)
				out.print("未发放");
			if (rs.getInt("ffzt")==1)
				out.print("已发放");
			%></div>
		<div class="jfqffjlin6"><%=sf.format(rs.getDate("ffsj"))%></div>
		<div class="jfqffjlin7"><%if (rs.getInt("ffzt")==0) {%><span class="cancletxt"><a href="javascript:void(0);" onclick="Cancleff(<%=rs.getString("nid")%>)">取消发放</a></span><%} %></div>
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
				out.print("<a href='javascript:void(0);' class='psel' onclick='showailist("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='showailist("+i+")'>"+String.valueOf(i)+"</a>");
			
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
					out.print("<a href='javascript:void(0);' class='psel' onclick='showailist("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='showailist("+i+")'>"+String.valueOf(i)+"</a>");
			}
			out.print("...");
		}
		else
		{
			for (int i=1;i<=pages;i++)
			{
				if (i==page_no)
					out.print("<a href='javascript:void(0);' class='psel' onclick='showailist("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='showailist("+i+")'>"+String.valueOf(i)+"</a>");
			}
		}
	}
	else
	{
		for (int i=pages-5;i<=pages;i++)
		{
			if (i==0) i=1;
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='showailist("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='showailist("+i+")'>"+String.valueOf(i)+"</a>");
		}
	}

	%>
	
	</div>
	<div class="pages-r">
	<%if (page_no>1) out.print("<h1><a href='javascript:void(0);' onclick='showailist("+(page_no-1)+")'>上一页</a></h1>");%>
	<%if (page_no<pages) out.print("<h2><a href='javascript:void(0);' onclick='showailist("+(page_no+1)+")'>下一页</a></h2>");%>					
	</div>		
<%

}
  catch(Exception e)
{			
	e.printStackTrace();
	conn.rollback();
	conncommit=0;
}
finally
{
	if (!conn.isClosed())
	{	
		if (conncommit==1)
			conn.commit();
		conn.close();
	}
}
%>
