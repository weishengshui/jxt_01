<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
menun=4;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
Fun fun=new Fun();
String lid=request.getParameter("lid");
if (lid==null || lid.equals("") || !fun.sqlStrCheck(lid))
{
	response.sendRedirect("buywelfare.jsp");
	return;
}

int ln=0;
int pages=1;
int psize=12;
String pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";
try{%>
	<%@ include file="head.jsp" %>
	<div id="main">
		<div class="main2">
			<div class="jifeng-t">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %>&nbsp;&nbsp;&nbsp;&nbsp;<a href="buyintegral.jsp">立即充值&gt;&gt;</a></div>
			<div class="subnav">
				<a href="buywelfare.jsp">推荐</a>
				<%
				strsql="select nid,lmmc from tbl_jfqlm where sfxs=1 order by xswz desc";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{				
				 %>
				<a href="welfarelist.jsp?lid=<%=rs.getString("nid")%>" <%if (rs.getString("nid").equals(lid)) out.print("class='sel'"); %>><%=rs.getString("lmmc")%></a>				
				<%}
				rs.close();
				 %>				
			</div>
			<ul class="zqth">
					<%
					
					strsql="select count(nid) as hn from tbl_jfqhd where zt=1 and now()>=kssj and now()<=jssj  and lm="+lid;
					rs=stmt.executeQuery(strsql);
					if (rs.next())
					{
						ln=rs.getInt("hn");
					}
					rs.close();
					pages=(ln-1)/psize+1;
					
					strsql="select nid, hdmc,hdtp,zxjf from tbl_jfqhd where zt=1 and curdate()>=kssj and curdate()<=jssj  and lm="+lid+" order by nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
					rs=stmt.executeQuery(strsql);					
					while(rs.next())
					{
					 %>
					<li>
						<a href="welfare.jsp?hid=<%=rs.getString("nid")%>">
							<img src="../hdimg/<%=rs.getString("hdtp")%>" />
							<h1><%=rs.getString("hdmc")%></h1>
							<h2>只需&nbsp;<span><%=rs.getString("zxjf")%></span>&nbsp;积分</h2>
						</a>
					</li>
					<%					
					}
					rs.close();
					 %>
					 
				
			</ul>
			<div class="pages bianju marginleft18">
				<div class="pages-l">
				<%
					int page_no=Integer.valueOf(pno);	
					if (page_no>=5 && page_no<=pages-2)
					{
						for (int i=page_no-3;i<=page_no+2;i++)
						{
							if (i==page_no)
								out.print("<a href='welfarelist.jsp?lid="+lid+"&pno="+i+"' class='psel'>"+String.valueOf(i)+"</a>");
							else
								out.print("<a href='welfarelist.jsp?lid="+lid+"&pno="+i+"'>"+String.valueOf(i)+"</a>");
							
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
									out.print("<a href='welfarelist.jsp?lid="+lid+"&pno="+i+"'' class='psel'>"+String.valueOf(i)+"</a>");
								else
									out.print("<a href='welfarelist.jsp?lid="+lid+"&pno="+i+"'>"+String.valueOf(i)+"</a>");
							}
							out.print("...");
						}
						else
						{
							for (int i=1;i<=pages;i++)
							{
								if (i==page_no)
									out.print("<a href='welfarelist.jsp?lid="+lid+"&pno="+i+"' class='psel'>"+String.valueOf(i)+"</a>");
								else
									out.print("<a href='welfarelist.jsp?lid="+lid+"&pno="+i+"'>"+String.valueOf(i)+"</a>");
							}
						}
					}
					else
					{
						for (int i=pages-5;i<=pages;i++)
						{
							if (i==0) i=1;
							if (i==page_no)
								out.print("<a href='welfarelist.jsp?lid="+lid+"&pno="+i+"' class='psel'>"+String.valueOf(i)+"</a>");
							else
								out.print("<a href='welfarelist.jsp?lid="+lid+"&pno="+i+"'>"+String.valueOf(i)+"</a>");
						}
					}
				
					%>
	
				</div>
				<div class="pages-r">
				<%if (page_no>1) out.print("<h1><a href='welfarelist.jsp?lid="+lid+"&pno="+(page_no-1)+"'>上一页</a></h1>");%>
				<%if (page_no<pages) out.print("<h2><a href='welfarelist.jsp?lid="+lid+"&pno="+(page_no+1)+"'>下一页</a></h2>");%>						
				</div>		
			</div>
		</div>
	</div>
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