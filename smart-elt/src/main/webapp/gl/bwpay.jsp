<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
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

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
menun=4;
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
Fun fun=new Fun();
String jfqdd=request.getParameter("jid");
int wjf=0,wsl=0;
String ddsj="";
String ddbh="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
try{

	if (jfqdd!=null && jfqdd.length()>0)
	{
		if (!fun.sqlStrCheck(jfqdd))
		{
			response.sendRedirect("buywelfare.jsp");
			return;
		}
		strsql="select ddbh,ddjf,zt,ddsj from tbl_jfqdd where nid="+jfqdd;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			ddbh=rs.getString("ddbh");
			wjf=rs.getInt("ddjf");
			ddsj=sf.format(rs.getDate("ddsj"));
			
		}
		rs.close();
	}
	else
	{
		String bwpay=request.getParameter("bwpay");
		if (bwpay==null || bwpay.length()==0 || !fun.sqlStrCheck(bwpay))
		{
			response.sendRedirect("buywelfare.jsp");
			return;
		}
		
		 String gmh=request.getParameter("gmh");
		 strsql="select nid from tbl_jfqdd where gmh='"+gmh+"'";
		  rs=stmt.executeQuery(strsql);
		  if (rs.next())
		  {
			rs.close();
			out.print("<script type='text/javascript'>");
			out.print("alert('请不要重复提交!');");
			out.print("location.href='buywelfare.jsp';");
			out.print("</script>");
			return;
		  }
		  rs.close();
		  
		
		Calendar now=Calendar.getInstance();
		
		ddsj=sf.format(now.getTime());
		strsql="select ddbh from tbl_jfqdd where ddsj>='"+ddsj+"' order by nid desc limit 1";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			ddbh=rs.getString("ddbh");
		}
		rs.close();
		
		if (ddbh==null || ddbh.equals(""))
		{
			ddbh=sf.format(now.getTime());
			ddbh=ddbh.replace("-","")+"1";  	
		}
		else
		{			
			ddbh=ddbh.substring(0,8)+String.valueOf(Integer.valueOf(ddbh.substring(8))+1);			
		}
		
		//0:HR 购买, 1:部门leader购买, 2:小组leader购买, 3:部门leader(也是小组leader)购买
		int ddtype=0;
		int bmxz=0;
		if (session.getAttribute("glqx").toString().indexOf(",12,")!=-1) {
			ddtype=0;
			bmxz=0;
		} else if (isLeader) {
			String bm="";
			String xz="";
			if (session.getAttribute("ffbm") != null) {
				bm=session.getAttribute("ffbm").toString();
			}
			if (session.getAttribute("ffxz") != null) {
				xz=session.getAttribute("ffxz").toString();
			}
			boolean isBm = bm!=null && bm.length()>0 && !"''".equals(bm);
			boolean isXz = xz!=null && xz.length()>0 && !"''".equals(xz);
			if (isBm && isXz) {
				ddtype=3;
				bmxz=0;
			} else if (isBm) {
				ddtype=1;
				if (bm.indexOf(',')==-1) {
					bmxz=Integer.valueOf(bm);
				} else {
					bmxz=Integer.valueOf(bm.substring(0, bm.indexOf(',')));
				}
			} else if (isXz) {
				ddtype=2;
				if (xz.indexOf(',')==-1) {
					bmxz=Integer.valueOf(xz);
				} else {
					bmxz=Integer.valueOf(xz.substring(0, xz.indexOf(',')));
				}
			}
		}
		
		//保存订单
		strsql="insert into tbl_jfqdd (ddbh,qy,xdr,ddsj,gmh,ddtype,bmxz) values('"+ddbh+"',"+session.getAttribute("qy")+","+session.getAttribute("ygid")+",now(),'"+gmh+"',"+ddtype+","+bmxz+")";
		stmt.executeUpdate(strsql);
		
		strsql="select nid from tbl_jfqdd where ddbh='"+ddbh+"'";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			jfqdd=rs.getString("nid");
		}
		rs.close();
		
		//保存订单明细
		String[] bwarr=bwpay.split(",");
		for (int i=0;i<bwarr.length;i++)
		{
			if (bwarr[i]!=null && bwarr[i].length()>0)
			{
				if (i%2==0)
				{
					strsql="insert into tbl_jfqddmc (qy,jfqdd,jfq,sl,ddtype,xdr,bmxz) values("+session.getAttribute("qy")+","+jfqdd+","+bwarr[i]+","+bwarr[i+1]+","+ddtype+","+session.getAttribute("ygid")+","+bmxz+")";
					stmt.executeUpdate(strsql);
				}
			}
		}
		
		//取订单金额和数量并保存
		strsql="select sum(q.jf*m.sl) as wjf,sum(sl) as wsl from tbl_jfqddmc m inner join tbl_jfq q on m.jfq=q.nid where m.jfqdd="+jfqdd;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			wjf=rs.getInt("wjf");
			wsl=rs.getInt("wsl");
		}
		rs.close();
		if (wjf>0)
		{
			strsql="update tbl_jfqdd set ddsl="+wsl+",ddjf="+wjf+" where nid="+jfqdd;
			stmt.executeUpdate(strsql);
		}
		
		//清除cookie
		out.print("<script type='text/javascript'>");
		out.print("writeCookie('bwcarp','');");
		out.print("writeCookie('bwcarn','');");
		out.print("</script>");
	}
