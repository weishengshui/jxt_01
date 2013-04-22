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
<%@page import="jxt.elt.common.DbPool"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="jxt.elt.common.SecurityUtil"%>

<%request.setCharacterEncoding("UTF-8"); %>
<%
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String gpemail=request.getParameter("email");
if (gpemail!=null)
{
	gpemail=fun.unescape(gpemail);
	gpemail=URLDecoder.decode(gpemail,"utf-8");
}




if (!fun.sqlStrCheck(gpemail))
{
	return;
}

try
{
	String ygxm="",ygid="",qyid="";
	String strsql="select nid,qy,ygxm from tbl_qyyg where email='"+gpemail+"'";
	rs=stmt.executeQuery(strsql);
	if (!rs.next())
	{
		rs.close();
		return;
	}
	else
	{
		ygid=rs.getString("nid");
		qyid=rs.getString("qy");
		ygxm=rs.getString("ygxm");
	}
	rs.close();
	
	SecurityUtil su=new SecurityUtil();
	Random rand=new Random();
	int dlmm=rand.nextInt(999999);
	if (dlmm<100000) dlmm=100000+dlmm;
	strsql="update tbl_qyyg set dlmm='"+su.md5(String.valueOf(dlmm))+"' where email='"+gpemail+"'";
	stmt.executeUpdate(strsql);
	
	//发送初始密码					
	/* instead of velocity 
	StringBuffer mailc=new StringBuffer();
	mailc.append("尊敬的"+ygxm+"：<br/> ");
	mailc.append("    您使用“通过邮箱找回密码”功能，我们已帮你初始化密码，登陆后请尽快更改初始密码。<br/><br/>");
	mailc.append("登录账号和新密码如下<br/>");
	mailc.append("    登录账号："+gpemail+"<br/>");
	mailc.append("    初始化登录密码："+String.valueOf(dlmm)+"<br/><br/>");
	mailc.append("若您有相关需求和意向，可联系我们，联系邮箱：xiao.ling@china-rewards.com，在2-3个工作日内由我们的顾问与您取得联系<br/>");
	mailc.append("若您对该体验有任何建议，可联系我们，联系邮箱：zhen.liang@china-rewards.com<br/>");
	*/
	//SendEmailBean sendemail=new SendEmailBean();
	//sendemail.sendHtmlEmail(gpemail,mailc.toString(),"通过邮箱找回密码");
	
	VelocityContext context = new VelocityContext();
	context.put("name", ygxm);
	context.put("loginAccount", gpemail);
	context.put("loginPassword", dlmm);
	
	Template template = Velocity.getTemplate("templates/mail/forgetpwd.vm");
	StringWriter sw = new StringWriter();
	template.merge(context, sw);
	String mailContent = sw.toString();
	System.out.println("mail content: "+mailContent);
	
	SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj) values(?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstm=conn.prepareStatement(strsql);
	pstm.setString(1,qyid);
	pstm.setString(2,ygid);
	pstm.setString(3,gpemail);
	pstm.setString(4,"IRewards密码");
	pstm.setString(5,mailContent);
	pstm.setString(6,sf.format(Calendar.getInstance().getTime()));
	pstm.setString(7,"1");
	pstm.setString(8,"1");
	pstm.setString(9,"100");
	pstm.executeUpdate();
	pstm.close();
	
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
