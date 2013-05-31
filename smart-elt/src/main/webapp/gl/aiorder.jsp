<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>

<%request.setCharacterEncoding("UTF-8"); %>
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
 function cancleff(id)
{
	if (confirm("确认要取消此发放"))
	{
		location.href="aiorder.jsp?naction=cancle&ffid="+id;	
		
	}
}
 </script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>

<%
menun=3;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
Fun fun=new Fun();
ResultSet rs=null;
String strsql="";

String ffid=request.getParameter("ffid");
if (ffid==null || !fun.sqlStrCheck(ffid) || ffid.equals(""))
{
	response.sendRedirect("assignintegral.jsp");
	return;
}
String naction=request.getParameter("naction");

try
{
	if (naction!=null && naction.equals("cancle"))
	{
		
		//先判断状态是否可以取消
		int nowffzt=1;
		int ffjf=0;
		strsql="select ffzt,ffjf from tbl_jfff where nid="+ffid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			nowffzt=rs.getInt("ffzt");
			ffjf=rs.getInt("ffjf");
		}
		rs.close();
		
		//还没有发放，则可以取消
		//取消后冻结积分减掉，可用积分添加
		if (nowffzt==0)
		{
			strsql="update tbl_jfff set ffzt=-1,ztsj=now() where nid="+ffid;
			stmt.executeUpdate(strsql);
			//更新企业表中数据
			strsql="update tbl_qy set jf=jf+"+ffjf+",djjf=djjf-"+ffjf+" where nid="+session.getAttribute("qy");
			stmt.executeUpdate(strsql);
			
			Integer jfye=Integer.valueOf(session.getAttribute("qyjf").toString())+Integer.valueOf(ffjf);
			session.setAttribute("qyjf",String.valueOf(jfye));
			//冻结积分
			
			Integer sdjjf=Integer.valueOf(session.getAttribute("djjf").toString())-Integer.valueOf(ffjf);
			session.setAttribute("djjf",String.valueOf(sdjjf));
		}
	}
	String ffbh="",ffjf="",ffmm="",ffsj="",bz="",ffzt="";
	SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
	strsql="select f.nid,f.ffsj,m1.mmmc as mc1,m2.mmmc as mc2,f.hjr,f.ffjf,f.ffzt,f.srsj,f.bz from tbl_jfff f left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where f.qy="+session.getAttribute("qy")+" and f.nid="+ffid;
	
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{
		ffbh=sf.format(rs.getDate("srsj"))+rs.getString("nid");
		ffbh=ffbh.replace("-","");		
		ffjf=rs.getString("ffjf");
		ffmm=rs.getString("mc1");
		if (rs.getString("mc2")!=null) ffmm=ffmm+","+rs.getString("mc2");
		ffmm=(ffmm==null)?"部门或项目组奖励":ffmm;
		ffsj=sf.format(rs.getDate("ffsj"));
		bz=rs.getString("bz");
		ffzt=rs.getString("ffzt");
		if (ffzt==null) ffzt="0";
	}
	rs.close();
 %>
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
	  		    <%if (isAuth) {%>
				<div class="gsjf-states">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %></div>
				<%} %>
				<div class="ffjfbox">
					<div class="ffjfbox-top">订单  <%=ffbh %> 详细信息</div>
					<div class="jf-ffmm" style="margin:0"><strong>发放名目</strong>&nbsp;&nbsp;<%=ffmm%></div>
					<div class="jf-ffmm" style="border:0; margin:0"><strong>发放信息</strong></div>
					<%
					int i=0;
					String jfstr="";
					//考虑不同部门有可能有不同的积分，先按积分分组
					strsql="select jf from tbl_jfffxx where jfff="+ffid+" and fflx=1 group by jf";
					rs=stmt.executeQuery(strsql);
					while (rs.next())
					{
						jfstr=jfstr+rs.getString("jf")+",";
					}
					rs.close();
					
					if (jfstr.length()>0)
					{
						String[] jfarr=jfstr.split(",");
						for (int j=0;j<jfarr.length;j++)
						{
							i=0;						
							strsql="select b.bmmc from tbl_jfffxx f left join tbl_qybm b on f.lxbh=b.nid where f.jfff="+ffid+" and f.fflx=1 and f.jf="+jfarr[j]; 
							
							rs=stmt.executeQuery(strsql);
							while(rs.next())
							{
								if (i==0) out.print("<ul class=\"jf-ffxx-list\"><li>发放授权：");
								out.print(rs.getString("bmmc")+",");							
								i++;
							}
							rs.close();
							out.print("</li><li><span class=\"floatleft txtsize14\">奖励积分: 每部门"+jfarr[j]+"</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+Integer.valueOf(jfarr[j])*i+"</span> 积分</div></li></ul>");							
						}
					}
					
					//小组
					jfstr="";
					strsql="select jf from tbl_jfffxx where jfff="+ffid+" and fflx=2 group by jf";
					rs=stmt.executeQuery(strsql);
					while (rs.next())
					{
						jfstr=jfstr+rs.getString("jf")+",";
					}
					rs.close();
					
					if (jfstr.length()>0)
					{	
						String[] jfarr2=jfstr.split(",");
						for (int j=0;j<jfarr2.length;j++)
						{
							i=0;					
							strsql="select f.jf,x.xzmc from tbl_jfffxx f left join tbl_qyxz x on f.lxbh=x.nid where f.jfff="+ffid+" and f.fflx=2 and f.jf="+jfarr2[j]; 
							rs=stmt.executeQuery(strsql);
							while(rs.next())
							{
								if (i==0) out.print("<ul class=\"jf-ffxx-list\"><li>发放授权：");
								out.print(rs.getString("xzmc")+",");							
								i++;
							}
							rs.close();
							out.print("</li><li><span class=\"floatleft txtsize14\">奖励积分: 每组"+jfarr2[j]+"</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+Integer.valueOf(jfarr2[j])*i+"</span> 积分</div></li></ul>");							
						}
					}
					
					//个别员工
					jfstr="";
					strsql="select jf from tbl_jfffxx where jfff="+ffid+" and fflx=3 group by jf";
					rs=stmt.executeQuery(strsql);
					while (rs.next())
					{
						jfstr=jfstr+rs.getString("jf")+",";
					}
					rs.close();
					
					if (jfstr.length()>0)
					{
						String[] jfarr3=jfstr.split(",");
						for (int j=0;j<jfarr3.length;j++)
						{
							i=0;					
							strsql="select y.ygxm from tbl_jfffxx f left join tbl_jfffmc m on f.nid=m.jfffxx left join tbl_qyyg y on m.hqr=y.nid where f.jfff="+ffid+" and f.fflx=3 and f.jf="+jfarr3[j]; 
							rs=stmt.executeQuery(strsql);
							while(rs.next())
							{
								if (i==0) out.print("<ul class=\"jf-ffxx-list\"><li>奖励对象：");
								out.print(rs.getString("ygxm")+",");							
								i++;
							}
							rs.close();
							out.print("</li><li><span class=\"floatleft txtsize14\">奖励积分: 每人"+jfarr3[j]+"</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+Integer.valueOf(jfarr3[j])*i+"</span> 积分</div></li></ul>");							
						}
					}
					
					//全体员工
					jfstr="";
					strsql="select jf from tbl_jfffxx where jfff="+ffid+" and fflx=4 group by jf";
					rs=stmt.executeQuery(strsql);
					while (rs.next())
					{
						jfstr=jfstr+rs.getString("jf")+",";
					}
					rs.close();
					
					if (jfstr.length()>0)
					{
						String[] jfarr4=jfstr.split(",");
						for (int j=0;j<jfarr4.length;j++)
						{
							i=0;					
							strsql="select rs from tbl_jfffxx where jfff="+ffid+" and fflx=4 and jf="+jfarr4[j]; 
							rs=stmt.executeQuery(strsql);
							while(rs.next())
							{
								out.print("<ul class=\"jf-ffxx-list\"><li>奖励对象：全体员工");														
								out.print("</li><li><span class=\"floatleft txtsize14\">奖励积分: 每人"+jfarr4[j]+"</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+Integer.valueOf(jfarr4[j])*rs.getInt("rs")+"</span> 积分</div></li></ul>");
							}
							rs.close();
						}
					}
					%>
					
					<div class="jf-ffdata"><h1>发放日期</h1><h2><%=ffsj%></h2><h3><%if (ffzt.equals("0")) out.print("时间未到，暂未发放"); else if (ffzt.equals("1")) out.print("已经发放"); else  out.print("已取消");%></h3></div>
					<div class="jf-mark" style="padding-left:16px"><h1>备注信息</h1><span><%=bz%></span></div>
					<div class="jf-sum" style="padding-left:16px">总计 <span class="yellowtxt"><%=ffjf%></span> 积分</div>
					<div class="jf-confirm"><span class="floatleft"><a href="assignintegral.jsp" class="backbtn2"></a></span><%if (ffzt!=null && ffzt.equals("0")) {%><span class="modify"><a href="javascript:void(0);" onclick="cancleff(<%=ffid%>)">取消发放</a></span><%}%>
					
					</div>				
				</div>
				<div class="jf-detail-bottom">您还可以去 <a href="assignintegral.jsp">发放积分</a> 或者 <a href="buyintegral.jsp">购买积分</a></div>
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
