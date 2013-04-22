<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>上海地铁</title>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ServerClock.js"></script>
<style type="text/css">
a{text-decoration: none;}
a.l-btn span.l-btn-left{ine-height: 20px;height: 20px;}
a.l-btn span span.l-btn-text{line-height: 25px;}
</style>
<% response.setHeader("Cache-Control","no-store");%>
<script>
	function dialog(name,url,width,height){// 公用弹出框方法
		$("#openIframe").attr("src",url);
		$("#divDialog").dialog({
			height:height,
			width:width,
			modal:true,
			resizable:true,
			maximizable:true,
			title:name
		});
	}
	
	function close(){
		$("#divDialog").dialog('close');
	}
	
	function getChild(){
		alert(window.frames['mainFrame'].length);
		if(window.frames['mainFrame'].document != null){
			return window.frames['mainFrame'];
		}else{
			return document.getElementById('mainFrame');
		}
	}
	function resetPassword(){
		$("#pform")[0].reset();
		$("#error").empty();
		$("#pdiv").dialog({
			modal:true,
			title:'修改密码'
		});
	}
	function updatePassword(){
		$("#error").empty();
		if($("#newpwd").val() =='' || $("#repwd").val()==''){
			$("#error").append("不能为空");
			return ;	
		}
		if($("#newpwd").val() != $("#repwd").val()){
			$("#error").append("输入密码不一致");
			$("#newpwd").focus();
			return ;
		}
		$.ajax({
			url:'user/validateOldPwd',
			data:'oldpwd='+$("#oldpwd").val()+"&newpwd="+$("#newpwd").val(),
			type:'post',
			async:false,
			success:function(data){
				if(data == ''){ 
					$("#error").append("旧密码输入错误");
				}else if(data == 'suc'){
					$("#pdiv").dialog('close');
		    		$.messager.alert('提示','修改成功','info');
				}
			}
		});
	}
	function forbidBackSpace(e) {
        var ev = e || window.event; //获取event对象   
        var obj = ev.target || ev.srcElement; //获取事件源   
        var t = obj.type || obj.getAttribute('type'); //获取事件源类型   
        //获取作为判断条件的事件类型   
        var vReadOnly = obj.readOnly;
        var vDisabled = obj.disabled;
        //处理undefined值情况   
        vReadOnly = (vReadOnly == undefined) ? false : vReadOnly;
        vDisabled = (vDisabled == undefined) ? true : vDisabled;
        //当敲Backspace键时，事件源类型为密码或单行、多行文本的，   
        //并且readOnly属性为true或disabled属性为true的，则退格键失效   
        var flag1 = ev.keyCode == 8 && (t == "password" || t == "text" || t == "textarea") && (vReadOnly == true || vDisabled == true);
        //当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效   
        var flag2 = ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea";
        //判断   
        if (flag2 || flag1) return false;
    }
    //禁止后退键 作用于Firefox、Opera  
    document.onkeypress = forbidBackSpace;
    //禁止后退键  作用于IE、Chrome  
    document.onkeydown = forbidBackSpace;
    
    $(document).ready(function(){
    	var srvClock = new ServerClock(${year},${month},${day},${hour},${minute},${second});
    	var fmtStr = "系统时间：yyyy年MM月dd日 HH:mm:ss";
    	//srvClock.set_delay(3000); // 时钟向后延时 3 秒，减少误差
    	window.setInterval(function(){
    		document.getElementById("time").innerHTML = srvClock.get_ServerTime(fmtStr);
    	},500);
    });
    
</script>
</head>
<body class="easyui-layout">
<!-- 
<div data-options="region:'north',border:false" style="height:26px;padding:0px;overflow: hidden;">
	<div style="position: absolute; right: 0px; bottom: 0px; ">
		<span>欢迎您, [<span style="font-weight: bold;"><sec:authentication property="name" /></span>] </span>&nbsp;&nbsp;&nbsp;
		<a href="javascript:void(0);" class="easyui-menubutton" data-options="menu:'#layout_north_pfMenu',iconCls:'icon-ok'">更换皮肤</a>
		<a href="javascript:void(0);" onclick="logout()" class="easyui-menubutton" data-options="menu:'#layout_north_zxMenu',iconCls:'icon-back'">注销</a>
	</div>
