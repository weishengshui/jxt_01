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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("4001")==-1)
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
	if(document.getElementById("mc").value.trim()=="")
	{
		alert("请填系列名称！");
		return false;
	}
	if(document.getElementById("lb1").value=="")
	{
		alert("请选择类目！");
		return false;
	}
	if (cpjsedit.document.getBody().getText()=="")
	{
		alert("商品介绍不能为空！");
		return false;
	}
	if (shfwedit.document.getBody().getText()=="")
	{
		alert("售后服务不能为空！");
		return false;
	}
	
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}

var lbl=1;
function lbshow(v,l)
{
	if (l==3) return;
	lbl=l+1;
	var timeParam = Math.round(new Date().getTime()/1000);
	var url = "selectsplb.jsp?lbid="+v+"&lbl="+lbl+"&time="+timeParam;	
	xmlHttp.open("GET", url, true);
	xmlHttp.onreadystatechange=showlb;
	xmlHttp.send(null);
	
}
function showlb()
{
	if (xmlHttp.readyState == 4)
	{
		var response = xmlHttp.responseText;
		try
		{			
			for(i=lbl;i<4;i++)
			document.getElementById("lblist"+i).innerHTML="";
			document.getElementById("lblist"+lbl).innerHTML=response;
		}
		catch(exception){}
	}
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="4001";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String mc="",lb1="",lb2="",lb3="",cpjs="",shfw="";
String lid=request.getParameter("lid");
String lb1_ = request.getParameter("lb1_");

if (lid==null) lid="";
if (!fun.sqlStrCheck(lid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='spxlgl.jsp';");
	out.print("</script>");
	return;
}
try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{
		mc=request.getParameter("mc");
		lb1=request.getParameter("lb1");
		lb2=request.getParameter("lb2");
		lb3=request.getParameter("lb3");
		cpjs=request.getParameter("cpjs");
		shfw=request.getParameter("shfw");
		
		
		if (!fun.sqlStrCheck(mc) || !fun.sqlStrCheck(lb1) || !fun.sqlStrCheck(lb2) || !fun.sqlStrCheck(lb3))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		if (lid!=null && lid.length()>0)
		{
		  strsql="select nid from tbl_spl where nid!="+lid+" and mc='"+mc+"'";
		  rs=stmt.executeQuery(strsql);
		  if (rs.next())
		  {
			    rs.close();
				out.print("<script type='text/javascript'>");
				out.print("alert('此系列名称已经存在！ ');");
				out.print("history.back(-1);");
				out.print("</script>");
				return;
		   }
		   rs.close();
			   
			strsql="update tbl_spl set mc=?,lb1=?,lb2=?,lb3=?,cpjs=?,shfw=? where nid="+lid;
			PreparedStatement pstmt=conn.prepareStatement(strsql);
			pstmt.setString(1,mc);
			pstmt.setString(2,lb1);
			if(lb2!=null&&lb2.equals("")){
				lb2 = "0";
			}
			pstmt.setString(3,lb2);
			if(lb3!=null&&lb3.equals("")){
				lb3 = "0";
			}
			pstmt.setString(4,lb3);
			pstmt.setString(5,cpjs);
			pstmt.setString(6,shfw);
			int result=pstmt.executeUpdate();
			pstmt.close();
			
			if (result>0)			
				response.sendRedirect("spxlgl.jsp?lb1="+lb1_+"&pno="+request.getParameter("pno"));
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
		  strsql="select nid from tbl_spl where  mc='"+mc+"'";
		  rs=stmt.executeQuery(strsql);
		  if (rs.next())
		  {
			    rs.close();
				out.print("<script type='text/javascript'>");
				out.print("alert('此系列名称已经存在！ ');");
				out.print("history.back(-1);");
				out.print("</script>");
				return;
		   }
		   rs.close();
			   
			strsql="insert into tbl_spl (mc,lb1,lb2,lb3,cpjs,shfw,zt,rq) values(?,?,?,?,?,?,0,now())";
			PreparedStatement  pstmt=conn.prepareStatement(strsql);
			pstmt.setString(1,mc);
			pstmt.setString(2,lb1);
			pstmt.setString(3,lb2);
			pstmt.setString(4,lb3);
			pstmt.setString(5,cpjs);
			pstmt.setString(6,shfw);	
			int result=pstmt.executeUpdate();			
			pstmt.close();
			if (result>0)				
				response.sendRedirect("spxlgl.jsp");
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
	
	if (lid!=null && lid.length()>0)
	{
		strsql="select mc,lb1,lb2,lb3,cpjs,shfw from tbl_spl where nid="+lid;		
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			mc=rs.getString("mc");
			lb1=rs.getString("lb1");
			lb2=rs.getString("lb2");
			lb3=rs.getString("lb3");
			cpjs=rs.getString("cpjs");
			shfw=rs.getString("shfw");
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
            <td><div class="local"><span>商品管理 &gt; 商品系列管理 &gt; <%if (lid!=null && lid.length()>0) out.print("修改系列"); else out.print("添加系列");%></span><a href="spxlgl.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	<form action="spxlbianji.jsp?lb1_=${param.lb1 }&pno=${param.pno }" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="lid" id="lid" value="<%=lid%>" />
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">系列名称：</td>
                          <td><input type="text" name="mc" id="mc" value="<%=mc%>" maxlength="50" class="input3" /></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>所属类目：</td>
                          <td>
                          <%
                        int j=0;
                        if (lid!=null && lid.length()>0)
                        {
				  			if (lb1!=null && lb1.length()>0)
				  			{
				  				out.print("<span id='lblist1'><select name='lb1' id='lb1' onchange='lbshow(this.value,1)'><option value=''>请选择</option>");
				  				strsql="select nid,mc from tbl_splm where flm=0";				  				
				  				rs=stmt.executeQuery(strsql);
				  				while(rs.next())
				  				{
				  					if (lb1.equals(rs.getString("nid")))
				  					{
				  					
				  					out.print("<option value='"+rs.getString("nid")+"' selected='selected'>"+rs.getString("mc")+"</option>");
				  					}
				  					else
				  					out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("mc")+"</option>");
				  				}
				  				rs.close();
				  				out.print("</select></span>");
				  				j++;
				  			}
	                          
	                        if (lb2!=null && lb2.length()>0)
	  			  			{
	  			  				out.print("<span id='lblist2'><select name='lb2' id='lb2' onchange='lbshow(this.value,2)'><option value=''>请选择</option>");
	  			  				strsql="select nid,mc from tbl_splm where flm="+lb1;
	  			  				rs=stmt.executeQuery(strsql);
	  			  				while(rs.next())
	  			  				{
	  			  					if (lb2.equals(rs.getString("nid")))
	  			  					{
	  			  					out.print("<option value='"+rs.getString("nid")+"' selected='selected'>"+rs.getString("mc")+"</option>");
	  			  					}
	  			  					else
	  			  					out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("mc")+"</option>");
	  			  				}
	  			  				rs.close();
	  			  				out.print("</select></span>");
	  			  				j++;
	  			  			}
	                        if (lb3!=null && lb3.length()>0)
	  			  			{
	  			  				out.print("<span id='lblist3'><select name='lb3' id='lb3'><option value=''>请选择</option>");
	  			  				strsql="select nid,mc from tbl_splm where flm="+lb2;
	  			  				rs=stmt.executeQuery(strsql);
	  			  				while(rs.next())
	  			  				{
	  			  					if (lb3.equals(rs.getString("nid")))
	  			  					{
	  			  					out.print("<option value='"+rs.getString("nid")+"' selected='selected'>"+rs.getString("mc")+"</option>");
	  			  					}
	  			  					else
	  			  					out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("mc")+"</option>");
	  			  				}
	  			  				rs.close();
	  			  				out.print("</select></span>");
	  			  				j++;
	  			  			}
                        }
                        else
                        {
                        	out.print("<span id='lblist1'><select name='lb1' id='lb1' onchange='lbshow(this.value,1)'><option value=''>请选择</option>");
			  				strsql="select nid,mc from tbl_splm where flm=0";
			  				rs=stmt.executeQuery(strsql);
			  				while(rs.next())
			  				{
			  					
			  					out.print("<option value='"+rs.getString("nid")+"'>"+rs.getString("mc")+"</option>");
			  				}
			  				rs.close();
			  				out.print("</select></span>");
			  				j++;
                        }
  		
				  		for (int i=j;i<4;i++)
				  		{
				  			out.print("<span id='lblist"+i+"'></span>");
				  		}
  	
  	%>
                          </td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>商品介绍：</td>
                          <td><textarea id="cpjs" name="cpjs"><%=cpjs==null?"":cpjs%></textarea></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>售后服务：</td>
                          <td><textarea id="shfw" name="shfw"><%=shfw==null?"":shfw%></textarea></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span><span class="floatleft" ><a href="#" class="reset"></a></span></td>
                        </tr>
                      </table>
                      <script type="text/javascript">var cpjsedit=CKEDITOR.replace("cpjs");var shfwedit=CKEDITOR.replace("shfw");</script>
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