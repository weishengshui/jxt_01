<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<style>
<!--
	.myjf #jfxx {
		background-color: #F9F2BA;
	    border: 1px solid #E9D315;
	    border-radius: 4px 4px 4px 4px;
	    color: #5B5316;
	    padding: 2px 10px;
	    position: absolute;
	    top: 63px;
	    min-width: 100px;
	    white-space: nowrap;
	    display: none;
	}
	.myjf #jfxx span {
		color: red;
	}
-->
</style>
<script type="text/javascript">
var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F399d3e1eb0a5e112f309a8b6241d62fe' type='text/javascript'%3E%3C/script%3E"));

function goShopping() {
	document.getElementById("hrflsc").submit();
}

function reftopjfxx(hrffjf, gmjf) {
	if (hrffjf) {
		document.getElementById("hrffjf").innerHTML=hrffjf;
	}
	if (gmjf) {
		document.getElementById("gmjf").innerHTML=gmjf;
	}
}

function showjfxx() {
	var jfDetailDiv = document.getElementById("jfxx");
	var headjfWidth = document.getElementById("headjf").clientWidth;
	jfDetailDiv.style.display = "block";
	var jfDetailWidth = jfDetailDiv.offsetWidth;
	var parentWidth = jfDetailDiv.parentElement.clientWidth;
	if (headjfWidth > jfDetailWidth) {
		jfDetailDiv.style.left = (parentWidth - headjfWidth)+"px";
	} else {
		jfDetailDiv.style.left = (parentWidth - jfDetailWidth - 10)+"px";
	}
}
function hidejfxx() {
	document.getElementById("jfxx").style.display = "none";
	
}

var markit = function(){
    if (document.all){
       window.external.addFavorite('http://www.irewards.cn','IRewards');
    } else if (window.sidebar){
       window.sidebar.addPanel('IRewards', 'http://www.irewards.cn', "");
    } else {
        alert("加入收藏失败，请使用Ctrl+D进行添加");
    }
 };
</script>

