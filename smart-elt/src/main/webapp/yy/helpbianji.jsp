<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8");
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("9004")==-1)
{
	out.print("你没有操作权限！");
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
<script type="text/javascript" src="ckeditor/ckeditor.js"></script>
<script type="text/javascript">
function saveit()
{
	if(document.getElementById("bt").value.trim()=="")
	{
		alert("请填写文档标题！");
		return false;
	}
	if(document.getElementById("upid").value=="")
	{
		alert("请选择类目！");
		return false;
	}
	if(document.getElementById("xswz").value=="")
	{
		alert("请填写显示位置！");
		return false;
	}
	if(!CheckNumber(document.getElementById("xswz").value))
	{
		alert("显示位置只能填数字！");
		return false;
	}
	
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}



</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="9004";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String bt="",upid="",xswz="",sfxz="1",bznr="";
String bid=request.getParameter("bid");
if (bid==null) bid="";
if (!fun.sqlStrCheck(bid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='helpgl.jsp';");
	out.print("</script>");
	return;
}
try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{
		bt=request.getParameter("bt");
		upid=request.getParameter("upid");
		sfxz=request.getParameter("sfxz");
		xswz=request.getParameter("xswz");
		bznr=request.getParameter("bznr");
		
		
		
		if (!fun.sqlStrCheck(bt) || !fun.sqlStrCheck(upid) || !fun.sqlStrCheck(sfxz) || !fun.sqlStrCheck(xswz))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		if (bid!=null && bid.length()>0)
		{
		  strsql="select nid from tbl_bzzx where nid!="+bid+" and bt='"+bt+"'";
		  rs=stmt.executeQuery(strsql);
		  if (rs.next())
		  {
			    rs.close();
				out.print("<script type='text/javascript'>");
				out.print("alert('此文档名称已经存在！ ');");
				out.print("history.back(-1);");
				out.print("</script>");
				return;
		   }
		   rs.close();
			   
			strsql="update tbl_bzzx set bt=?,upid=?,sfxz=?,xswz=?,nr=? where nid="+bid;
			PreparedStatement pstmt=conn.prepareStatement(strsql);
			pstmt.setString(1,bt);
			pstmt.setString(2,upid);			
			pstmt.setString(3,sfxz);
			pstmt.setString(4,xswz);
			pstmt.setString(5,bznr);
			int result=pstmt.executeUpdate();
			pstmt.close();
			
			if (result>0)			
				response.sendRedirect("helpgl.jsp");
			else
			{
				out.print("<script type='text/javascript'>");
		   		out.print("alert('保存时出错，请重新保存！');"); 
		   		out.print("history.back(-1);");
		   		out.print("</script>");
			}
		   	  return;
		}
		else
		{
		  strsql="select nid from tbl_bzzx where  bt='"+bt+"'";
		  rs=stmt.executeQuery(strsql);
		  if (rs.next())
		  {
			    rs.close();
				out.print("<script type='text/javascript'>");
				out.print("alert('此文档名称已经存在！ ');");
				out.print("history.back(-1);");
				out.print("</script>");
				return;
		   }
		   rs.close();
			   
			strsql="insert into tbl_bzzx (bt,upid,sfxz,xswz,nr) values(?,?,?,?,?)";
			PreparedStatement  pstmt=conn.prepareStatement(strsql);
			pstmt.setString(1,bt);
			pstmt.setString(2,upid);
			pstmt.setString(3,sfxz);
			pstmt.setString(4,xswz);
			pstmt.setString(5,bznr);	
			int result=pstmt.executeUpdate();			
			pstmt.close();
			if (result>0)				
				response.sendRedirect("helpgl.jsp");
			else
			{
				out.print("<script type='text/javascript'>");
		   		out.print("alert('保存时出错，请重新保存！');"); 
		   		out.print("history.back(-1);");
		   		out.print("</script>");
			}
	   		return;
		}
	}
	
	if (bid!=null && bid.length()>0)
	{
		strsql="select bt,upid,sfxz,xswz,nr from tbl_bzzx where nid="+bid;		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			bt=rs.getString("bt");
			upid=rs.getString("upid");
			sfxz=rs.getString("sfxz");
			xswz=rs.getString("xswz");
			bznr=rs.getString("nr");
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
            <td><div class="local"><span>系统管理 &gt; 帮助中心管理 &gt; <%if (bid!=null && bid.length()>0) out.print("修改文档"); else out.print("添加文档");%></span><a href="helpgl.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="helpbianji.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="bid" id="bid" value="<%=bid%>" /> 
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">文档名称：</td>
                          <td><input type="text" name="bt" id="bt" value="<%=bt%>" maxlength="10" class="input3" /></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>所属类类别：</td>
                          <td>
                          <select name="upid" id="upid"><option value="">请选择</option>
                         <option value="1" <%if (upid!=null && upid.equals("1")) out.print(" selected='selected'"); %>>购物指南</option>
						 <option value="2" <%if (upid!=null && upid.equals("2")) out.print(" selected='selected'"); %>>配送方式</option>
						<option value="3" <%if (upid!=null && upid.equals("3")) out.print(" selected='selected'"); %>>支付方式</option>
						<option value="4" <%if (upid!=null && upid.equals("4")) out.print(" selected='selected'"); %>>其他服务</option>
						<option value="5" <%if (upid!=null && upid.equals("5")) out.print(" selected='selected'"); %>>网站信息</option>
  							</select>
                          </td>
                        </tr>
                        <tr>
	                     <td align="center"><span class="star">*</span></td>
	                     <td>显示位置：</td>
	                  	  <td><input type="text" name="xswz" id="xswz" class="input3" value="<%=xswz%>" maxlength="5" />&nbsp;请填写数字，数字越大显示位置越靠前</td>
	                  </tr>
	                  <tr>
	                      <td align="center"><span class="star">*</span></td>
	                      <td>是否显示：</td>
	                      <td><input type="radio" name="sfxz" id="sfxz" value="1" <%if (sfxz.equals("1")) out.print("checked='checked'"); %> />是 　　<input type="radio" name="sfxz" id="sfxz" value="0" <%if (sfxz.equals("0")) out.print("checked='checked'"); %> />否</td>
	                    </tr>
                        <tr>
                          <td align="center"></td>
                          <td>文档内容：</td>
                          <td><textarea id="bznr" name="bznr"><%=bznr==null?"":bznr%></textarea></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="#" class="reset"></a></span></td>
                        </tr>
                      </table>
                      <script type="text/javascript">CKEDITOR.replace("bznr");</script>
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
}
finally
{
	if (!conn.isClosed())
		conn.close();
}
   %>
</body>
</html>