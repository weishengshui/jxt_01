<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jxt.elt.common.Fun"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@ include file="../common/hrlogcheck.jsp" %>
<%@page import="jxt.elt.common.DbPool"%>
<%request.setCharacterEncoding("UTF-8");%>
<%
Fun fun=new Fun();
Connection conn=DbPool.getInstance().getConnection();
Statement stmt=conn.createStatement();
ResultSet rs=null;
String strsql="";

String nid=request.getParameter("nid");
String naction=request.getParameter("naction");
if (!fun.sqlStrCheck(nid))
	return;

String sheng="",qu="",shi="",dz="",yb="",dh="",shr="",returns="0";
try
{
	if (naction!=null && naction.length()>0)
	{
		shr=request.getParameter("shdzshr");
		sheng=request.getParameter("shdz.sheng");
		shi=request.getParameter("shdz.shi");
		qu=request.getParameter("shdz.qu");
		dz=request.getParameter("shdz.dz");
		yb=request.getParameter("shdz.yb");
		dh=request.getParameter("shdz.dh");
		if (!fun.sqlStrCheck(shr)||!fun.sqlStrCheck(sheng)||!fun.sqlStrCheck(shi)||!fun.sqlStrCheck(qu)||!fun.sqlStrCheck(dz)||!fun.sqlStrCheck(yb)||!fun.sqlStrCheck(dh))
		{
			returns="1";
		}
		else
		{
			if (nid!=null && nid.length()>0)
			{
				strsql="update tbl_shdz set shr='"+shr+"',sheng='"+sheng+"',shi='"+shi+"',qu='"+qu+"',dz='"+dz+"',yb='"+yb+"',dh='"+dh+"' where nid="+nid;
				stmt.execute(strsql);
			}
			else
			{
				strsql="insert into tbl_shdz (shr,sheng,shi,qu,dz,yb,dh,yg,rq) values('"+shr+"','"+sheng+"','"+shi+"','"+qu+"','"+dz+"','"+yb+"','"+dh+"',"+session.getAttribute("ygid")+",now())";
				stmt.execute(strsql);
			}
			returns="2";
		}
	}
	else
	{
		if (nid!=null && nid.length()>0)
		{
			strsql="select s.sheng,s.shi,s.qu,s.dz,s.yb,s.dh,s.shr from tbl_shdz s where nid="+nid;
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				sheng=rs.getString("sheng");
				shi=rs.getString("shi");
				qu=rs.getString("qu");
				dz=rs.getString("dz");
				yb=rs.getString("yb");
				dh=rs.getString("dh");
				shr=rs.getString("shr");
			}
			rs.close();
		}
		else
			nid="";
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>IRewards 领先的员工奖励，弹性福利，忠诚度管理平台</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<link type="text/css" rel="stylesheet" href="css/style2.css">
		<script type="text/javascript" src="js/jquery-1.7.min.js"></script>	
		<script type="text/javascript" src="js/jquery.validate.js"></script>	
		<script type="text/javascript" src="js/common2.js"></script>	
		<script type="text/javascript" src="js/datepicker/WdatePicker.js"></script>	
		<script type="text/javascript" src="js/city.js"></script>	
		<script type="text/javascript">
			$(function() {
				if('<%=returns%>'=='2'){
					window.parent.handler();
					return false;
				}
				if('<%=returns%>'=='1'){
					alert("提交内容中有无法字符！");
				}
				fillCity();
				if('<%=nid%>'!=''){
					$("#shdzid").val('<%=nid%>');
					$("#province").val(U2A('<%=sheng%>'));
					$("#province").change();
					$("#city").val(U2A('<%=shi%>'));
					$("#city").change();
					$("#county").val(U2A('<%=qu%>'));					
				}
				$("#form1").validate({
        			rules:{
						"shdzshr":{required:true,mingchen:true},
						"shdz.dz":{required:true},
						"shdz.dh":{required:true,mobile:true},
						"shdz.yb":{number:true}
					},
					messages:{						
						"shdzshr":{required:"收货人为必输项。",mingchen:"支持中英文、数字、“_”。"},
						"shdz.dz":{required:"地址为必输项。"},
						"shdz.dh":{required:"电话为必输项。",mobile:"请输入正确的电话号码,例如13012345678。"},						
						"shdz.yb":{number:"请选择正确的邮编格式。"}
					}
				});
			});
		</script>
	<link rel="shortcut icon" href="<%=request.getContextPath() %>/images/favicon.ico" type="image/x-icon" /></head>

	<body style="background-color:#fff">
			<div class="wrap-right" style="float:left">
	          	<div class="list"  style="margin-top:0px">
					<div class="states" style="padding-top:0">
						<form action="shdz.jsp?naction=save" id="form1" name="form1" method="post">
						<div class="states-right" style="padding-left:0px; border:none">
							<input id="shdzid" type="hidden" name="nid" value="<%=nid%>"/>
							<p><label class="label"><span class="bisque">*</span>收货人</label>
								<input maxlength="20" id="bjshr" name="shdzshr" value='<%=shr%>' class="nameinputbox" /></p>
							<p><label class="label"><span class="bisque">*</span>地址</label>
								<select style="width:65px;" id="province" onchange="setCity(this.options[this.selectedIndex].id);" name="shdz.sheng" >
									<option value="" selected="selected">请选择</option> 
								</select>省
								<select style="width:65px;" id="city" onchange="setCounty(this.options[this.selectedIndex].id);" name="shdz.shi">
									<option value="" selected="selected">请选择</option> 
								</select>市
								<select style="width:65px;" id="county"  name="shdz.qu">
									<option value="" selected="selected">请选择</option> 
								</select>区
								<input id="bjdz" name="shdz.dz" type="text" maxlength="50" value='<%=dz%>' class="nameinputbox" /></p>
							<p><label class="label">邮编</label><input id="bjyb" value='<%=yb%>' maxlength="10" name="shdz.yb" type="text" class="nameinputbox" /></p>
							<p><label class="label"><span class="bisque">*</span>电话</label><input 
							 value='<%=dh%>' maxlength="20" id="bjdh" name="shdz.dh" type="text" class="nameinputbox" /></p>
						</div>
						<input value="" type="submit" class="savebtn" style="margin:10px 0 0 85px; display:inline" />
						</form>
					</div>
				</div>
	        </div>	     
	</body>
</html>
<%
}
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