%>
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local">
					<li class="local-ico1">
						<div class="local-1"><h1>确认购买福利信息</h1><h2><%=ddsj%></h2></div>
					</li>
					<li class="local-ico2">
						<div class="local-2"><h1>支付订单金额</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li>
						<div class="local-3"><h1>交易成功</h1></div>
					</li>
				</ul>
				<div class="jfqdetail">
					<ul class="jfqdetail-in">
					    <%
					    int kyjf=0;
						String errMessage="";
						String prompt = "";
						String jf = "";
						if (session.getAttribute("glqx").toString().indexOf(",12,")!=-1) {
							kyjf=Integer.valueOf(session.getAttribute("qyjf").toString());
							errMessage="您的账户积分余额不足，请立即";
							prompt = "您的账户积分余额";
							jf = session.getAttribute("qyjf").toString();
						} else if (isLeader){
							String ffbm = session.getAttribute("ffbm").toString();
						    if ("''".equals(ffbm)) {
						    	ffbm = "-1";
						    }
						    String ffxz = session.getAttribute("ffxz").toString();
						    if ("''".equals(ffxz)) {
						    	ffxz = "-1";
						    }
							strsql="select sum(x.jf-x.yffjf) from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid where ((x.fflx=1 and x.lxbh in ("+ffbm+")) or (x.fflx=2 and x.lxbh in ("+ffxz+"))) and x.jf<>x.yffjf  and f.ffzt=1 and f.fftype>0";			
							
							rs=stmt.executeQuery(strsql);
							if (rs.next())
							{
								kyjf=rs.getInt(1);
							}
							rs.close();
							errMessage="您的账户自购积分余额不足，请立即";
							prompt = "您的账户自购积分余额";
							jf = String.valueOf(kyjf);
						}
					    %>
						<li><h1><%=prompt %></h1><h2><%=jf%></h2></li>
						<li><h3>订单<%=ddbh%> 共需要支付 <span><%=wjf%></span> 积分</h3></li>
					</ul>
				</div>
				<%if (kyjf<wjf) {%>
				<div class="buyjf"><%=errMessage %> <a href="buyintegral.jsp">购买积分&gt;&gt; </a></div>
				<a href="#" class="buybtn2"></a>
				<%}%><%else {%><div class="buyjf">&nbsp;</div><a href="bwpayed.jsp?jid=<%=jfqdd%>" class="buybtn"></a><%} %>
			</div>
	  	</div>
	</div>
	
	<%@ include file="footer.jsp" %>
	<%
	
}
  catch(Exception e)
{			
	e.printStackTrace();
	conn.rollback();
	conncommit=0;
}
finally
{
	if (!conn.isClosed())
	{	
		if (conncommit==1)
			conn.commit();
		conn.close();
	}
}
	 %>
</body>
</html>