</div>
 -->
<div class="west-menu" data-options="region:'west',split:true,title:'客户关系管理系统'" style="width:200px;padding:5px;">
	<ul id="menuTree" class="easyui-tree"></ul> 
</div>
<div data-options="region:'south',border:false" style="height:20px;text-align: center;padding-top:4px;color:gray;font-size:12px;">
	技术支持：积享通信息有限公司
</div>
<div id="mainPanle" data-options="region:'center',title:'缤刻',tools:'#tt'">
	 <div id="tabs" class="easyui-tabs"  fit="true" border="false" >
		<div title=" 首&nbsp;&nbsp;页 " style="padding:20px;overflow:hidden;" id="home">
			<h1>Welcome to platform</h1>
		</div>
	</div>
</div>
<div id="divDialog">
   	<iframe scrolling="auto" id='openIframe' name="openIframe" frameborder="0"  src="" style="width:100%;height:100%;overflow: hidden;"></iframe> 
</div>
	<div style="display: none;">
	<div id="pdiv" style="width:280px;height: 220px;">
		<form id="pform">
		<table style="padding:20px;">
			<tr>
				<td>旧密码</td>
				<td><input type="password" id="oldpwd" /></td>
			</tr>
			<tr>
				<td>新密码</td>
				<td><input type="password" id="newpwd" /></td>
			</tr>
			<tr>
				<td>确认密码</td>
				<td><input type="password" id="repwd" /></td>
			</tr>
			<tr>
				<td colspan="2" align="right">
					<a id="btn" href="javascript:void(0)" onclick="updatePassword()" class="easyui-linkbutton" >修改</a>
					<a id="btn" href="javascript:void(0)" onclick="$('#pdiv').dialog('close')" class="easyui-linkbutton">取消</a>
				</td>
			</tr>
			<tr><td colspan="2" align="center"><span id="error" style="color:red;font-size:12px;"></span></td></tr>
		</table>
		</form>
	</div>
</div>
<div id="layout_north_pfMenu" style="width: 120px; display: none;">
	<div onclick="changeThemeFun('default');">default</div>
	<div onclick="changeThemeFun('gray');">gray</div>
	<div onclick="changeThemeFun('metro');">metro</div>
	<div onclick="changeThemeFun('cupertino');">cupertino</div>
	<div onclick="changeThemeFun('dark-hive');">dark-hive</div>
	<div onclick="changeThemeFun('pepper-grinder');">pepper-grinder</div>
	<div onclick="changeThemeFun('sunny');">sunny</div>
</div>
<div id="tt">
	
    <span>
    	<span id="time"></span>&nbsp;&nbsp;&nbsp;
    	欢迎您, [<span style="font-weight: bold;"><sec:authentication property="name" /></span>]
    </span>&nbsp;&nbsp;&nbsp;
   	<a href="javascript:void(0);" style="width: 90px;" onclick="resetPassword()" class="easyui-menubutton" data-options="menu:'#layout_north_zxMenu',iconCls:'icon-redo'">修改密码</a>
	<a href="javascript:void(0);" style="width: 100px;" class="easyui-menubutton" data-options="menu:'#layout_north_pfMenu',iconCls:'icon-ok'">更换皮肤</a>
	<a href="javascript:void(0);" style="width: 55px;" onclick="logout()" class="easyui-menubutton" data-options="menu:'#layout_north_zxMenu',iconCls:'icon-back'">注销</a>
</div>  
<script>
function logout(){
	window.location.href="j_spring_security_logout";
}
$(function() {
	$(".icon-back .m-btn-downarrow").remove();
	$(".icon-redo .m-btn-downarrow").remove();
	$(".l-btn-left").css("padding-top","0");
});
var ctrlTree;
$(function() {
	ctrlTree = $('#menuTree').tree({
		url : '${pageContext.request.contextPath}/user/findUserResources',
		lines : true,
		onClick : function(node) {
			if(node.attributes.url != null && node.attributes.url != ''){
				addTab(node.text,node.attributes.url);
			}else{
				if (node.state == 'closed') {
					$(this).tree('expand', node.target);
				} else {
					$(this).tree('collapse', node.target);
				}
			}
		}
	});
});
</script>
</body>
</html>