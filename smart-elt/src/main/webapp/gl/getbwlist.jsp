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

<div class="jftable-t">
	<%
	    String flag = request.getParameter("flag");
		if("fmfl".equals(flag)){
	%>
		<div class="jf1">福利券</div>
		<div class="jf2">数量(张)</div>
		<div class="jf2">冻结(张)</div>
		<div class="jf3">单价(积分)</div>
		<div class="jf5">有效期</div>
		<div class="jf4">操作</div>
	<%			
		}else{
	%>
		<div class="jf1">福利券</div>
		<div class="jf2">数量(张)</div>
		<div class="jf3">积分金额</div>
		<div class="jf4">操作</div>
	<%
		}
	%>
</div>
<ul class="jfin">
<%
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
int ln=0;
int pages=1;
int psize=10;
String jfqmc=request.getParameter("jfqmc");
String pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";
if (jfqmc!=null)
{
	jfqmc=fun.unescape(jfqmc);
	jfqmc=URLDecoder.decode(jfqmc,"utf-8");
}

if (!fun.sqlStrCheck(jfqmc) || !fun.sqlStrCheck(pno))
{	
	return;
}
try
{
	SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
	String ffbm = session.getAttribute("ffbm").toString();
    if ("''".equals(ffbm)) {
    	ffbm = "-1";
    }
    String ffxz = session.getAttribute("ffxz").toString();
    if ("''".equals(ffxz)) {
    	ffxz = "-1";
    }
	if("fmfl".equals(flag)){
		strsql="select count(*) as hn from (select m.jfq from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where m.qy="+session.getAttribute("qy")+" and m.zt=1 and m.sl<>m.ffsl and q.yxq >= curdate()";
	}else{
		strsql="select count(*) as hn from (select m.jfq from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where m.qy="+session.getAttribute("qy")+" and m.zt=1 and m.sl<>m.ffsl";
	}
	
	if (session.getAttribute("glqx").toString().indexOf(",12,")!=-1) {
		strsql+=" and m.ddtype=0";
	} else if (isLeader) {
		strsql+=" and m.ddtype>0 and ((m.ddtype=1 and m.bmxz in ("+ffbm+")) or (m.ddtype=2 and m.bmxz in ("+ffxz+")) or (m.ddtype=3 and m.xdr="+session.getAttribute("ygid")+"))";
	}
	
	if (jfqmc!=null && jfqmc.length()>0)
		strsql+=" and q.mc like '%"+jfqmc+"%'";	
	strsql+=" group by m.jfq,q.mc,q.jf) abc";	
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{ln=rs.getInt("hn");}
	rs.close();
	pages=(ln-1)/psize+1;
	
	if("fmfl".equals(flag)){
		strsql="select q.yxq,m.jfq,sum(m.sl-m.ffsl) as sysl,sum(m.djsl) as djsl,q.nid sid,q.hd hid,q.mc,q.jf from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where m.qy="+session.getAttribute("qy")+" and m.zt=1 and m.sl<>m.ffsl and q.yxq >= curdate()";
	}else{
		strsql="select q.yxq,m.jfq,sum(m.sl-m.ffsl) as sysl,sum(m.djsl) as djsl,q.nid sid,q.hd hid,q.mc,q.jf from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where m.qy="+session.getAttribute("qy")+" and m.zt=1 and m.sl<>m.ffsl";
	}
	if (session.getAttribute("glqx").toString().indexOf(",12,")!=-1) {
		strsql+=" and m.ddtype=0";
	} else if (isLeader) {
		strsql+=" and m.ddtype>0 and ((m.ddtype=1 and m.bmxz in ("+ffbm+")) or (m.ddtype=2 and m.bmxz in ("+ffxz+")) or (m.ddtype=3 and m.xdr="+session.getAttribute("ygid")+"))";
	}
	if (jfqmc!=null && jfqmc.length()>0)
		strsql+=" and q.mc like '%"+jfqmc+"%'";
	strsql+=" group by m.jfq,q.mc,q.jf order by m.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
	
	rs=stmt.executeQuery(strsql);
	while (rs.next())
	{
	 %>
	<li>
		<div class="jfin1"><a href="welfare2.jsp?hid=<%=rs.getString("hid")%>&sid=<%=rs.getString("sid")%>"><%=rs.getString("mc")%></a></div>
		<div class="jfin2"><%=rs.getInt("sysl")%></div>
		<%
			if("fmfl".equals(flag)){
		%>
			<div class="jfin2"><%=rs.getInt("djsl")%></div>
		<%
			}
		%>
		<div class="jfin3"><%=rs.getInt("jf")%></div>
		<%
			if("fmfl".equals(flag)){
		%>
			<div class="jfin5"><%=rs.getDate("yxq")%></div>
		<%
			}
		%>
		<div class="jfin4">
			<%
				if("fmfl".equals(flag)){
			%>
				<a href="assignwelfare.jsp?qid=<%=rs.getString("jfq")%>"><img src="images/fafang.jpg" /></a>
			<%
				}else{
			%>
					<%
						if(rs.getDate("yxq").after(new Date())){
					%>
						<a href="assignwelfare.jsp?qid=<%=rs.getString("jfq")%>"><img src="images/fafang.jpg" /></a>
					<%
						}else{
					%>
						已过期
					<%
						}
					%>
			<%				
				}
			%>
		</div>					
	</li>
	<%}
	rs.close();
	 %>
	 </ul>
	<div class="pages bianju">
	<div class="pages-l">
	<%
	int page_no=Integer.valueOf(pno);	
	if (page_no>=5 && page_no<=pages-2)
	{
		for (int i=page_no-3;i<=page_no+2;i++)
		{
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='showbwlist("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='showbwlist("+i+")'>"+String.valueOf(i)+"</a>");
			
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
					out.print("<a href='javascript:void(0);' class='psel' onclick='showbwlist("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='showbwlist("+i+")'>"+String.valueOf(i)+"</a>");
			}
			out.print("...");
		}
		else
		{
			for (int i=1;i<=pages;i++)
			{
				if (i==page_no)
					out.print("<a href='javascript:void(0);' class='psel' onclick='showbwlist("+i+")'>"+String.valueOf(i)+"</a>");
				else
					out.print("<a href='javascript:void(0);' onclick='showbwlist("+i+")'>"+String.valueOf(i)+"</a>");
			}
		}
	}
	else
	{
		for (int i=pages-5;i<=pages;i++)
		{
			if (i==0) i=1;
			if (i==page_no)
				out.print("<a href='javascript:void(0);' class='psel' onclick='showbwlist("+i+")'>"+String.valueOf(i)+"</a>");
			else
				out.print("<a href='javascript:void(0);' onclick='showbwlist("+i+")'>"+String.valueOf(i)+"</a>");
		}
	}

	%>
	
	</div>
	<div class="pages-r">
	<%if (page_no>1) out.print("<h1><a href='javascript:void(0);' onclick='showbwlist("+(page_no-1)+")'>上一页</a></h1>");%>
	<%if (page_no<pages) out.print("<h2><a href='javascript:void(0);' onclick='showbwlist("+(page_no+1)+")'>下一页</a></h2>");%>					
	</div>
	<%
		if("fmfl".equals(flag)){
	%>
	<div style="clear: both; height: 25px; padding-top:10px; font-weight: bold;"><a href="welfaresendlist.jsp" style="color:#2ea6d7;">福利券发放记录>></a></div>
	<%
		}	
	%>
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
