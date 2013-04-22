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
<%@page import="jxt.elt.common.SecurityUtil"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",4,")==-1) 
	response.sendRedirect("main.jsp");
%>
<%request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/calendar3.js"></script>
<script type="text/javascript">
function saveit()
{
	
	if (document.getElementById("ygxm").value=="")
	{
		alert("请填写员工姓名！");
		return false;
	}
	if (document.getElementById("email").value=="")
	{
		alert("请填写邮箱！");
		return false;
	}
	if (!EmailCheck(document.getElementById("email").value))
	{
		alert("填写的邮箱格式不正确！");
		return false;
	}
	document.getElementById("naction").value="save";
	document.getElementById("yform").submit();
}

var bml=1;
function bmshow(v,l)
{
	if (l==5) return;
	bml=l+1;
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "selectbm.jsp?bmid="+v+"&bml="+bml+"&time="+timeParam;			
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showbm;
	xmlHttp.send(null);
	
}
function showbm()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			for(i=bml;i<6;i++)
			document.getElementById("bmlist"+i).innerHTML="";
			document.getElementById("bmlist"+bml).innerHTML=response;
		}
		catch(exception){}
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
 <body>
  <%menun=6; %>
<%@ include file="head.jsp" %>
<%

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="",naction="",ygid="",ygbh="",ygxm="",xb="",bm="",zw="",zsld="",lxdh="",email="",csrj="",zt="",rzsj="",bm1="",bm2="",bm3="",bm4="",bm5="";
naction=request.getParameter("naction");
ygid=request.getParameter("ygid");
if (ygid==null) ygid="";
if (naction!=null && naction.equals("save"))
{
	ygbh=request.getParameter("ygbh");
	ygxm=request.getParameter("ygxm");
	xb=request.getParameter("xb");
	bm1=request.getParameter("bm1");
	bm2=request.getParameter("bm2");
	bm3=request.getParameter("bm3");
	bm4=request.getParameter("bm4");
	bm5=request.getParameter("bm5");
	zsld=request.getParameter("zsld");
	lxdh=request.getParameter("lxdh");
	email=request.getParameter("email");
	csrj=request.getParameter("csrj");
	zt=request.getParameter("zt");
	rzsj=request.getParameter("rzsj");
	if (bm1!=null && !bm1.equals(""))
		bm="," + bm1+",";
	if (bm2!=null && !bm2.equals(""))
		bm=bm + bm2+",";
	if (bm3!=null && !bm3.equals(""))
		bm=bm + bm3+",";
	if (bm4!=null && !bm4.equals(""))
		bm=bm + bm4+",";
	if (bm5!=null && !bm5.equals(""))
		bm=bm + bm5+",";	
	if (csrj==null) csrj="";
	if (rzsj==null) rzsj="";
	if (lxdh==null) lxdh="";
	
}


if (!fun.sqlStrCheck(ygid) || !fun.sqlStrCheck(ygbh) || !fun.sqlStrCheck(ygxm) || !fun.sqlStrCheck(xb) || !fun.sqlStrCheck(bm) || !fun.sqlStrCheck(zw) || !fun.sqlStrCheck(zsld) || !fun.sqlStrCheck(lxdh)|| !fun.sqlStrCheck(email)|| !fun.sqlStrCheck(csrj)|| !fun.sqlStrCheck(zt)|| !fun.sqlStrCheck(rzsj))
{
	return;
}

