<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<script type="text/javascript">
var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F399d3e1eb0a5e112f309a8b6241d62fe' type='text/javascript'%3E%3C/script%3E"));
</script>

<div id="headmain">
		<div class="head">
			<div class="top">
				<p>您好，<a href="main.jsp"><%=session.getAttribute("ygxm")%></a>！欢迎来到<%=session.getAttribute("qymc")%>员工积分平台！【<a href="logout.jsp">退出</a>】</p>
				<div class="top-right">
					<span><a href="bwconfirm.jsp"><img src="images/ico2.jpg" /></a></span>
					<h1 id="jfqcar">(0)</h1>
					<span><img src="images/ico1.jpg" /></span>
					<h1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h1>
					<span><img src="images/ico1.gif" /></span>
					<h1><a href="#">收藏本站</a></h1>
				</div>
			</div>	
			<div class="logo">
				<img src="../<%=((session.getAttribute("qylog")==null||"".equals(session.getAttribute("qylog")))?(request.getContextPath()+"/images/IReward_LOGO-black.jpg"):(session.getAttribute("qylog")))%>" />
				<img src="images/logo3.jpg" />
				<img src="images/logo2.jpg" />
				<div class="myjf">
					<h1>我的<br />积分</h1>
					<ul id="headjf">
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
				</div>
			</div>
			<div class="nav">
				<ul>
					<li><a href="main.jsp" <%if (menun==1) out.print(" class='nowone'"); %>>我的首页</a></li>
					<%if (session.getAttribute("glqx").toString().indexOf(",10,")>-1) {%><li><a href="buyintegral.jsp"  <%if (menun==2) out.print(" class='nowone'"); %>>购买积分</a></li><%} %>
					<%if (session.getAttribute("glqx").toString().indexOf(",11,")>-1 || session.getAttribute("ffjf")!=null) {%><li><a href="assignintegral.jsp" <%if (menun==3) out.print(" class='nowone'"); %>>发放积分</a></li><%} %>
					<%if (session.getAttribute("glqx").toString().indexOf(",12,")>-1) {%><li><a href="buywelfare.jsp" <%if (menun==4) out.print(" class='nowone'"); %>>购买福利</a></li><%} %>
					<%if (session.getAttribute("glqx").toString().indexOf(",13,")>-1 || session.getAttribute("ffjf")!=null) {%><li><a href="mywelfare.jsp" <%if (menun==5) out.print(" class='nowone'"); %>>发放福利</a></li><%} %>
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
					
				</ul>
			</div>			
		</div>
	</div>