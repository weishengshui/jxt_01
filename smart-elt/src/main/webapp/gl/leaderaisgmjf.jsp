<%@page import="org.apache.velocity.Template"%>
<%@page import="org.apache.velocity.VelocityContext"%>
<%@page import="org.apache.velocity.app.Velocity"%>
<%@page import="jxt.elt.common.EmailTemplate"%>
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
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
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
String xid=request.getParameter("xid");
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
int xxfflx=0,xxlxbh=0,xxjf=0;

if (!fun.sqlStrCheck(xid)||!fun.sqlStrCheck(mm1)|| !fun.sqlStrCheck(mm2)|| !fun.sqlStrCheck(ffsj)|| !fun.sqlStrCheck(bz)|| !fun.sqlStrCheck(sendfflx)|| !fun.sqlStrCheck(sendojfs)|| !fun.sqlStrCheck(sendvalue)|| !fun.sqlStrCheck(ctjf)|| !fun.sqlStrCheck(ffh))
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
		String ffbm = session.getAttribute("ffbm").toString();
	    if ("''".equals(ffbm)) {
	    	ffbm = "-1";
	    }
	    String ffxz = session.getAttribute("ffxz").toString();
	    if ("''".equals(ffxz)) {
	    	ffxz = "-1";
	    }
		strsql="select sum(x.jf-x.yffjf) as kyjf from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid where (f.mm1 is null or f.mm1=0) and f.mm2=0 and ((x.fflx=1 and x.lxbh in ("+ffbm+")) or (x.fflx=2 and x.lxbh in ("+ffxz+"))) and x.jf<>x.yffjf  and f.ffzt=1 order by f.ffsj desc";
		rs=stmt.executeQuery(strsql);
		int kyjf = 0;
		if (rs.next())
		{
			kyjf=rs.getInt("kyjf");
		}
		rs.close();
		if (kyjf < Integer.valueOf(ctjf))
		{
			rs.close();
			out.print("<script type='text/javascript'>");
			out.print("alert('该发放名目可发放的积分数不够!');");
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
			out.print("location.href='leaderjf.jsp';");
			out.print("</script>");
			return;
		}
		rs.close();
		
		String ffrbm="";
		strsql="select fflx,lxbh,jf,jsmc from tbl_jfffxx where nid="+xid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			xxfflx=rs.getInt("fflx");
			xxlxbh=rs.getInt("lxbh");
			xxjf=rs.getInt("jf");
			ffrbm=rs.getString("jsmc");
		}
		rs.close();
		
		strsql="insert into tbl_jfff (qy,mm1,mm2,bz,ffr,ffsj,srsj,ffzt,ffxx,ffh) values("+session.getAttribute("qy")+","+mm1+","+mm2+",'"+bz+"',"+session.getAttribute("ygid")+",'"+ffsj+"',now(),"+ffzt+","+xid+",'"+ffh+"')";
		stmt.executeUpdate(strsql);
		
		strsql="select nid from tbl_jfff where qy="+session.getAttribute("qy")+" and ffr="+session.getAttribute("ygid")+" and ffxx="+xid+" order by nid desc limit 1";
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
							strsql="select ld from tbl_qybm where nid="+bmarr[j];
							rs=stmt.executeQuery(strsql);
							if (rs.next())
							{
								ldbh=rs.getInt("ld");
							}
							rs.close();
							strsql="insert into tbl_jfffxx (qy,jfff,fflx,lxbh,jf,ldbh) values("+session.getAttribute("qy")+","+jfff+",1,"+bmarr[j]+","+ojfs[i]+","+ldbh+")";
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
							strsql="select ld from tbl_qyxz where nid="+xzarr[j];
							rs=stmt.executeQuery(strsql);
							if (rs.next())
							{
								ldbh=rs.getInt("ld");
							}
							rs.close();
							strsql="insert into tbl_jfffxx (qy,jfff,fflx,lxbh,jf,ldbh) values("+session.getAttribute("qy")+","+jfff+",2,"+xzarr[j]+","+ojfs[i]+","+ldbh+")";
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
							//即时发放的更新会员积分
							if (ffzt==1)
							{
								//strsql="update tbl_qyyg set jf=jf+"+ojfs[i]+" where nid="+ygarr[j];
								//stmt.executeUpdate(strsql);
							}
						}
						
						showtxt.append("<p>");
						strsql="select email,ygxm from tbl_qyyg where nid in ("+lxvalue[i]+")";
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							showtxt.append("["+rs.getString("ygxm")+"] ");
							hjr.append(rs.getString("ygxm")+" ");
							//instead of velocity String mailcon=rs.getString("ygxm")+"<br/>"+ffrbm+"已于"+ffsj+"以"+jfmm+"的名目发放了"+ojfs[i]+"积分到您的帐户，<a href='http://119.145.4.25:88'>请及时进行领取</a>";
							//sendemail.sendHtmlEmail(rs.getString("email"),mailcon,"积分领取通知");
							
							VelocityContext context = new VelocityContext();
							context.put("name", rs.getString("ygxm"));
							context.put("company", ffrbm);
							context.put("assignedDate",ffsj);
							context.put("catagoryName", jfmm);
							context.put("quantity",ojfs[i]);
							
