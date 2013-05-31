<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>IRewards企业员工忠诚度系统</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="gl/css/style.css" type="text/css" rel="stylesheet" />
<script type="text/javascript">
var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://" : " http://");
document.write(unescape("%3Cscript src='" + _bdhmProtocol + "hm.baidu.com/h.js%3F399d3e1eb0a5e112f309a8b6241d62fe' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript" src="gl/js/common.js"></script>
<script type="text/javascript" src="gl/js/select2css.js"></script>
<script type="text/javascript">

function saveit(t)
{
	if (t==1)
	{
		if(document.getElementById("qymc").value=="")
		{
			alert("请填写企业名称！");
			return false;
		}
		
		if(document.getElementById("qydz").value=="")
		{
			alert("请填写企业地址！");
			return false;
		}
		if(document.getElementById("rys").value=="")
		{
			alert("请选择员工人数！");
			return false;
		}
		if(document.getElementById("lxr").value=="")
		{
			alert("请填写联系人！");
			return false;
		}
		if(document.getElementById("lxdh").value=="")
		{
			alert("请填写联系电话！");
			return false;
		}
		if(document.getElementById("lxremail").value=="")
		{
			alert("请填写联系人Email！");
			return false;
		}
		if(!EmailCheck(document.getElementById("lxremail").value))
		{
			alert("联系人Email格式不对！");
			return false;
		}
	}
	else
	{
		if(document.getElementById("lxr").value=="")
		{
			alert("请填写姓名！");
			return false;
		}
		if(document.getElementById("lxremail").value=="")
		{
			alert("请填写邮箱！");
			return false;
		}
		if(!EmailCheck(document.getElementById("lxremail").value))
		{
			alert("邮箱格式不对！");
			return false;
		}
		if(document.getElementById("lxdh").value=="")
		{
			alert("请填写联系电话！");
			return false;
		}
		if(document.getElementById("qymc").value=="")
		{
			alert("请填写公司名称！");
			return false;
		}
	}
	document.getElementById("naction").value="reg";
	document.getElementById("cform").submit();
}


</script>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>
 <body>
<%
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
Fun fun=new Fun();
String strsql="";
String qymc=request.getParameter("qymc");
String qydz=request.getParameter("qydz");
String lxr=request.getParameter("lxr");
String lxremail=request.getParameter("lxremail");
String naction=request.getParameter("naction");
String t=request.getParameter("t");
String lxdh=request.getParameter("lxdh");
String rys=request.getParameter("rys");
if (t==null || t.equals("")) t="1";
try
{
	
	if (naction!=null && naction.equals("reg"))
	{
		if (qymc==null || lxr==null || lxremail==null || lxdh==null)
		{
			return;
		}
		if (!fun.sqlStrCheck(qymc) || !fun.sqlStrCheck(qydz) || !fun.sqlStrCheck(lxr) || !fun.sqlStrCheck(lxremail) || !fun.sqlStrCheck(lxdh) || !fun.sqlStrCheck(rys))	
		{
			return;
		}
		
		if (t.equals("1"))
		{
			if (qydz==null || rys==null)
				return;
			
			strsql="select nid from tbl_qy where lxremail='"+lxremail+"'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				rs.close();
				out.print("<script type='text/javascript'>");
           		out.print("alert('该联系人邮箱已经注册过！');");
           		out.print("history.back(-1);");
           		out.print("</script>");
           		return;
			}
			rs.close();
			
			strsql="select nid from tbl_qyyg where email='"+lxremail+"'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				rs.close();
				out.print("<script type='text/javascript'>");
           		out.print("alert('该联系人邮箱已经注册过！');");
           		out.print("history.back(-1);");
           		out.print("</script>");
           		return;
			}
			rs.close();
			
			strsql="insert into tbl_qy (qymc,qydz,lxr,lxremail,zt,srsj,lxdh,rys,sqlx) values('"+qymc+"','"+qydz+"','"+lxr+"','"+lxremail+"',0,now(),'"+lxdh+"',"+rys+",1)";
			stmt.executeUpdate(strsql);
			out.print("<script type='text/javascript'>");
       		out.print("alert('注册成功,我司客服会及时与您联系！');");
       		out.print("location.href='index.jsp';");
       		out.print("</script>");
		}
		
		if (t.equals("2"))
		{
			
			strsql="select nid from tbl_qy where lxremail='"+lxremail+"'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				rs.close();
				out.print("<script type='text/javascript'>");
           		out.print("alert('该联系人邮箱已经注册过！');");
           		out.print("history.back(-1);");
           		out.print("</script>");
           		return;
			}
			rs.close();
			
			strsql="select nid from tbl_qyyg where email='"+lxremail+"'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				rs.close();
				out.print("<script type='text/javascript'>");
           		out.print("alert('该联系人邮箱已经注册过！');");
           		out.print("history.back(-1);");
           		out.print("</script>");
           		return;
			}
			rs.close();
			
			strsql="insert into tbl_qy (qymc,lxr,lxremail,zt,srsj,lxdh,sqlx) values('"+qymc+"','"+lxr+"','"+lxremail+"',0,now(),'"+lxdh+"',2)";
			stmt.executeUpdate(strsql);
			out.print("<script type='text/javascript'>");
       		out.print("alert('注册成功,我司客服会及时与您联系！');");
       		out.print("location.href='index.jsp';");
       		out.print("</script>");
		}			
	}


