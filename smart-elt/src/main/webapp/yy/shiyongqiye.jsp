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
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="jxt.elt.common.SecurityUtil"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("1001")==-1)
{
	out.print("你没有操作权限！");
	return;
}
Fun fun=new Fun();
int ln=0;
int pages=1;
int psize=10;
String pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";
String qymc=request.getParameter("qymc");
if (qymc!=null)
{
	qymc=fun.unescape(qymc);
	qymc=URLDecoder.decode(qymc,"utf-8");
}
if (qymc==null) qymc="";
String naction=request.getParameter("naction");
String qyid=request.getParameter("qyid");
if (!fun.sqlStrCheck(qymc) || !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(qyid))
{	
	response.sendRedirect("shiyongqiye.jsp");
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
function audit(id)
{
	if (confirm("是否审核通过，发送测试帐号"))
	{
		location.href= "shiyongqiye.jsp?naction=audit&qyid="+id+"&qymc="+encodeURI(escape(document.getElementById("qymc").value))+"&pno=<%=pno%>";
		
	}
}

function audit2(id)
{
	if (confirm("是否确认重置密码"))
	{
		location.href= "shiyongqiye.jsp?naction=audit2&qyid="+id+"&qymc="+encodeURI(escape(document.getElementById("qymc").value))+"&pno=<%=pno%>";
		
	}
}
function delit(id)
{
	if (confirm("是否删除此企业信息"))
	{
		location.href="shiyongqiye.jsp?naction=del&qyid="+id+"&qymc="+encodeURI(escape(document.getElementById("qymc").value))+"&pno=<%=pno%>";
		
	}
}
function searchit(p)
{
	location.href="shiyongqiye.jsp?qymc="+encodeURI(escape(document.getElementById("qymc").value))+"&pno="+p;
}

function changezt(id)
{
	if (confirm("是否确认转正此企业"))
	{
		location.href= "shiyongqiye.jsp?naction=czt&qyid="+id;		
	}
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="1001";
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="",ygxm="",email="",eqymc="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
try{
	
	if (naction!=null && naction.equals("czt"))
	{
		strsql="select nid from tbl_qy where nid="+qyid+" and zt<2";
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			rs.close();
			strsql="update tbl_qy set zt=2 where nid="+qyid;
			stmt.executeUpdate(strsql);
			
			strsql="update tbl_qyyg set gly=1,glqx=',1,2,3,4,5,6,7,10,11,12,13,' where qy="+qyid;
			stmt.executeUpdate(strsql);
		}
		else
		{
			rs.close();
		}
	}
	
	if (naction!=null && naction.equals("del"))
	{
		strsql="delete from tbl_qy where nid="+qyid;
		stmt.executeUpdate(strsql);
	}
	//自动生成把联系人和邮箱生成一条员工信息，并发邮件
	if (naction!=null && naction.equals("audit"))
	{
		int qyzt=0;
		strsql="select zt from tbl_qy where nid="+qyid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			qyzt=rs.getInt("zt");
		}
		rs.close();
		if (qyzt==0)
		{
			strsql="update tbl_qy set zt=1 where nid="+qyid;
			stmt.executeUpdate(strsql);
			
			SecurityUtil su=new SecurityUtil();
// 			Random rand=new Random();
// 			int dlmm=rand.nextInt(999999);
// 			if (dlmm<100000) dlmm=100000+dlmm;
			
			// 试用账号发送默认密码“111111”
			int dlmm = 111111;
			strsql="select qymc,lxr,lxremail from tbl_qy where nid="+qyid;
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				eqymc=rs.getString("qymc");
				ygxm=rs.getString("lxr");
				email=rs.getString("lxremail");
			}
			rs.close();
			strsql="insert into tbl_qyyg (qy,ygxm,email,dlmm,zt) values("+qyid+",'"+ygxm+"','"+email+"','"+su.md5(String.valueOf(dlmm))+"',1)";
			stmt.executeUpdate(strsql);
			//邮件发送
			//SendEmailBean sendemail=new SendEmailBean();
			/* instread of velocity 
			StringBuffer mailc=new StringBuffer();
			mailc.append("尊敬的"+ygxm+"：<br/>");
			mailc.append("    您已代表"+eqymc+"申请ELT（Employee Loyalty Tools）平台体验账号，稍后您可以登录http:xxxxxx进行体验。<br/><br/>");
			mailc.append("登录账号和密码如下<br/> ");
			mailc.append("    体验账号："+email+"<br/>");
			mailc.append("    登录密码："+String.valueOf(dlmm)+"<br/><br/>");
			mailc.append("若您有相关需求和意向，可联系我们，联系邮箱：xiao.ling@china-rewards.com，在2-3个工作日内由我们的顾问与您取得联系<br/>");
			mailc.append("若您对该体验有任何建议，可联系我们，联系邮箱：zhen.liang@china-rewards.com<br/>");
			*/
			
			VelocityContext context = new VelocityContext();
			context.put("name", ygxm);
			context.put("company", eqymc);
			context.put("loginAccount", email);
			context.put("loginPassword", dlmm);
			
// 			Template template = Velocity.getTemplate("templates/mail/testaccountgenerated.vm");
			Template template = EmailTemplate.getTemplate("testaccountgenerated.vm");
			StringWriter sw = new StringWriter();
			template.merge(context, sw);
			String mailContent = sw.toString();
			System.out.println("mail content: "+mailContent);
			
			//sendemail.sendHtmlEmail(email,mailc.toString(),"ELT体验账号获取");
			strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj) values(?,?,?,?,?,?,?,?,?)";									
			PreparedStatement pstm=conn.prepareStatement(strsql);
			pstm.setString(1,"0");
			pstm.setString(2,session.getAttribute("xtyh").toString());
			pstm.setString(3,email);
			pstm.setString(4,"IRewards体验账号获取");
			pstm.setString(5,mailContent);
			pstm.setString(6,sf.format(Calendar.getInstance().getTime()));
			pstm.setString(7,"7");
			pstm.setString(8,"1");
			pstm.setString(9,"50");
			pstm.executeUpdate();
			pstm.close();
			out.print("<script type='text/javascript'>");
	   		out.print("alert('测试帐号已发送到联系人邮箱！');");   		
	   		out.print("</script>");
		}
	}
	
	if (naction!=null && naction.equals("audit2"))
	{
		SecurityUtil su=new SecurityUtil();
// 		Random rand=new Random();
// 		int dlmm=rand.nextInt(999999);
// 		if (dlmm<100000) dlmm=100000+dlmm;

		// 试用账号发送默认密码“111111”
		int dlmm = 111111;
		strsql="select qymc,lxr,lxremail from tbl_qy where nid="+qyid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			eqymc=rs.getString("qymc");
			ygxm=rs.getString("lxr");
			email=rs.getString("lxremail");
		}
		rs.close();
		
		strsql="update tbl_qyyg set dlmm='"+su.md5(String.valueOf(dlmm))+"' where email='"+email+"'";
		stmt.executeUpdate(strsql);
		//邮件发送
		//SendEmailBean sendemail=new SendEmailBean();
		
		/* instead of velocity 
		StringBuffer mailc=new StringBuffer();
		mailc.append("尊敬的"+ygxm+"：<br/>");
		mailc.append("    您已代表"+eqymc+"申请ELT（Employee Loyalty Tools）平台体验账号，稍后您可以登录http:xxxxxx进行体验。<br/><br/>");
		mailc.append("登录账号和密码如下<br/> ");
		mailc.append("    体验账号："+email+"<br/>");
		mailc.append("    登录密码："+String.valueOf(dlmm)+"<br/><br/>");
		mailc.append("若您有相关需求和意向，可联系我们，联系邮箱：xiao.ling@china-rewards.com，在2-3个工作日内由我们的顾问与您取得联系<br/>");
		mailc.append("若您对该体验有任何建议，可联系我们，联系邮箱：zhen.liang@china-rewards.com<br/>");
		*/
		
		VelocityContext context = new VelocityContext();
		context.put("name", ygxm);
		context.put("company", eqymc);
		context.put("loginAccount", email);
		context.put("loginPassword", dlmm);
		