// 							Template template = Velocity.getTemplate("templates/mail/jfreceive.vm");
							Template template = EmailTemplate.getTemplate("jfreceive.vm");
							StringWriter sw = new StringWriter();
							template.merge(context, sw);
							String mailContent = sw.toString();
							System.out.println("mail content: "+mailContent);
							
							strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj) values(?,?,?,?,?,?,?,?,?)";									
							PreparedStatement pstm=conn.prepareStatement(strsql);
							pstm.setString(1,session.getAttribute("qy").toString());
							pstm.setString(2,session.getAttribute("ygid").toString());
							pstm.setString(3,rs.getString("email"));
							pstm.setString(4,"积分领取通知");
							pstm.setString(5,mailContent);
							pstm.setString(6,sf2.format(Calendar.getInstance().getTime()));
							pstm.setString(7,"4");
							pstm.setString(8,"1");
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
						
						if (xxfflx==1)
							strsql="select nid,email,ygxm from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3 and zt=1 and bm like '%,"+xxlxbh+",%'";
						
						if (xxfflx==2)
							strsql="select y.nid,y.email,y.ygxm from tbl_qyxzmc x inner join tbl_qyyg y on x.yg=y.nid where x.xz="+xxlxbh+"  and y.zt=1 and y.xtzt<>3 ";
						
						rs=stmt.executeQuery(strsql);
						while(rs.next())
						{
							yg.append(rs.getString("nid")+",");
							//instead of velocity String mailcon=rs.getString("ygxm")+"<br/>"+ffrbm+"已于"+ffsj+"以"+jfmm+"的名目发放了"+ojfs[i]+"积分到您的帐户，<a href='http://119.145.4.25:88'>请及时进行领取</a>";
							//sendemail.sendHtmlEmail(rs.getString("email"),mailcon,"积分领取通知");
							
							VelocityContext context = new VelocityContext();
							context.put("name", rs.getString("ygxm"));
							context.put("company", ffrbm);
							context.put("assignedDate",ffsj);
							context.put("catagoryName", jfmm);
							context.put("quantity",ojfs[i]);
							
// 							Template template = Velocity.getTemplate("templates/mail/jfreceive.vm");
							Template template = EmailTemplate.getTemplate("jfreceive.vm");
							StringWriter sw = new StringWriter();
							template.merge(context, sw);
							String mailContent = sw.toString();
							System.out.println("mail content: "+mailContent);
							
							strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj) values(?,?,?,?,?,?,?,?,?)";									
							PreparedStatement pstm=conn.prepareStatement(strsql);
							pstm.setString(1,session.getAttribute("qy").toString());
							pstm.setString(2,session.getAttribute("ygid").toString());
							pstm.setString(3,rs.getString("email"));
							pstm.setString(4,"积分领取通知");
							pstm.setString(5,mailContent);
							pstm.setString(6,sf2.format(Calendar.getInstance().getTime()));
							pstm.setString(7,"4");
							pstm.setString(8,"1");
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
								if (ffzt==1)
								{
									//strsql="update tbl_qyyg set jf=jf+"+ojfs[i]+" where nid="+ygarr[j];
									//stmt.executeUpdate(strsql);
								}
							}
						}
						hjr.append("全体员工 ");
						showtxt.append("<p>");
						showtxt.append("[全体员工] 每人"+ojfs[i]+"积分  共 <span class=\"yellowtxt\">"+String.valueOf(Integer.valueOf(ojfs[i])*ygarr.length)+"</span> 积分</p>");						
						tjf=tjf+Integer.valueOf(ojfs[i])*ygarr.length;
					}
				}
				
			
			//更新已发放积分
            strsql="select x.nid, (x.jf-x.yffjf) as ye from tbl_jfffxx x inner join tbl_jfff f on x.jfff=f.nid where ((x.fflx=1 and x.lxbh in ("+ffbm+")) or (x.fflx=2 and x.lxbh in ("+ffxz+"))) and x.jf<>x.yffjf  and f.ffzt=1 and f.fftype>0 order by ye";			
			
			rs=stmt.executeQuery(strsql);
			int ykjf=0;
			int ye=0;
			int zffjf=tjf;
			int nid=0;
			Statement stmt2=conn.createStatement();
			while (rs.next())
			{
				nid=rs.getInt("nid");
				ye=rs.getInt("ye");
				if (ye>=(zffjf-ykjf)) {
					strsql="update tbl_jfffxx set yffjf=yffjf+"+(zffjf-ykjf)+" where nid="+nid;
					stmt2.execute(strsql);
					break;
				} else {
					strsql="update tbl_jfffxx set yffjf=yffjf+"+ye+" where nid="+nid;
					stmt2.execute(strsql);
					ykjf+=ye;
				}
			}
			stmt2.close();
			rs.close();
			
			
			//更新发放表
			String savehjr=hjr.toString();
			if (savehjr.length()>150) savehjr=savehjr.substring(0,145)+"...";
			strsql="update tbl_jfff set ffjf="+tjf+",hjr='"+savehjr+"' where nid="+jfff;
			stmt.executeUpdate(strsql);
			
			Integer jfye=Integer.valueOf(session.getAttribute("qyjf").toString())-Integer.valueOf(tjf);
			session.setAttribute("qyjf",String.valueOf(jfye));
			
			getjfxx(stmt, session);
			out.print("<script type='text/javascript'>reftopjfxx('"+session.getAttribute("hrffjf")+"', '"+session.getAttribute("gmjf")+"');</script>");
			
			//冻结积分
			if (ffzt==0)
			{
				//Integer sdjjf=Integer.valueOf(session.getAttribute("djjf").toString())+Integer.valueOf(tjf);
				//session.setAttribute("djjf",String.valueOf(sdjjf));
			}
			}
	%>
	<script type='text/javascript'>reftopjf('<%=session.getAttribute("qyjf")%>');</script>
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
				<div class="ffcg-tishi">本名目还有余额 <span><%=session.getAttribute("gmjf")%></span> 积分，您还可以</div>
				<div class="paybtnbox2">
					<a href="leaderjf.jsp" class="jxffbtn"></a>					
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
