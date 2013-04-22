<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script>
function searchs(){
    //load 加载数据分页从第一页开始, reload 从当前页开始
	$('#table').datagrid('load',getForms("searchForm"));
}
function getState(v){
	if(v.indexOf("失败")>-1){
		if(v.length > 2){
			return "失败 (<a href='javascript:showE(\""+v+"\")'>查看原因</a>)";
		}else{
			return "失败";
		}
	}
	return v;
}
function showE(error){
	$("#er").html(error);
	$("#er").dialog({
		title:'错误',
		width:300,
		height:200
	});
}
</script>
</head>
<body>
	<!-- 查询条件Table -->
	<form id="searchForm" onsubmit="return false">
		<table style="font-size:13px;">
			<tr>
				<td>时间段</td>
				<td><input name="startTime" type="text" style="width:150px" class="easyui-datetimebox" editable="false"/></td>
				<td>至</td>
				<td><input name="endTime" type="text" style="width:150px" class="easyui-datetimebox" editable="false"/></td>
				<td>用户名:</td>
				<td><input type="text" name="name" size="18"/></td>
				<td>&nbsp;<a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td>
				<td>&nbsp;<a id="btn" href="javascript:void(0)" onclick="searchForm.reset()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a></td>
			</tr>
		</table>
	</form>
	<!-- 显示列表Table -->
	<table id="table" class="easyui-datagrid" data-options="url:'findLogs',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
		rownumbers:false,pageList:pageList,singleSelect:false">  
	    <thead>  
	        <tr>
	            <th data-options="field:'operator',width:100">用户名</th>  
	            <th data-options="field:'time',width:100">操作时间</th>
	            <th data-options="field:'object',width:100">操作对象</th>
	            <th data-options="field:'name',width:100">名称</th>
	            <th data-options="field:'event',width:100">事件</th>
	            <th data-options="field:'other',width:100,formatter:function(v){return getState(v) }">状态</th>
	        </tr>  
	    </thead>  
	</table> 
	
	<div style="display: none;">
		<div id="er" style="word-break: break-all;"></div>
	</div>
</body>
</html>