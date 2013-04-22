<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",4,")==-1) 
	response.sendRedirect("main.jsp");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards企业员工忠诚度系统</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript">


function delyg(id)
{
	if (confirm("确定要删除此员工吗，删除后不可恢复！"))
	location.href= "staff.jsp?naction=del&ygid="+id;	
	
}
function searchit()
{
	location.href="staff.jsp?sxm="+encodeURI(escape(document.getElementById("sxm").value))+"&semail="+encodeURI(escape(document.getElementById("semail").value))+"&szt="+document.getElementById("szt").value+"&sbm="+document.getElementById("sbm").value;
	
}
function inputyg()
{
	openLayer("<div class=\"findyg\"><div class=\"findyg-title\">导入员工信息</div><div  style=\"margin: 10px 0;\">格式为Excel文件，请先下载导入模板，<a href=\"ygdr/template.xls\" class=\"blue\" target=\"_blank\">去下载>></a></div><form action=\"staffinput.jsp\" enctype=\"multipart/form-data\" name=\"uform\" id=\"uform\" method=\"post\" target=\"_blank\"><div class=\"find-top\"><li><input type=\"file\" name=\"yginfo\" id=\"yginfo\" /></li><li style=\"margin: 10px 0;\"> <a href=\"javascript:void(0);\" onclick=\"yginput()\" class=\"caxun2\">开始导入</a></span>　　<a href=\"javascript:void(0);\" onclick=\"closeLayer()\" class=\"caxun2\">取消关闭</a></li></div></form></div>");
}

function yginput()
{
	var t=document.getElementById("yginfo").value;
	if (t=="")
	{
		alert("请选择要导入的文件!");
		return;
	}
	
	if (t.substr(t.indexOf("."))!=".xls" && t.substr(t.indexOf("."))!=".xlsx")
	{
		alert("导入的文件格式不对，请选择excel文件!");
		return;
	}
	document.getElementById("uform").submit();
}

function audit(id)
{
	if (confirm("是否确认发送初始密码"))
	{
		location.href= "staff.jsp?naction=audit&ygid="+id+"&sxm="+encodeURI(escape(document.getElementById("sxm").value))+"&semail="+encodeURI(escape(document.getElementById("semail").value))+"&szt="+document.getElementById("szt").value+"&sbm="+document.getElementById("sbm").value;
		
	}
}

