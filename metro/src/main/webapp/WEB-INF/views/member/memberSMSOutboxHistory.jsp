<%@page import="com.chinarewards.metro.domain.sms.SMSSendStatus"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%--"http://www.w3.org/TR/html4/loose.dtd" --%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/extend-easyui-validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/constant.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<style>
	fieldset{margin-bottom:10px;margin:0px;font-size:14px;}
	.showTable td{}
	form{margin:0; padding:0}
</style>
<script type="text/javascript">
	
	function searchs(){
		
		$('#table').datagrid('load',{  
			id: $('#id_').val(),
			status: $('#status').val(),
			sentDateStart: $('#sentDateStart').datebox('getValue'),
			sentDateEnd: $('#sentDateEnd').datebox('getValue')
	    }); 
		$('#table2').datagrid('load',{  
			id: $('#id_').val(),
			status: $('#status').val()
	    }); 
	}
	function formatStatus(status){
		if(status == '<%=SMSSendStatus.SENT.toString()%>'){
			return "发送成功";
		}
		return "发送失败";
		
	}
	function reset1(){
		$('#sentDateStart').datebox('setValue','');
		$('#sentDateEnd').datebox('setValue','');
		$('#status').val('');
	}
</script>
</head>
<body style="padding:20px;">
	<input type="hidden" name="id" id="id_" value="${id }">
	<fieldset>
		<legend>查询条件</legend>
		<table class="showTable">
			<tr>
				<td>状态：</td>
				<td>
					<select name="status" id="status" style="width:98px">
						<option value="">全部</option>
						<option value="<%=SMSSendStatus.SENT%>">发送成功</option>
						<option value="<%=SMSSendStatus.ERROR%>">发送失败</option>
						<option value="<%=SMSSendStatus.QUEUED%>">等待发送</option>
					</select>
				</td>
				<td></td>
			</tr>
			<tr>
				<td>&nbsp;时间段：</td>
				<td><input type="text" name="sentDateStart" id="sentDateStart" style="width:100px" class="easyui-datebox" editable="false" /></td>
				<td>&nbsp;至</td>
				<td><input type="text" name="sentDateEnd" id="sentDateEnd" style="width:100px" class="easyui-datebox" editable="false"  /></td>
				<td><a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>&nbsp;&nbsp;<a id="btn" href="javascript:void(0)" onclick="reset1()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a></td>
			</tr>
		</table>
	</fieldset>
	<br/>
	<fieldset>
		<legend>发送短信历史记录</legend>
		<table id="table" class="easyui-datagrid" data-options="url:'memberSMSOutboxHistory',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
			rownumbers:true,pageList:pageList,singleSelect:true,queryParams:{
				id: ${id }
			}">
			<thead>  
		        <tr>  
		            <th data-options="field:'phoneNumber',width:80">手机号</th>  
		            <th data-options="field:'content',width:80">发送内容</th>
		            <th data-options="field:'sentDate',width:80,formatter:function(v,r,i){if(r.sentDate){return dateFormat(v);}return '';}">发送时间</th>
		            <th data-options="field:'status',width:80,formatter:function(v,r,i){return formatStatus(v);}">状态</th>
		        </tr>  
		    </thead>  
		</table> 
	</fieldset>
	<br>
	<fieldset>
		<legend>等待发送的短信记录</legend>
		<table id="table2" class="easyui-datagrid" data-options="url:'memberSMSOutboxWait',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
			rownumbers:true,pageList:pageList,singleSelect:true,queryParams:{
				id: ${id }
			}">
			<thead>  
		        <tr>  
		            <th data-options="field:'phoneNumber',width:80">手机号</th>  
		            <th data-options="field:'content',width:80">发送内容</th>
		            <th data-options="field:'sentDate',width:80,formatter:function(v,r,i){if(r.sentDate){return dateFormat(v);}return '';}">发送时间</th>
		            <th data-options="field:'status',width:80,formatter:function(v,r,i){return '等待发送';}">状态</th>
		        </tr>  
		    </thead>  
		</table> 
	</fieldset>
</body>
</html>