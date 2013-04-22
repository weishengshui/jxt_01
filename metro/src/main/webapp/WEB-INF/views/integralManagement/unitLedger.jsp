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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/extend-easyui-validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/PCASClass.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/constant.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/changeEasyuiTheme.js"></script>
<style type="text/css">
	.table select{width:140px;height:22px;margin-right:20px;}
	form{margin:0; padding:0}
</style>

<script type="text/javascript">
	
	
	function doSearch(){  
		
	    $('#tt').datagrid('load',{  
	    	operationPeople:$('#operationPeople').val(),  
	    	start:$('#start').datebox('getValue'),
	    	end:$('#end').datebox('getValue')
	    });  
	}
	function clearForm(){
		$('#fm').form('clear');
	}
</script>

</head>
	<body>
		<form action="" id="fm" style="width:700px;">
			<table border="0" style="font-size: 14px;">
				<tr>
					<td width="80px">操作员：</td>
					<td width="160px" align="left">
						<input id="operationPeople" name="operationPeople" type="text" style="width:150px"/> 
					</td>
				</tr>
				<tr>
					<td width="80px">操作时间：</td>
					<td width="160px" align="left">
						<input id="start" name="start" type="text" style="width:150px" class="easyui-datebox" editable="false"/>
					</td>
					<td width="20px">至</td>
					<td width="160px" align="left">
						<input id="end" name="end" type="text" style="width:150px" class="easyui-datebox" editable="false"/>
					</td>
					<td>
						<a href="javascript:void(0)" onclick="doSearch()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="clearForm()" class="easyui-linkbutton" data-options="iconCls:'icon-redo'">重置</a>
					</td>
				</tr>
			</table>
		</form>
		<table id="tt" class="easyui-datagrid" data-options="url:'unitLedger',fitColumns:true,striped:true,loadMsg:'正在载入...',pagination:true,	rownumbers:true,pageList:pageList,singleSelect:false">  
   					<thead>  
       				<tr>  
             		<th data-options="field:'operationPeople',width:100">操作员</th>
             		<th data-options="field:'operationTime',width:60,formatter:function(v,r,i){return dateFormat(v);}">操作时间</th>
             		<th data-options="field:'displayName',width:100" >积分名称</th>
             		<th data-options="field:'available',width:100,formatter:function(v,r,i){return v+'个月';}">有效期</th>
             		<th data-options="field:'price',width:100">积分价值(元/积分)</th>
          	</tr>  
       	</thead>  
  		</table> 
	</body>
</html>