function showyglist(p)
{
	location.href="staff.jsp?pno="+p+"&sxm="+encodeURI(escape(document.getElementById("sxm").value))+"&semail="+encodeURI(escape(document.getElementById("semail").value))+"&szt="+document.getElementById("szt").value+"&sbm="+document.getElementById("sbm").value;
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
  <body>
<%menun=6; %>
<div id="bodybackdiv" style="display:none"></div>
<div id="logdiv" style="display:none"></div>


<%@ include file="head.jsp" %>
<%

Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Statement stmt2=conn.createStatement();
ResultSet rs2=null;
Fun fun=new Fun();
String strsql="";
String ygid=request.getParameter("ygid");
String naction=request.getParameter("naction");

String sxm=request.getParameter("sxm");
if (sxm==null) sxm="";
String semail=request.getParameter("semail");
if (semail==null) semail="";
String szt=request.getParameter("szt");
if (szt==null) szt="";
String sbm=request.getParameter("sbm");
if (sbm==null) sbm="";

int psize=10;
String pno="";
pno=request.getParameter("pno");
if (pno==null || pno.equals(""))
	pno="1";

if (sxm!=null)
{
	sxm=fun.unescape(sxm);	
	sxm=URLDecoder.decode(sxm,"UTF-8");
}

if (semail!=null)
{
	semail=fun.unescape(semail);	
	semail=URLDecoder.decode(semail,"UTF-8");
}

if (!fun.sqlStrCheck(pno) || !fun.sqlStrCheck(ygid) || !fun.sqlStrCheck(sxm) || !fun.sqlStrCheck(semail) || !fun.sqlStrCheck(szt))
	return;
	
try
{
if (naction!=null && naction.equals("del"))
{
	strsql="update tbl_qyyg set xtzt=3 where nid=" +ygid;
	stmt.executeUpdate(strsql);
	
}
if (naction!=null && naction.equals("up"))
{
	strsql="update tbl_qyyg set xtzt=2 where nid=" +ygid;
	stmt.executeUpdate(strsql);
	
}
if (naction!=null && naction.equals("noup"))
{
	strsql="update tbl_qyyg set xtzt=1 where nid=" +ygid;
	stmt.executeUpdate(strsql);
	
}
if (naction!=null && naction.equals("admin"))
{
	strsql="update tbl_qyyg set gly=1 where nid=" +ygid;
	stmt.executeUpdate(strsql);	
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
					<div class="zhsz-up"><span><strong>员工信息管理：</strong>用于设置员工基本信息，开展后续员工奖励</span>	</div>
					<div class="zhsz-up2">
						<div style="float: left;margin-top: 10px;"><a href="staffedit.jsp"><img src="images/addbut.jpg" /></a> <a href="javascript:void(0);" onclick="inputyg()"><img src="images/inputbut.jpg" /></a></div>
						<div style="float: right;">
						姓名：<input class="input0" type="text" name="sxm" id="sxm" value="<%=sxm%>" style="width:80px;" />&nbsp;&nbsp;邮箱：<input class="input0" type="text" name="semail" id="semail"  value="<%=semail%>"/>&nbsp;&nbsp;
						  	部门：
						  	<select name="sbm" id="sbm">
								<option value=""></option>
								<%
								strsql="select nid, bmmc from tbl_qybm where qy="+session.getAttribute("qy")+" and fbm=0";
								rs=stmt.executeQuery(strsql);
								while (rs.next())
								{
									if (sbm!=null && sbm.equals(rs.getString("nid")))
										out.print("<option value='"+rs.getString("nid")+"' selected='selected'>"+rs.getString("bmmc")+"</option>");
									else
										out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("bmmc")+"</option>");
								}
								rs.close();
								%>
							</select>
						  	员工状态：<select name="szt" id="szt"><option value=""></option><option value="0" <%if (szt!=null && szt.equals("0")) out.print(" selected='selected'"); %>>离职</option><option value="1" <%if (szt!=null && szt.equals("1")) out.print(" selected='selected'"); %>>在职</option></select>
						  	<a href="javascript:void(0);" onclick="searchit()" class="caxun" />查询</a></div>
					</div>
				  
  	
				<div class="scoresjilu">					
					<div class="scoresjilu-t">
					  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="20">&nbsp;</td>
                          <td width="60">编号</td>
                          <td width="80">姓名</td>
                          <td width="80">部门</td>
                          <td width="180">邮箱</td>
                          <td width="50">状态</td>                         
                          <td>操作</td>
                        </tr>
                      </table>
					</div>
					<%
				  	int tn=0;
				  	strsql="select count(*) as hn from tbl_qyyg where xtzt<>3 and qy="+session.getAttribute("qy");
				  	if (sxm!=null && !sxm.equals(""))
				  	strsql+=" and (ygxm like '%"+sxm+"%' or ygbh like '%"+sxm+"%')";
				  	if (semail!=null && !semail.equals(""))
				  	strsql+=" and email like '%"+semail+"%'";
					if (sbm!=null && !sbm.equals(""))
					  	strsql+=" and bm like '%,"+sbm+"%,'";
				  	if (szt!=null && !szt.equals(""))
				  	strsql+=" and zt="+szt;
				  	
				  	rs=stmt.executeQuery(strsql);
				  	if (rs.next())
				  	{
				  		tn=rs.getInt("hn");
				  	}
				  	rs.close();
				  	int pages=(tn-1)/psize+1;
				  	
				  	strsql="select y.nid,y.ygbh,y.ygxm,y.bm,y.email,y.zt,y.xtzt,y.gly,y.dlmm from tbl_qyyg y where y.qy="+session.getAttribute("qy")+" and xtzt<>3";
				  	if (sxm!=null && !sxm.equals(""))
				  	strsql+=" and (ygxm like '%"+sxm+"%' or ygbh like '%"+sxm+"%')";
				  	if (semail!=null && !semail.equals(""))
				  	strsql+=" and email like '%"+semail+"%'";
				  	if (sbm!=null && !sbm.equals(""))
					  	strsql+=" and bm like '%,"+sbm+"%,'";
				  	if (szt!=null && !szt.equals(""))
				  	strsql+=" and zt="+szt;
				  	strsql+=" order by y.zt desc, y.nid desc limit " + (Integer.valueOf(pno)-1)*psize+","+psize;
				  	
				  	rs=stmt.executeQuery(strsql);
				  	while(rs.next())
				  	{
				  	%>
					<div class="scoresjiluin">
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable2">
                        <tr>
                          <td width="20">&nbsp;</td>
                          <td width="60">&nbsp;<%=rs.getString("ygbh")==null?"":rs.getString("ygbh")%></td>
                          <td width="80"><%=rs.getString("ygxm")%></td>
                          <td width="80">&nbsp;
                          	<%
							  	String bm=rs.getString("bm");
							  	if (bm!=null && !bm.equals(""))
							  	{
							  		String[] bmarr=bm.split(",");
							  		
							  		for (int i=0;i<bmarr.length;i++)
							  		{
							  			if (bmarr[i]!=null && !bmarr[i].equals(""))
							  			{
							  				
							  				strsql="select nid,bmmc from tbl_qybm where nid="+bmarr[i];
							  				rs2=stmt2.executeQuery(strsql);
							  				if (rs2.next())
							  				{
							  					out.print(rs2.getString("bmmc")+" ");
							  					break;
							  				}
							  				rs2.close();
							  				
							  			}
							  		}
							  	}
							  	%>
                          </td>
                          <td width="180"><%=rs.getString("email")%></td>
                          <td width="50">
                          	<%if (rs.getInt("zt")==0)
						  		out.print("离职");
						  	  else if (rs.getInt("zt")==1)
						  	  	out.print("在职");
						  	%></td>                          
                          <td>
  	  					<%if (rs.getInt("zt")==1){%>
                          <span class="floatleft"><a href="staffedit.jsp?ygid=<%=rs.getInt("nid") %>"><img src="images/editbut.jpg" /></a></span>
                        <%} %>
                          <% if (rs.getInt("xtzt")==2) {%>
					  		<span class="floatleft"><a href="staff.jsp?naction=noup&ygid=<%=rs.getInt("nid") %>"><img src="images/jiedongbut.jpg" /></a></span>
					  	<%} else {%>
					  		<span class="floatleft"><a href="staff.jsp?naction=up&ygid=<%=rs.getInt("nid") %>"><img src="images/dongjiebut.jpg" /></a></span>
					  	<%} %>
                        
                          <%if (rs.getInt("gly")!=1 &&rs.getInt("zt")==1) {%>
  	  						<span class="floatleft"><a href="staff.jsp?naction=admin&ygid=<%=rs.getInt("nid") %>"><img src="images/adminbut.jpg" /></a></span><%} %>
                         
                          </td>
                        </tr>						
                      </table>
					</div>
					
				  	<%
				  	}
				  	rs.close();
				  	 %>
				</div>
				<div class="pages marginleft5">
					<div class="pages-l">
					<%
					int page_no=Integer.valueOf(pno);	
					if (page_no>=5 && page_no<=pages-2)
					{
						for (int i=page_no-3;i<=page_no+2;i++)
						{
							if (i==page_no)
								out.print("<a href='javascript:void(0);' class='psel' onclick='showyglist("+i+")'>"+String.valueOf(i)+"</a>");
							else
								out.print("<a href='javascript:void(0);' onclick='showyglist("+i+")'>"+String.valueOf(i)+"</a>");
							
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
									out.print("<a href='javascript:void(0);' class='psel' onclick='showyglist("+i+")'>"+String.valueOf(i)+"</a>");
								else
									out.print("<a href='javascript:void(0);' onclick='showyglist("+i+")'>"+String.valueOf(i)+"</a>");
							}
							out.print("...");
						}
						else
						{
							for (int i=1;i<=pages;i++)
							{
								if (i==page_no)
									out.print("<a href='javascript:void(0);' class='psel' onclick='showyglist("+i+")'>"+String.valueOf(i)+"</a>");
								else
									out.print("<a href='javascript:void(0);' onclick='showyglist("+i+")'>"+String.valueOf(i)+"</a>");
							}
						}
					}
					else
					{
						for (int i=pages-5;i<=pages;i++)
						{
							if (i==0) i=1;
							if (i==page_no)
								out.print("<a href='javascript:void(0);' class='psel' onclick='showyglist("+i+")'>"+String.valueOf(i)+"</a>");
							else
								out.print("<a href='javascript:void(0);' onclick='showyglist("+i+")'>"+String.valueOf(i)+"</a>");
						}
					}
				
					%>
					</div>
					<div class="pages-r">
						<%if (Integer.valueOf(pno)>1) {%>
					  		<h1><a href="javascript:void(0);" onclick="showyglist(<%=Integer.valueOf(pno)-1%>)">上一页</a></h1>
					  	<%} if (Integer.valueOf(pno)<pages) {%>
					  		<h2><a href="javascript:void(0);" onclick="showyglist(<%=Integer.valueOf(pno)+1%>)">下一页</a></h2>
					  	<%} %>
					</div>
				</div>
				<div class="txtinfo">
					<ul>
						<li>注:操作列中的名词释义:</li>
						<li>冻结：暂时让该员工登陆账号失效，员工无法登陆员工端系统</li>
						<li>解冻：将“冻结”的账号还原，员工可再次登陆员工端系统并使用账号内的积分和积分券</li>						
						<li>设为管理员：让特定的员工拥有一定HR端的权限，参与HR端的管理</li>
					</ul>
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
