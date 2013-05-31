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
menun=5;
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
					<h1>您要发放的福利</h1>
				</div>
				<div class="jftable" style="margin:3px 0 0 8px;"  id="bwlist">
					<div class="jftable-t">						
						<div class="ljf1">接收日期</div>
						<div class="ljf2">名目</div>
						<div class="ljf3">发放对象</div>
						<div class="ljf41">发放备注</div>
						<div class="ljf42">福利券名称</div>
						<div class="ljf5">总数量</div>
						<div class="ljf6">已发数量</div>										
						<div class="ljf7"></div>
					</div>
					<ul class="jfin">
						<%
					int ln=0,pages=0;
						String ffbm = session.getAttribute("ffbm").toString();
					    if ("''".equals(ffbm)) {
					    	ffbm = "-1";
					    }
					    String ffxz = session.getAttribute("ffxz").toString();
					    if ("''".equals(ffxz)) {
					    	ffxz = "-1";
					    }
					strsql="select x.nid,x.jsmc,f.ffsj,f.jfq,f.bz,m1.mmmc as mc1,m2.mmmc as mc2,x.jf,x.fflx,x.lxbh,x.yffjf,q.mc from tbl_jfqffxx x inner join tbl_jfqff f on x.jfqff=f.nid left join tbl_jfq q on f.jfq=q.nid left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where ((x.fflx=1 and x.lxbh in ("+ffbm+")) or (x.fflx=2 and x.lxbh in ("+ffxz+"))) and x.jf<>x.yffjf  and f.ffzt=1  order by x.nid desc";
					
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
							mmmc="购买福利券";
						}
						
						bz=rs.getString("bz")==null?"":rs.getString("bz");
					%>
					<li>
						<div class="ljfin1"><%=sf.format(rs.getDate("ffsj"))%></div>
						<div class="ljfin2"><%=mmmc%></div>
						<div class="ljfin3"><%=rs.getString("jsmc")%></div>
						<div class="ljfin41" title="<%=bz%>">&nbsp;<%=bz%></div>
						<div class="ljfin42"><%=rs.getString("mc")%></div>
						<div class="ljfin5"><%=rs.getInt("jf")%></div>
						<div class="ljfin6"><%=rs.getInt("yffjf")%></div>							
						<div class="ljfin7"><a href="leaderaw.jsp?xid=<%=rs.getString("nid")%>&qid=<%=rs.getString("jfq")%>"><img src="images/fafang.jpg" /></a></div>					
					</li>
					<%}
					rs.close();
					%>
					</ul>
					
				</div>
				<div style="clear: both; height: 25px; padding-top:10px; font-weight: bold;"><a href="leaderwsendlist.jsp" style="color:#2ea6d7;">福利券发放记录>></a></div>
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