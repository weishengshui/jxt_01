<%@page import="com.chinarewards.metro.core.common.Dictionary"%>
<%@ page language="java" contentType="text/html; charset=utf8" pageEncoding="utf8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<style>
	.table select{width:140px;height:22px;margin-right:20px;}
</style>
<script>
	function del(id){
		var rows = $('#table').datagrid('getSelections');
		if(rows==''){$.messager.alert('提示','请选择要删除的数据','warning');return;}
		$.messager.confirm('确认框','确定要删除吗 ?',function(r){
			if(r){
				var s = '',nums='',n='';
				for(var i=0; i<rows.length; i++){
		            if (s != '') s += ',',nums+=',',n+=',';  
		            s += rows[i].id;
		            nums += rows[i].numno;
		            n += rows[i].name;
		        }
				
				$.ajax({
		        	url:'delShopChain',
		        	type:'post',
		        	dataType:'json',
		        	data:"ids="+s+"&numno="+nums+"&names="+encodeURI(n),
		        	success:function(data){
		        		if('删除成功'==data){
		        			$.messager.show({  
		                        title:'提示',  
		                        msg:data,  
		                        showType:'show'  
		                    });
		        		}else{
		        			$.messager.alert('提示',data,'warning'); 
		        		}
		        		$('.easyui-datagrid').datagrid('reload');
		        	}
				});
			}
		});
	}
	function searchs(){
        //load 加载数据分页从第一页开始, reload 从当前页开始
    	$('#table').datagrid('load',getForms("searchForm"));
    }
	function edit(id_,name_){
		var id = id_;
		var name = name_;
		if(id == undefined){
			var row = $('#table').datagrid('getSelected');//getSelected / getSelected
			if(row == null){
				$.messager.alert('提示','请选择要编辑的数据','warning');
				return;
			}
			id = row.id;
			name = row.name;
		}
		parent.addTab('修改总店'+name,"line/findShopChainById?id="+id);
	}
	function redo(){
		$('#searchForm').form('clear');
	}
</script>
</head>
<body>
	<!-- 查询条件Table -->
	<form id="searchForm">
		<table class="table" style="font-size:13px;">
			<tr>
				<td>总店编号:</td>
				<td><input type="text" name="numno" style="width:100px;"/></td>
				<td>&nbsp;</td>
				<td>总店名称:</td>
				<td><input type="text" name="name" style="width:100px;"/></td>
				<td>&nbsp;</td>
				<td><a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td>
				<td><a id="btn" href="javascript:void(0)" onclick="redo()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a></td>
			</tr>
		</table>
	</form>

	<!-- 显示列表Table -->
	<table id="table" class="easyui-datagrid" data-options="url:'findShopChain',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
		rownumbers:true,pageList:pageList,singleSelect:false,onDblClickRow:function(rowIndex,rowData){edit(rowData.id,rowData.name)}">
	    <thead>  
	        <tr> 
	        	<th data-options="field:'id',hidden:true,width:30">id</th>
	            <th data-options="field:'numno',width:30">总店编号</th>
	            <th data-options="field:'name',width:30">总店名称</th>
	            <th data-options="field:'linkman',width:30">联系人</th>
	            <th data-options="field:'hotline',width:30">固定电话</th>
	            <th data-options="field:'email',width:30">电子邮件</th>
	        </tr>  
	    </thead>  
	</table> 
	<div id="toolbar">  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="edit()">修改</a>  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="del()">删除</a>  
    </div>  
</body>
</html>