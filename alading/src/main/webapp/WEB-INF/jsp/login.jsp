<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>平台登录</title>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript">
	
	function noBack() {  
	    window.history.forward();  
	    setTimeout("noBack()", 500);  
	}  
	noBack();  
	  
	  
	window.onpageshow=function(evt) {  
	    if (evt.persisted) noBack();  
	} 
	
	window.onload=function(){
		// noBack();
		if(window.self != window.top){
			window.top.location = window.self.location;
		}
	};
	function login(){
		var userName = $("#userName").val();
		var password = $("#password").val();
		// var rand = $("#rand").val();
		if(userName == ""){ alert("请输入用户名");return; }
		if(password == ""){ alert("请输入密码");return;}
		// if(rand == ""){ alert("请输入验证码");return;}
		$('#loginForm').submit();
		/* $.ajax({
        	url:'validate',
        	type:'post',
        	dataType:'json',
        	data:"userName="+userName+"&randCode="+rand,
        	success:function(data){
        		if(data == 0){
        			$('#loginForm').submit();
        		}else{
        			$("#error").html(data);
        			$("#pwdError").remove();
        		}
        	}
		}); */ 
	}
	
	function pressKeyDown(e){
	    var e = e || window.event;
	    var keyCode = e.keyCode || e.which;
	    if(keyCode == 13){
	    	login();
	    }
	}
</script>
</head>
<body bgcolor="gray">
<div id="win" class="easyui-window" title="登录" style="width:330px;height:250px;padding:30px;"  
       data-options="iconCls:'icon-save',closable:false,minimizable:false,maximizable:false,resizable:false">
       <s:form id="loginForm" method="post" action="login">
			<table>
				<tr>
					<td>用户名：</td>
					<td colspan="2"><input type="text" id="userName" name="username" style="width:150px;"/></td>
				</tr>
				<tr>
					<td>密&nbsp;&nbsp;码：</td>
					<td colspan="2"><input type="password" id="password" name="password" style="width:150px;"/></td>
				</tr>
				<tr align="right" height="36">
					<td colspan="3">
						<a id="btn" href="javascript:void(0)" onclick="login()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">登录</a>
					</td>
				</tr>
			</table>
       </s:form>  
		
		<s:if test="error == 'true'">
			<div id="pwdError" style="text-align: center;color:red;width: 200px;">用户名或密码错误</div>
		</s:if>
</div>
</body>
</html>