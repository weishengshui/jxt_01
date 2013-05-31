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
window.history.forward(1);
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
String strsql="",ddsj="",ddbh="",ddjf="";
Fun fun=new Fun();
String jfqdd=request.getParameter("jid");
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
int nowzt=0;
try{

	if (jfqdd!=null && jfqdd.length()>0)
	{
		if (!fun.sqlStrCheck(jfqdd))
		{
			response.sendRedirect("buywelfare.jsp");
			return;
		}
		
		
		
		strsql="select ddbh,ddjf,zt,ddsj,ddtype from tbl_jfqdd where nid="+jfqdd;
		rs=stmt.executeQuery(strsql);
		int ddtype=0;
		if (rs.next())
		{
			ddjf=rs.getString("ddjf");
			ddsj=sf.format(rs.getDate("ddsj"));
			nowzt=rs.getInt("zt");
			ddtype=rs.getInt("ddtype");
		}
		rs.close();
		
		int kyjf=0;
		boolean isGly=session.getAttribute("glqx").toString().indexOf(",12,")!=-1;
		String ffbm = session.getAttribute("ffbm").toString();
	    if ("''".equals(ffbm)) {
	    	ffbm = "-1";
	    }
	    String ffxz = session.getAttribute("ffxz").toString();
	    if ("''".equals(ffxz)) {
	    	ffxz = "-1";
	    }
		if (isGly) {
			kyjf=Integer.valueOf(session.getAttribute("qyjf").toString());
		} else if (isLeader){
			
			strsql="select sum(x.jf-x.yffjf) from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid where ((x.fflx=1 and x.lxbh in ("+ffbm+")) or (x.fflx=2 and x.lxbh in ("+ffxz+"))) and x.jf<>x.yffjf  and f.ffzt=1 and f.fftype>0";			
			
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				kyjf=rs.getInt(1);
			}
			rs.close();
		}
		
		if (kyjf<Integer.valueOf(ddjf))
		{
			response.sendRedirect("bwpay.jsp?jid="+jfqdd);
			return;
		}
		
		if (nowzt==1)
		{
			out.print("<script type='text/javascript'>");
			out.print("alert('此订单已经提交过，请不要重复提交！'); ");	
			out.print("location.href='buywelfare.jsp';");
			out.print("</script>");				
			return;
		}
		
		//先判断库存是不是够 
		strsql="select j.mc from tbl_jfqddmc m inner join tbl_jfq j on m.jfq=j.nid where m.jfqdd="+jfqdd+" and  m.sl>j.kcsl";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{					
			rs.close();	
			out.print("<script type='text/javascript'>");
			out.print("alert('您下手的速度太慢了，此订单对应的库存数量不够，请联系我们！或者挑选其他福利！'); ");	
			out.print("location.href='buywelfare.jsp';");
			out.print("</script>");				
			return;
		}
		else
		{
			rs.close();
		}
		
		String qyid=session.getAttribute("qy").toString();
		Integer newqyjf = 0;
		if (isGly) {
			//企业表中扣去积分
			strsql="update tbl_qy set jf=jf-"+ddjf+" where nid="+qyid;
			stmt.execute(strsql);
			newqyjf=Integer.valueOf(session.getAttribute("qyjf").toString())-Integer.valueOf(ddjf);
		} else if (isLeader){
            strsql="select x.nid, (x.jf-x.yffjf) as ye from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid where ((x.fflx=1 and x.lxbh in ("+ffbm+")) or (x.fflx=2 and x.lxbh in ("+ffxz+"))) and x.jf<>x.yffjf  and f.ffzt=1 and f.fftype>0 order by ye";			
			
			rs=stmt.executeQuery(strsql);
			int ykjf=0;
			int ye=0;
			int ddjfInt=Integer.parseInt(ddjf);
			int nid=0;
			Statement stmt2=conn.createStatement();
			while (rs.next())
			{
				nid=rs.getInt("nid");
				ye=rs.getInt("ye");
				if (ye>=(ddjfInt-ykjf)) {
					strsql="update tbl_jfffxx set yffjf=yffjf+"+(ddjfInt-ykjf)+" where nid="+nid;
					stmt2.execute(strsql);
					break;
				} else {
					strsql="update tbl_jfffxx set yffjf=yffjf+"+ye+" where nid="+nid;
					stmt2.execute(strsql);
					ykjf+=ye;
				}
			}
			getjfxx(stmt2, session);
			stmt2.close();
			rs.close();
			
			newqyjf=Integer.valueOf(session.getAttribute("hrffjf").toString())+ Integer.valueOf(session.getAttribute("gmjf").toString());
		}
 		
		//更改session中的值 
		session.setAttribute("qyjf",newqyjf.toString());
		
		
		//修改订单状态
		strsql="update tbl_jfqdd set zt=1,ztsj=now() where  nid="+jfqdd;
		stmt.execute(strsql);
		
		//修改订单明细中的状态
		strsql="update tbl_jfqddmc set zt=1 where jfqdd="+jfqdd;
		stmt.execute(strsql);
		
		//对应具体的福利券
		
		
		ArrayList jfq=new ArrayList();
		ArrayList sl=new ArrayList();
		strsql="select jfq,sl from tbl_jfqddmc where jfqdd="+jfqdd;
		rs=stmt.executeQuery(strsql);
		while(rs.next())
		{
			jfq.add(rs.getString("jfq"));
			sl.add(rs.getString("sl"));
		}
		rs.close();
		
		//把券对应到企业帐号上
		for (int i=0;i<jfq.size();i++)
		{
			strsql="update tbl_jfqmc set qy="+qyid+",jfqdd="+jfqdd+" where nid in (select s.nid from (select nid from tbl_jfqmc where jfq="+jfq.get(i)+" and qy=0 and zt=0 order by nid limit "+sl.get(i)+") as s)";
			stmt.executeUpdate(strsql);
			
			if (isLeader) {
				String ygid=session.getAttribute("ygid").toString();
				String ffh=ygid+String.valueOf(Calendar.getInstance().getTimeInMillis());
				strsql="insert into tbl_jfqff (qy,ffjf,ffr,ffsj,jfq,ffzt,ffh,fftype) values("+qyid+","+sl.get(i)+","+ygid+",now(),"+jfq.get(i)+",1,'"+ffh+"',"+ddtype+")";
				stmt.executeUpdate(strsql);
				
				strsql="select nid from tbl_jfqff where qy="+qyid+" and ffr="+ygid+" order by nid desc limit 1";
				rs=stmt.executeQuery(strsql);
				String jfqffId="";
				if (rs.next())
				{
					jfqffId=rs.getString("nid");
				}
				rs.close();
				
				//1:部门 2:小组
				int fflx=1;
				if (ddtype==2) {
					fflx=2;
					strsql="select nid,xzmc as mc from tbl_qyxz where ld="+ygid;
				} else {
					fflx=1;
					strsql="select nid,bmmc as mc from tbl_qybm where ld="+ygid;
				}
				rs=stmt.executeQuery(strsql);
				String nid="0";
				String mc="";
				if (rs.next())
				{
					nid=rs.getString("nid");
					mc=rs.getString("mc");
				}
				rs.close();
				strsql="insert into tbl_jfqffxx (qy,jfqff,fflx,lxbh,jf,jfq,ldbh,jsmc) values("+qyid+","+jfqffId+","+fflx+","+nid+","+sl.get(i)+","+jfq.get(i)+","+ygid+",'"+mc+"')";
				stmt.executeUpdate(strsql);
			}
			
			//修改库存
			strsql="update tbl_jfq set kcsl=kcsl-"+sl.get(i)+" where nid="+jfq.get(i);
			stmt.executeUpdate(strsql);
		}
		
	}
	
%>
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local">
					<li class="local-ico3">
						<div class="local2-1"><h1>确认购买福利信息</h1><h2><%=ddsj%></h2></div>
					</li>
					<li class="local-ico1">
						<div class="local2-2"><h1>支付订单金额</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li>
						<div class="local2-3"><h1>付款成功积分到帐</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
				</ul>	
				<div class="paydetail">
				恭喜您，您的订单 <span class="txt1"><%=ddbh%></span> 已经付款成功，共扣除积分 <span class="txt2"><%=ddjf%></span> 积分
				</div>
				<div class="paytishi">您目前公司账户积分余额 <span><%=session.getAttribute("qyjf")%></span></div>
				<div class="paybtnbox2">
					<a href="mywelfare.jsp" class="ffflbtn2"></a>
					<span>您还可以</span>
					<a href="buywelfare.jsp" class="gmflbtn2"></a>
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