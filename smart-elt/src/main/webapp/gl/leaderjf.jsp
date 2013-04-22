<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.omg.CORBA.INTERNAL"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
menun=3;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try{%>
	<%@ include file="head.jsp" %>	
	<div id="main">
	  	<div class="main2">
  		  	<div class="box">
				
				<div class="selectsend-top">
					<h1>您要发放的积分</h1>
				</div>
				<div class="jftable" style="margin:3px 0 0 8px;"  id="bwlist">
					<div class="jftable-t">
						<div class="ljf1">接收日期</div>
						<div class="ljf2">名目</div>
						<div class="ljf3">发放对象</div>
						<div class="ljf4">发放备注</div>
						<div class="ljf5">总积分</div>
						<div class="ljf6">已发积分</div>										
						<div class="ljf7"></div>
					</div>
					<ul class="jfin">
						<%
					int ln=0,pages=0;
										
					strsql="select x.nid,x.jsmc,f.ffsj,f.bz,m1.mmmc as mc1,m2.mmmc as mc2,x.jf,x.fflx,x.lxbh,x.yffjf from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where ((x.fflx=1 and x.lxbh in ("+session.getAttribute("ffbm")+")) or (x.fflx=2 and x.lxbh in ("+session.getAttribute("ffxz")+"))) and x.jf<>x.yffjf  and f.ffzt=1 order by f.ffsj desc";
					
					rs=stmt.executeQuery(strsql);
					
					while(rs.next())
					{						
					%>
					<li>
						<div class="ljfin1"><%=sf.format(rs.getDate("ffsj"))%></div>
						<div class="ljfin2"><%if (rs.getString("mc2")!=null) out.print(rs.getString("mc2")); else out.print(rs.getString("mc1"));%></div>
						<div class="ljfin3">&nbsp;<%=rs.getString("jsmc")==null?"":rs.getString("jsmc")%></div>
						<div class="ljfin4" title="<%=rs.getString("bz")%>">&nbsp;<%=rs.getString("bz")%></div>
						<div class="ljfin5"><%=rs.getInt("jf")%></div>
						<div class="ljfin6"><%=rs.getInt("yffjf")%></div>							
						<div class="ljfin7"><a href="leaderai.jsp?xid=<%=rs.getString("nid")%>"><img src="images/fafang.jpg" /></a></div>					
					</li>
					<%}
					rs.close();
					%>
					</ul>
					
				</div>
				<div style="clear: both; height: 25px; padding-top:10px; font-weight: bold;"><a href="leaderjfsendlist.jsp" style="color:#2ea6d7;">积分发放记录>></a></div>
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