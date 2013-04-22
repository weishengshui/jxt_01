<%@page import="org.apache.velocity.Template"%>
<%@page import="org.apache.velocity.VelocityContext"%>
<%@page import="org.apache.velocity.app.Velocity"%>
<%@page import="java.io.StringWriter"%>
<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@page import="java.sql.PreparedStatement"%>

<%request.setCharacterEncoding("UTF-8"); %>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards企业员工忠诚度系统</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <link href="css/style.css" type="text/css" rel="stylesheet" />
 <script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
function reftopjf(jf)
{
	var shows="";
	for (var i=1;i<=jf.length;i++)
	{
		shows=shows+"<li>"+jf.substring(i-1,i)+"</li>";
	}	
	document.getElementById("headjf").innerHTML=shows;	
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>

<%
menun=3;
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
Fun fun=new Fun();
ResultSet rs=null;
String strsql="";

String mm1=request.getParameter("mm1");
String mm2=request.getParameter("mm2");
String ffsj=request.getParameter("ffsj");
String bz=request.getParameter("bz");
String sendfflx=request.getParameter("sendfflx");
String sendojfs=request.getParameter("sendojfs");
String sendvalue=request.getParameter("sendvalue");
String ctjf=request.getParameter("ctjf");
String ffh=request.getParameter("ffh");
String jfmm="";
if (mm2==null || mm2.equals("null") || mm2.equals("")) mm2="0";
StringBuffer showtxt=new StringBuffer();
StringBuffer hjr=new StringBuffer();
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat sf2=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
int tjf=0;

if (!fun.sqlStrCheck(mm1)|| !fun.sqlStrCheck(mm2)|| !fun.sqlStrCheck(ffsj)|| !fun.sqlStrCheck(bz)|| !fun.sqlStrCheck(sendfflx)|| !fun.sqlStrCheck(sendojfs)|| !fun.sqlStrCheck(sendvalue)|| !fun.sqlStrCheck(ctjf)|| !fun.sqlStrCheck(ffh))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('提交内容中有非法数据!');");
	out.print("history.back(-1);");
	out.print("</script>");
	return;
}
try
{
	
 %>
	<%@ include file="head.jsp" %>
	<%
	if (mm1!=null && mm1.length()>0)
	{
		
		String jfff="";
		int ffzt=0;
		if (sf.parse(ffsj).after(Calendar.getInstance().getTime()))
			ffzt=0;
		else
			ffzt=1;
		
		//判断积分是否够
		strsql="select nid from tbl_qy where nid="+session.getAttribute("qy")+" and jf>="+ctjf;		
		rs=stmt.executeQuery(strsql);
		if (!rs.next())
		{
			rs.close();
			out.print("<script type='text/javascript'>");
			out.print("alert('你现在的积分数不够!');");
			out.print("history.back(-1);");
			out.print("</script>");
			return;
		}
		rs.close();
		
		//防止刷新重复发放
		strsql="select nid from tbl_jfff where qy="+session.getAttribute("qy")+" and ffh='"+ffh+"'";		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			rs.close();
			out.print("<script type='text/javascript'>");
			out.print("alert('请不要重复发放!');");
			out.print("location.href='assignintegral.jsp';");
			out.print("</script>");
			return;
		}
		rs.close();
		
		//取发放人对应的部门
		String ffrbm="";
		strsql="select bm from tbl_qyyg where nid="+session.getAttribute("ygid");
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			ffrbm=rs.getString("bm");
		}
		rs.close();
		if (ffrbm==null || ffrbm.equals(""))
			ffrbm="HR";
		else
		{
			ffrbm=ffrbm.substring(0,ffrbm.length()-1);
			ffrbm=ffrbm.substring(ffrbm.lastIndexOf(",")+1);
			strsql="select bmmc from tbl_qybm where nid="+ffrbm;
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				ffrbm=rs.getString("bmmc");
			}
			else
				ffrbm="HR";
			rs.close();
		}
		
		
		
		strsql="insert into tbl_jfff (qy,mm1,mm2,bz,ffr,ffsj,srsj,ffzt,ffh) values("+session.getAttribute("qy")+","+mm1+","+mm2+",'"+bz+"',"+session.getAttribute("ygid")+",'"+ffsj+"',now(),"+ffzt+",'"+ffh+"')";
		stmt.executeUpdate(strsql);
		
		strsql="select nid from tbl_jfff where qy="+session.getAttribute("qy")+" and ffr="+session.getAttribute("ygid")+" order by nid desc limit 1";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			jfff=rs.getString("nid");
		}
		rs.close();
		
		
		if (mm2!=null && !mm2.equals("") && !mm2.equals("0"))
		{
			strsql="select mmmc from tbl_jfmm where nid="+mm2;
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{jfmm=rs.getString("mmmc");}
			rs.close();
		}
		else
		{
			strsql="select mmmc from tbl_jfmm where nid="+mm1;
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{jfmm=rs.getString("mmmc");}
			rs.close();
		}
		
		String[] fflx=sendfflx.split(";");
		String[] ojfs=sendojfs.split(";");
		String[] lxvalue=sendvalue.split(";");
		
		
		String jfffxx="";
		int ldbh=0;
		//SendEmailBean sendemail=new SendEmailBean();
		for (int i=0;i<fflx.length;i++)
		{
			
					if (fflx[i].equals("1"))
					{
						
						String[] bmarr=lxvalue[i].split(",");
						for (int j=0;j<bmarr.length;j++)
						{
							ldbh=0;
							String bmmc="";
							strsql="select b.ld,b.bmmc,y.email,y.ygxm from tbl_qybm b left join tbl_qyyg y on b.ld=y.nid where b.nid="+bmarr[j];
							rs=stmt.executeQuery(strsql);
							if (rs.next())
							{
								ldbh=rs.getInt("ld");
								bmmc=rs.getString("bmmc");
								if (rs.getString("email")!=null)
								{
									
									// instead of velocity String mailcon=rs.getString("ygxm")+"<br/>"+session.getAttribute("qymc")+"已于"+ffsj+"以"+jfmm+"的名目发放了"+ojfs[i]+"积分到您管理的["+bmmc+"]帐户，<a href='http://119.145.4.25:88'>请及时进行发放</a>";
									//sendemail.sendHtmlEmail(rs.getString("email"),mailcon,"积分发放通知");
									
									
									VelocityContext context = new VelocityContext();
									context.put("name", rs.getString("ygxm"));
									context.put("company", session.getAttribute("qymc"));
									context.put("assignedDate",ffsj);
									context.put("catagoryName", jfmm);
									context.put("quantity",ojfs[i]);
									context.put("account", bmmc);
									
									Template template = Velocity.getTemplate("templates/mail/jfassign.vm");
									StringWriter sw = new StringWriter();
									template.merge(context, sw);
									String mailContent = sw.toString();
									System.out.println("mail content: "+mailContent);
															
									strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj,ffbh) values(?,?,?,?,?,?,?,?,?,'jf"+jfff+"')";									
									PreparedStatement pstm=conn.prepareStatement(strsql);
									pstm.setString(1,session.getAttribute("qy").toString());
									pstm.setString(2,session.getAttribute("ygid").toString());
									pstm.setString(3,rs.getString("email"));
									pstm.setString(4,"积分发放通知");
									pstm.setString(5,mailContent);
									pstm.setString(6,sf2.format(Calendar.getInstance().getTime()));
									pstm.setString(7,"2");
									pstm.setString(8,String.valueOf(ffzt));
									pstm.setString(9,"50");
									pstm.executeUpdate();
									pstm.close();
								}
							}
							rs.close();
							strsql="insert into tbl_jfffxx (qy,jfff,fflx,lxbh,jf,ldbh,jsmc) values("+session.getAttribute("qy")+","+jfff+",1,"+bmarr[j]+","+ojfs[i]+","+ldbh+",'"+bmmc+"')";
							stmt.executeUpdate(strsql);
						}
						
						strsql="select bmmc from tbl_qybm where nid in ("+lxvalue[i]+")";
						//out.print(strsql);
						//if (1==1) return;
						showtxt.append("<p>");
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							showtxt.append("["+rs.getString("bmmc")+"] ");
							hjr.append(rs.getString("bmmc")+" ");
						}
						rs.close();
						
						showtxt.append("每部门"+ojfs[i]+"积分  共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs[i])*bmarr.length)+"</span> 积分</p>");						
						tjf=tjf+Integer.valueOf(ojfs[i])*bmarr.length;
					}
					
					if (fflx[i].equals("2"))
					{
						String[] xzarr=lxvalue[i].split(",");
						for (int j=0;j<xzarr.length;j++)
						{
							ldbh=0;
							String xzmc="";
							strsql="select x.ld,x.xzmc,y.email,y.ygxm from tbl_qyxz x left join tbl_qyyg y on x.ld=y.nid where x.nid="+xzarr[j];
							rs=stmt.executeQuery(strsql);
							if (rs.next())
							{
								ldbh=rs.getInt("ld");
								xzmc=rs.getString("xzmc");
								if (rs.getString("email")!=null)
								{
									// instead of velocity String mailcon=rs.getString("ygxm")+"<br/>"+session.getAttribute("qymc")+"已于"+ffsj+"以"+jfmm+"的名目发放了"+ojfs[i]+"积分到您管理的["+xzmc+"]帐户，<a href='http://119.145.4.25:88'>请及时进行发放</a>";
									//sendemail.sendHtmlEmail(rs.getString("email"),mailcon,"积分发放通知");
									
									VelocityContext context = new VelocityContext();
									context.put("name", rs.getString("ygxm"));
									context.put("company", session.getAttribute("qymc"));
									context.put("assignedDate",ffsj);
									context.put("catagoryName", jfmm);
									context.put("quantity",ojfs[i]);
									context.put("account", xzmc);
									
									Template template = Velocity.getTemplate("templates/mail/jfassign.vm");
									StringWriter sw = new StringWriter();
									template.merge(context, sw);
									String mailContent = sw.toString();
									System.out.println("mail content: "+mailContent);
									
									strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj,ffbh) values(?,?,?,?,?,?,?,?,?,'jf"+jfff+"')";									
									PreparedStatement pstm=conn.prepareStatement(strsql);
									pstm.setString(1,session.getAttribute("qy").toString());
									pstm.setString(2,session.getAttribute("ygid").toString());
									pstm.setString(3,rs.getString("email"));
									pstm.setString(4,"积分发放通知");
									pstm.setString(5,mailContent);
									pstm.setString(6,sf2.format(Calendar.getInstance().getTime()));
									pstm.setString(7,"2");
									pstm.setString(8,String.valueOf(ffzt));
									pstm.setString(9,"50");
									pstm.executeUpdate();
									pstm.close();
								}
							}
							rs.close();
							strsql="insert into tbl_jfffxx (qy,jfff,fflx,lxbh,jf,ldbh,jsmc) values("+session.getAttribute("qy")+","+jfff+",2,"+xzarr[j]+","+ojfs[i]+","+ldbh+",'"+xzmc+"')";
							stmt.executeUpdate(strsql);
						}
						showtxt.append("<p>");
						strsql="select xzmc from tbl_qyxz where nid in ("+lxvalue[i]+")";
						rs=stmt.executeQuery(strsql);
						while (rs.next())
						{
							showtxt.append("["+rs.getString("xzmc")+"] ");
							hjr.append(rs.getString("xzmc")+" ");
						}
						
						rs.close();
						
						showtxt.append("每小组"+ojfs[i]+"积分  共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs[i])*xzarr.length)+"</span> 积分</p>");						
						tjf=tjf+Integer.valueOf(ojfs[i])*xzarr.length;
					}
					
					if (fflx[i].equals("3"))
					{
						String[] ygarr=lxvalue[i].split(",");
						//发放信息表						
						strsql="insert into tbl_jfffxx (qy,jfff,fflx,jf,rs) values("+session.getAttribute("qy")+","+jfff+",3,"+ojfs[i]+","+ygarr.length+")";
						
						stmt.executeUpdate(strsql);
						
						strsql="select nid from tbl_jfffxx where qy="+session.getAttribute("qy")+" order by nid desc limit 1";
						rs=stmt.executeQuery(strsql);
						if(rs.next())
						{
							jfffxx=rs.getString("nid");
						}
						rs.close();
						
						//发放明细表	
						for (int j=0;j<ygarr.length;j++)
						{
							strsql="insert into tbl_jfffmc (qy,jfff,jfffxx,hqr,ffjf,ffsj,sfff,ffly) values("+session.getAttribute("qy")+","+jfff+","+jfffxx+","+ygarr[j]+","+ojfs[i]+",'"+ffsj+"',"+ffzt+",'"+ffrbm+"')";
							stmt.executeUpdate(strsql);
							
						}
						
						showtxt.append("<p>");
						strsql="select email,ygxm from tbl_qyyg where nid in ("+lxvalue[i]+")";
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							showtxt.append("["+rs.getString("ygxm")+"] ");
							hjr.append(rs.getString("ygxm")+" ");
							
							// instead of velocity String mailcon=rs.getString("ygxm")+"<br/>"+session.getAttribute("qymc")+"已于"+ffsj+"以"+jfmm+"的名目发放了"+ojfs[i]+"积分到您的帐户，<a href='http://119.145.4.25:88'>请及时进行领取</a>";
							//sendemail.sendHtmlEmail(rs.getString("email"),mailcon,"积分领取通知");
							
							VelocityContext context = new VelocityContext();
							context.put("name", rs.getString("ygxm"));
							context.put("company", session.getAttribute("qymc"));
							context.put("assignedDate",ffsj);
							context.put("catagoryName", jfmm);
							context.put("quantity",ojfs[i]);
							
							Template template = Velocity.getTemplate("templates/mail/jfreceive.vm");
							StringWriter sw = new StringWriter();
							template.merge(context, sw);
							String mailContent = sw.toString();
							System.out.println("mail content: "+mailContent);
									
							strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj,ffbh) values(?,?,?,?,?,?,?,?,?,'jf"+jfff+"')";									
							PreparedStatement pstm=conn.prepareStatement(strsql);
							pstm.setString(1,session.getAttribute("qy").toString());
							pstm.setString(2,session.getAttribute("ygid").toString());
							pstm.setString(3,rs.getString("email"));
							pstm.setString(4,"积分领取通知");
							pstm.setString(5,mailContent);
							pstm.setString(6,sf2.format(Calendar.getInstance().getTime()));
							pstm.setString(7,"2");
							pstm.setString(8,String.valueOf(ffzt));
							pstm.setString(9,"50");
							pstm.executeUpdate();
							pstm.close();
							
						}
						rs.close();
						
						
						showtxt.append("每人"+ojfs[i]+"积分  共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs[i])*ygarr.length)+"</span> 积分</p>");						
						tjf=tjf+Integer.valueOf(ojfs[i])*ygarr.length;
					}
					if (fflx[i].equals("4"))
					{
						//发放信息表						
						strsql="insert into tbl_jfffxx (qy,jfff,fflx,jf,rs) values("+session.getAttribute("qy")+","+jfff+",4,"+ojfs[i]+","+lxvalue[i]+")";
						
						stmt.executeUpdate(strsql);
						
						strsql="select nid from tbl_jfffxx where qy="+session.getAttribute("qy")+" order by nid desc limit 1";
						rs=stmt.executeQuery(strsql);
						if(rs.next())
						{
							jfffxx=rs.getString("nid");
						}
						rs.close();
						
						
						StringBuffer yg=new StringBuffer();
						strsql="select nid,email,ygxm from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3 and zt=1";
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							yg.append(rs.getString("nid")+",");
							
							// instead of velocity String mailcon=rs.getString("ygxm")+"<br/>"+session.getAttribute("qymc")+"已于"+ffsj+"以"+jfmm+"的名目发放了"+ojfs[i]+"积分到您的帐户，<a href='http://119.145.4.25:88'>请及时进行领取</a>";
							//sendemail.sendHtmlEmail(rs.getString("email"),mailcon,"积分领取通知");	
							
							VelocityContext context = new VelocityContext();
							context.put("name", rs.getString("ygxm"));
							context.put("company", session.getAttribute("qymc"));
							context.put("assignedDate",ffsj);
							context.put("catagoryName", jfmm);
							context.put("quantity",ojfs[i]);
							
							Template template = Velocity.getTemplate("templates/mail/jfreceive.vm");
							StringWriter sw = new StringWriter();
							template.merge(context, sw);
							String mailContent = sw.toString();
							System.out.println("mail content: "+mailContent);
							
							strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj,ffbh) values(?,?,?,?,?,?,?,?,?,'jf"+jfff+"')";									
							PreparedStatement pstm=conn.prepareStatement(strsql);
							pstm.setString(1,session.getAttribute("qy").toString());
							pstm.setString(2,session.getAttribute("ygid").toString());
							pstm.setString(3,rs.getString("email"));
							pstm.setString(4,"积分领取通知");
							pstm.setString(5,mailContent);
							pstm.setString(6,sf2.format(Calendar.getInstance().getTime()));
							pstm.setString(7,"2");
							pstm.setString(8,String.valueOf(ffzt));
							pstm.setString(9,"50");
							pstm.executeUpdate();
							pstm.close();
							
						}
						rs.close();
						

						//发放明细表	
						String[] ygarr=yg.toString().split(",");
						for (int j=0;j<ygarr.length;j++)
						{
							if (ygarr[j]!=null && !ygarr[j].equals(""))
							{
								strsql="insert into tbl_jfffmc (qy,jfff,jfffxx,hqr,ffjf,ffsj,sfff,ffly) values("+session.getAttribute("qy")+","+jfff+","+jfffxx+","+ygarr[j]+","+ojfs[i]+",'"+ffsj+"',"+ffzt+",'"+ffrbm+"')";
								stmt.executeUpdate(strsql);
								
								//即时发放的更新会员积分
								
							}
						}
						hjr.append("全体员工 ");
						showtxt.append("<p>");
						showtxt.append("[全体员工] 每人"+ojfs[i]+"积分  共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs[i])*ygarr.length)+"</span> 积分</p>");						
						tjf=tjf+Integer.valueOf(ojfs[i])*ygarr.length;
					}
				}
				
			
			//更新企业表
			strsql="update tbl_qy set jf=jf-"+Integer.valueOf(tjf);
			//定时发放
			if (ffzt==0)
				strsql+=",djjf=djjf+"+Integer.valueOf(tjf);
			strsql+=" where nid="+session.getAttribute("qy");
			stmt.executeUpdate(strsql);
			
			
			
			//更新发放表
			String savehjr=hjr.toString();
			if (savehjr.length()>150) savehjr=savehjr.substring(0,145)+"...";
			strsql="update tbl_jfff set ffjf="+tjf+",hjr='"+savehjr+"' where nid="+jfff;
			stmt.executeUpdate(strsql);
			
			Integer jfye=Integer.valueOf(session.getAttribute("qyjf").toString())-Integer.valueOf(tjf);
			session.setAttribute("qyjf",String.valueOf(jfye));
			//冻结积分
			if (ffzt==0)
			{
				Integer sdjjf=Integer.valueOf(session.getAttribute("djjf").toString())+Integer.valueOf(tjf);
				session.setAttribute("djjf",String.valueOf(sdjjf));
			}
			}
	%>
	
	<div id="main">
	  	<div class="main2">
	  		<div class="box">				
				<ul class="local">
					<li class="local-ico3">
						<div class="local2-1"><h1>填写发放积分信息</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li class="local-ico1">
						<div class="local2-2"><h1>确认发放信息</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></div>
					</li>
					<li>
						<div class="local2-3"><h1>确认发放</h1><h2><%=ffsj%></h2></div>
					</li>
				</ul>
				<div class="ffcg-states">
					<h1>恭喜您，您以“<%=jfmm%>”的名义共发放了 <span><%=tjf%></span> 积分给以下对象</h1>
					<%=showtxt.toString()%>
				</div>
				<script type='text/javascript'>reftopjf('<%=session.getAttribute("qyjf")%>');</script>
				<div class="ffcg-tishi">您的积分账户余额 <span><%=session.getAttribute("qyjf")%></span> 积分，您还可以</div>
				<div class="paybtnbox2">
					<a href="assignintegral.jsp" class="jxffbtn"></a>
					<a href="buyintegral.jsp" class="gmjfbtn margintop15"></a>
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