<%!
void getjfxx(java.sql.Statement stmt, HttpSession session) {
	    String ffbm = session.getAttribute("ffbm").toString();
	    if ("''".equals(ffbm)) {
	    	ffbm = "-1";
	    }
	    String ffxz = session.getAttribute("ffxz").toString();
	    if ("''".equals(ffxz)) {
	    	ffxz = "-1";
	    }
		String sql = "(select sum(x.jf-x.yffjf) from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid where ((x.fflx=1 and x.lxbh in ("
				+ ffbm + ")) or (x.fflx=2 and x.lxbh in (" + ffxz + "))) and x.jf<>x.yffjf  and f.ffzt=1 and f.fftype = 0)"
				+ "UNION ALL (select sum(x.jf-x.yffjf) from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid where ((x.fflx=1 and x.lxbh in ("
				+ ffbm + ")) or (x.fflx=2 and x.lxbh in (" + ffxz + "))) and x.jf<>x.yffjf  and f.ffzt=1 and f.fftype > 0)";
		java.sql.Connection conn = null;
		try {
			if (stmt == null) {
				conn = jxt.elt.common.DbPool.getInstance().getConnection();
				stmt = conn.createStatement();
			}
			java.sql.ResultSet rs = stmt.executeQuery(sql);
			int hrffjf = 0;
			int gmjf = 0;
			if (rs.next()) {
				hrffjf = rs.getInt(1);
				if (rs.next()) {
					gmjf = rs.getInt(1);
				}
			}
			session.setAttribute("hrffjf", String.valueOf(hrffjf));
			session.setAttribute("gmjf", String.valueOf(gmjf));
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (conn != null && !conn.isClosed()) {
					conn.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
%>
<div id="headmain">
		<div class="head">
			<div class="top">
				<p>您好，<a href="main.jsp"><%=session.getAttribute("ygxm")%></a>！欢迎来到<span style="font-weight: bold;"><%=session.getAttribute("qymc")%></span>弹性福利与奖励平台！【<a href="logout.jsp">退出</a>】</p>
				<div class="top-right">
					<span><a href="bwconfirm.jsp"><img src="images/ico2.jpg" /></a></span>
					<h1 id="jfqcar">(0)</h1>
					<span><img src="images/ico1.jpg" /></span>
					<h1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h1>
					<span><img src="images/ico1.gif" /></span>
					<h1><a href="#" onclick="markit();">收藏本站</a></h1>
				</div>
			</div>	
			<div class="logo">
			<!--  
				<img src="../<%=((session.getAttribute("qylog")==null||"".equals(session.getAttribute("qylog")))?(request.getContextPath()+"/images/IReward-logo-white2.jpg"):(session.getAttribute("qylog")))%>" />
				<img style="width:200px;height:75px;" src="../images/IReward-logo-white2.jpg">
			-->
				<img style="width:200px;height:75px;" src="../<%=((session.getAttribute("qylog")==null||"".equals(session.getAttribute("qylog")))?(request.getContextPath()+"/images/IReward-logo-white2.jpg"):(session.getAttribute("qylog")))%>" />
				<img src="images/logo3.jpg" />
				<img src="images/logo2.jpg" />
				<div class="myjf" style="position:relative;">
					<h1>我的<br />积分</h1>
					<ul id="headjf" <%if(session.getAttribute("ffjf")!=null && session.getAttribute("ffjf").equals("1")){%>onmouseover="showjfxx()" onmouseout="hidejfxx()"<%}%>>
						<%String qyjf=session.getAttribute("qyjf").toString();
						 if(qyjf.equals("0"))
						 {
							 out.print("<li></li>");
							 out.print("<li></li>");
							 out.print("<li></li>");
							 out.print("<li>0</li>");
						 }
						 else
						 {
							 for (int i=1;i<=qyjf.length();i++)
							 {
								 out.print("<li>"+qyjf.substring(i-1,i)+"</li>");
							 }
						 }
						%>
					</ul>
					<div id="jfxx">
						HR发放积分数:<span id="hrffjf"><%=session.getAttribute("hrffjf") != null ? session.getAttribute("hrffjf").toString() : "0"%></span><br/>
						自行购买积分数:<span id="gmjf"><%=session.getAttribute("gmjf") != null ? session.getAttribute("gmjf").toString() : "0"%></span>
					</div>
				</div>
			</div>
			<div class="nav">
				<ul>
					<li><a href="main.jsp" <%if (menun==1) out.print(" class='nowone'"); %>>我的首页</a></li>
					<%if (session.getAttribute("glqx").toString().indexOf(",10,")>-1 || session.getAttribute("ffjf")!=null) {%><li><a href="buyintegral.jsp"  <%if (menun==2) out.print(" class='nowone'"); %>>购买积分</a></li><%} %>
					<%if (session.getAttribute("glqx").toString().indexOf(",11,")>-1 || session.getAttribute("ffjf")!=null) {%><li><a href="assignintegral.jsp" <%if (menun==3) out.print(" class='nowone'"); %>>发放积分</a></li><%} %>
					<%if (session.getAttribute("glqx").toString().indexOf(",12,")>-1 || session.getAttribute("ffjf")!=null) {%><li><a href="buywelfare.jsp" <%if (menun==4) out.print(" class='nowone'"); %>>购买福利</a></li><%} %>
					<%if (session.getAttribute("glqx").toString().indexOf(",13,")>-1 || session.getAttribute("ffjf")!=null) {%><li><a href="mywelfare.jsp" <%if (menun==5) out.print(" class='nowone'"); %>>发放福利</a></li><%} %>
					<li><a href="#" onclick="goShopping();">福利商城</a></li>
					<%if (session.getAttribute("glqx").toString().indexOf(",1,")>-1) {%>
						<li><a href="admin.jsp" <%if (menun==6) out.print(" class='nowone'"); %>>账户设置</a></li>
					<%} else if (session.getAttribute("glqx").toString().indexOf(",2,")>-1) {%>
						<li><a href="company.jsp" <%if (menun==6) out.print(" class='nowone'"); %>>账户设置</a></li>
					<%}else if (session.getAttribute("glqx").toString().indexOf(",3,")>-1) {%>
						<li><a href="department.jsp" <%if (menun==6) out.print(" class='nowone'"); %>>账户设置</a></li>
					<%}else if (session.getAttribute("glqx").toString().indexOf(",4,")>-1) {%>
						<li><a href="staff.jsp" <%if (menun==6) out.print(" class='nowone'"); %>>账户设置</a></li>
					<%}else if (session.getAttribute("glqx").toString().indexOf(",5,")>-1) {%>
						<li><a href="group.jsp" <%if (menun==6) out.print(" class='nowone'"); %>>账户设置</a></li>
					<%}else if (session.getAttribute("glqx").toString().indexOf(",6,")>-1) {%>
						<li><a href="item.jsp" <%if (menun==6) out.print(" class='nowone'"); %>>账户设置</a></li>
					<%}else if (session.getAttribute("glqx").toString().indexOf(",7,")>-1) {%>
						<li><a href="info.jsp" <%if (menun==6) out.print(" class='nowone'"); %>>账户设置</a></li>
					<%} %>
					<%if (session.getAttribute("glqx").toString().indexOf(",14,")>-1) {
						String nid = session.getAttribute("ygid").toString();
						String qyid = session.getAttribute("qy").toString();
						String url = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/eltcustom/sp!base2.do";
					%>
					<!--
					<li><a href="ddlist.jsp" <%if (menun==7) out.print(" class='nowone'"); %>>企业物流订单</a></li>
					-->
					<form action="<%=url %>" name="hrflsc" id="hrflsc" method="post">
						<input type="hidden" name="hrqyjf" id="hrqyjf" value="<%=qyjf %>" />
						<input type="hidden" name="hrygid" id="hrygid" value="<%=nid %>" />
						<input type="hidden" name="hrqyid" id="hrqyid" value="<%=qyid %>" />
						<input type="hidden" name="hrygxm" id="hrygxm" value="<%=session.getAttribute("ygxm") %>" />
					</form>
					<%} %>
				</ul>
			</div>			
		</div>
	</div>