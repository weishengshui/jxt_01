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
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="jxt.elt.common.SecurityUtil"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("9001")==-1)
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


String naction=request.getParameter("naction");
String glyid=request.getParameter("glyid");
if ( !fun.sqlStrCheck(pno) || !fun.sqlStrCheck(glyid))
{	
	response.sendRedirect("guanliyuan.jsp");
	return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/adminstyle.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">


function searchit(p)
{
	location.href="guanliyuan.jsp?pno="+p;;
}
function delit(lid)
{
	if (confirm("确认删除此人员，删除后无法恢复"))
	{
		location.href="guanliyuan.jsp?naction=del&glyid="+lid+"&pno=<%=pno%>";
	}
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="9001";
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
try{
	if (naction!=null && naction.equals("del"))
	{
		strsql="delete from tbl_xtyh where nid="+glyid;
		stmt.executeUpdate(strsql);
	}
	if (naction!=null && (naction.equals("sendpwd")||naction.equals("sendpwd2")||naction.equals("sendpwd3")))
	{
		SendEmailBean sendemailB=new SendEmailBean();
		String sendemail="";
		int dlmm=0;
		strsql="select dlm from tbl_xtyh where nid="+glyid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			sendemail=rs.getString("dlm");
		}
		rs.close();
		if (sendemail!=null && sendemail.length()>0)
		{
			SecurityUtil su=new SecurityUtil();
			Random rand=new Random();
			dlmm=rand.nextInt(999999);
			if (dlmm<100000) dlmm=100000+dlmm;
			if (naction.equals("sendpwd"))
				strsql="update tbl_xtyh set dlmm='"+su.md5(String.valueOf(dlmm))+"' where nid="+glyid;
			else if (naction.equals("sendpwd2"))
				strsql="update tbl_xtyh set ffmm='"+su.md5(String.valueOf(dlmm))+"' where nid="+glyid;
			else
				strsql="update tbl_xtyh set syffmm='"+su.md5(String.valueOf(dlmm))+"' where nid="+glyid;
			stmt.executeUpdate(strsql);
			
			//StringBuffer mailc=new StringBuffer();
			String mbt="";
			
			
			VelocityContext context = new VelocityContext();
			Template template = null;
			
			
			if (naction.equals("sendpwd"))
			{
				context.put("loginAccount", sendemail);
				context.put("loginPassword", dlmm);
				template = Velocity.getTemplate("templates/mail/managerinitpwd.vm");
				
				/* instead of velocity 
				mailc.append("用户名："+sendemail+"<br/>");			
				mailc.append("登陆密码："+String.valueOf(dlmm)+"<br/>");
				*/
				//sendemailB.sendSimpleEmail(sendemail,mailc.toString(),"ELT系统管理账号");
				mbt="IRewards管理账号和密码";
			}
			else if (naction.equals("sendpwd2"))
			{		
				context.put("password", dlmm);
				template = Velocity.getTemplate("templates/mail/managerappendpwd.vm");
				// instead of velocity mailc.append("追加密码："+String.valueOf(dlmm)+"<br/>");
				//sendemailB.sendSimpleEmail(sendemail,mailc.toString(),"ELT系统追加积分密码");
				mbt="IRewards追加积分密码";
			}
			else
			{
				context.put("assignPassword", dlmm);
				template = Velocity.getTemplate("templates/mail/managerinitassignpwd.vm");
				
				// instread of velocity mailc.append("试用企业发放积分密码："+String.valueOf(dlmm)+"<br/>");
				//sendemailB.sendSimpleEmail(sendemail,mailc.toString(),"ELT系统试用企业发放积分密码");
				mbt="IRewards试用企业发放积分密码";
			}
			
			StringWriter sw = new StringWriter();
			template.merge(context, sw);
			String mailContent = sw.toString();
			System.out.println("mail content: "+mailContent);
			
			strsql="insert into tbl_yjdf (qy,yg,jsyx,bt,nr,srsj,fslx,ljfs,fsdj) values(?,?,?,?,?,?,?,?,?)";									
			PreparedStatement pstm=conn.prepareStatement(strsql);
			pstm.setString(1,"0");
			pstm.setString(2,session.getAttribute("xtyh").toString());
			pstm.setString(3,sendemail);
			pstm.setString(4,mbt);
			pstm.setString(5,mailContent);
			pstm.setString(6,sf.format(Calendar.getInstance().getTime()));
			pstm.setString(7,"8");
			pstm.setString(8,"1");
			pstm.setString(9,"50");
			pstm.executeUpdate();
			pstm.close();
			out.print("<script type='text/javascript'>");
	   		out.print("alert('邮箱发送成功！');");
	   		out.print("location.href='guanliyuan.jsp';");
	   		out.print("</script>");
		}
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
            <td><div class="local"><span>系统管理&gt; 管理员管理</span></div></td>
          </tr>
          <tr>
            <td>
					<div class="caxunbox">
					
					<div class="caxun-r"><a href="guanliyuanbianji.jsp" class="daorutxt">增加管理员</a></div>
				</div>
			</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">
            <%
            	
            	strsql="select count(nid) as hn from tbl_xtyh";           		
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
                   <th width="10%">姓名</th>
                   <th width="10%">登录账号</th>
                   <th width="50%">权限菜单</th>                  
                   <th>操作</th>
                 </tr>
                  <%
                  strsql="select nid,xm,dlm,czqx,dlmm,ffmm,syffmm from tbl_xtyh";                  
                  strsql+=" order by nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
                  rs=stmt.executeQuery(strsql);
                  while(rs.next())
                  {
                  %>
                  <tr>                  	
                    <td><%=rs.getString("xm")%></td>
                    <td><%=rs.getString("dlm")%></td>
                    <td>
                    <%
                    if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("9001")>-1)
			  			out.print("[管理员管理]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("9002")>-1)
			  			out.print("[奖励名目管理] ");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("9003")>-1)
			  			out.print("[参数设置] ");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("9004")>-1)
			  			out.print("[帮助中心管理] ");
			  		
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("1001")>-1)
			  			out.print("[试用企业管理]");					  		
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("1002")>-1)
			  			out.print("[企业信息管理]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("1003")>-1)
			  			out.print("[企业员工管理]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("2001")>-1)
			  			out.print("[在线订单-未支付]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("2002")>-1)
			  			out.print("[线下订单]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("2003")>-1)
			  			out.print("[在线订单-已支付]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("2004")>-1)
			  			out.print("[待充值订单]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("2005")>-1)
			  			out.print("[交易失败订单]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("3001")>-1)
			  			out.print("[积分券活动类目管理]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("3002")>-1)
			  			out.print("[积分券活动管理]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("3003")>-1)
			  			out.print("[积分券内容管理]");
			  		
          			
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("4004")>-1)
			  			out.print("[商品类目管理]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("4001")>-1)
			  			out.print("[商品系列管理]");			  		
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("4002")>-1)
			  			out.print("[商品内容管理]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("4005")>-1)  		
			  			out.print("[活动管理]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("4006")>-1)
			  			out.print("[供应商管理]");			  			
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("4007")>-1)
			  			out.print("[进货管理]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("4008")>-1)
			  			out.print("[库存查询]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("4009")>-1)
			  			out.print("[出库管理]");
			  		
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("5001")>-1)
			  			out.print("[未付款订单]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("5001")>-1)
			  			out.print("[未发货订单]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("5001")>-1)
			  			out.print("[未收货订单]");
			  		if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("5001")>-1)
			  			out.print("[已完成订单]");
			  	
					 %>
                    </td>
                    <td><a href="guanliyuanbianji.jsp?glyid=<%=rs.getString("nid")%>" class="blue">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" class="blue" onclick="delit(<%=rs.getString("nid")%>)">删除</a>
                    <%out.print("&nbsp;&nbsp;&nbsp;&nbsp;<a href='guanliyuan.jsp?naction=sendpwd&glyid="+rs.getString("nid")+"' class='blue'>发送初始登陆密码</a>");%>
                     <%if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("2004")>-1){out.print("&nbsp;&nbsp;&nbsp;&nbsp;<a href='guanliyuan.jsp?naction=sendpwd2&glyid="+rs.getString("nid")+"' class='blue'>发送初始追加密码</a>");} %>
                     <%if (rs.getString("czqx")!=null && rs.getString("czqx").indexOf("1001")>-1){out.print("&nbsp;&nbsp;&nbsp;&nbsp;<a href='guanliyuan.jsp?naction=sendpwd3&glyid="+rs.getString("nid")+"' class='blue'>发送初始发放密码</a>");} %>
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