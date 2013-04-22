<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%
if (session.getAttribute("glqx").toString().indexOf(",6,")==-1) 
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
<script type="text/javascript">
function saveit(na)
{
	if (document.getElementById("mmmc").value=="")
	{
		alert("请填写名目！");
		return false;
	}
	if (na=="")
		document.getElementById("naction").value="save";
	if (na=="addson")
		document.getElementById("naction").value="sonsave";
	if (na=="edit")
		document.getElementById("naction").value="editsave";
	document.getElementById("iform").submit();
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
String strsql="",mmmc="",naction="",itemid="",bz="";
naction=request.getParameter("naction");
mmmc=request.getParameter("mmmc");
itemid=request.getParameter("itemid");
bz=request.getParameter("bz");
if (itemid==null) itemid="";
if (mmmc==null) mmmc="";
if (naction==null) naction="";
if (bz==null) bz="";

if (!fun.sqlStrCheck(itemid) || !fun.sqlStrCheck(mmmc) || !fun.sqlStrCheck(bz))
{
	return;
}
try
{
		if (naction!=null && naction.equals("save"))
		{
			strsql="select nid from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and mmmc='"+mmmc+"'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				rs.close();
				out.print("<script type='text/javascript'>");
        	    out.print("alert('此名目已经存在！');");
        	    out.print("history.back(-1);");
        	    out.print("</script>");
        	    return;
			}
			strsql="insert into tbl_jfmm (qy,mmmc,fmm,bz) values("+session.getAttribute("qy")+",'"+mmmc+"',0,'"+bz+"')";
			stmt.executeUpdate(strsql);			
			response.sendRedirect("item.jsp");
		}
		if (naction!=null && naction.equals("sonsave"))
		{
			strsql="select nid from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and mmmc='"+mmmc+"'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				rs.close();
				out.print("<script type='text/javascript'>");
        	    out.print("alert('此名目已经存在！');");
        	    out.print("history.back(-1);");
        	    out.print("</script>");
        	    return;
			}
			strsql="insert into tbl_jfmm (qy,mmmc,fmm,bz) values("+session.getAttribute("qy")+",'"+mmmc+"',"+itemid+",'"+bz+"')";
			stmt.executeUpdate(strsql);			
			response.sendRedirect("item.jsp");
		}
		if (naction!=null && naction.equals("editsave"))
		{
			strsql="select nid from tbl_jfmm where (qy="+session.getAttribute("qy")+" or qy=0) and nid!="+itemid+" and mmmc='"+mmmc+"'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				rs.close();
				out.print("<script type='text/javascript'>");
        	    out.print("alert('此名目已经存在！');");
        	    out.print("history.back(-1);");
        	    out.print("</script>");
        	    return;
			}
			
			strsql="update tbl_jfmm set mmmc='"+mmmc+"',bz='"+bz+"' where nid="+itemid;
			stmt.executeUpdate(strsql);			
			response.sendRedirect("item.jsp");
		}
		
		
		if (naction!=null && naction.equals("edit"))
		{
			strsql="select * from tbl_jfmm where nid="+itemid;	
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				mmmc=rs.getString("mmmc");
				bz=rs.getString("bz");		
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
					<li><a href="staff.jsp"><span><img src="images/ico-zh3.jpg" /></span><h1>员工信息管理</h1></a></li>
					<li><a href="group.jsp"><span><img src="images/ico-zh4.jpg" /></span><h1>小组管理</h1></a></li>
					<li><a href="item.jsp" class="dangqian"><span><img src="images/ico-zh5.jpg" /></span><h1>发放名目管理</h1></a></li>
					<li><a href="info.jsp"><span><img src="images/ico-zh6.jpg" /></span><h1>公告管理</h1></a></li>
					<li><a href="admin.jsp"><span><img src="images/ico-zh7.jpg" /></span><h1>管理员管理</h1></a></li>
				</ul>
				<div class="zhszwrap">
					<div class="zhsz-up">
						<span><strong>奖励名目管理</strong></span>
						<div class="zhsz-up-r"><span class="floatleft"><a href="item.jsp" class="caxun" style="margin:0">返 回</a></span></div>
					</div>				
					
					<div class="zhszbox">
					<form action="itemedit.jsp" name="iform" id="iform" method="post">
					<input type="hidden" name="itemid" id="itemid" value="<%=itemid%>" /> 
					<input type="hidden" name="naction" id="naction" value="<%=naction%>" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
					  <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">名目名称：</td>
                          <td><input type="text" class="input3" name="mmmc" id="mmmc" value="<%=mmmc%>" maxlength="25" /></td>
                        </tr>
                        <tr>
                          <td align="center"></td>
                          <td>名目说明：</td>
                          <td><textarea rows="3" cols="50" name="bz" id="bz"><%=bz%></textarea></textarea></td>
                        </tr>
                         <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit('<%=naction%>')" ></a></span><span class="floatleft" ><a href="itemedit.jsp?itemid=<%=itemid%>&naction=<%=naction%>" class="reset"></a></span></td>
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