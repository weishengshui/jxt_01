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
if (session.getAttribute("xtczqx")==null || session.getAttribute("xtczqx").toString().indexOf("2004")==-1)
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
		alert("请填写追加积分");
		return false;
	}
	if(document.getElementById("ffmm").value=="")
	{
		alert("请填写追加密码");
		return false;
	}
	if(document.getElementById("bz").value=="")
	{
		alert("请填写追加理由");
		return false;
	}
	if (!CheckNumber(document.getElementById("zjjf").value))
	{
		alert("追加积分格式不正确");
		return false;
	}
	document.getElementById("naction").value="save";
	document.getElementById("cform").submit();
}
function ckzjjf()
{
	if (!CheckNumber(document.getElementById("zjjf").value))
	{
		alert("追加积分格式不正确");
		return false;
	}
}

</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
<body>
<%
String  menun="2004";
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
conn.setAutoCommit(false);
int conncommit=1;
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";
SimpleDateFormat sf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String zjjf="",bz="",ffmm="";
String zzid=request.getParameter("zzid");
if (zzid==null) zzid="";
if (!fun.sqlStrCheck(zzid))
{
	out.print("<script type='text/javascript'>");
	out.print("alert('错误的网址');"); 
	out.print("location.href='zzchenggong.jsp';");
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
		strsql="select nid from tbl_xtyh where nid="+session.getAttribute("xtyh")+" and ffmm='"+su.md5(ffmm)+"'";
		rs=stmt.executeQuery(strsql);
		if (!rs.next())
		{
			rs.close();
			out.print("<script type='text/javascript'>");
	   		out.print("alert('追加密码不正确 ！');"); 
	   		out.print("history.back(-1);");
	   		out.print("</script>");
	   		return;
		}
		rs.close();
		
		int qy=0;
		strsql="select qy from tbl_jfzz where nid="+zzid;
		rs=stmt.executeQuery(strsql);
		if (rs.next())
		{
			qy=rs.getInt("qy");
		}
		rs.close();
		
		//明细
		strsql="insert into tbl_jfzj (zz,qy,jf,zjr,zjsj,bz) values("+zzid+","+qy+","+zjjf+","+session.getAttribute("xtyh")+",now(),'"+bz+"')";
		stmt.executeUpdate(strsql);
		
		//修改充值记录
		strsql="update tbl_jfzz set dzjf=dzjf+"+zjjf+" where nid="+zzid;
		stmt.executeUpdate(strsql);
		
		//修改企业积分
		strsql="update tbl_qy set jf=jf+" +zjjf+" where nid="+qy;
		stmt.executeUpdate(strsql);
		
		out.print("<script type='text/javascript'>");
		out.print("alert('追加成功');"); 
		out.print("location.href='zzchenggong.jsp';");
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
            <td><div class="local"><span>积分管理 &gt; 积分追加 </span><a href="zzchenggong.jsp" class="back">返回上一页</a></div></td>
          </tr>
         
          <tr>
            <td bgcolor="#FFFFFF" style="padding:10px 0 10px 5px">           
            	
            		  <table width="100%" border="0" cellspacing="0" cellpadding="0"  class="zhsztable">
                        <%
                        strsql="select z.nid, z.zzsj,q.qymc,z.zzbh,z.zzje,z.zzjf,z.zzbz,z.zzzt,z.dzjf,z.zzbz,y.ygxm from tbl_jfzz z left join tbl_qy q on z.qy=q.nid left join tbl_qyyg y on z.far=y.nid  where z.nid="+zzid;
                        rs=stmt.executeQuery(strsql);
                        if (rs.next())
                        {
                        %>
                        <tr>
                        	<td>企业名称：</td><td colspan="5"><%=rs.getString("qymc") %></td>                        	
                        </tr>
                        <tr>
                        	<td>订单号：</td><td><%=rs.getString("zzbh") %></td>
                        	<td>订单生成时间：</td><td colspan="3"><%=sf.format(rs.getTimestamp("zzsj"))%></td>
                        	
                        </tr>
                        <tr>
                        	<td width="80">支付金额：</td><td width="80"><%=rs.getString("zzje") %></td>
                        	<td width="80">购买积分：</td><td width="80"><%=rs.getString("zzjf") %></td>
                        	<td width="80">到账积分：</td><td width="80"><%=rs.getString("dzjf") %></td>
                        	<td></td>
                        </tr>
                       
                        <tr>
                        	<td>充值备注：</td><td colspan="5"><%=rs.getString("zzbz") %></td>                        	
                        </tr>
                        
                        <%
                        }
                        out.print("<tr><td colspan='6'>追加记录：<td></tr><tr><td colspan='6'><table width=\"100%\" border=\"1\" cellspacing=\"0\" cellpadding=\"0\" align='center' class=\"zhsztable\"><tr><td>追加时间</td><td>追加积分</td><td>追加人</td><td>说明</td></tr>");
                        strsql="select z.fksj,z.zzje, x.xm from tbl_jfzz z left join tbl_xtyh x on z.far=x.nid where z.nid="+zzid;
                        rs=stmt.executeQuery(strsql);
                        if (rs.next())
                        {
                        %>
                        <tr><td><%=sf.format(rs.getTimestamp("fksj"))%></td><td><%=Math.round(rs.getDouble("zzje")*10)%></td><td><%if (rs.getString("xm")!=null) out.print(rs.getString("xm")); else out.print("系统自动");%></td><td><%if (rs.getString("xm")!=null) out.print("按正常比例充值");%></td></tr>
                        <%	
                        }
                        rs.close();
                        
                        strsql="select z.jf,z.zjsj,z.bz,x.xm from tbl_jfzj z inner join tbl_jfzz j on z.zz=j.nid left join tbl_xtyh x on z.zjr=x.nid where j.nid="+zzid+" order by z.nid desc";
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
					  
					  <form action="zzjifenzhuijia.jsp" name="cform" id="cform" method="post">
            		  <input type="hidden" name="naction" id="naction" />
            		  <input type="hidden" name="zzid" id="zzid" value="<%=zzid%>" />
            		  
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                        <tr>
                          <td width="30" align="center"><span class="star">*</span></td>
                          <td width="90">追加积分：</td>
                          <td><input type="text" name="zjjf" id="zjjf" class="input3" onchange="ckzjjf()" maxlength="8" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>追加密码：</td>
                          <td><input type="password" type="text" name="ffmm" id="ffmm" class="input3" maxlength="8" /></td>
                        </tr>                       
                        <tr>
                          <td valign="top" align="center"><span class="star">*</span></td>
                          <td valign="top">追加说明：</td>
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