try
{
		if (naction!=null && naction.equals("save"))
		{
			if (ygid!=null && !ygid.equals(""))
			{
				strsql="select nid from tbl_qyyg where nid!="+ygid+" and email='"+email+"'";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					rs.close();
					out.print("<script type='text/javascript'>");
	        	    out.print("alert('此邮箱已经有人使用！');");
	        	    out.print("history.back(-1);");
	        	    out.print("</script>");
	        	    return;
				}
				rs.close();
				
				strsql="update tbl_qyyg set ygbh='"+ygbh+"',ygxm='"+ygxm+"',xb="+xb+",bm='"+bm+"',lxdh='"+lxdh+"',zt="+zt;
				if (zt.equals("1"))
					strsql+=",email='"+email+"'";
				else
					strsql+=",email='"+email.replace("@","$")+"'";
				if (csrj!=null && csrj.length()>0)
					strsql+=",csrj='"+csrj+"'";
				if (rzsj!=null && rzsj.length()>0)
					strsql+=",rzsj='"+rzsj+"'";
				strsql+=" where nid="+ygid;
				stmt.executeUpdate(strsql);
			}
			else
			{
				strsql="select nid from tbl_qyyg where email='"+email+"'";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					rs.close();
					out.print("<script type='text/javascript'>");
	        	    out.print("alert('此邮箱已经有人使用！');");
	        	    out.print("history.back(-1);");
	        	    out.print("</script>");
	        	    return;
				}
				rs.close();
				
				SecurityUtil su=new SecurityUtil();
				Random rand=new Random();
				int dlmm=rand.nextInt(999999);
				if (dlmm<100000) dlmm=100000+dlmm;
				
				strsql="insert into tbl_qyyg (qy,ygbh,ygxm,xb,bm,lxdh,email,zt,dlmm";
				if (csrj!=null && csrj.length()>0)
					strsql+=",csrj";
				if (rzsj!=null && rzsj.length()>0)
					strsql+=",rzsj";
				strsql+=") values("+session.getAttribute("qy")+",'"+ygbh+"','"+ygxm+"',"+xb+",'"+bm+"','"+lxdh+"','"+email+"',"+zt+",'"+su.md5(String.valueOf(dlmm))+"'";
				if (csrj!=null && csrj.length()>0)
					strsql+=",'"+csrj+"'";
				if (rzsj!=null && rzsj.length()>0)
					strsql+=",'"+rzsj+"'";
				strsql+=")";
				stmt.executeUpdate(strsql);
				
				//发送初始密码							
				/* instead of velocity 
				StringBuffer mailc=new StringBuffer();
				mailc.append("尊敬的"+ygxm+"：<br/> ");
				mailc.append("    您的公司"+session.getAttribute("qymc")+"重新设置ELT（Employee Loyalty Tools）平台登陆密码，您可使用初始化密码登录，登陆后请尽快更改初始密码。<br/><br/>");
				mailc.append("登录账号和新密码如下<br/>");
				mailc.append("    登录账号："+email+"<br/>");
				mailc.append("    初始化登录密码："+String.valueOf(dlmm)+"<br/><br/>");
				mailc.append("若您有相关需求和意向，可联系我们，联系邮箱：xiao.ling@china-rewards.com，在2-3个工作日内由我们的顾问与您取得联系<br/>");
				mailc.append("若您对该体验有任何建议，可联系我们，联系邮箱：zhen.liang@china-rewards.com<br/>");
				*/
				
				VelocityContext context = new VelocityContext();
				context.put("name", ygxm);
				context.put("loginAccount", email);
				context.put("loginPassword", dlmm);
				
				Template template = Velocity.getTemplate("templates/mail/staffregisterpwd.vm");
				StringWriter sw = new StringWriter();
				template.merge(context, sw);
				String mailContent = sw.toString();
				System.out.println("mail content: "+mailContent);
				
				//SendEmailBean sendemail=new SendEmailBean();
				//sendemail.sendHtmlEmail(email,mailc.toString(),"ELT重置密码获取");
				SimpleDateFormat sf2=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj) values(?,?,?,?,?,?,?,?,?)";									
				PreparedStatement pstm=conn.prepareStatement(strsql);
				pstm.setString(1,session.getAttribute("qy").toString());
				pstm.setString(2,session.getAttribute("ygid").toString());
				pstm.setString(3,email);
				pstm.setString(4,"IRewards登录账号");
				pstm.setString(5,mailContent);
				pstm.setString(6,sf2.format(Calendar.getInstance().getTime()));
				pstm.setString(7,"6");
				pstm.setString(8,"1");
				pstm.setString(9,"50");
				pstm.executeUpdate();
				pstm.close();
			}
			
			
			response.sendRedirect("staff.jsp");
		}
		else if (ygid!=null && !ygid.equals(""))
		{
			strsql="select * from tbl_qyyg where nid="+ygid;		
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd");				
				ygbh=rs.getString("ygbh")==null?"":rs.getString("ygbh");
				ygxm=rs.getString("ygxm");
				xb=rs.getString("xb");
				bm=rs.getString("bm");				
				lxdh=rs.getString("lxdh")==null?"":rs.getString("lxdh");;
				email=rs.getString("email");
				if (rs.getDate("csrj")!=null && !rs.getDate("csrj").equals(""))
				csrj=sf.format(rs.getDate("csrj"));
				zt=rs.getString("zt");
				if (rs.getDate("rzsj")!=null && !rs.getDate("rzsj").equals(""))
				rzsj=sf.format(rs.getDate("rzsj"));
			}
			rs.close();
		}