%>
	<div id="main">
	  	<div class="main2">
	  		<div class="box">
				
				<div class="zhszwrap">
					<div class="zhsz-up">
						
					</div>
					<div class="zhszbox">
					<form action="register.jsp"  name="cform" id="cform" method="post">
					<input type="hidden" name="naction" id="naction" />
					<input type="hidden" name="t" id="t" value="<%=t%>" />
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="zhsztable">
                         <tr>
                          <td width="30" align="center"></td>
                          <td width="90">&nbsp;</td>
                          <td><h1><%if (t.equals("1")) out.print("企业申请"); else out.print("员工试用"); %></h1></td>
                        </tr>
                        <%if (t!=null && t.equals("1")) {%>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>企业名称：</td>
                          <td><input type="text" name="qymc" id="qymc"  maxlength="80" class="input1" /></td>
                        </tr>
                       
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>企业地址：</td>
                          <td><input type="text" class="input3" name="qydz" id="qydz" maxlength="80" /></td>
                        </tr>
                          <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>员工人数：</td>
                          <td><div id="tm2008style"><select name="rys" id="rys"><option value="">请选择</option><option value="1">1~99</option><option value="2">100~999</option><option value="3">1000~9999</option><option value="4">10000+</option></select></div></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>联系人：</td>
                          <td><input type="text" class="input3" name="lxr" id="lxr"  maxlength="25" /></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>联系电话：</td>
                          <td><input type="text" class="input3" name="lxdh" id="lxdh"  maxlength="25" /></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>联系人信箱：</td>
                          <td><input type="text" class="input3" name="lxremail" id="lxremail"   maxlength="50" /></td>
                        </tr>
                       <tr>
                          <td align="center"></td>
                          <td colspan="2">如有意向，请填写以上相关信息， 我们会有业务代表与您联系，并为您提供企业试用帐号</td>
                        </tr>
                        
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit(1)" ></a></span></td>
                        </tr>
                      </tbody></table>
                      </form>
                      <a style="color: #2B9BE1;font-size: 13px;" href="index.jsp">&lt;&lt;返回首页</a>
                       <%}
						else
						{
						%>
						
						<tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>姓名：</td>
                          <td><input type="text" class="input1" name="lxr" id="lxr"  maxlength="25" /></td>
                        </tr>
                         <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>邮箱：</td>
                          <td><input type="text" class="input3" name="lxremail" id="lxremail"   maxlength="50" /></td>
                        </tr>
                        <tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>联系电话：</td>
                          <td><input type="text" class="input3" name="lxdh" id="lxdh"  maxlength="25" /></td>
                        </tr>
						<tr>
                          <td align="center"><span class="star">*</span></td>
                          <td>公司名称：</td>
                          <td><input type="text" name="qymc" id="qymc"  maxlength="80" class="input3" /></td>
                        </tr>
                       
                        
                       <tr>
                          <td align="center"></td>
                          <td colspan="2">请填写以上相关信息，我们会为您提供员工试用账号</td>
                        </tr>
                        
                        <tr>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td><span class="floatleft"><a href="javascript:void(0);" class="submit" onclick="saveit(2)" ></a></span></td>
                        </tr>
                      </tbody></table>
                      </form>
                      <a style="color: #2B9BE1;font-size: 13px;" href="index.jsp">&lt;&lt;返回首页</a>
						<%} %>
                      </table>
                      </form>
					</div>
				</div>
			</div>
	  	</div>
	</div>
	
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
