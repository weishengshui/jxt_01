<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.SendEmailBean"%>
<%@page import="jxt.elt.common.SecurityUtil"%>
<%@ include file="../common/yylogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8"); 
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("1001")==-1)
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
<script type="text/javascript">
function saveit()
{
	
	
	if(document.getElementById("zjjf").value=="")
	{
		alert("请填写要发放的积分");
		return false;
	}
	if(document.getElementById("ffmm").value=="")
	{
		alert("请填写发放密码");
		return false;
	}
	if(document.getElementById("bz").value=="")
	{
		alert("请填写发放理由");
		return false;
	}
	if (!CheckNumber(document.getElementById("zjjf").value))
	{
		alert("发放积分格式不正确");
		return false;
	}
	if (!parseInt(document.getElementById("zjjf").value))
	{
		alert("发放积分格式不正确");
		return false;
	}
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}
function ckzjjf()
{
	if (!CheckNumber(document.getElementById("zjjf").value))
	{
		alert("发放积分格式不正确");
		return false;
	}
	if (!parseInt(document.getElementById("zjjf").value))
	{
		alert("发放积分格式不正确");
		return false;
	}
}
function removeInputValue() {
	document.getElementById("zjjf").value="";
	document.getElementById("ffmm").value="";
}
</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body onload="removeInputValue()">
<%
String  menun="1001";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String zjjf="",bz="",ffmm="";
String qyid=request.getParameter("qyid");
if (qyid==null) qyid="";
if (!fun.sqlStrCheck(qyid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='shiyongqiye.jsp';");
	out.print("</script>");
	return;
}
try{
	
	String naction=request.getParameter("naction");
	if (naction!=null && naction.equals("save"))
	{
		
		zjjf=request.getParameter("zjjf");
		ffmm=request.getParameter("ffmm");
		bz=request.getParameter("bz");
		if (!fun.sqlStrCheck(zjjf) || !fun.sqlStrCheck(ffmm) || !fun.sqlStrCheck(bz))
		{
			out.print("<script type='text/javascript'>");
	   		out.print("alert('提交的数据格式不对，请修改后重新提交');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		
		SecurityUtil su=new SecurityUtil();
		strsql="select nid from tbl_xtyh where nid="+session.getAttribute("xtyh")+" and syffmm='"+su.md5(ffmm)+"'";
		rs=stmt.executeQuery(strsql);
		if (!rs.next())
		{
			rs.close();
			out.print("<script type='text/javascript'>");
	   		out.print("alert('发放密码不正确 ！');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		rs.close();
		
		int ygid=0;
		strsql="select nid from tbl_qyyg where qy="+qyid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			ygid=rs.getInt(1);
		}
		rs.close();
		
		//明细
		strsql="insert into tbl_syqyjf (qy,yg,jf,zjr,zjsj,bz,sflq) values("+qyid+","+ygid+","+zjjf+","+session.getAttribute("xtyh")+",now(),'"+bz+"',0)";
		stmt.executeUpdate(strsql);
		
		/* 
		//修改员工积分
		strsql="update tbl_qyyg set jf=jf+" +zjjf+" where nid="+ygid;
		stmt.executeUpdate(strsql);
		 */
		out.print("<script type='text/javascript'>");
		out.print("alert('发放成功');"); 
		out.print("location.href='shiyongqiye.jsp';");
		out.print("</script>");
		return;
		
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
            <td><div class="local"><span>试用企业管理 &gt; 积分发放 </span><a href="shiyongqiye.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	
            		  <table width="100%" border="0" cellspacing="0" cellpadding="0"  class="zhsztable">
                        <%
                        strsql="select q.qymc,q.qydz,q.rys,q.lxr,q.lxdh,q.lxremail,q.sqlx,y.jf from tbl_qy q left join tbl_qyyg y on q.nid=y.qy where q.nid="+qyid;
                        rs=stmt.executeQuery(strsql);
                        if (rs.next())
                        {
                        %>
                        <tr>
                        	<td width="100">申请类型：</td><td colspan="5"><%=rs.getInt("sqlx")==1?"企业":"员工"%></td>                        	
                        </tr>
                        <tr>
                        	<td>企业名称：</td><td colspan="5"><%=rs.getString("qymc") %></td>                        	
                        </tr>
                        <tr>
                        	<td>企业地址：</td><td colspan="5"><%=rs.getString("qydz")==null?"":rs.getString("qydz") %></td>                        	
                        </tr>
                        <%if (rs.getInt("sqlx")==1) {%>
                        <tr>
                        	<td>员工人数：</td><td colspan="5"><%
                        	 if (rs.getInt("rys")==1)
                             	out.print("1~99");
                             else if (rs.getInt("rys")==2)
                             	out.print("100~999");
                             else if (rs.getInt("rys")==3)
                             	out.print("1000~9999");
                             else if (rs.getInt("rys")==4)
                             	out.print("10000+");
                        	%></td>                        	
                        </tr>
                        <%} %>
                        <tr>
                        	<td>联系人：</td><td colspan="5"><%=rs.getString("lxr") %></td>                        	
                        </tr>
                         <tr>
                        	<td>联系电话：</td><td colspan="5"><%=rs.getString("lxdh") %></td>                        	
                        </tr>
                         <tr>
                        	<td>联系Email：</td><td colspan="5"><%=rs.getString("lxremail") %></td>                        	
                        </tr>
                        <tr>
                        	<td>现有积分：</td><td colspan="5"><%=rs.getString("jf") %></td>                        	
                        </tr>
                        <%
                        }
						rs.close();
						
                        out.print("<tr><td colspan='6'>发放记录：<td></tr><tr><td colspan='6'><table width=\"100%\" border=\"1\" cellspacing=\"0\" cellpadding=\"0\" align='center' class=\"zhsztable\"><tr><td>发放时间</td><td>发放积分</td><td>发放人</td><td>说明</td></tr>");
                       
                        
                        strsql="select s.jf,s.zjsj,s.bz,x.xm from tbl_syqyjf s inner join tbl_xtyh x on s.zjr=x.nid where s.qy="+qyid+" order by s.nid desc";
                        rs=stmt.executeQuery(strsql);
                        while(rs.next())
                        {
                        	
                        	%>
                        		<tr><td><%=sf.format(rs.getTimestamp("zjsj"))%></td><td><%=rs.getString("jf")%></td><td><%=rs.getString("xm")%></td><td><%=rs.getString("bz")%></td></tr>
                        
                        	<%
                        	
                        }
                        rs.close();
                       
                        out.print("</table></td></tr>");
                        %>
                      </table>
					  
					  <form action="qyjfff.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="qyid" id="qyid" value="<%=qyid%>" />
            		  
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">发放积分：</td>
                          <td><input type="text" name="zjjf" id="zjjf" class="input3" autocomplete="off" onchange="ckzjjf()" maxlength="8" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>发放密码：</td>
                          <td><input type="password" type="text" name="ffmm" id="ffmm" autocomplete="off" class="input3" maxlength="8" /></td>
                        </tr>                       
                        <tr>
                          <td valign="top" align="center"><span class="star">*</span></td>
                          <td valign="top">发放说明：</td>
                          <td><textarea rows="5" cols="50" name="bz" id="bz" ></textarea></td>
                        </tr>            
                       
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit()" ></a></span></td>
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