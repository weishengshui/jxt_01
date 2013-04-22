<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",7,")==-1) 
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
<script type="text/javascript" src="../gl/js/calendar3.js"></script>
<script type="text/javascript">
function saveit()
{
	if (document.getElementById("bt").value=="")
	{
		alert("请填写标题！");
		return false;
	}
	if (document.getElementById("nr").value=="")
	{
		alert("请填写内容！");
		return false;
	}
	if (checkStrLen(document.getElementById("nr").value)>1000)
	{
		alert("公告内容不能超过1000字符！");
		return false;
	}
	
	document.getElementById("naction").value="save";
	document.getElementById("gbform").submit();
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
  <body>
  <%menun=6; %>
<%@ include file="head.jsp" %>

<%

Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="",bt="",nr="",fbsj="";
String naction=request.getParameter("naction");
String iid=request.getParameter("iid");
if (iid==null) iid="";
//fbsj=request.getParameter("fbsj");



if (!fun.sqlStrCheck(bt) || !fun.sqlStrCheck(nr) || !fun.sqlStrCheck(fbsj)|| !fun.sqlStrCheck(iid))
{
	return;
}

try
{
		if (naction!=null && naction.equals("save"))
		{
			bt=request.getParameter("bt");	
			nr=request.getParameter("nr");
			
			if (iid!=null && iid.length()>0)
			{
				strsql="update tbl_hrgb set bt='"+bt+"',nr='"+nr+"' where nid="+iid;
				stmt.executeUpdate(strsql);
				response.sendRedirect("info.jsp");
			}
			else
			{
				strsql="insert into tbl_hrgb (qy,bt,nr,fbsj) values("+session.getAttribute("qy")+",'"+bt+"','"+nr+"',now())";			
				stmt.executeUpdate(strsql);
				
				String lynid="";
				strsql="select @@identity as lynid";
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					lynid=rs.getString("lynid");
				}
				rs.close();
				
				strsql="insert into tbl_ygmsg (lylx,lynid,sfyd,yg) select 0,"+lynid+",0,nid from tbl_qyyg where qy="+session.getAttribute("qy")+" and xtzt<>3 and zt=1";
				stmt.executeUpdate(strsql);
				response.sendRedirect("info.jsp");
			}
		}
		else
		{
			if (iid!=null && iid.length()>0)
			{
				strsql="select bt,nr from tbl_hrgb where nid="+iid;
				rs=stmt.executeQuery(strsql);
				if (rs.next())
				{
					bt=rs.getString("bt");
					nr=rs.getString("nr");
				}
				rs.close();	
			}
		}
	
		
		
%>		
<div id="main">
	  	<div class="main2">
	  		<div class="box">
				<ul class="zhsz-top">
					<li><a href="company.jsp"><span><img src="images/ico-zh1.jpg" /></span><h1>企业信息管理</h1></a></li>
					<li><a href="department.jsp"><span><img src="images/ico-zh2.jpg" /></span><h1>组织架构管理</h1></a></li>
					<li><a href="staff.jsp"><span><img src="images/ico-zh3.jpg" /></span><h1>员工信息管理</h1></a></li>
					<li><a href="group.jsp"><span><img src="images/ico-zh4.jpg" /></span><h1>小组管理</h1></a></li>
					<li><a href="item.jsp"><span><img src="images/ico-zh5.jpg" /></span><h1>发放名目管理</h1></a></li>
					<li><a href="info.jsp" class="dangqian"><span><img src="images/ico-zh6.jpg" /></span><h1>公告管理</h1></a></li>
					<li><a href="admin.jsp"><span><img src="images/ico-zh7.jpg" /></span><h1>管理员管理</h1></a></li>
				</ul>
				<div class="zhszwrap">
					<div class="zhsz-up">
						<span><strong>公告管理</strong></span>
						<div class="zhsz-up-r"><span class="floatleft"><a href="info.jsp" class="caxun" style="margin:0">返 回</a></span></div>
					</div>
					<div class="zhszbox">
					<form action="infoedit.jsp" name="gbform" id="gbform" method="post">
					<input type="hidden" name="naction" id="naction" />
					<input type="hidden" name="iid" id="iid" value="<%=iid%>" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
					 <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">公告标题：</td>
                          <td><input type="text" class="input3" name="bt" id="bt" value="<%=bt%>" maxlength="25" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>公告内容：</td>
                          <td><textarea rows="5" cols="80" name="nr" id="nr"><%=nr%></textarea>&nbsp;1000字以内</td>
                        </tr>
                        <!--  
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>发布时间：</td>
                          <td><input type="text" name="fbsj" id="fbsj" class="input3" value="<%=fbsj%>" maxlength="25" onclick="new Calendar().show(this);" readonly="readonly" /></td>
                        </tr>
                        -->
 						 <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="#" class="reset"></a></span></td>
                        </tr>
                      </table>
                      </form>
					</div>
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