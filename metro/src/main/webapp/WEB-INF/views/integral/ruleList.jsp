<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<style type="text/css">
#searchTable input{width:100px;}
</style>
<script>
	function addDialog(){
		//parent.dialog("积分规则","integralRule/ruleCreatePage",550,380);
		parent.addTab('新增消费积分规则','integralRule/ruleCreatePage');
	}
	
    function searchs(){
    	$('#Integral_table').datagrid('load',getForms("searchForm"));
    }

	function del(){
		var rows = $('#Integral_table').datagrid('getSelections');//getSelected选一个
		var ids = '',n='';
		for(var i=0; i<rows.length; i++){
			if(ids != '') ids += ",",n+=',';
		    ids += rows[i].id;
		    n += rows[i].ruleName;
		}
		if(ids == ''){
           	$.messager.alert('提示','请选择要删除的记录','warning');return false;
		}
		$.messager.confirm('确认框','确定要删除选中的记录吗 ?',function(r){
			if(r){
				$.ajax({
		        	url:'removeRule',
		        	type:'post',
		        	dataType:'json',
		        	data:"ids="+ids+"&names="+encodeURI(n),
		        	success:function(data){
		        		$.messager.show({  
		                    title:'提示',  
		                    msg:'删除成功!',  
		                    showType:'show'  
		                });
		        		$('.easyui-datagrid').datagrid('reload');
		        	}
				});
			}
		})
	}
	
    function edit(id_,name_){
    	var id = id_;
		var name = name_;
		if(id == undefined){
			var row = $('#Integral_table').datagrid('getSelected');//getSelected / getSelected
			if(row == null){
				$.messager.alert('提示','请选择要编辑的数据','warning');
				return;
			}
			id = row.id;
			name = row.ruleName;
		}
    	parent.addTab("修改"+name+"规则","integralRule/findRuleById?id="+id);
    }
    function getSex(v){
        var sex = ${sexJson};
        for(var i=0;i<sex.length;i++){
            if(v == sex[i].key){
            	return sex[i].value;
            };
        };
    }
    function reset1(){
    	$('#searchTable').form('clear');
    }
</script>
</head>
<body>
	<!-- 查询条件Table -->
	<form id="searchForm">
		<table id="searchTable" style="font-size:13px;" border="0" width="880">
			<tr>
				<td width="60">规则名称:</td>
				<td><input type="text" name="ruleName" /></td>
				<td width="60">积分倍数:</td>
				<td><input type="text" name="times" /></td>
				<td width="58">时间段:</td>
				<td>
					<input name="rangeFrom" type="text" class="easyui-datebox" style="width:100px"/>
					至
					<input name="rangeTo" type="text" class="easyui-datebox" style="width:100px"/>
				</td>
				<td><a style="width:62px;" id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td>
				<td><a style="width:62px;" id="btn" href="javascript:void(0)" onclick="reset1()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a></td>
			</tr>
		</table>
	</form>
	<div id="toolbar">
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addDialog()">新增</a>  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="edit()">修改</a>  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="del()">删除</a>  
    </div>  
	<!-- 显示列表Table -->
	<table id="Integral_table" class="easyui-datagrid" data-options="url:'findRules',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
		rownumbers:true,pageList:pageList,singleSelect:false,onDblClickRow:function(rowIndex,rowData){edit(rowData.id,rowData.ruleName);}">  
	    <thead>
	        <tr>
	            <th data-options="field:'ruleName',width:80">规则名称</th>
	            <th data-options="field:'times',width:100">积分倍数</th>
	            <th data-options="field:'rangeFrom',width:100">开始时间</th>
	            <th data-options="field:'rangeTo',width:100">结束时间</th>
	         	<th data-options="field:'rangeAgeFrom',width:100">年龄起</th>
	         	<th data-options="field:'rangeAgeTo',width:100">年龄止</th>
	         	<th data-options="field:'amountConsumedFrom',width:100">消费金额起</th>
	         	<th data-options="field:'amountConsumedTo',width:100">消费金额止</th>
	         	<th data-options="field:'gender',width:50,formatter:function(v){return getSex(v)}">性别</th>
	        </tr>
	    </thead>  
	</table> 
</body>
</html>