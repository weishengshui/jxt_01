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
						String ffbm = session.getAttribute("ffbm").toString();
					    if ("''".equals(ffbm)) {
					    	ffbm = "-1";
					    }
					    String ffxz = session.getAttribute("ffxz").toString();
					    if ("''".equals(ffxz)) {
					    	ffxz = "-1";
					    }
					    
						strsql="select nid,jsmc,ffsj,sum(jf) as zjf,sum(yffjf) as zffjf from (select x.nid,x.jsmc,f.ffsj,x.jf,x.yffjf from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid where (f.mm1 is null or f.mm1=0) and f.mm2=0 and ((x.fflx=1 and x.lxbh in ("+ffbm+")) or (x.fflx=2 and x.lxbh in ("+ffxz+"))) and f.ffzt=1 order by f.ffsj desc) as temp";
						rs=stmt.executeQuery(strsql);
						// add "rs.getString("nid") != null" condition because there is one record that all column values are null when the above sub query returns no record
						if (rs.next() && rs.getString("nid") != null && rs.getInt("zjf") > rs.getInt("zffjf")) {
						%>
						<li>
						<div class="ljfin1"><%=sf.format(rs.getDate("ffsj"))%></div>
						<div class="ljfin2">购买积分</div>
						<div class="ljfin3">&nbsp;<%=rs.getString("jsmc")==null?"":rs.getString("jsmc")%></div>
						<div class="ljfin4">&nbsp;</div>
						<div class="ljfin5"><%=rs.getInt("zjf")%></div>
						<div class="ljfin6"><%=rs.getInt("zffjf")%></div>							
						<div class="ljfin7"><a href="leaderai.jsp?xid=<%=rs.getString("nid")%>"><img src="images/fafang.jpg" /></a></div>					
					</li>
						<%
						}
						rs.close();
						
						
					strsql="select x.nid,x.jsmc,f.ffsj,f.bz,m1.mmmc as mc1,m2.mmmc as mc2,x.jf,x.fflx,x.lxbh,x.yffjf from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where f.mm1 is not null and f.mm1>0 and ((x.fflx=1 and x.lxbh in ("+ffbm+")) or (x.fflx=2 and x.lxbh in ("+ffxz+"))) and x.jf<>x.yffjf  and f.ffzt=1 order by f.ffsj desc";
					
					rs=stmt.executeQuery(strsql);
					
					String mmmc="";
					String bz="";
					while(rs.next())
					{
						if (rs.getString("mc2")!=null) {
							mmmc=rs.getString("mc2");
						} else if (rs.getString("mc1")!=null) {
							mmmc=rs.getString("mc1");
						} else {
							mmmc="购买积分";
						}
						
						bz=rs.getString("bz")==null?"":rs.getString("bz");
					%>
					<li>
						<div class="ljfin1"><%=sf.format(rs.getDate("ffsj"))%></div>
						<div class="ljfin2"><%=mmmc%></div>
						<div class="ljfin3">&nbsp;<%=rs.getString("jsmc")==null?"":rs.getString("jsmc")%></div>
						<div class="ljfin4" title="<%=bz%>">&nbsp;<%=bz%></div>
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