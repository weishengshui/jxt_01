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
<style>
	.table select{width:140px;height:22px;margin-right:20px;}
</style>
<script>
	function edit(id_,name_){
		var id = id_;
		var name = name_;
		if(id == undefined){
			var row = $('#table').datagrid('getSelected');
			if(row == null){
				 $.messager.alert('提示','请选择要编辑的数据','warning');
				return;
			}
			id = row.id;
			name = row.name;
		}
		parent.addTab('修改站台'+name,"line/siteUpdatePage?id="+id);
	}
	function del(id){
		var rows = $('#table').datagrid('getSelections');
		if(rows==''){ $.messager.alert('提示','请选择要删除的数据','warning');return;}
		$.messager.confirm('确认框','确定要删除选中的数据吗 ?',function(r){
			if(r){
				var s = '',n=''; 
				for(var i=0; i<rows.length; i++){
		            if (s != '') { s += ',',n+=",";}  
		            s += rows[i].id;
		            n += rows[i].name;
		        }
				$.ajax({
		        	url:'delMetroSite',
		        	type:'post',
		        	dataType:'json',
		        	data:"id="+s+"&names="+encodeURI(n),
		        	success:function(data){
		        		if(data==0){
		        			$.messager.show({  
		                        title:'提示',  
		                        msg:'删除成功!',  
		                        showType:'show'  
		                    }); 
		        			$('.easyui-datagrid').datagrid('reload');
		        		}else{
		        			alert("该站台已与门店关联,不能被删除");
		        		}
		        	}
				});
			}		
		});
	}
	function searchs(){
        //load 加载数据分页从第一页开始, reload 从当前页开始
    	$('#table').datagrid('load',getForms("searchForm"));
    }
</script>
</head>
<body>
	<!-- 查询条件Table -->
	<form id="searchForm" name="searchForm">
		<table class="table" style="font-size:13px;">
			<tr>
				<td>线路名称:</td>
				<td><input type="text" name="lineName" /></td>
				<td>&nbsp;&nbsp;站台名称:</td>
				<td><input type="text" name="name" /></td>
				<td><a id="btn" href="javascript:void(0)" onclick="searchs()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a></td>
				<td><a id="btn" href="javascript:void(0)" onclick="searchForm.reset()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a></td>
			</tr>
		</table>
	</form>
	<div id="toolbar">  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="edit()">修改</a>  
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="del()">删除</a>  
    </div> 
	<!-- 显示列表Table -->
	<table id="table" class="easyui-datagrid" data-options="url:'findSites',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,toolbar: '#toolbar',
		rownumbers:true,pageList:pageList,singleSelect:false,onDblClickRow:function(rowIndex,rowData){edit(rowData.id,rowData.name)}">
	    <thead>  
	        <tr> 
	        	<th data-options="field:'id',hidden:true,width:30">id</th>
	            <th data-options="field:'name',width:30">站台名称</th>
	            <th data-options="field:'descs',width:30">站台描述</th>  
	            <th data-options="field:'lineName',width:30">所属线路</th>
	            <th data-options="field:'orderNo',width:30">门店数量</th>
	        </tr>  
	    </thead>  
	</table> 
</body>
</html>