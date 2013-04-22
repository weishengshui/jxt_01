<%@page import="org.apache.velocity.Template"%>
<%@page import="org.apache.velocity.VelocityContext"%>
<%@page import="org.apache.velocity.app.Velocity"%>
<%@page import="java.io.StringWriter"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="jxt.elt.common.SecurityUtil"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8"); 

if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("1002")==-1)
{
	out.print("你没有操作权限！");
	return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards企业员工忠诚度系统</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/adminstyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">
function saveit()
{
	if(document.getElementById("qymc").value.trim()=="")
	{
		alert("请填写企业名称！");
		document.getElementById("qymc").focus();
		return false;
	}
	if(document.getElementById("qybh").value.trim()=="")
	{
		alert("请填写企业域名！");
		document.getElementById("qybh").focus();
		return false;
	}
	if(document.getElementById("qydz").value.trim()=="")
	{
		alert("请填写企业地址！");
		document.getElementById("qydz").focus();
		return false;
	}
	if(!LcNCheck(document.getElementById("qybh").value.trim()))
	{
		alert("企业域名只能包括数字和小写字母！");
		document.getElementById("qybh").focus();
		return false;
	}
	if(document.getElementById("yb").value.trim()=="")
	{
		alert("请填写邮编！");
		document.getElementById("yb").focus();
		return false;
	}
	if(!CheckNumber(document.getElementById("yb").value.trim()))
	{
		alert("邮编格式填写有误！");
		document.getElementById("yb").focus();
		return false;
	}
	if(document.getElementById("qh").value.trim()=="")
	{
		alert("请填写区号！");
		document.getElementById("qh").focus();
		return false;
	}
	if(!CheckNumber(document.getElementById("qh").value.trim()))
	{
		alert("区号只能包括数字！");
		document.getElementById("qh").focus();
		return false;
	}
	if(document.getElementById("dh").value.trim()=="")
	{
		alert("请填写电话！");
		document.getElementById("dh").focus();
		return false;
	}
	if(!CheckNumber(document.getElementById("dh").value.trim()))
	{
		alert("电话号码格式填写有误！");
		document.getElementById("dh").focus();
		return false;
	}
	
	if(document.getElementById("lxr").value.trim()=="")
	{
		alert("请填写联系人！");
		document.getElementById("lxr").focus();
		return false;
	}
	if(document.getElementById("lxremail").value.trim()=="")
	{
		alert("请填写联系人邮箱!");
		document.getElementById("lxremail").focus();
		return false;
	}
	if(!EmailCheck(document.getElementById("lxremail").value.trim()))
	{
		alert("联系人邮箱格式有误!");
		document.getElementById("lxremail").focus();
		return false;
	}
	if(document.getElementById("khjl").value.trim()=="")
	{
		alert("请填定客户经理!");
		document.getElementById("khjl").focus();
		return false;
	}
	if(document.getElementById("khjldh").value.trim()=="")
	{
		alert("请填定客户经理电话!");
		document.getElementById("khjldh").focus();
		return false;
	}
	if(!MobileCheck(document.getElementById("khjldh").value.trim()))
	{
		alert("客户经理电话格式有误!");
		document.getElementById("khjldh").focus();
		return false;
	}
	document.getElementById("naction").value ="save";
	document.getElementById("cform").submit();
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="1002";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String qymc="",qybh="",qydz="",qh="",dh="",yb="",lxr="",lxremail="",bz="",khjl="",khjldh="";
String qyid=request.getParameter("qyid");
if (qyid==null) qyid="";
if (!fun.sqlStrCheck(qyid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='qiyexinxi.jsp';");
	out.print("</script>");
	return;
}
try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{
		qymc=request.getParameter("qymc");
		qybh=request.getParameter("qybh");
		qydz=request.getParameter("qydz");
		yb=request.getParameter("yb");
		qh=request.getParameter("qh");
		dh=request.getParameter("dh");
		lxr=request.getParameter("lxr");
		lxremail=request.getParameter("lxremail");
		bz=request.getParameter("bz");
		khjl=request.getParameter("khjl");
		khjldh=request.getParameter("khjldh");
		if (!fun.sqlStrCheck(qymc) || !fun.sqlStrCheck(qybh) || !fun.sqlStrCheck(qydz) || !fun.sqlStrCheck(yb) || !fun.sqlStrCheck(qh) || !fun.sqlStrCheck(dh) || !fun.sqlStrCheck(lxr) || !fun.sqlStrCheck(lxremail) || !fun.sqlStrCheck(bz) || !fun.sqlStrCheck(khjl)  || !fun.sqlStrCheck(khjldh))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		if (qyid!=null && qyid.length()>0)
		{
			strsql="select nid from tbl_qy where nid<>"+qyid+" and qymc='"+qymc+"'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				rs.close();
				out.print("<script type='text/javascript'>");
		   		out.print("alert('企业名称已经存在，请不要重复');"); 
		   		out.print("history.back(-1);");
		   		out.print("</script>");
		   		return;
			}
			rs.close();
			
			//保存客户经理信息,先判断是否修改过了
			int isup=0;
			strsql="select nid from tbl_qy where nid="+qyid+" and khjl='"+khjl+"'";
			rs=stmt.executeQuery(strsql);
			if (!rs.next())
			{
				isup=1;				
			}
			rs.close();
			//变动了客户经理姓名就要保存信息
			if (isup==1)
			{
				strsql="insert into tbl_xtywy (qy,xm,dh,srsj) values("+qyid+",'"+khjl+"','"+khjldh+"',now())";
				stmt.executeUpdate(strsql);
			}
			
			strsql="update tbl_qy set qymc='"+qymc+"',qybh='"+qybh+"',qydz='"+qydz+"',qh='"+qh+"',dh='"+dh+"',yb='"+yb+"',lxr='"+lxr+"',lxremail='"+lxremail+"',bz='"+bz+"',khjl='"+khjl+"',khjldh='"+khjldh+"' where nid="+qyid;
			 stmt.execute(strsql);
			 out.print("<script type='text/javascript'>");
	   		 out.print("alert('修改成功');");
	   		 out.print("location.href='qiyexinxi.jsp';");
	   		 out.print("</script>");
	   		 return;
		}
		else
		{
			strsql="select nid from tbl_qy where  qymc='"+qymc+"'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				rs.close();
				out.print("<script type='text/javascript'>");
		   		out.print("alert('企业名称已经存在，请不要重复');"); 
		   		out.print("history.back(-1);");
		   		out.print("</script>");
		   		return;
			}
			rs.close();
			
			strsql="select nid from tbl_qyyg where  email='"+lxremail+"'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				rs.close();
				out.print("<script type='text/javascript'>");
		   		out.print("alert('企业联系人邮箱已经存在，请不要重复');"); 
		   		out.print("history.back(-1);");
		   		out.print("</script>");
		   		return;
			}
			rs.close();
			
			strsql="insert into tbl_qy (qymc,qybh,qydz,qh,dh,yb,lxr,lxremail,zt,srsj,bz,khjl,khjldh) values('"+qymc+"','"+qybh+"','"+qydz+"','"+qh+"','"+dh+"','"+yb+"','"+lxr+"','"+lxremail+"',2,now(),'"+bz+"','"+khjl+"','"+khjldh+"')";
			stmt.executeUpdate(strsql);
			
			strsql="select nid from tbl_qy where qymc='"+qymc+"' order by nid desc limit 1";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				qyid=rs.getString("nid");
			}
			rs.close();
			
			//保存客户经理信息
			strsql="insert into tbl_xtywy (qy,xm,dh,srsj) values("+qyid+",'"+khjl+"','"+khjldh+"',now())";
			stmt.executeUpdate(strsql);
			
			SecurityUtil su=new SecurityUtil();
			Random rand=new Random();
			int dlmm=rand.nextInt(999999);
			if (dlmm<100000) dlmm=100000+dlmm;
			strsql="insert into tbl_qyyg (qy,ygxm,email,dlmm,gly,glqx,zt) values("+qyid+",'"+lxr+"','"+lxremail+"','"+su.md5(String.valueOf(dlmm))+"',1,',1,2,3,4,5,6,7,10,11,12,13,',1)";
			stmt.executeUpdate(strsql);
			//邮件发送
			//SendEmailBean sendemail=new SendEmailBean();
			/* remove it implemented by velocity  
			StringBuffer mailc=new StringBuffer();
			mailc.append("尊敬的"+lxr+"：<br/>");
			mailc.append("    您的公司"+qymc+"重新设置ELT（Employee Loyalty Tools）平台登陆密码，您可使用初始化密码登录，登陆后请尽快更改初始密码。<br/><br/>");
			mailc.append("登录账号和新密码如下<br/>");
			mailc.append("    登录账号："+lxremail+"<br/>");
			mailc.append("    初始化登录密码："+String.valueOf(dlmm)+"<br/><br/>");
			mailc.append("若您有相关需求和意向，可联系我们，联系邮箱：xiao.ling@china-rewards.com，在2-3个工作日内由我们的顾问与您取得联系<br/>");
			mailc.append("若您对该体验有任何建议，可联系我们，联系邮箱：zhen.liang@china-rewards.com<br/>");	
			*/
			VelocityContext context = new VelocityContext();
			context.put("name", lxr);
			context.put("company", qymc);
			context.put("loginAccount", lxremail);
			context.put("loginPassword", dlmm);
			
			Template template = Velocity.getTemplate("templates/mail/qymanageraccount.vm");
			StringWriter sw = new StringWriter();
			template.merge(context, sw);
			String mailContent = sw.toString();
			System.out.println("mail content: "+mailContent);
			
			//sendemail.sendHtmlEmail(lxremail,mailc.toString(),"ELT系统HR账号");
			
			strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj) values(?,?,?,?,?,?,?,?,?)";									
			PreparedStatement pstm=conn.prepareStatement(strsql);
			pstm.setString(1,"0");
			pstm.setString(2,session.getAttribute("xtyh").toString());
			pstm.setString(3,lxremail);
			pstm.setString(4,"IRewards管理账号");
			pstm.setString(5,mailContent);
			pstm.setString(6,sf.format(Calendar.getInstance().getTime()));
			pstm.setString(7,"7");
			pstm.setString(8,"1");
			pstm.setString(9,"50");
			pstm.executeUpdate();
			pstm.close();
			
	   		
			out.print("<script type='text/javascript'>");
	   		out.print("alert('企业添加成功，已自动生成HR账号并自动发邮件给联系人了！');");
	   		out.print("location.href='qiyexinxi.jsp';");
	   		out.print("</script>");
	   		return;
		}
	}
	
	if (qyid!=null && qyid.length()>0)
	{
		strsql="select * from tbl_qy where nid="+qyid;		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			qymc=rs.getString("qymc");
			qybh=rs.getString("qybh");
			qydz=rs.getString("qydz");
			qh=rs.getString("qh");
			dh=rs.getString("dh");
			yb=rs.getString("yb");		
			lxr=rs.getString("lxr");
			lxremail=rs.getString("lxremail");
			bz=rs.getString("bz");
			khjl = rs.getString("khjl");
			khjldh = rs.getString("khjldh");
			if (bz==null) bz="";
		}
		rs.close();
	}
	
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <%@ include file="head.jsp" %>
  <tr>
    <td bgcolor="#f4f4f4"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="200" height="100%" valign="top"style="background:url(images/left-bottom.jpg) bottom">
			<%@ include file="leftmenu.jsp" %>
		  </td>
         <td width="10">&nbsp;</td>
        <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><div class="local"><span>企业管理 &gt; 企业信息管理 &gt; <%if (qyid!=null && qyid.length()>0) out.print("修改企业"); else out.print("添加企业");%></span><a href="qiyexinxi.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="qiyebianji.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="qyid" id="qyid" value="<%=qyid%>" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">企业名称：</td>
                          <td><input type="text" name="qymc" id="qymc" value="<%=qymc%>" maxlength="150" class="input3" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>企业域名：</td>
                          <td><input type="text" name="qybh" id="qybh" class="input3" value="<%=qybh%>" maxlength="25" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>地址：</td>
                          <td><input type="text" class="input3" name="qydz" id="qydz" value="<%=qydz%>" maxlength="100" /></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>邮编：</td>
                          <td><input type="text" class="input3" name="yb" id="yb"  value="<%=yb%>" maxlength="10" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>电话：</td>
                          <td><input type="text" class="input3" style="width: 50px;" name="qh" id="qh"  value="<%=qh%>" maxlength="10" />-<input type="text" class="input3" name="dh" id="dh" value="<%=dh%>" maxlength="25" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>企业联系人：</td>
                          <td><input type="text" class="input3" name="lxr" id="lxr"  value="<%=lxr%>" maxlength="25" /></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>联系人信箱：</td>
                          <td><input type="text" class="input3" name="lxremail" id="lxremail"  value="<%=lxremail%>" maxlength="50" /></td>
                        </tr>
                       
                        
                        <tr>
                          <td>&nbsp;</td>
                          <td valign="top">备注：</td>
                          <td><textarea rows="5" cols="50" name="bz" id="bz" ><%=bz %></textarea></td>
                        </tr>            
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>客户经理：</td>
                          <td><input type="text" class="input3" name="khjl" id="khjl"  value="<%=khjl%>" maxlength="10" /></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>客户经理手机：</td>
                          <td><input type="text" class="input3" name="khjldh" id="khjldh"  value="<%=khjldh%>" maxlength="25" /></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="#" class="reset"></a></span></td>
                        </tr>
                      </table>
                      </form>
            </td>
          </tr>
          
        </table></td>
        <td width="20">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
  <%@ include file="bottom.jsp" %>
</table>
<%}
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