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
 <script type="text/javascript">
 function cancleff(id)
{
	if (confirm("确认要取消此发放"))
	{
		location.href="aworder.jsp?naction=cancle&ffid="+id;	
		
	}
}
 </script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>

<%
menun=5;
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
Fun fun=new Fun();
ResultSet rs=null;
String strsql="";
String backurl=request.getParameter("backurl");
String ffid=request.getParameter("ffid");
if (ffid==null || !fun.sqlStrCheck(ffid) || ffid.equals(""))
{
	response.sendRedirect("assignwelfare.jsp");
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
		int jfq=0;
		strsql="select jfq,ffzt,ffjf from tbl_jfqff where nid="+ffid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			jfq=rs.getInt("jfq");
			nowffzt=rs.getInt("ffzt");
			ffjf=rs.getInt("ffjf");
		}
		rs.close();
		
		//还没有发放，则可以取消
		//取消后冻结数量减少，发放数量减少
		//对应员工的取消掉
		if (nowffzt==0)
		{
			strsql="update tbl_jfqff set ffzt=-1,ztsj=now() where nid="+ffid;
			stmt.executeUpdate(strsql);
			
			//对应具体人员的还原过来
			strsql="update tbl_jfqmc set qyyg=0 where nid in (select nid from (select q.nid from tbl_jfqffmc f inner join tbl_jfqmc q on f.nid=q.jfqffmc where f.jfqff="+ffid+") ab)";
			stmt.execute(strsql);
			
			//更改冻结数量和发放数量
			int gdtjf=0;
			strsql="select sum(jf*rs) as jf from tbl_jfqffxx where jfqff="+ffid+" and jfq="+jfq;
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				gdtjf=rs.getInt("jf");
			}
			rs.close();
			
			int sl=0,ffsl=0,nid=0,djsl=0;
			while(gdtjf>0)
			{
				strsql="select nid,sl,ffsl,djsl from tbl_jfqddmc where qy="+session.getAttribute("qy")+" and jfq="+jfq+" and zt=1 and djsl>0 order by nid limit 1";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					nid=rs.getInt("nid");
					sl=rs.getInt("sl");
					ffsl=rs.getInt("ffsl");
					djsl=rs.getInt("djsl");
				}
				rs.close();
				
				if (djsl>=gdtjf)
				{
					strsql="update tbl_jfqddmc set ffsl=ffsl-"+gdtjf+",djsl=djsl-"+gdtjf+" where nid="+nid;
					stmt.executeUpdate(strsql);
				}
				else
				{
					strsql="update tbl_jfqddmc set ffsl=0,djsl=0 where nid="+nid;
					stmt.executeUpdate(strsql);
				}
				
				gdtjf=gdtjf-djsl;
			}
		}
	}
	String ffbh="",ffjf="",ffmm="",ffsj="",bz="",ffzt="",jfq="";
	SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
	strsql="select f.nid,f.ffsj,f.jfq,m1.mmmc as mc1,m2.mmmc as mc2,f.hjr,f.ffjf,f.ffzt,f.srsj,f.bz from tbl_jfqff f left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where f.qy="+session.getAttribute("qy")+" and f.nid="+ffid;
	
	rs=stmt.executeQuery(strsql);
	if (rs.next())
	{
		ffbh=sf.format(rs.getDate("srsj"))+rs.getString("nid");
		ffbh=ffbh.replace("-","");		
		ffjf=rs.getString("ffjf");
		jfq=rs.getString("jfq");
		ffmm=rs.getString("mc1");
		if (rs.getString("mc2")!=null) ffmm=ffmm+","+rs.getString("mc2");
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
				
				<div class="ffjfbox">
					<div class="ffjfbox-top">订单  <%=ffbh %> 详细信息</div>
					
					<%
					strsql="select q.nid,q.mc,q.sm,q.jf,q.sp,h.hdmc,h.hdtp from tbl_jfq q inner join tbl_jfqhd h on q.hd=h.nid where q.nid="+jfq;
					rs=stmt.executeQuery(strsql);
					if (rs.next())
					{
					%>
					<div class="confirm-t">您选择的福利券</div>
					<div class="confirm-states">
						<h1><img src="../hdimg/<%=rs.getString("hdtp")%>" width="121" height="88" /></h1>
						<dl>
							<dt><%=rs.getString("hdmc")%></dt>
							<dd><%=rs.getString("mc")%></dd>
						</dl>
						<span id="selnumbers"></span>
					</div>
					<%}
					rs.close();
					%>
				
					<div class="jf-ffmm" style="margin:0"><strong>发放名目</strong>&nbsp;&nbsp;<%=ffmm%></div>
					<div class="jf-ffmm" style="border:0; margin:0"><strong>发放信息</strong></div>
					<%
					int i=0;
					String jfstr="";
					//考虑不同部门有可能有不同的积分，先按积分分组
					strsql="select jf from tbl_jfqffxx where jfqff="+ffid+" and fflx=1 group by jf";
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
							strsql="select b.bmmc from tbl_jfqffxx f left join tbl_qybm b on f.lxbh=b.nid where f.jfqff="+ffid+" and f.fflx=1 and f.jf="+jfarr[j]; 
							
							rs=stmt.executeQuery(strsql);
							while(rs.next())
							{
								if (i==0) out.print("<ul class=\"jf-ffxx-list\"><li>发放授权：");
								out.print(rs.getString("bmmc")+",");							
								i++;
							}
							rs.close();
							out.print("</li><li><span class=\"floatleft txtsize14\">奖励福利券: 每部门"+jfarr[j]+"张</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+Integer.valueOf(jfarr[j])*i+"</span> 张</div></li></ul>");							
						}
					}
					
					//小组
					jfstr="";
					strsql="select jf from tbl_jfqffxx where jfqff="+ffid+" and fflx=2 group by jf";
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
							strsql="select f.jf,x.xzmc from tbl_jfqffxx f left join tbl_qyxz x on f.lxbh=x.nid where f.jfqff="+ffid+" and f.fflx=2 and f.jf="+jfarr2[j]; 
							rs=stmt.executeQuery(strsql);
							while(rs.next())
							{
								if (i==0) out.print("<ul class=\"jf-ffxx-list\"><li>发放授权：");
								out.print(rs.getString("xzmc")+",");							
								i++;
							}
							rs.close();
							out.print("</li><li><span class=\"floatleft txtsize14\">奖励福利券: 每组"+jfarr2[j]+"张</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+Integer.valueOf(jfarr2[j])*i+"</span> 张</div></li></ul>");							
						}
					}
					
					//个别员工
					jfstr="";
					strsql="select jf from tbl_jfqffxx where jfqff="+ffid+" and fflx=3 group by jf";
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
							strsql="select y.ygxm from tbl_jfqffxx f left join tbl_jfqffmc m on f.nid=m.jfqffxx left join tbl_qyyg y on m.hqr=y.nid where f.jfqff="+ffid+" and f.fflx=3 and f.jf="+jfarr3[j]; 
							rs=stmt.executeQuery(strsql);
							while(rs.next())
							{
								if (i==0) out.print("<ul class=\"jf-ffxx-list\"><li>奖励对象：");
								out.print(rs.getString("ygxm")+",");							
								i++;
							}
							rs.close();
							out.print("</li><li><span class=\"floatleft txtsize14\">奖励福利券: 每人"+jfarr3[j]+"张</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+Integer.valueOf(jfarr3[j])*i+"</span> 张</div></li></ul>");							
						}
					}
					
					//全体员工
					jfstr="";
					strsql="select jf from tbl_jfqffxx where jfqff="+ffid+" and fflx=4 group by jf";
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
							strsql="select rs from tbl_jfqffxx where jfqff="+ffid+" and fflx=4 and jf="+jfarr4[j]; 
							rs=stmt.executeQuery(strsql);
							while(rs.next())
							{
								out.print("<ul class=\"jf-ffxx-list\"><li>奖励对象：全体员工");														
								out.print("</li><li><span class=\"floatleft txtsize14\">奖励福利券: 每人"+jfarr4[j]+"张</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+Integer.valueOf(jfarr4[j])*rs.getInt("rs")+"</span> 张</div></li></ul>");
							}
							rs.close();
						}
					}
					%>
					
					<div class="jf-ffdata"><h1>发放日期</h1><h2><%=ffsj%></h2><h3><%if (ffzt.equals("0")) out.print("时间未到，暂未发放"); else if (ffzt.equals("1")) out.print("已经发放"); else  out.print("已取消");%></h3></div>
					<div class="jf-mark" style="padding-left:16px"><h1>备注信息</h1><span><%=bz%></span></div>
					<div class="jf-sum" style="padding-left:16px">总计 <span class="yellowtxt"><%=ffjf%></span> 张</div>
					<div class="jf-confirm"><span class="floatleft"><%out.print("<a href=\"mywelfare.jsp\" class=\"backbtn2\"></a>");%></span><%if (ffzt!=null && ffzt.equals("0")) {%><span class="modify"><a href="javascript:void(0);" onclick="cancleff(<%=ffid%>)">取消发放</a></span><%}%>
					
					</div>				
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
