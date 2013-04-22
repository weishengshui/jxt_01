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

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>

<%
menun=5;
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
String jfq=request.getParameter("jfq");
String ctjf=request.getParameter("ctjf");
String ffh=request.getParameter("ffh");

String jfmm="";
if (mm2==null || mm2.equals("null") || mm2.equals("")) mm2="0";
StringBuffer showtxt=new StringBuffer();

StringBuffer hjr=new StringBuffer();
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat sf2=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
int tjf=0,oldtjf=0;
int haven=0;
String jfff="";

if (!fun.sqlStrCheck(jfq)||!fun.sqlStrCheck(mm1)|| !fun.sqlStrCheck(mm2)|| !fun.sqlStrCheck(ffsj)|| !fun.sqlStrCheck(bz)|| !fun.sqlStrCheck(sendfflx)|| !fun.sqlStrCheck(sendojfs)|| !fun.sqlStrCheck(sendvalue)|| !fun.sqlStrCheck(ctjf)|| !fun.sqlStrCheck(ffh))
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
	if (jfq!=null && jfq.length()>0)
	{
		
		strsql="select sum(sl-ffsl) as haven from tbl_jfqddmc  where qy="+session.getAttribute("qy")+" and zt=1 and sl<>ffsl and jfq="+jfq;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			haven=rs.getInt("haven");
		}
		rs.close();
		
		
		int ffzt=0;
		if (sf.parse(ffsj).after(Calendar.getInstance().getTime()))
			ffzt=0;
		else
			ffzt=1;
		
		
		//判断积分券是否够		
		if (haven<Integer.valueOf(ctjf))
		{
			out.print("<script type='text/javascript'>");
			out.print("alert('该积分券数量不够!');");
			out.print("history.back(-1);");
			out.print("</script>");
			return;
		}
		
		
		//防止刷新重复发放
		strsql="select nid from tbl_jfqff where qy="+session.getAttribute("qy")+" and ffh='"+ffh+"'";		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			rs.close();
			out.print("<script type='text/javascript'>");
			out.print("alert('请不要重复发放!');");
			out.print("location.href='mywelfare.jsp';");
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
		
		strsql="insert into tbl_jfqff (qy,mm1,mm2,bz,ffr,ffsj,srsj,jfq,ffzt,ffh) values("+session.getAttribute("qy")+","+mm1+","+mm2+",'"+bz+"',"+session.getAttribute("ygid")+",'"+ffsj+"',now(),"+jfq+","+ffzt+",'"+ffh+"')";
		stmt.executeUpdate(strsql);
		
		strsql="select nid from tbl_jfqff where qy="+session.getAttribute("qy")+" and ffr="+session.getAttribute("ygid")+" order by nid desc limit 1";
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
		
		
		int jfqffmcid=0;
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
									//instead of velocity String mailcon=rs.getString("ygxm")+"<br/>"+session.getAttribute("qymc")+"已于"+ffsj+"以"+jfmm+"的名目发放了"+ojfs[i]+"积分券到您管理的["+bmmc+"]帐户，<a href='http://119.145.4.25:88'>请及时进行发放</a>";
									//sendemail.sendHtmlEmail(rs.getString("email"),mailcon,"积分券发放通知");
									
									VelocityContext context = new VelocityContext();
									context.put("name", rs.getString("ygxm"));
									context.put("company", session.getAttribute("qymc"));
									context.put("assignedDate",ffsj);
									context.put("catagoryName", jfmm);
									context.put("quantity",ojfs[i]);
									context.put("account", bmmc);
									
									Template template = Velocity.getTemplate("templates/mail/jfqassign.vm");
									StringWriter sw = new StringWriter();
									template.merge(context, sw);
									String mailContent = sw.toString();
									System.out.println("mail content: "+mailContent);
									
									strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj,ffbh) values(?,?,?,?,?,?,?,?,?,'jfq"+jfff+"')";									
									PreparedStatement pstm=conn.prepareStatement(strsql);
									pstm.setString(1,session.getAttribute("qy").toString());
									pstm.setString(2,session.getAttribute("ygid").toString());
									pstm.setString(3,rs.getString("email"));
									pstm.setString(4,"福利券发放通知");
									pstm.setString(5,mailContent);
									pstm.setString(6,sf2.format(Calendar.getInstance().getTime()));
									pstm.setString(7,"3");
									pstm.setString(8,String.valueOf(ffzt));
									pstm.setString(9,"50");
									pstm.executeUpdate();
									pstm.close();
								}
							}
							rs.close();
							
							strsql="insert into tbl_jfqffxx (qy,jfqff,fflx,lxbh,jf,jfq,ldbh,jsmc) values("+session.getAttribute("qy")+","+jfff+",1,"+bmarr[j]+","+ojfs[i]+","+jfq+","+ldbh+",'"+bmmc+"')";
							stmt.executeUpdate(strsql);
						}
						
						strsql="select bmmc from tbl_qybm where nid in ("+lxvalue[i]+")";
						//out.print(strsql);
						//if (1==1) return;
						showtxt.append("<li>发放授权: ");
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							showtxt.append("["+rs.getString("bmmc")+"] ");
							hjr.append(rs.getString("bmmc")+" ");
						}
						rs.close();
						showtxt.append("每部门"+ojfs[i]+"张  共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs[i])*bmarr.length)+"</span> 张</li>");						
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
									//instead of velocity String mailcon=rs.getString("ygxm")+"<br/>"+session.getAttribute("qymc")+"已于"+ffsj+"以"+jfmm+"的名目发放了"+ojfs[i]+"积分券到您管理的["+xzmc+"]帐户，<a href='http://119.145.4.25:88'>请及时进行发放</a>";
									//sendemail.sendHtmlEmail(rs.getString("email"),mailcon,"积分券发放通知");
									
									VelocityContext context = new VelocityContext();
									context.put("name", rs.getString("ygxm"));
									context.put("company", session.getAttribute("qymc"));
									context.put("assignedDate",ffsj);
									context.put("catagoryName", jfmm);
									context.put("quantity",ojfs[i]);
									context.put("account", xzmc);
									
									Template template = Velocity.getTemplate("templates/mail/jfqassign.vm");
									StringWriter sw = new StringWriter();
									template.merge(context, sw);
									String mailContent = sw.toString();
									System.out.println("mail content: "+mailContent);
									
									strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj,ffbh) values(?,?,?,?,?,?,?,?,?,'jfq"+jfff+"')";									
									PreparedStatement pstm=conn.prepareStatement(strsql);
									pstm.setString(1,session.getAttribute("qy").toString());
									pstm.setString(2,session.getAttribute("ygid").toString());
									pstm.setString(3,rs.getString("email"));
									pstm.setString(4,"福利券发放通知");
									pstm.setString(5,mailContent);
									pstm.setString(6,sf2.format(Calendar.getInstance().getTime()));
									pstm.setString(7,"3");
									pstm.setString(8,String.valueOf(ffzt));
									pstm.setString(9,"50");
									pstm.executeUpdate();
									pstm.close();
								}
							}
							rs.close();
							strsql="insert into tbl_jfqffxx (qy,jfqff,fflx,lxbh,jf,jfq,ldbh,jsmc) values("+session.getAttribute("qy")+","+jfff+",2,"+xzarr[j]+","+ojfs[i]+","+jfq+","+ldbh+",'"+xzmc+"')";
							stmt.executeUpdate(strsql);
						}
						
						strsql="select xzmc from tbl_qyxz where nid in ("+lxvalue[i]+")";
						showtxt.append("<li>发放授权: ");
						rs=stmt.executeQuery(strsql);
						while (rs.next())
						{
							showtxt.append("["+rs.getString("xzmc")+"] ");
							hjr.append(rs.getString("xzmc")+" ");
						}
						rs.close();
						
						showtxt.append("每小组"+ojfs[i]+"张  共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs[i])*xzarr.length)+"</span> 张</li>");						
						tjf=tjf+Integer.valueOf(ojfs[i])*xzarr.length;
						
					}
					
					if (fflx[i].equals("3"))
					{
						String[] ygarr=lxvalue[i].split(",");
						//发放信息表						
						strsql="insert into tbl_jfqffxx (qy,jfqff,fflx,jf,rs,jfq) values("+session.getAttribute("qy")+","+jfff+",3,"+ojfs[i]+","+ygarr.length+","+jfq+")";
						
						stmt.executeUpdate(strsql);
						
						strsql="select nid from tbl_jfqffxx where qy="+session.getAttribute("qy")+" order by nid desc limit 1";
						rs=stmt.executeQuery(strsql);
						if(rs.next())
						{
							jfffxx=rs.getString("nid");
						}
						rs.close();
						
						//发放明细表	
						
						for (int j=0;j<ygarr.length;j++)
						{													
							//发放明细表
							strsql="insert into tbl_jfqffmc (qy,jfqff,jfqffxx,hqr,ffjf,ffsj,jfq,sfff) values("+session.getAttribute("qy")+","+jfff+","+jfffxx+","+ygarr[j]+","+ojfs[i]+",'"+ffsj+"',"+jfq+","+ffzt+")";
							stmt.executeUpdate(strsql);
							
							strsql="select nid from tbl_jfqffmc where jfqff="+jfff+" order by nid desc limit 1";
							rs=stmt.executeQuery(strsql);
							if (rs.next())
							{
								jfqffmcid=rs.getInt("nid");
							}
							rs.close();
							
							strsql="update tbl_jfqmc set  qyyg="+ygarr[j]+",jfqffmc="+jfqffmcid+",ffly='"+ffrbm+"',ffsj='"+ffsj+"',ffyy='"+jfmm+"'";
							if (ffzt==1)
								strsql+=",ffzt=1";
							strsql+=" where nid in (select nid from (select nid from tbl_jfqmc where qy="+session.getAttribute("qy")+" and jfq="+jfq+" and qyyg=0 order by nid limit "+ojfs[i]+") ab)";
							stmt.executeUpdate(strsql);
							
							
						}
						showtxt.append("<li>获奖对象：");
						strsql="select email,ygxm from tbl_qyyg where nid in ("+lxvalue[i]+")";
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							showtxt.append("["+rs.getString("ygxm")+"] ");
							hjr.append(rs.getString("ygxm")+" ");
							
								//instead of velocity String mailcon=rs.getString("ygxm")+"<br/>"+session.getAttribute("qymc")+"已于"+ffsj+"以"+jfmm+"的名目发放了"+ojfs[i]+"积分券到您的帐户，<a href='http://119.145.4.25:88'>请及时进行领取</a>";
								//sendemail.sendHtmlEmail(rs.getString("email"),mailcon,"积分券领取通知");
								
								VelocityContext context = new VelocityContext();
								context.put("name", rs.getString("ygxm"));
								context.put("company", session.getAttribute("qymc"));
								context.put("assignedDate",ffsj);
								context.put("catagoryName", jfmm);
								context.put("quantity",ojfs[i]);
								
								Template template = Velocity.getTemplate("templates/mail/jfqreceive.vm");
								StringWriter sw = new StringWriter();
								template.merge(context, sw);
								String mailContent = sw.toString();
								System.out.println("mail content: "+mailContent);
								
								strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj,ffbh) values(?,?,?,?,?,?,?,?,?,'jfq"+jfff+"')";									
								PreparedStatement pstm=conn.prepareStatement(strsql);
								pstm.setString(1,session.getAttribute("qy").toString());
								pstm.setString(2,session.getAttribute("ygid").toString());
								pstm.setString(3,rs.getString("email"));
								pstm.setString(4,"福利券领取通知");
								pstm.setString(5,mailContent);
								pstm.setString(6,sf2.format(Calendar.getInstance().getTime()));
								pstm.setString(7,"3");
								pstm.setString(8,String.valueOf(ffzt));
								pstm.setString(9,"50");
								pstm.executeUpdate();
								pstm.close();
							
						}
						rs.close();
						
						
						
						showtxt.append("每人"+ojfs[i]+"张  共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs[i])*ygarr.length)+"张</span></li>");						
						tjf=tjf+Integer.valueOf(ojfs[i])*ygarr.length;
					}
					if (fflx[i].equals("4"))
					{
						//发放信息表						
						strsql="insert into tbl_jfqffxx (qy,jfqff,fflx,jf,rs,jfq) values("+session.getAttribute("qy")+","+jfff+",4,"+ojfs[i]+","+lxvalue[i]+","+jfq+")";
						
						stmt.executeUpdate(strsql);
						
						strsql="select nid from tbl_jfqffxx where qy="+session.getAttribute("qy")+" order by nid desc limit 1";
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
							
								//instead of velocity String mailcon=rs.getString("ygxm")+"<br/>"+session.getAttribute("qymc")+"已于"+ffsj+"以"+jfmm+"的名目发放了"+ojfs[i]+"积分券到您的帐户，<a href='http://119.145.4.25:88'>请及时进行领取</a>";
								//sendemail.sendHtmlEmail(rs.getString("email"),mailcon,"积分券领取通知");
								
								VelocityContext context = new VelocityContext();
								context.put("name", rs.getString("ygxm"));
								context.put("company", session.getAttribute("qymc"));
								context.put("assignedDate",ffsj);
								context.put("catagoryName", jfmm);
								context.put("quantity",ojfs[i]);
								
								Template template = Velocity.getTemplate("templates/mail/jfqreceive.vm");
								StringWriter sw = new StringWriter();
								template.merge(context, sw);
								String mailContent = sw.toString();
								System.out.println("mail content: "+mailContent);
								
								strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj,ffbh) values(?,?,?,?,?,?,?,?,?,'jfq"+jfff+"')";									
								PreparedStatement pstm=conn.prepareStatement(strsql);
								pstm.setString(1,session.getAttribute("qy").toString());
								pstm.setString(2,session.getAttribute("ygid").toString());
								pstm.setString(3,rs.getString("email"));
								pstm.setString(4,"福利券领取通知");
								pstm.setString(5,mailContent);
								pstm.setString(6,sf2.format(Calendar.getInstance().getTime()));
								pstm.setString(7,"3");
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
								//发放明细表
								strsql="insert into tbl_jfqffmc (qy,jfqff,jfqffxx,hqr,ffjf,ffsj,jfq,sfff) values("+session.getAttribute("qy")+","+jfff+","+jfffxx+","+ygarr[j]+","+ojfs[i]+",'"+ffsj+"',"+jfq+","+ffzt+")";
								stmt.executeUpdate(strsql);
								
								strsql="select nid from tbl_jfqffmc where jfqff="+jfff+" order by nid desc limit 1";
								rs=stmt.executeQuery(strsql);
								if (rs.next())
								{
									jfqffmcid=rs.getInt("nid");
								}
								rs.close();
								
								
								strsql="update tbl_jfqmc set  qyyg="+ygarr[j]+",jfqffmc="+jfqffmcid+",ffly='"+ffrbm+"',ffsj='"+ffsj+"',ffyy='"+jfmm+"'";
								if (ffzt==1)
									strsql+=",ffzt=1";
								strsql+=" where nid in (select nid from (select nid from tbl_jfqmc where qy="+session.getAttribute("qy")+" and jfq="+jfq+" and qyyg=0 order by nid limit "+ojfs[i]+") ab)";
								
								stmt.executeUpdate(strsql);
								
							}
						}
						hjr.append("全体员工 ");
						showtxt.append("<li>获奖对象：");
						showtxt.append("[全体员工] 每人"+ojfs[i]+"张  共  <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs[i])*ygarr.length)+"张</span></li>");						
						tjf=tjf+Integer.valueOf(ojfs[i])*ygarr.length;
					}
				}
			
			
			//更新发放表					
			String savehjr=hjr.toString();
			if (savehjr.length()>150) savehjr=savehjr.substring(0,145)+"...";
			strsql="update tbl_jfqff set ffjf="+tjf+",hjr='"+savehjr+"' where nid="+jfff;
			stmt.executeUpdate(strsql);
			
			//更新积分券订单表
			oldtjf=tjf;  //用于下面显示，tjf会变成0
			int sl=0,ffsl=0,nid=0;
			//前面一定要做好库存判断,不然这里会有死循环
			
			while(tjf>0)
			{
				//先进先出
				strsql="select nid,sl,ffsl from tbl_jfqddmc where qy="+session.getAttribute("qy")+" and jfq="+jfq+" and zt=1 and sl<>ffsl order by nid limit 1";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					nid=rs.getInt("nid");
					sl=rs.getInt("sl");
					ffsl=rs.getInt("ffsl");
				}
				rs.close();
				
				if (sl-ffsl>=tjf)
				{
					strsql="update tbl_jfqddmc set ffsl=ffsl+"+tjf;
					if (ffzt==0)
						strsql+=",djsl=djsl+"+tjf;
					strsql+=" where nid="+nid;
					stmt.executeUpdate(strsql);
				}
				else
				{
					
					if (ffzt==0)
						strsql="update tbl_jfqddmc set djsl=djsl+(sl-ffsl),ffsl=sl where nid="+nid;
					else
						strsql="update tbl_jfqddmc set ffsl=sl where nid="+nid;
					stmt.executeUpdate(strsql);
				}
				
				tjf=tjf-(sl-ffsl);
			}
		}

	%>
	
	<div id="main">
	  	<div class="main2" style="padding-bottom:20px">
  		  	<div class="box2">
		  		<ul class="local2">
					<li class="local2-ico3"><h1>选择积分券</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></li>
					<li class="local2-ico3"><h1>选择发放对象</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></li>
					<li class="local2-ico1"><h1>确认发放信息</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></li>
					<li><h1 class="current-local">确认发放</h1><h2><%=sf.format(Calendar.getInstance().getTime())%></h2></li>
				</ul>
		  		<div class="sendorder-top">订单 <%=sf.format(Calendar.getInstance().getTime()).replace("-","")+jfff %> 详细信息</div>
				<div class="box3">
					<%
					strsql="select q.nid,q.mc,q.sm,q.jf,q.sp,h.hdmc,h.hdtp from tbl_jfq q inner join tbl_jfqhd h on q.hd=h.nid where q.nid="+jfq;
					rs=stmt.executeQuery(strsql);
					if (rs.next())
					{
					%>
					<div class="confirm-t"><strong>您选择的积分券</strong></div>
					<div class="confirm-states">
						<h1><img src="../hdimg/<%=rs.getString("hdtp")%>" width="121" height="88" /></h1>
						<dl>
							<dt><%=rs.getString("hdmc")%></dt>
							<dd><%=rs.getString("mc")%></dd>
						</dl>
						<span>您共拥有 <%=haven%> 份，已选择 <%=oldtjf%> 份</span>
					</div>
					<%}
					rs.close();
					%>
					<div class="fafang-name" style="padding-left:10px"><strong>发放名目</strong>&nbsp;&nbsp;<%=jfmm%></div>
					<div class="fafang-name" style="padding-left:10px"><strong>发放信息</strong></div>
					<ul class="sendsucess-detail">
						<%=showtxt.toString()%>
					</ul>
					<div class="sendorder-data" style="padding-left:10px"><h1>发放日期</h1><span><%=ffsj%></span><h2>
					<%if (sf.parse(ffsj).after(Calendar.getInstance().getTime()))
						out.print("时间未到，暂未发放");
					 else
						 out.print("已经发放");
					 %>
					</h2></div>
					<div class="fafang-mark" style="padding-left:10px"><h1>备注信息</h1><span><%=bz%></span></div>
					<div class="fafang-sum" style="padding-left:10px">总计 <span class="yellowtxt"><%=oldtjf%></span> 份，该积分券您还剩 <%=haven-Integer.valueOf(oldtjf) %> 份，您还可以</div>
					<div class="fafang-confirm" style="margin-top:10px"><a href="mywelfare.jsp" class="jxffbtn"></a></div>
					<div class="fafang-confirm" style="margin-top:15px"><a href="buywelfare.jsp" class="gmflbtnbtn"></a></div>
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
