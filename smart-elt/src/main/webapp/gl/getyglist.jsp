<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8");%>


<%
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Statement stmt2=conn.createStatement();
ResultSet rs2=null;
String strsql="",bmmc="";
int ln=0;
int pages=1;
int psize=10;
String xid=request.getParameter("xid");
String t=request.getParameter("t");
String dsbm=request.getParameter("dsbm");
String pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

String dsygxm=request.getParameter("dsygxm");
if (dsygxm!=null)
{
	dsygxm=fun.unescape(dsygxm);
	dsygxm=URLDecoder.decode(dsygxm,"utf-8");
}

String dsemail=request.getParameter("dsemail");
if (dsemail!=null)
{
	dsemail=fun.unescape(dsemail);
	dsemail=URLDecoder.decode(dsemail,"utf-8");
}
if (!fun.sqlStrCheck(t) || !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(dsbm)  || !fun.sqlStrCheck(dsygxm) || !fun.sqlStrCheck(dsemail))
{	
	return;
}
%>
<div class="workers-t">
	<div class="workers1"><%if (t!=null && t.equals("0")) {%><h1><input type="checkbox" name="sygsa" id="sygsa" onclick="allselyg()" /></h1><span>全选</span><%}  else out.print("&nbsp;"); %></div>
	<div class="workers2">姓名</div>
	<div class="workers3">部门</div>
	<div class="workers4">邮箱</div>
</div>
<ul class="workersin">
<%
int fflx=0,lxbh=0;
try
{
	
	if (xid!=null && xid.length()>0)
	{
		strsql="select fflx,lxbh from tbl_jfffxx where nid="+xid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			fflx=rs.getInt("fflx");
			lxbh=rs.getInt("lxbh");
		}
		rs.close();
	}
	
	SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
	
	if (fflx==1)
		strsql="select count(nid) as hn from tbl_qyyg y where qy="+session.getAttribute("qy")+" and xtzt<>3  and zt=1 and bm like '%,"+lxbh+",%'";

	if (fflx==2)
		strsql="select count(x.nid) as hn from tbl_qyxzmc x inner join tbl_qyyg y on x.yg=y.nid where x.xz="+lxbh+"  and y.xtzt<>3  and y.zt=1";
	if (fflx==0)		
		strsql="select count(nid) as hn from tbl_qyyg y where qy="+session.getAttribute("qy")+" and xtzt<>3  and zt=1";
	if (dsygxm!=null && dsygxm.length()>0)
	{
		strsql+=" and y.ygxm like '%"+dsygxm+"%'";
	}
	if (dsemail!=null && dsemail.length()>0)
	{
		strsql+=" and y.email like '%"+dsemail+"%'";
	}
	if (dsbm!=null && dsbm.length()>0)
	{
		strsql+=" and y.bm like '%,"+dsbm+"%,'";
	}
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{
		ln=rs.getInt("hn");
	}
	rs.close();
	pages=(ln-1)/psize+1;
	
	if (fflx==1)
		strsql="select  y.nid,y.ygxm,y.email,y.bm from tbl_qyyg y where qy="+session.getAttribute("qy")+" and xtzt<>3  and zt=1  and bm like '%,"+lxbh+",%'";

	if (fflx==2)
		strsql="select  y.nid,y.ygxm,y.email,y.bm from tbl_qyxzmc x inner join tbl_qyyg y on x.yg=y.nid where x.xz="+lxbh+"  and y.xtzt<>3   and y.zt=1 ";
	if (fflx==0)
		strsql="select y.nid,y.ygxm,y.email,y.bm  from tbl_qyyg y where qy="+session.getAttribute("qy")+" and xtzt<>3  and zt=1 ";
	
	if (dsygxm!=null && dsygxm.length()>0)
	{
		strsql+=" and y.ygxm like '%"+dsygxm+"%'";
	}
	if (dsemail!=null && dsemail.length()>0)
	{
		strsql+=" and y.email like '%"+dsemail+"%'";
	}
	if (dsbm!=null && dsbm.length()>0)
	{
		strsql+=" and y.bm like '%,"+dsbm+"%,'";
	}
	strsql+=" order by y.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
	//out.print(strsql);
	rs=stmt.executeQuery(strsql);
	while (rs.next())
	{
	 %>
	<li>
		<div class="workersin1">
		<%if (t!=null && t.equals("0")) {%>
		<input type="checkbox" name="yg" id="yg" value="<%=rs.getInt("nid")%>" title="<%=rs.getString("ygxm")%>" />
		<%} %>
		<%if (t!=null && t.equals("1")) {%>
		<input type="radio" name="yg" id="yg" value="<%=rs.getInt("nid")%>" title="<%=rs.getString("ygxm")%>" />
		<%} %>
		</div>
		<div class="workersin2"><%=rs.getString("ygxm") %></div>
		<div class="workersin3">&nbsp;
		<%
		bmmc=rs.getString("bm");
		if (bmmc!=null && bmmc.length()>1)
		{
		strsql="select bmmc from tbl_qybm where nid="+bmmc.substring(1,bmmc.indexOf(",",1));
		rs2=stmt2.executeQuery(strsql);
		if (rs2.next())
		{out.print(rs2.getString("bmmc"));}
		rs2.close();
		}
		%>
		</div>
		<div class="workersin4"><%=rs.getString("email") %></div>
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
				out.print("<a href='javascript:void(0);' class='psel' onclick='sygagain("+i+","+t+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='sygagain("+i+","+t+")'>"+String.valueOf(i)+"</a>");
			
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
					out.print("<a href='javascript:void(0);' class='psel' onclick='sygagain("+i+","+t+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='sygagain("+i+","+t+")'>"+String.valueOf(i)+"</a>");
			}
			out.print("...");
		}
		else
		{
			for (int i=1;i<=pages;i++)
			{
				if (i==page_no)
					out.print("<a href='javascript:void(0);' class='psel' onclick='sygagain("+i+","+t+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='sygagain("+i+","+t+")'>"+String.valueOf(i)+"</a>");
			}
		}
	}
	else
	{
		for (int i=pages-5;i<=pages;i++)
		{
			if (i==0) i=1;
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='sygagain("+i+","+t+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='sygagain("+i+","+t+")'>"+String.valueOf(i)+"</a>");
		}
	}

	%>
	
	</div>
	<div class="pages-r">
	<%if (page_no>1) out.print("<h1><a href='javascript:void(0);' onclick='sygagain("+(page_no-1)+","+t+")'>上一页</a></h1>");%>
	<%if (page_no<pages) out.print("<h2><a href='javascript:void(0);' onclick='sygagain("+(page_no+1)+","+t+")'>下一页</a></h2>");%>					
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
