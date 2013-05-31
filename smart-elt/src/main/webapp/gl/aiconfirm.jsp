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
function goback(t)
{
	if (t==0)
		document.getElementById("aiform").action="assignintegral.jsp";	
	else
		document.getElementById("aiform").action="leaderai.jsp?xid="+t;
	document.getElementById("aiform").submit();
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
String listn=request.getParameter("listn");
String mm1=request.getParameter("mm1");
String mm2=request.getParameter("mm2");
if (mm2==null) mm2="";
String ffsj=request.getParameter("ffsj");
String bz=request.getParameter("bz");
String xid=request.getParameter("xid");

ArrayList fflx=new ArrayList();
ArrayList ojf=new ArrayList();
ArrayList ygid=new ArrayList();
ArrayList bmid=new ArrayList();
ArrayList xzid=new ArrayList();
String fflxs="",ojfs="",ygids="",bmids="",xzids="";
String sendfflx="",sendojfs="",sendvalue="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
int xxfflx=0,xxlxbh=0;

try
{
	String mmmc="";
	
	if (listn!=null && listn.length()>0)
	{
		int staffn=0;
		
		if (xid!=null && xid.length()>0)
		{
			strsql="select fflx,lxbh from tbl_jfffxx where nid="+xid;
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				xxfflx=rs.getInt("fflx");
				xxlxbh=rs.getInt("lxbh");
			}
			rs.close();
		}
		
		if (xxfflx==1)
			strsql="select count(nid) as hn from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3 and zt=1 and bm like '%,"+xxlxbh+",%'";
		
		if (xxfflx==2)
			strsql="select count(x.nid) as hn from tbl_qyxzmc x inner join tbl_qyyg y on x.yg=y.nid where x.xz="+xxlxbh+"  and y.xtzt<>3  and y.zt=1";
		if (xxfflx==0)
			strsql="select count(nid) as hn from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3 and zt=1";
		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
			{
				staffn=rs.getInt("hn");
			}
		rs.close();
		
		
		
		if (mm1!=null && mm1.length()>0 && !"0".equals(mm1))
		{
			strsql="select mmmc from tbl_jfmm where nid="+mm1;
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{mmmc=rs.getString("mmmc");}
		}
		
		if ("0".equals(mm1)) {
			mmmc="部门或项目组奖励";
		}
		
		if (mm2!=null && mm2.length()>0)
		{
			strsql="select mmmc from tbl_jfmm where nid="+mm2;
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{mmmc=mmmc+","+rs.getString("mmmc");}
		}
		
		for (int i=0;i<Integer.valueOf(listn);i++)
		{
			fflx.add(request.getParameter("fflx"+i));
			ojf.add(request.getParameter("ojf"+i));
			ygid.add(request.getParameterValues("ygid"+i));
			bmid.add(request.getParameterValues("bmid"+i));
			xzid.add(request.getParameter("xzid"+i));	
			
			
		}
		
		int tjf=0;
		
		
		%>
		
 
	<%@ include file="head.jsp" %>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="local">
					<li class="local-ico1">
						<div class="local-1"><h1>填写发放积分信息</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li class="local-ico2">
						<div class="local-2"><h1>确认发放信息</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li>
						<div class="local-3"><h1>确认发放</h1></div>
					</li>
				</ul>
				<%if (xid==null || xid.length()==0)  {%>
				<div class="gsjf-states">尊敬的<%=session.getAttribute("qymc")%>，您目前公司账户积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("qyjf")%></em><%if (session.getAttribute("djjf")!=null && !session.getAttribute("djjf").equals("0")) {%>，冻结积分：<em class="yellowtxt txtsize16"><%=session.getAttribute("djjf")%></em><%} %></div>
				<%} %>
				<div class="jf-ffmm"><span class="star">*</span>&nbsp;<strong>发放名目</strong>&nbsp;&nbsp;<%=mmmc%></div>
				<div class="jf-ffmm" style="border:0"><span class="star">*</span>&nbsp;<strong>发放信息</strong></div>
				<%
				int fn=0;
				for (int i=0;i<fflx.size();i++)
				{
					if (fflx.get(i)!=null)
						{
						fflxs=fflx.get(i).toString();
						ojfs=ojf.get(i).toString();
						
						if (fflxs!=null && fflxs.length()>0)
						{
							sendfflx=sendfflx+fflxs+";";
							sendojfs=sendojfs+ojfs+";";
							if (fflxs.equals("1"))
							{
								fn=0;
								String[] bmarr= (String[]) bmid.get(i);
								bmids="";
								
								for (int j=0;j<bmarr.length;j++)
									{
										if (j<bmarr.length-1)
										bmids=bmids+bmarr[j]+",";
										else
										bmids=bmids+bmarr[j];
									}
								sendvalue=sendvalue+bmids+";";
								strsql="select bmmc from tbl_qybm where nid in ("+bmids+")";
								
								out.print("<ul class=\"jf-ffxx-list\">");
								out.print("<li>发放授权:");
								rs=stmt.executeQuery(strsql);
								while(rs.next())
								{
									out.print(rs.getString("bmmc")+",");
									fn++;
								}
								rs.close();
								out.print("</li>");
								if (fn>1)
									out.print("<li><span class=\"floatleft txtsize14\">发放积分:"+ojfs+"积分</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*bmarr.length)+"</span> 积分</div></li></ul>");
								else
									out.print("<li><span class=\"floatleft txtsize14\">发放积分:每部门"+ojfs+"积分</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*bmarr.length)+"</span> 积分</div></li></ul>");
								
								tjf=tjf+Integer.valueOf(ojfs)*bmarr.length;
							}
							
							if (fflxs.equals("2"))
							{
								
								int xzl=0;
								xzids=xzid.get(i).toString();
								xzids=xzids.substring(0,xzids.length()-1);
								
								sendvalue=sendvalue+xzids+";";
								strsql="select xzmc from tbl_qyxz where nid in ("+xzids+")";
								out.print("<ul class=\"jf-ffxx-list\">");
								out.print("<li>发放授权:");								
								rs=stmt.executeQuery(strsql);
								while (rs.next())
								{
									out.print(rs.getString("xzmc")+",");
									xzl++;
								}
								rs.close();
								out.print("</li>");
								if (xzl>1)
									out.print("<li><span class=\"floatleft txtsize14\">发放积分:每项目组"+ojfs+"积分</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*xzl)+"</span> 积分</div></li></ul>");
								else
									out.print("<li><span class=\"floatleft txtsize14\">发放积分:"+ojfs+"积分</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*xzl)+"</span> 积分</div></li></ul>");
								tjf=tjf+Integer.valueOf(ojfs)*xzl;
							}
							
							if (fflxs.equals("3"))
							{
								
								fn=0;
								String[] ygarr= (String[]) ygid.get(i);
								ygids="";
								
								for (int j=0;j<ygarr.length;j++)
									{
										if (j<ygarr.length-1)
										ygids=ygids+ygarr[j]+",";
										else
										ygids=ygids+ygarr[j];	
									}
								sendvalue=sendvalue+ygids+";";
								strsql="select ygxm from tbl_qyyg where nid in ("+ygids+")";
								out.print("<ul class=\"jf-ffxx-list\">");
								out.print("<li>发放对象:");	
								rs=stmt.executeQuery(strsql);
								while(rs.next())
								{
								out.print(rs.getString("ygxm")+",");
								fn++;
								}
								rs.close();
								out.print("</li>");
								if (fn>1)
									out.print("<li><span class=\"floatleft txtsize14\">发放积分:每人"+ojfs+"积分</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*ygarr.length)+"</span> 积分</div></li></ul>");
								else
									out.print("<li><span class=\"floatleft txtsize14\">发放积分:"+ojfs+"积分</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*ygarr.length)+"</span> 积分</div></li></ul>");
								
								tjf=tjf+Integer.valueOf(ojfs)*ygarr.length;
							}
							if (fflxs.equals("4"))
							{
								sendvalue=sendvalue+staffn+";";
								out.print("<ul class=\"jf-ffxx-list\">");
								out.print("<li>发放对象:");	
								out.print("全体员工(共"+staffn+"人)");
								out.print("</li>");
								out.print("<li><span class=\"floatleft txtsize14\">发放积分:每人"+ojfs+"积分</span><div class=\"sum\">共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs)*staffn)+"</span> 积分</div></li></ul>");
								
								tjf=tjf+Integer.valueOf(ojfs)*staffn;
							}
						}
					}
				}
				%>
				<%if (xid!=null && xid.length()>0) {
					strsql="select m1.mmmc as mc1,m2.mmmc as mc2 from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid left join tbl_jfmm m1 on f.mm1=m1.nid left join tbl_jfmm m2 on f.mm2=m2.nid where x.nid="+xid;
					rs=stmt.executeQuery(strsql);
					String formAction = "leaderais.jsp";
					if (rs.next())
					{
						// assign integral purchased by leader
						if (rs.getString("mc1")==null && rs.getString("mc2")==null) {
							formAction = "leaderaisgmjf.jsp";
						}
					}
					rs.close();
				%>
				<form action="<%=formAction %>" name="aiform" id="aiform" method="post">		
				<input type="hidden" name="mm1" id="mm1" value="<%=mm1%>"  /><input type="hidden" name="mm2" id="mm2" value="<%=mm2%>"  />
				<input type="hidden" name="ffsj" id="ffsj" value="<%=ffsj%>"/>
				<input type="hidden" name="bz" id="bz" value="<%=bz%>"/>
				<input type="hidden" name="sendfflx" id="sendfflx"  value="<%=sendfflx%>"/>
				<input type="hidden" name="sendojfs" id="sendojfs"  value="<%=sendojfs%>"/>
				<input type="hidden" name="sendvalue" id="sendvalue"  value="<%=sendvalue%>"/>
				<input type="hidden" name="xid" id="xid"  value="<%=xid%>"/>
				<input type="hidden" name="ctjf" id="ctjf"  value="<%=tjf%>"/>	
				<input type="hidden" name="ffh" id="ffh"  value="<%=session.getAttribute("ygid").toString()+String.valueOf(Calendar.getInstance().getTimeInMillis())%>"/>			
				</form>
				<%}
				else
				{
				%>
				<form action="aisuccess.jsp" name="aiform" id="aiform" method="post">		
				<input type="hidden" name="mm1" id="mm1" value="<%=mm1%>"  /><input type="hidden" name="mm2" id="mm2" value="<%=mm2%>"  />
				<input type="hidden" name="ffsj" id="ffsj" value="<%=ffsj%>"/>
				<input type="hidden" name="bz" id="bz" value="<%=bz%>"/>
				<input type="hidden" name="sendfflx" id="sendfflx"  value="<%=sendfflx%>"/>
				<input type="hidden" name="sendojfs" id="sendojfs"  value="<%=sendojfs%>"/>
				<input type="hidden" name="sendvalue" id="sendvalue"  value="<%=sendvalue%>"/>
				<input type="hidden" name="ctjf" id="ctjf"  value="<%=tjf%>"/>
				<input type="hidden" name="ffh" id="ffh"  value="<%=session.getAttribute("ygid").toString()+String.valueOf(Calendar.getInstance().getTimeInMillis())%>"/>								
				</form>
				
				
				<%
				}
				%>
				<div class="jf-ffdata"><span class="star floatleft">*&nbsp;</span><h1>发放日期</h1><h2><%=ffsj%></h2><h3>
				<%if (sf.parse(ffsj).after(Calendar.getInstance().getTime())) out.print("时间未到，暂未发放");%>
				</h3></div>
				<div class="jf-mark"><h1>备注信息</h1><span><%=bz%></span></div>
				<div class="jf-sum">总计 <span class="yellowtxt"><%=tjf%></span> 积分</div>
				<%if (xid==null || xid.length()==0)  {%>
				<div class="jf-confirm"><span class="floatleft"><a href="javascript:document.getElementById('aiform').submit();" class="confirmbtn"></a></span><span class="modify"><a href="#" onclick="goback(0)">返回修改</a></span> <span class="modify"><a href="main.jsp">取消发放</a></span>
				<%} else { %>
				<div class="jf-confirm"><span class="floatleft"><a href="javascript:document.getElementById('aiform').submit();" class="confirmbtn"></a></span><span class="modify"><a href="#" onclick="goback(<%=xid%>)">返回修改</a></span> <span class="modify"><a href="leaderjf.jsp">取消发放</a></span>
				<%} %>
				</div>
			</div>	
	  	</div>
	</div>
	
		<%
		
	}
	%>
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
