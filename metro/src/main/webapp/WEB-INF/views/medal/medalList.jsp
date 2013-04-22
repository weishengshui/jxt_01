<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/icon.css" />
<style type="text/css">
	body {
		font-family: 黑体、宋体、Arial;
		font-size: 12px;
	}
</style>
<link id="easyuiTheme" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/jquery/themes/default/easyui.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<script type="text/javascript">
function edit_g(id_,name_){
	var id = id_;
	var name = name_;
	if(id == 'undefined'){
		var row = $('#table').datagrid('getSelected');
		if(row == 'null'){
			alert("请选择要编辑的数据");
			return;
		}
		id = row.id;
		name = decodeURIComponent(row.medalName);
		if(name == 'null'){
			name = row.medalName;
		}
	} 
	parent.addTab('维护'+name+'信息','medal/queryMedal?id='+id);
}
$(document).ready(function(){
	$('#searchbtn').click(function(){
		$('#table').datagrid('load',getForms("searchForm"));
	});
	
	$('#updateMedal').click(function(){
		var rows = $('#table').datagrid('getSelections');
		if(rows.length <= 0 || rows.length > 1){
			$.messager.alert('提示',"请选择一条记录进行修改！");
			return false; 	
		}
		parent.addTab('维护勋章奖励规则信息','medal/queryMedal?id='+rows[0].id);
	});
	
	window.onresize = function(){
		var changeWidth  = document.documentElement.clientWidth;

	    if(changeWidth <= 830){
	    	$('#table').datagrid({width:1200});
	    }else{
	    	$('#table').datagrid({width:changeWidth-18});
	    }
	}
	$('#deleteMedal').click(function(){
		var data ='';
		var rows = $('#table').datagrid('getSelections');
		
		for(var i in rows){
			data += rows[i].id+',';
		}
		data = data.substring(0, data.length -1);
		if(rows.length == 0){
			$.messager.alert('提示',"请先选择要删除的规则信息！");
			return false; 	
		}
		$.messager.confirm('信息','确认是否删除?',function(r){   
			if (r){   
				$.ajax({
		            url:'delMedal',
		            type:'post',
		            async: false,
		            data:'ids='+data,
		            success:function(data){
		            	if(data == 1){
		            		$.messager.show({  
				    			title:'提示信息',  
				    			msg:'删除成功！',  
				    			timeout:5000,  
				    			showType:'slide'  
				    		});
		            		$('#table').datagrid('reload');
		            	}else{
		            		$.messager.show({  
				    			title:'提示信息',  
				    			msg:'删除失败！',  
				    			timeout:5000,  
				    			showType:'slide'  
				    		});
		            	}
		            }
		        });
			}   
		});
	});
});
</script>
</head>
<body>
	<form id="searchForm" method="post" >
		<table width="800px">
			<tr>
				<td>勋章名称：</td>
				<td><input id="medalName" name="medalName" type="text"/></td>
				<td>获取方式：</td>
				<td><input id="obtainWay" name="obtainWay" type="text"/></td>
				<td>
					<a id="searchbtn" href="javascript:void(0)" onclick="" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
					<a style="margin-left: 20px;" href="javascript:void(0)" data-options="iconCls:'icon-redo'" onclick="javascript:$('#searchForm').form('clear');" class="easyui-linkbutton" >重置</a>
				</td>
				
			</tr>
		</table>
	</form>
	
	<!-- 显示列表Table -->
	<table  id="table"  class="easyui-datagrid" data-options="url:'findMedalList',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,
				rownumbers:true,pageList:pageList,toolbar: '#toolbar',singleSelect:false,onDblClickRow:function(rowIndex,rowData){edit_g(rowData.id,rowData.medalName)}">    
	    <thead>  
	        <tr>  
	        	<th data-options="field:'id',width:20,hidden:true"></th>
	        	<th data-options="field:'medalName',width:20">勋章名称</th>
	            <th data-options="field:'obtainWay',width:80">获取方式</th>  
	            <th data-options="field:'obtainCondition',width:50,formatter:function(v){return v}">获取条件</th>
	            <th data-options="field:'validTime',width:50,formatter:function(v){return v}">有效时间</th>
	            <th data-options="field:'revealSort',width:50,formatter:function(v,o,i){ return v}">显示排序</th>
	        </tr>  
	    </thead>  
	</table> 
</div>
<br><br>
<div id="toolbar">
	<a id="updateMedal" href="javascript:void(0)" plain="true" iconCls="icon-edit" class="easyui-linkbutton" style="margin-left: 10px;">修改</a>
	<a id="deleteMedal" href="javascript:void(0)" plain="true" iconCls="icon-remove" class="easyui-linkbutton" style="margin-left: 10px;">删除</a>
</div>
</body>
</html>