// 		Template template = Velocity.getTemplate("templates/mail/testresetpwd.vm");
		Template template = EmailTemplate.getTemplate("testresetpwd.vm");
		StringWriter sw = new StringWriter();
		template.merge(context, sw);
		String mailContent = sw.toString();
		System.out.println("mail content: "+mailContent);
		
		//sendemail.sendHtmlEmail(email,mailc.toString(),"ELT体验账号获取");
		strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj) values(?,?,?,?,?,?,?,?,?)";									
		PreparedStatement pstm=conn.prepareStatement(strsql);
		pstm.setString(1,"0");
		pstm.setString(2,session.getAttribute("xtyh").toString());
		pstm.setString(3,email);
		pstm.setString(4,"IRewards密码重置");
		pstm.setString(5,mailContent);
		pstm.setString(6,sf.format(Calendar.getInstance().getTime()));
		pstm.setString(7,"7");
		pstm.setString(8,"1");
		pstm.setString(9,"50");
		pstm.executeUpdate();
		pstm.close();
		out.print("<script type='text/javascript'>");
   		out.print("alert('体验账号已发送到联系人邮箱！');");   		
   		out.print("</script>");
		
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
            <td><div class="local"><span>企业管理&gt; 试用企业管理</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					<div class="caxun">
						<span>企业名称：</span><input type="text" class="inputbox" name="qymc" id="qymc" value="<%=qymc%>" />					
						<input name="" type="button"  onclick="searchit(1)" class="findbtn"/>
					</div>
					<div class="caxun-r"></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(nid) as hn from tbl_qy where zt<2";
           		if (qymc!=null && qymc.length()>0)
           			strsql+=" and qymc like '%"+qymc+"%'";
            	rs=stmt.executeQuery(strsql);
            	if(rs.next())
            	{
            		ln=rs.getInt("hn");
            	}
            	rs.close();
            	pages=(ln-1)/psize+1;
            	
            %>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="30">一共 <span class="red"><%=ln%></span> 条信息 </td>
              </tr>
              <tr>
                <td><table width="100%" border="0" cellspacing="1" cellpadding="1" class="maintable">
                  <tr>
                   <th width="12%">注册时间</th>
                   <th width="15%">企业名称</th>
                   <th width="15%">企业地址</th>
                   <th width="7%">联系人</th>
                   <th width="10%">联系人邮箱</th>
                   <th width="7%">联系电话</th>                  
				   <th width="7%">员工人数</th>
				   <th width="7%">申请类型</th>
				   <th width="7%">积分</th>          
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select q.nid,q.qymc,q.qydz,q.lxr,q.lxremail,q.srsj,q.zt,q.lxdh,q.rys,q.sqlx,y.jf from tbl_qy q left join tbl_qyyg y on q.nid=y.qy where q.zt<2 ";
                  if (qymc!=null && qymc.length()>0)
             			strsql+=" and q.qymc like '%"+qymc+"%'";
                  strsql+=" order by q.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>
                  	<td><%=sf.format(rs.getTimestamp("srsj"))%></td>
                    <td class="textbreak"><%=rs.getString("qymc")%></td>
                    <td class="textbreak"><%=rs.getString("qydz")==null?"":rs.getString("qydz")%></td>
                    <td><%=rs.getString("lxr")%></td>
                    <td><%=rs.getString("lxremail")%></td>
                    <td><%=rs.getString("lxdh")==null?"":rs.getString("lxdh")%></td>
                    <td><%if (rs.getInt("sqlx")==1)
                    if (rs.getInt("rys")==1)
                    	out.print("1~99");
                    else if (rs.getInt("rys")==2)
                    	out.print("100~999");
                    else if (rs.getInt("rys")==3)
                    	out.print("1000~9999");
                    else if (rs.getInt("rys")==4)
                    	out.print("10000+");
                    %></td>
                    <td><%=rs.getInt("sqlx")==1?"企业":"员工"%></td>
                    <td><%=rs.getInt("jf")%></td>                
                    <td>
                    <%if (rs.getInt("zt")==0){ %><a href="javascript:void(0);" onclick="audit(<%=rs.getString("nid")%>)" class="blue">生成测试帐号</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0);" class="blue" onclick="delit(<%=rs.getString("nid")%>)">删除</a><%}%>
                     <%if (rs.getInt("zt")==1){ %><a href="javascript:void(0);" onclick="audit2(<%=rs.getString("nid")%>)" class="blue">重置密码</a><%}%>
                     <%if (rs.getInt("zt")==1){out.print(" <a href=\"qyjfff.jsp?qyid="+rs.getString("nid")+"\" class=\"blue\">积分发放</a> <a href=\"javascript:void(0);\" onclick='changezt("+rs.getString("nid")+")'  class=\"blue\">转为正式</a>");} %>
                    </td>
                  </tr>
                 <%}
                  rs.close();
                  %>
                
                </table>
				</td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td style="padding:15px 0"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>                
                <td width="450">
                <%
					int page_no=Integer.valueOf(pno);	
					if (page_no>=5 && page_no<=pages-2)
					{
						for (int i=page_no-3;i<=page_no+2;i++)
						{
							if (i==page_no)
								out.print("<a href='javascript:void(0);' class='nums' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							else
								out.print("<a href='javascript:void(0);' class='num'  onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							
						}
						out.print("...");
					}
					else if (page_no<5)
					{
						if (pages>6)
						{
							for (int i=1;i<=6;i++)
							{
								if (i==page_no)
									out.print("<a href='javascript:void(0);' class='nums' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
								else
									out.print("<a href='javascript:void(0);'  class='num' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							}
							out.print("...");
						}
						else
						{
							for (int i=1;i<=pages;i++)
							{
								if (i==page_no)
									out.print("<a href='javascript:void(0);' class='nums' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
								else
									out.print("<a href='javascript:void(0);' class='num' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							}
						}
					}
					else
					{
						for (int i=pages-5;i<=pages;i++)
						{
							if (i==0) i=1;
							if (i==page_no)
								out.print("<a href='javascript:void(0);' class='nums' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
							else
								out.print("<a href='javascript:void(0);' class='num' onclick='searchit("+i+")'>"+String.valueOf(i)+"</a>");
						}
					}
				
					%>
                </td>
                <td align="right">
                <%if (page_no>1) out.print("<a href='javascript:void(0);' class='up' onclick='searchit("+(page_no-1)+")'>上一页</a>");%>
				<%if (page_no<pages) out.print("<a href='javascript:void(0);' class='up' onclick='searchit("+(page_no+1)+")'>下一页</a>");%>
                </td>
              </tr>
            </table></td>
          </tr>
        </table></td>
        <td width="20">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
  <%@ include file="bottom.jsp" %>
</table>
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