%>		

<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="zhsz-top">
					<li><a href="company.jsp"><span><img src="images/ico-zh1.jpg" /></span><h1>企业信息管理</h1></a></li>
					<li><a href="department.jsp"><span><img src="images/ico-zh2.jpg" /></span><h1>组织架构管理</h1></a></li>
					<li><a href="staff.jsp" class="dangqian"><span><img src="images/ico-zh3.jpg" /></span><h1>员工信息管理</h1></a></li>
					<li><a href="group.jsp"><span><img src="images/ico-zh4.jpg" /></span><h1>小组管理</h1></a></li>
					<li><a href="item.jsp"><span><img src="images/ico-zh5.jpg" /></span><h1>发放名目管理</h1></a></li>
					<li><a href="info.jsp"><span><img src="images/ico-zh6.jpg" /></span><h1>公告管理</h1></a></li>
					<li><a href="admin.jsp"><span><img src="images/ico-zh7.jpg" /></span><h1>管理员管理</h1></a></li>
				</ul>
				<div class="zhszwrap">
					
					<div class="zhsz-up">
						<span><strong>员工信息管理：</strong></span>
						<div class="zhsz-up-r"><span class="floatleft"><a href="staff.jsp" class="caxun" style="margin:0">返 回</a></span></div>
					</div>
					<div class="zhszbox">
					<form action="staffedit.jsp" name="yform" id="yform" method="post">
						<input type="hidden" name="ygid" id="ygid" value="<%=ygid%>" /> 
						<input type="hidden" name="naction" id="naction" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
					  

  						<tr>
                          <td width="30" align="center"></td>
                          <td width="90">员工编号：</td><td><input class="input3" type="text" name="ygbh" id="ygbh" value="<%=ygbh%>" maxlength="25" /></td></tr>
  	<tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>员工姓名：</td><td><input class="input3" type="text" name="ygxm" id="ygxm" value="<%=ygxm%>" maxlength="12" /></td></tr>
  	<tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>性　　别：</td><td><input type="radio" name="xb" id="xb" value="1" <%if (xb==null || xb.equals("") || xb.equals("1")) out.print("checked='checked'"); %> />男 　　<input type="radio" name="xb" id="xb" value="2" <%if (xb!=null && xb.equals("2")) out.print("checked='checked'"); %> />女</td></tr>
  	<tr>
                          <td align="center"></td>
                          <td>部　　门：</td><td>
  	<%
  	int j=1;
  	int fbm=0;
  	String lastbm="";
  	if (bm!=null && !bm.equals(""))
  	{
  		String[] bmarr=bm.split(",");
  		
  		for (int i=0;i<bmarr.length;i++)
  		{
  			if (bmarr[i]!=null && !bmarr[i].equals(""))
  			{
  				out.print("<span id='bmlist"+j+"'><select name='bm"+j+"' id='bm"+j+"' onchange='bmshow(this.value,"+j+")'><option value=''>请选择</option>");
  				strsql="select nid,bmmc from tbl_qybm where qy="+session.getAttribute("qy")+" and fbm="+fbm;
  				rs=stmt.executeQuery(strsql);
  				while(rs.next())
  				{
  					if (bmarr[i].equals(rs.getString("nid")))
  					{fbm=rs.getInt("nid");
  					out.print("<option value='"+rs.getString("nid")+"' selected='selected'>"+rs.getString("bmmc")+"</option>");
  					}
  					else
  					out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("bmmc")+"</option>");
  				}
  				rs.close();
  				out.print("</select></span>");
  				j=j+1;
  				lastbm=bmarr[i];
  			}
  		}
  		
  		//判断是否新增子部门出来
  		if (lastbm!=null && lastbm.length()>0)
  		{
  			strsql="select nid,bmmc from tbl_qybm where qy="+session.getAttribute("qy")+" and fbm="+lastbm;
  			rs=stmt.executeQuery(strsql);
  	  		while (rs.next())
  	  		{
  	  			if (rs.isFirst())
  	  				out.print("<span id='bmlist"+j+"'><select  name='bm"+j+"' id='bm"+j+"' onchange='bmshow(this.value,"+j+")'><option value=''>请选择</option>");
  	  			out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("bmmc")+"</option>");
  	  			if (rs.isLast())
  	  			{
  	  				out.print("</select></span>");
  	  				j=j+1;
  	  			}
  	  		}
  	  		rs.close();
  		}
  		for (int i=j;i<6;i++)
  		{
  			out.print("<span id='bmlist"+i+"'></span>");
  		}
  	}
  	else
  	{
  		out.print("<span id='bmlist"+j+"'><select  name='bm"+j+"' id='bm"+j+"' onchange='bmshow(this.value,"+j+")'><option value=''>请选择</option>");
  		strsql="select nid,bmmc from tbl_qybm where qy="+session.getAttribute("qy")+" and fbm=0";
  		rs=stmt.executeQuery(strsql);
  		while (rs.next())
  		{
  			out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("bmmc")+"</option>");
  		}
  		rs.close();
  		out.print("</select></span>");
  		j=j+1;
  		for (int i=j;i<6;i++)
  		{
  			out.print("<span id='bmlist"+i+"'></span>");
  		}
  	}
  	%>
  	</td></tr>
  	<tr>
                          <td align="center"></td>
                          <td>联系电话：</td><td><input class="input3" type="text" name="lxdh" id="lxdh" value="<%=lxdh%>" maxlength="25" /></td></tr>
  	<tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>邮　　箱：</td><td><input class="input3" type="text" name="email" id="email" value="<%=email%>" maxlength="50" /></td></tr>
  	<tr>
                          <td align="center"></td>
                          <td>出生日期：</td><td><input class="input3" type="text" name="csrj" id="csrj" value="<%=csrj%>" onclick="new Calendar().show(this);" /></td></tr>
  	<tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>状　　态：</td><td><input type="radio" name="zt" id="zt" value="1" <%if (zt==null || zt.equals("") || zt.equals("1")) out.print("checked='checked'"); %> />在职　　<input type="radio" name="zt" id="zt" value="0" <%if (zt!=null && zt.equals("0")) out.print("checked='checked'"); %> />离职&nbsp;员工离职后该档案不可编辑</td></tr>
  	<tr>
                          <td align="center"></td>
                          <td>入职时间：</td><td><input  class="input3" type="text" name="rzsj" id="rzsj" value="<%=rzsj%>" onclick="new Calendar().show(this);" /></td></tr>
  	 <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="staffedit.jsp?ygid=<%=ygid%>" class="reset"></a></span></td>
                        </tr>
                      </table>
                      </form>
					</div>
				</div>
			</div>
	  	</div>
	</div>
	<%@ include file="footer.jsp" %> 
  	<%}
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