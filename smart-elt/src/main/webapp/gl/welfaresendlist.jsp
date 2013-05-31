<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.omg.CORBA.INTERNAL"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%

if (session.getAttribute("glqx").toString().indexOf(",13,")==-1) 
{
	out.print("<script type='text/javascript'>");
	out.print("location.href='main.jsp';");
	out.print("</script>");
	return;
}

String ffzt=request.getParameter("ffzt");
if (ffzt==null) ffzt="";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/select2css.js"></script>
<script type="text/javascript" src="js/calendar3.js"></script>
<script type="text/javascript">
function showlist()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			document.getElementById("wslist").innerHTML=response;
		}
		catch(exception){}
	}
}

function showwslist(p)
{
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "getwslist.jsp?pno="+p+"&ffzt="+document.getElementById("ffzt").value+"&sffsj="+document.getElementById("sffsj").value+"&effsj="+document.getElementById("effsj").value+"&time="+timeParam;	
		
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlist;
	xmlHttp.send(null);
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
menun=5;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Statement stmt2=conn.createStatement();
ResultSet rs2=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try{%>
	<%@ include file="head.jsp" %>	
	<div id="main">
	  	<div class="main2">
  		  	<div class="box">
				<div class="gsjf-states">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %></div>
				<div class="hjr-box3">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="125" height="30" align="center"><strong>福利券发放记录</strong></td>
						<td width="86" align="center"></td>
						<td width="90"></td>
						<td width="20" height="30" align="center"></td>
						<td width="90" valign="top"></td>
						
						<td width="90" align="right">时间：</td>
						<td width="90"><input type="text" class="input7" style="margin-top:0" name="sffsj" id="sffsj" onclick="new Calendar().show(this);" readonly="readonly" /></td>
						<td width="20" align="center">-</td>
						<td width="90"><input type="text" class="input7" style="margin-top:0" name="effsj" id="effsj" onclick="new Calendar().show(this);" readonly="readonly" /></td>
						<td width="60" align="right">状态：</td>
						<td width="90" valign="top"><div id="tm2008style">
								<select name="ffzt" id="ffzt">
									<option value="">所有</option>
									<option value="1" <%if (ffzt.equals("1")) out.print(" selected='selected'"); %>>已发放</option>
									<option value="0"  <%if (ffzt.equals("0")) out.print(" selected='selected'"); %>>未发放</option>
									<option value="-1"  <%if (ffzt.equals("-1")) out.print(" selected='selected'"); %>>已取消</option>
								</select>
						</div></td>
						<td align="right"><span class="caxun" style="margin-right:10px; margin-top:0" onclick="showwslist(1)">查询</span></td>
					  </tr>
					</table>
				</div>
				<div class="jfqffjl" id="wslist">
					<div class="jfqffjl-t">
						<div class="jfqffjl1">发放时间</div>
						<div class="jfqffjl22">福利券名称</div>
						<div class="jfqffjl33">发放名目</div>						
						<div class="jfqffjl44">发放对象/发放授权</div>
						<div class="jfqffjl55">状态</div>		
					</div>
					<ul class="jfqffjlin">
					<%
					int ln=0,pages=1;
					strsql="select count(nid) as hn from tbl_jfqff where qy="+session.getAttribute("qy")+" and ffxx=0";
					if (session.getAttribute("glqx").toString().indexOf(",13,")!=-1) {
						strsql+=" and fftype=0";
					} else if (isLeader) {
						strsql+=" and fftype>0 and ffr="+session.getAttribute("ygid");
					}
					if (ffzt!=null && ffzt.length()>0)
						strsql+=" and ffzt="+ffzt;
					rs=stmt.executeQuery(strsql);
					if (rs.next())
					{
						ln=rs.getInt("hn");
					}
					rs.close();
					pages=(ln-1)/10+1;
					
					strsql="select f.nid,f.ffsj,m1.mmmc as mc1,m2.mmmc as mc2,f.hjr,ffjf,ffzt,f.srsj,q.mc,q.hd,q.nid sid from tbl_jfqff f left join tbl_jfq q on f.jfq=q.nid left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where f.qy="+session.getAttribute("qy")+"  and f.ffxx=0";
					if (session.getAttribute("glqx").toString().indexOf(",13,")!=-1) {
						strsql+=" and f.fftype=0";
					} else if (isLeader) {
						strsql+=" and f.fftype>0 and f.ffr="+session.getAttribute("ygid");
					}
					if (ffzt!=null && ffzt.length()>0)
						strsql+=" and f.ffzt="+ffzt;
					strsql+=" order by f.nid desc limit 10";
					rs=stmt.executeQuery(strsql);
					while (rs.next())
					{
					%>
						<li>
							<div class="jfqffjlin1"><%=sf.format(rs.getDate("ffsj"))%></div>							
							<div class="jfqffjlin22"><a href="welfare2.jsp?hid=<%=rs.getString("hd")%>&sid=<%=rs.getString("sid")%>"><%=rs.getString("mc")%></a></div>
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
					<%for (int i=1;i<=pages;i++) {
					%>
					<a href="javascript:void(0);" <%if (i==1) out.print(" class='psel'"); %> onclick="showwslist(<%=i%>)"><%=i%></a>
					<%
					if (i>=6) break;
					} %>
					</div>
					<div class="pages-r">
					<%if (pages>1) out.print("<h2><a href='javascript:void(0);' onclick='showwslist(2)'>下一页</a></h2>");%>					
					</div>		
					</div>
		  	</div>
		  	<div style="clear: both; height: 25px; padding-top: 10px; ">您还可以 <a href="mywelfare.jsp" style="color: #2ea6d7">查看福利库存</a> 或者去 <a href="buywelfare.jsp" style="color: #2ea6d7">购买福利</a></div>
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