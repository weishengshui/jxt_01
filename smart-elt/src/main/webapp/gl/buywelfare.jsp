<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.omg.CORBA.INTERNAL"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",12,")==-1 && !isLeader) 
	response.sendRedirect("main.jsp");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
function showlist()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			document.getElementById("bwlist").innerHTML=response;
		}
		catch(exception){}
	}
}

function showbwlist(p)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "getbwlist.jsp?pno="+p+"&jfqmc="+encodeURI(escape(document.getElementById("jfqmc").value))+"&time="+timeParam;	
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlist;
	xmlHttp.send(null);
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
menun=4;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
try{%>
	<%@ include file="head.jsp" %>
	<div id="main">
		<div class="main2">
		    <%if (isAuth) {%>
			<div class="jifeng-t"><span class="floatleft txtsize14">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %>&nbsp;&nbsp;&nbsp;&nbsp;<a href="buyintegral.jsp">立即充值&gt;&gt;</a></span><span class="jifeng-t-r"></span></div>
			<%} %>
			<div class="subnav">
				<a href="buywelfare.jsp" class="sel">推荐</a>
				<%
				ArrayList lmid=new ArrayList();
				ArrayList lmmc=new ArrayList();
				int j=1,k=1;
				strsql="select nid,lmmc from tbl_jfqlm where sfxs=1 order by xswz desc";
				rs=stmt.executeQuery(strsql);
				while (rs.next())
				{
				lmid.add(rs.getString("nid"));
				lmmc.add(rs.getString("lmmc"));
				 %>
				<a href="welfarelist.jsp?lid=<%=rs.getString("nid")%>"><%=rs.getString("lmmc")%></a>				
				<%}
				rs.close();
				 %>
			</div>
			<%
			for (int i=0;i<lmid.size();i++)
			{
			 %>
			<div class="tjlist<%=k%>">
				<div class="tjlist<%=k%>-t"><span><%=lmmc.get(i)%></span><a href="welfarelist.jsp?lid=<%=lmid.get(i)%>">更多&gt;&gt;</a></div>
				<ul>
					<%strsql="select nid, hdmc,hdtp,zxjf from tbl_jfqhd where zt=1 and now()>=kssj and now()<=jssj and tj=1 and lm="+lmid.get(i)+" order by nid limit 4";
					rs=stmt.executeQuery(strsql);
					j=1;
					while(rs.next())
					{
					 %>
					<li <%if (j==4) out.print(" class=\"lastone\""); %>>
						<a href="welfare.jsp?hid=<%=rs.getString("nid")%>">
							<img src="../hdimg/<%=rs.getString("hdtp")%>" />
							<h1><%=rs.getString("hdmc")%></h1>
							<h2>只需&nbsp;<span><%=rs.getString("zxjf")%></span>&nbsp;积分</h2>
						</a>
					</li>
					<%
					j++;
					}
					rs.close();
					 %>
					
				</ul>
			</div>
			<%
			k++;
			if (k==4) k=1;
			} 
			if (session.getAttribute("glqx").toString().indexOf(",12,")!=-1) {
			%>
			<div class="cx">
				<h1>未发放福利券</h1><span>关键字：</span><input type="text" class="cxinput" name="jfqmc" id="jfqmc" value=""/><span class="floatleft"><a href="javascript:void(0);" class="caxun" onclick="showbwlist(1)">查 询</a></span>
				<a href="welfareorder.jsp" class="cx-r">购买记录&gt;&gt;</a>
			</div>
			<div class="jftable" id="bwlist">
				<div class="jftable-t">
					<div class="jf1">福利券</div>
					<div class="jf2">数量(张)</div>
					<div class="jf3">积分金额</div>
					<div class="jf4">操作</div>
				</div>
				<ul class="jfin">
					<%
					int ln=0,pages=0;
					strsql="select count(*) as hn from (select m.jfq from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where m.qy="+session.getAttribute("qy")+" and m.ddtype=0 and m.zt=1 and m.sl<>m.ffsl and q.yxq >= curdate() group by m.jfq,q.mc,q.jf) abc";
					rs=stmt.executeQuery(strsql);
					if (rs.next())
					{ln=rs.getInt("hn");}
					rs.close();
					pages=(ln-1)/10+1;
					
					strsql="select q.yxq,m.jfq,sum(m.sl-m.ffsl) as sysl,q.mc,q.nid sid,q.hd hid,q.jf from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where m.qy="+session.getAttribute("qy")+" and m.ddtype=0 and m.zt=1 and m.sl<>m.ffsl and q.yxq >= curdate() group by m.jfq,q.mc,q.jf";
					rs=stmt.executeQuery(strsql);
					while(rs.next())
					{
					%>
					<li>
						<div class="jfin1"><a href="welfare2.jsp?hid=<%=rs.getString("hid")%>&sid=<%=rs.getString("sid")%>"><%=rs.getString("mc")%></a></div>
						<div class="jfin2"><%=rs.getInt("sysl")%></div>
						<div class="jfin3"><%=rs.getInt("jf")%></div>
						<div class="jfin4">
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
  				       </div>					
					</li>
					<%
					}
					rs.close();
					%>
					
				</ul>
				<div class="pages bianju">
				<div class="pages-l">
				<%for (int i=1;i<=pages;i++) {
				%>
				<a href="javascript:void(0);" <%if (i==1) out.print(" class='psel'"); %> onclick="showbwlist(<%=i%>)"><%=i%></a>
				<%
				if (i>=6) break;
				} %>
				</div>
				<div class="pages-r">
				<%if (pages>1) out.print("<h2><a href='javascript:void(0);' onclick='showbwlist(2)'>下一页</a></h2>");%>					
				</div>
			</div>
			</div>
			<%
			} else if (isLeader) {
			%>
			<div class="cx">
				<h1>未发放福利券</h1>
				<a href="welfareorder.jsp" class="cx-r">购买记录&gt;&gt;</a>
			</div>
			<div class="jftable" style="margin:3px 0 20px 8px;"  id="bwlist">
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
					SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
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
			<%
			}
			%>
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