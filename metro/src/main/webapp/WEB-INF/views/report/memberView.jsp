<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><%--"http://www.w3.org/TR/html4/loose.dtd" --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/extend-easyui-validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/constant.js"></script>
<style type="text/css">
	fieldset table tr{height: 35px;}
	fieldset{margin-bottom:10px;margin:0px;width:600px;font-size:14px;}
	select{width:155px;height:20px;}
	.red{color:red;font-size:12px;}
</style>
<script type="text/javascript">

</script>
</head>
<body>
	<div class="easyui-tabs" style="height:690px;">  
	    <div title="会员资料" style="padding:20px;">  
			  <fieldset style="font-size:14px;">
			  	<legend style="color: blue;">基本信息</legend>
			  	<table>
			  	<tr>
			  			<td></td>
			  			<td >会员卡号：</td>
			  			<td >
			  			${member.card.cardNumber }
		  				
			  			</td>
			  			
			  	</tr>
			  	<tr>
			  			<td></td>
			  			<td width="80">姓名：</td>
			  			<td width="200">
			  			${member.surname} ${member.name}
		  				
			  			</td>
			  			<td width="80">出生日期:</td>
			  			<td>
			  			${fn:substring(member.birthDay,0,10)}
			  			</td>
			  	</tr>
			  	<tr>
			  			<td></td>
			  			<td>性别：</td>
			  			<td>
			  			<c:if test="${member.sex==1}">男</c:if>
			  			<c:if test="${member.sex==2}">女</c:if>
			  			</td>
			  			
			  		</tr>
			  		<tr>
			  			<td></td>
			  			<td>手机：</td>
			  			<td>
			  			${member.phone}
			  			</td>
			  			<td>E-mail:</td>
			  			<td>
			  			${member.email}
			  			</td>
			  		</tr>
			  		<tr>
			  			<td></td>
			  			<td>详细地址：</td>
			  			<td>
			  			${member.province}${member.city}${member.area}${member.address}
			  			</td>
			  			
			  		</tr>
			  		<tr>
			  		 <td></td>
			  			<td>注册时间:</td>
			  			<td >
			  			  ${member.createDate}
			  			</td>
			  			<td>消费金额:</td>
			  			<td>
			  			 ${member.orderPriceSum}
			  			</td>
			  		</tr>
			  	
			  		<tr>
			  		<td></td>
			  			<td width="80">状态：</td>
			  			<td width="200">
			  			    <c:if test="${member.status==1}">已激活</c:if>
							<c:if test="${member.status==2}">未激活</c:if>
			  			</td>
			  			<td width="80">注册渠道：</td>
			  			<td>
				  			${member.source}
			  			</td>
			  		</tr>
			  		
			  	</table>
			  </fieldset>
	    </div>  
	  
	</div> 
</body>
<script type="text/javascript">
	for(var i=0;i<Constant.industry.length;i++){
		if(Constant.industry[i].id == '${member.industry}'){
			$("#industry").append("<option value="+Constant.industry[i].id+" selected='selected'>"+Constant.industry[i].text+"</option>");
		}else{
			$("#industry").append("<option value="+Constant.industry[i].id+">"+Constant.industry[i].text+"</option>");
		}
	}
	for(var i=0;i<Constant.profession.length;i++){
		if(Constant.profession[i].id == '${member.profession}'){
			$("#profession").append("<option value="+Constant.profession[i].id+" selected='selected'>"+Constant.profession[i].text+"</option>");
		}else{
			$("#profession").append("<option value="+Constant.profession[i].id+">"+Constant.profession[i].text+"</option>");
		}
	}
	for(var i=0;i<Constant.position.length;i++){
		if(Constant.position[i].id == '${member.position}'){
			$("#position").append("<option value="+Constant.position[i].id+" selected='selected'>"+Constant.position[i].text+"</option>");
		}else{
			$("#position").append("<option value="+Constant.position[i].id+">"+Constant.position[i].text+"</option>");
		}
	}
	for(var i=0;i<Constant.salary.length;i++){
		if(Constant.salary[i].id == '${member.salary}'){
			$("#salary").append("<option value="+Constant.salary[i].id+" selected='selected'>"+Constant.salary[i].text+"</option>");
		}else{
			$("#salary").append("<option value="+Constant.salary[i].id+">"+Constant.salary[i].text+"</option>");
		}
	}
	for(var i=0;i<Constant.education.length;i++){
		if(Constant.education[i].id == '${member.education}'){
			$("#education").append("<option value="+Constant.education[i].id+" selected='selected'>"+Constant.education[i].text+"</option>");
		}else{
			$("#education").append("<option value="+Constant.education[i].id+">"+Constant.education[i].text+"</option>");
		}
	}
	new PCAS("province","city","area","${member.province}","${member.city}","${member.area}");
</script>
</html>